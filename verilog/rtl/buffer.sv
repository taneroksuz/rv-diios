package buffer_wires;
  timeunit 1ns; timeprecision 1ps;

  import configure::*;

  localparam BUFFER_WIDTH = 4;
  localparam ISSUE_WIDTH  = 2;

  localparam BDEPTH = $clog2(BUFFER_DEPTH);
  localparam BWIDTH = $clog2(BUFFER_WIDTH);

  typedef struct packed {
    logic [BUFFER_WIDTH-1:0][0:0]        wen;
    logic [BUFFER_WIDTH-1:0][BDEPTH-1:0] waddr;
    logic [BUFFER_WIDTH-1:0][BDEPTH-1:0] raddr;
    logic [BUFFER_WIDTH-1:0][15:0]       wdata;
  } buffer_reg_in_type;

  typedef struct packed {logic [BUFFER_WIDTH-1:0][15:0] rdata;} buffer_reg_out_type;

endpackage

import configure::*;
import constants::*;
import wires::*;
import buffer_wires::*;

module buffer_reg (
  input  logic               clock,
  input  buffer_reg_in_type  buffer_reg_in,
  output buffer_reg_out_type buffer_reg_out
);
  timeunit 1ns; timeprecision 1ps;

  genvar i;

  generate
    for (i = 0; i < BUFFER_WIDTH; i++) begin : gen_buffer_reg_array
      logic [15:0] buffer_reg_array[0:BUFFER_DEPTH-1] = '{default: '0};
      always_ff @(posedge clock) begin
        if (buffer_reg_in.wen[i] == 1) begin
          buffer_reg_array[buffer_reg_in.waddr[i]] <= buffer_reg_in.wdata[i];
        end
      end
      always_comb begin
        buffer_reg_out.rdata[i] = (buffer_reg_in.wen[i] == 1 &&
                                   buffer_reg_in.raddr[i] == buffer_reg_in.waddr[i]) ?
            buffer_reg_in.wdata[i] : buffer_reg_array[buffer_reg_in.raddr[i]];
      end
    end
  endgenerate

endmodule

