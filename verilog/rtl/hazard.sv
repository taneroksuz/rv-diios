package hazard_wires;
  timeunit 1ns; timeprecision 1ps;

  import configure::*;
  import wires::*;

  localparam DEPTH = $clog2(HAZARD_DEPTH);

  typedef struct packed {
    logic [0:0]       wen0;
    logic [0:0]       wen1;
    logic [DEPTH-1:0] waddr0;
    logic [DEPTH-1:0] waddr1;
    logic [DEPTH-1:0] raddr0;
    logic [DEPTH-1:0] raddr1;
    instruction_type  wdata0;
    instruction_type  wdata1;
  } hazard_reg_in_type;

  typedef struct packed {
    instruction_type rdata0;
    instruction_type rdata1;
  } hazard_reg_out_type;

endpackage

import configure::*;
import constants::*;
import wires::*;
import hazard_wires::*;

module hazard_reg (
  input  logic               clock,
  input  hazard_reg_in_type  hazard_reg_in,
  output hazard_reg_out_type hazard_reg_out
);
  timeunit 1ns; timeprecision 1ps;

  localparam DEPTH = $clog2(HAZARD_DEPTH);

  instruction_type hazard_reg_array0[0:HAZARD_DEPTH-1] = '{default: '0};
  instruction_type hazard_reg_array1[0:HAZARD_DEPTH-1] = '{default: '0};

  always_ff @(posedge clock) begin
    if (hazard_reg_in.wen0 == 1) begin
      hazard_reg_array0[hazard_reg_in.waddr0] <= hazard_reg_in.wdata0;
    end
  end

  always_ff @(posedge clock) begin
    if (hazard_reg_in.wen1 == 1) begin
      hazard_reg_array1[hazard_reg_in.waddr1] <= hazard_reg_in.wdata1;
    end
  end

  assign hazard_reg_out.rdata0 = hazard_reg_array0[hazard_reg_in.raddr0];
  assign hazard_reg_out.rdata1 = hazard_reg_array1[hazard_reg_in.raddr1];

endmodule

