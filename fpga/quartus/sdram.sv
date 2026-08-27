import configure::*;
import wires::*;

module sdram_ctrl (
  input  logic               reset,
  input  logic               clock,
  input  mem_in_type         sdram_in,
  output mem_out_type        sdram_out,
  output logic        [12:0] sdram_sa,
  output logic        [ 1:0] sdram_ba,
  output logic               sdram_cs_n,
  output logic               sdram_cke,
  output logic               sdram_ras_n,
  output logic               sdram_cas_n,
  output logic               sdram_we_n,
  output logic        [ 3:0] sdram_dqm,
  inout  wire         [31:0] sdram_dq
);
  timeunit 1ns; timeprecision 1ps;

  localparam COLSTART = 0;
  localparam COLSIZE  = 9;

  localparam ROWSTART = 9;
  localparam ROWSIZE  = 13;

  localparam BANKSTART = 22;
  localparam BANKSIZE  = 2;

  localparam ASIZE = COLSIZE + ROWSIZE + BANKSIZE;

  localparam INIT_PER = 30000;
  localparam REF_PER  = 950;
  localparam SC_CL    = 3;
  localparam SC_RCD   = 3;
  localparam SC_RP    = 3;
  localparam SC_RFC   = 9;
  localparam SC_MRD   = 3;
  localparam SC_WR    = 2;
  localparam SC_REF   = 8;

  localparam SC_RDLAT = SC_CL + 2;

  localparam logic [12:0] MODE_REG = {3'b000, 1'b0, 2'b00, 3'b011, 1'b0, 3'b000};

  localparam logic [12:0] PRECHARGE_ALL = 13'h400;

  localparam [2:0] S_INIT   = 0;
  localparam [2:0] S_IDLE   = 1;
  localparam [2:0] S_ACTIVE = 2;
  localparam [2:0] S_READ   = 3;
  localparam [2:0] S_WAIT   = 4;

  typedef struct packed {
    logic [2:0]       state;
    logic [3:0]       step;
    logic [15:0]      delay;
    logic [15:0]      refresh_timer;
    logic [0:0]       refresh_req;
    logic [0:0]       pending;
    logic [ASIZE-1:0] addr;
    logic [31:0]      wdata;
    logic [3:0]       wstrb;
    logic [0:0]       write;
    logic [31:0]      rdata;
    logic [0:0]       ready;
    logic [12:0]      sa;
    logic [1:0]       ba;
    logic [0:0]       cs_n;
    logic [0:0]       cke;
    logic [0:0]       ras_n;
    logic [0:0]       cas_n;
    logic [0:0]       we_n;
    logic [3:0]       dqm;
    logic [0:0]       dq_oe;
  } reg_type;

  localparam reg_type init_reg = '{
      state : S_INIT,
      step : 0,
      delay : INIT_PER,
      refresh_timer : REF_PER,
      refresh_req : 0,
      pending : 0,
      addr : 0,
      wdata : 0,
      wstrb : 0,
      write : 0,
      rdata : 0,
      ready : 0,
      sa : 0,
      ba : 0,
      cs_n : 1,
      cke : 0,
      ras_n : 1,
      cas_n : 1,
      we_n : 1,
      dqm : '1,
      dq_oe : 0
  };

  reg_type r, rin, v;

  logic [31:0] dq_in;

  assign sdram_dq = (r.dq_oe == 1) ? r.wdata : 32'bz;

  always_ff @(posedge clock) begin
    dq_in <= sdram_dq;
  end

  always_comb begin

    v = r;

    v.cs_n  = 0;
    v.cke   = 1;
    v.ras_n = 1;
    v.cas_n = 1;
    v.we_n  = 1;
    v.dqm   = 0;
    v.dq_oe = 0;
    v.ready = 0;

    if (r.refresh_timer == 0) begin
      v.refresh_timer = REF_PER;
      v.refresh_req   = 1;
    end
    else begin
      v.refresh_timer = r.refresh_timer - 1'b1;
    end

    if (sdram_in.mem_valid == 1 && r.pending == 0) begin
      v.addr    = sdram_in.mem_addr[ASIZE+1:2];
      v.wdata   = sdram_in.mem_wdata;
      v.wstrb   = sdram_in.mem_wstrb;
      v.write   = |sdram_in.mem_wstrb;
      v.pending = 1;
    end

    case (r.state)

      S_INIT: begin
        if (r.delay != 0) begin
          v.delay = r.delay - 1'b1;
        end
        else if (r.step == 0) begin
          v.sa    = PRECHARGE_ALL;
          v.ba    = 0;
          v.ras_n = 0;
          v.cas_n = 1;
          v.we_n  = 0;
          v.delay = SC_RP;
          v.step  = r.step + 1'b1;
        end
        else if (r.step <= SC_REF) begin
          v.ras_n = 0;
          v.cas_n = 0;
          v.we_n  = 1;
          v.delay = SC_RFC;
          v.step  = r.step + 1'b1;
        end
        else if (r.step == SC_REF + 1) begin
          v.sa    = MODE_REG;
          v.ba    = 0;
          v.ras_n = 0;
          v.cas_n = 0;
          v.we_n  = 0;
          v.delay = SC_MRD;
          v.step  = r.step + 1'b1;
        end
        else begin
          v.state = S_IDLE;
        end
      end

      S_IDLE: begin
        if (v.refresh_req == 1) begin
          v.ras_n       = 0;
          v.cas_n       = 0;
          v.we_n        = 1;
          v.refresh_req = 0;
          v.delay       = SC_RFC;
          v.state       = S_WAIT;
        end
        else if (v.pending == 1) begin
          v.sa      = v.addr[ROWSTART+ROWSIZE-1:ROWSTART];
          v.ba      = v.addr[BANKSTART+BANKSIZE-1:BANKSTART];
          v.ras_n   = 0;
          v.cas_n   = 1;
          v.we_n    = 1;
          v.pending = 0;
          v.delay   = SC_RCD - 1;
          v.state   = S_ACTIVE;
        end
      end

      S_ACTIVE: begin
        if (r.delay != 0) begin
          v.delay = r.delay - 1'b1;
        end
        else begin
          v.sa    = {2'b00, 1'b1, 1'b0, r.addr[COLSTART+COLSIZE-1:COLSTART]};
          v.ras_n = 1;
          v.cas_n = 0;
          if (r.write == 1) begin
            v.we_n  = 0;
            v.dqm   = ~r.wstrb;
            v.dq_oe = 1;
            v.ready = 1;
            v.delay = SC_WR + SC_RP;
            v.state = S_WAIT;
          end
          else begin
            v.we_n  = 1;
            v.delay = SC_RDLAT;
            v.state = S_READ;
          end
        end
      end

      S_READ: begin
        if (r.delay != 0) begin
          v.delay = r.delay - 1'b1;
        end
        else begin
          v.rdata = dq_in;
          v.ready = 1;
          v.delay = SC_RP;
          v.state = S_WAIT;
        end
      end

      default: begin
        if (r.delay != 0) begin
          v.delay = r.delay - 1'b1;
        end
        else begin
          v.state = S_IDLE;
        end
      end

    endcase

    sdram_out.mem_ready = r.ready;
    sdram_out.mem_error = 0;
    sdram_out.mem_rdata = r.rdata;

    sdram_sa    = r.sa;
    sdram_ba    = r.ba;
    sdram_cs_n  = r.cs_n;
    sdram_cke   = r.cke;
    sdram_ras_n = r.ras_n;
    sdram_cas_n = r.cas_n;
    sdram_we_n  = r.we_n;
    sdram_dqm   = r.dqm;

    rin = v;

  end

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      r <= init_reg;
    end
    else begin
      r <= rin;
    end
  end

endmodule

import configure::*;
import wires::*;

module sdram (
  input  logic               reset,
  input  logic               clock,
  input  mem_in_type         sdram_in,
  output mem_out_type        sdram_out,
  input  logic               sdram_clk,
  output logic               sdram_cke,
  output logic        [ 1:0] sdram_ba,
  output logic               sdram_cs_n,
  output logic               sdram_we_n,
  output logic               sdram_cas_n,
  output logic               sdram_ras_n,
  output logic        [12:0] sdram_sa,
  output logic        [ 3:0] sdram_dqm,
  inout  wire         [31:0] sdram_dq
);
  timeunit 1ns; timeprecision 1ps;

  logic [1:0] sdram_reset = 0;

  mem_in_type  sdram_ctrl_in;
  mem_out_type sdram_ctrl_out;

  always_ff @(posedge sdram_clk) begin
    if (reset == 0) begin
      sdram_reset <= 2'b00;
    end
    else begin
      sdram_reset <= {sdram_reset[0], 1'b1};
    end
  end

  cdc cdc_comp (
    .src_clk    (clock),
    .src_rstn   (reset),
    .src_mem_in (sdram_in),
    .src_mem_out(sdram_out),
    .dst_clk    (sdram_clk),
    .dst_rstn   (sdram_reset[1]),
    .dst_mem_in (sdram_ctrl_in),
    .dst_mem_out(sdram_ctrl_out)
  );

  sdram_ctrl sdram_ctrl_comp (
    .reset      (sdram_reset[1]),
    .clock      (sdram_clk),
    .sdram_in   (sdram_ctrl_in),
    .sdram_out  (sdram_ctrl_out),
    .sdram_sa   (sdram_sa),
    .sdram_ba   (sdram_ba),
    .sdram_cs_n (sdram_cs_n),
    .sdram_cke  (sdram_cke),
    .sdram_ras_n(sdram_ras_n),
    .sdram_cas_n(sdram_cas_n),
    .sdram_we_n (sdram_we_n),
    .sdram_dqm  (sdram_dqm),
    .sdram_dq   (sdram_dq)
  );

endmodule