module buffer_ctrl (
  input  logic               reset,
  input  logic               clock,
  input  buffer_in_type      buffer_in,
  output buffer_out_type     buffer_out,
  input  buffer_reg_out_type buffer_reg_out,
  output buffer_reg_in_type  buffer_reg_in
);
  timeunit 1ns; timeprecision 1ps;

  localparam W = BDEPTH + BWIDTH;
  localparam TOTAL = BUFFER_WIDTH * (BUFFER_DEPTH - 2);

  localparam WINDOW = 2 * ISSUE_WIDTH;

  typedef struct packed {
    logic [BUFFER_WIDTH-1:0][15:0] wdata;
    logic [WINDOW-1:0][15:0]       rdata;
    logic [WINDOW-1:0]             comp;
    logic [W-1:0]                  wid;
    logic [W-1:0]                  rid;
    logic [31:0]                   pc_base;
    logic [W-1:0]                  diff;
    logic [W-1:0]                  count;
    logic [W-1:0]                  align;
    logic [ISSUE_WIDTH-1:0][31:0]  pc;
    logic [ISSUE_WIDTH-1:0][31:0]  instr;
    logic [ISSUE_WIDTH-1:0]        ready;
    logic [0:0]                    wen;
    logic [0:0]                    clear;
    logic [0:0]                    stall;
    logic [BWIDTH-1:0]             rid_bank;
    logic [BDEPTH-1:0]             rid_row;
    logic [BDEPTH-1:0]             rid_row_p1;
    logic [BDEPTH-1:0]             wid_row;
  } reg_type;

  parameter reg_type init_reg = '{
      wdata : '{default: '0},
      rdata : '{default: '0},
      comp : 0,
      wid : 0,
      rid : 0,
      pc_base : 0,
      diff : 0,
      count : 0,
      align : 0,
      pc : '{default: '0},
      instr : '{default: '0},
      ready : 0,
      wen : 0,
      clear : 0,
      stall : 0,
      rid_bank : 0,
      rid_row : 0,
      rid_row_p1 : 0,
      wid_row : 0
  };

  reg_type r, rin, v;

  function automatic int slot_offset(input logic [WINDOW-1:0] comp, input int slot);
    int off;
    off = 0;
    for (int k = 0; k < slot; k++) begin
      off = off + (comp[off] ? 1 : 2);
    end
    return off;
  endfunction

  int         base;
  logic [1:0] need;

  always_comb begin

    v = r;

    if (buffer_in.clear == 1) begin
      v.wid   = 0;
      v.rid   = 0;
      v.count = 0;
      v.clear = 1;
    end

    if (r.clear == 1 && buffer_in.clear == 0 && buffer_in.ready == 1) begin
      v.rid     = {{W - 1{1'b0}}, buffer_in.pc0[1]};
      v.align   = {{W - 1{1'b0}}, buffer_in.pc0[1]};
      v.pc_base = {buffer_in.pc0[31:1], 1'b0};
      v.clear   = 0;
    end

    v.wen = (~buffer_in.clear) & (~r.stall) & buffer_in.ready;

    v.wid_row = v.wid[W-1:BWIDTH];

    for (int k = 0; k < BUFFER_WIDTH; k++) begin
      v.wdata[k] = buffer_in.rdata[k*16+:16];
    end

    for (int k = 0; k < BUFFER_WIDTH; k++) begin
      buffer_reg_in.wen[k]   = v.wen;
      buffer_reg_in.waddr[k] = v.wid_row;
      buffer_reg_in.wdata[k] = v.wdata[k];
    end

    v.rid_bank   = v.rid[BWIDTH-1:0];
    v.rid_row    = v.rid[W-1:BWIDTH];
    v.rid_row_p1 = v.rid_row + 1'b1;

    for (int k = 0; k < BUFFER_WIDTH; k++) begin
      buffer_reg_in.raddr[k] = (k < int'(v.rid_bank)) ? v.rid_row_p1 : v.rid_row;
    end

    for (int j = 0; j < WINDOW; j++) begin
      v.rdata[j] = buffer_reg_out.rdata[(int'(v.rid_bank)+j)&(BUFFER_WIDTH-1)];
    end

    if (v.wen == 1) begin
      v.wid   = v.wid + BUFFER_WIDTH;
      v.count = v.count + BUFFER_WIDTH;
    end

    v.diff = 0;

    for (int k = 0; k < WINDOW; k++) begin
      v.comp[k] = ~(&v.rdata[k][1:0]);
    end

    for (int s = 0; s < ISSUE_WIDTH; s++) begin
      v.pc[s]    = '0;
      v.instr[s] = '0;
      v.ready[s] = 0;
    end

    for (int s = 0; s < ISSUE_WIDTH; s++) begin
      base = slot_offset(v.comp, s);
      need = v.comp[base] ? 1 : 2;
      if (v.count > v.align + W'(base) + (v.comp[base] ? W'(0) : W'(1))) begin
        v.pc[s] = v.pc_base + 32'(2 * base);
        if (v.comp[base]) begin
          v.instr[s] = {16'b0, v.rdata[base]};
        end else begin
          v.instr[s] = {v.rdata[base+1], v.rdata[base]};
        end
        v.ready[s] = 1;
        v.diff     = W'(base) + W'(need);
      end
    end

    if (buffer_in.stall == 1) begin
      v.diff  = 0;
      v.ready = '0;
    end

    v.count   = v.count - v.diff;
    v.rid     = v.rid + v.diff;
    v.pc_base = v.pc_base + (32'(v.diff) << 1);

    if (v.count > TOTAL) begin
      v.stall = 1;
    end else begin
      v.stall = 0;
    end

    buffer_out.pc0    = v.ready[0] ? v.pc[0] : 32'hFFFFFFFF;
    buffer_out.pc1    = v.ready[1] ? v.pc[1] : 32'hFFFFFFFF;
    buffer_out.instr0 = v.ready[0] ? v.instr[0] : 0;
    buffer_out.instr1 = v.ready[1] ? v.instr[1] : 0;
    buffer_out.ready0 = v.ready[0];
    buffer_out.ready1 = v.ready[1];
    buffer_out.stall  = ~v.wen;

    rin = v;

  end

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      r <= init_reg;
    end else begin
      r <= rin;
    end
  end

endmodule

module buffer (
  input  logic           reset,
  input  logic           clock,
  input  buffer_in_type  buffer_in,
  output buffer_out_type buffer_out
);
  timeunit 1ns; timeprecision 1ps;

  buffer_reg_in_type  buffer_reg_in;
  buffer_reg_out_type buffer_reg_out;

  buffer_reg buffer_reg_comp (
    .clock         (clock),
    .buffer_reg_in (buffer_reg_in),
    .buffer_reg_out(buffer_reg_out)
  );

  buffer_ctrl buffer_ctrl_comp (
    .reset         (reset),
    .clock         (clock),
    .buffer_in     (buffer_in),
    .buffer_out    (buffer_out),
    .buffer_reg_in (buffer_reg_in),
    .buffer_reg_out(buffer_reg_out)
  );

endmodule