module hazard_ctrl (
  input  logic               reset,
  input  logic               clock,
  input  hazard_in_type      hazard_in,
  output hazard_out_type     hazard_out,
  input  hazard_reg_out_type hazard_reg_out,
  output hazard_reg_in_type  hazard_reg_in
);
  timeunit 1ns; timeprecision 1ps;

  localparam DEPTH = $clog2(HAZARD_DEPTH);
  localparam TOTAL = 2 * (HAZARD_DEPTH - 2);

  localparam [DEPTH-1:0] ONE = 1;

  typedef struct packed {
    logic [DEPTH-1:0] wid;
    logic [DEPTH:0]   rid;
    logic [DEPTH:0]   diff;
    logic [DEPTH:0]   count;
    logic [0:0]       wen;
    logic [0:0]       single;
    logic [0:0]       stall;
  } reg_type;

  parameter reg_type init_reg = '{wid : 0, rid : 0, diff : 0, count : 0, wen : 0, single : 0, stall : 0};

  instruction_type wdata0;
  instruction_type wdata1;
  instruction_type instr0;
  instruction_type instr1;
  calculation_type calc0;
  calculation_type calc1;

  reg_type r, rin, v;

  always_comb begin

    v = r;

    if (hazard_in.clear == 1) begin
      v.wid   = 0;
      v.rid   = 0;
      v.count = 0;
    end

    v.wen = (~hazard_in.clear) & (~r.stall) & (hazard_in.instr0.op.valid | hazard_in.instr1.op.valid);

    wdata0 = hazard_in.instr0;
    wdata1 = hazard_in.instr1;

    hazard_reg_in.wen0   = v.wen;
    hazard_reg_in.wen1   = v.wen;
    hazard_reg_in.waddr0 = v.wid;
    hazard_reg_in.waddr1 = v.wid;
    hazard_reg_in.wdata0 = wdata0;
    hazard_reg_in.wdata1 = wdata1;

    instr0 = init_instruction;
    instr1 = init_instruction;

    if (v.rid[0] == 0) begin
      hazard_reg_in.raddr0 = v.rid[DEPTH:1];
      hazard_reg_in.raddr1 = v.rid[DEPTH:1];
      if (v.wid == v.rid[DEPTH:1]) begin
        instr0 = wdata0;
        instr1 = wdata1;
      end
      else begin
        instr0 = hazard_reg_out.rdata0;
        instr1 = hazard_reg_out.rdata1;
      end
    end
    else begin
      hazard_reg_in.raddr0 = v.rid[DEPTH:1] + ONE;
      hazard_reg_in.raddr1 = v.rid[DEPTH:1];
      if (v.wid == v.rid[DEPTH:1]) begin
        instr0 = wdata0;
        instr1 = wdata1;
      end
      else if (v.wid == v.rid[DEPTH:1] + ONE) begin
        instr0 = hazard_reg_out.rdata1;
        instr1 = wdata0;
      end
      else begin
        instr0 = hazard_reg_out.rdata1;
        instr1 = hazard_reg_out.rdata0;
      end
    end

    if (v.wen == 1) begin
      v.wid   = v.wid + 1;
      v.count = v.count + 2;
    end

    calc0 = init_calculation;
    calc1 = init_calculation;

    calc0.pc     = instr0.pc;
    calc0.npc    = instr0.npc;
    calc0.instr  = instr0.instr;
    calc0.imm    = instr0.imm;
    calc0.waddr  = instr0.waddr;
    calc0.raddr1 = instr0.raddr1;
    calc0.raddr2 = instr0.raddr2;
    calc0.raddr3 = instr0.raddr3;
    calc0.caddr  = instr0.caddr;
    calc0.fmt    = instr0.fmt;
    calc0.rm     = instr0.rm;
    calc0.op     = instr0.op;
    calc0.alu_op = instr0.alu_op;
    calc0.bcu_op = instr0.bcu_op;
    calc0.lsu_op = instr0.lsu_op;
    calc0.csr_op = instr0.csr_op;
    calc0.div_op = instr0.div_op;
    calc0.mul_op = instr0.mul_op;
    calc0.bit_op = instr0.bit_op;
    calc0.pred   = instr0.pred;

    calc1.pc     = instr1.pc;
    calc1.npc    = instr1.npc;
    calc1.instr  = instr1.instr;
    calc1.imm    = instr1.imm;
    calc1.waddr  = instr1.waddr;
    calc1.raddr1 = instr1.raddr1;
    calc1.raddr2 = instr1.raddr2;
    calc1.raddr3 = instr1.raddr3;
    calc1.caddr  = instr1.caddr;
    calc1.fmt    = instr1.fmt;
    calc1.rm     = instr1.rm;
    calc1.op     = instr1.op;
    calc1.alu_op = instr1.alu_op;
    calc1.bcu_op = instr1.bcu_op;
    calc1.lsu_op = instr1.lsu_op;
    calc1.csr_op = instr1.csr_op;
    calc1.div_op = instr1.div_op;
    calc1.mul_op = instr1.mul_op;
    calc1.bit_op = instr1.bit_op;
    calc1.pred   = instr1.pred;

    v.single = calc0.op.fence | calc0.op.mret | calc0.op.wfi | calc0.op.csreg | calc1.op.fence | calc1.op.mret |
        calc1.op.wfi | calc1.op.csreg;
    v.single = v.single | (calc0.op.store & calc1.op.load);
    v.single = v.single | (calc0.op.load & calc1.op.store);
    v.single = v.single | (calc0.op.division & calc1.op.division);
    v.single = v.single | (calc0.op.mult & calc1.op.mult);

    if (v.count > 1) begin
      if (v.single == 1) begin
        v.diff = 1;
      end
      else begin
        v.diff = 2;
        if (calc0.op.wren == 1) begin
          if (calc1.op.rden1 == 1 && calc1.raddr1 == calc0.waddr) begin
            v.diff = 1;
          end
          if (calc1.op.rden2 == 1 && calc1.raddr2 == calc0.waddr) begin
            v.diff = 1;
          end
        end
      end
    end
    else if (v.count > 0) begin
      v.diff = 1;
    end
    else begin
      v.diff = 0;
    end

    if (hazard_in.stall == 1) begin
      v.diff = 0;
    end

    v.count = v.count - v.diff;
    v.rid   = v.rid + v.diff;

    v.stall = 0;

    if (v.count > TOTAL) begin
      v.stall = 1;
    end

    hazard_out.calc0 = v.diff > 0 ? calc0 : init_calculation;
    hazard_out.calc1 = v.diff > 1 ? calc1 : init_calculation;
    hazard_out.stall = v.stall;

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

module hazard (
  input  logic           reset,
  input  logic           clock,
  input  hazard_in_type  hazard_in,
  output hazard_out_type hazard_out
);
  timeunit 1ns; timeprecision 1ps;

  hazard_reg_in_type  hazard_reg_in;
  hazard_reg_out_type hazard_reg_out;

  hazard_reg hazard_reg_comp (
    .clock         (clock),
    .hazard_reg_in (hazard_reg_in),
    .hazard_reg_out(hazard_reg_out)
  );

  hazard_ctrl hazard_ctrl_comp (
    .reset         (reset),
    .clock         (clock),
    .hazard_in     (hazard_in),
    .hazard_out    (hazard_out),
    .hazard_reg_in (hazard_reg_in),
    .hazard_reg_out(hazard_reg_out)
  );

endmodule
