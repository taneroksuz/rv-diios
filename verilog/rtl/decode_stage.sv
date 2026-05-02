import constants::*;
import wires::*;
import functions::*;

module decode_stage (
  input  logic             reset,
  input  logic             clear,
  input  logic             clock,
  input  base_out_type     base0_out,
  output base_in_type      base0_in,
  input  base_out_type     base1_out,
  output base_in_type      base1_in,
  input  compress_out_type compress0_out,
  output compress_in_type  compress0_in,
  input  compress_out_type compress1_out,
  output compress_in_type  compress1_in,
  input  csr_out_type      csr_out,
  input  btac_out_type     btac_out,
  input  decode_in_type    a,
  input  decode_in_type    d,
  output decode_out_type   y,
  output decode_out_type   q
);
  timeunit 1ns; timeprecision 1ps;

  decode_reg_type r, rin;
  decode_reg_type v;

  always_comb begin

    v                    = r;

    v.instr0.pc          = a.f.ready0 ? a.f.pc0 : 32'hFFFFFFFF;
    v.instr1.pc          = a.f.ready1 ? a.f.pc1 : 32'hFFFFFFFF;
    v.instr0.instr       = a.f.ready0 ? a.f.instr0 : 0;
    v.instr1.instr       = a.f.ready1 ? a.f.instr1 : 0;

    v.instr0.npc         = v.instr0.pc + ((&v.instr0.instr[1:0]) ? 4 : 2);
    v.instr1.npc         = v.instr1.pc + ((&v.instr1.instr[1:0]) ? 4 : 2);

    v.stall              = 0;

    v.instr0.waddr       = v.instr0.instr[11:7];
    v.instr0.raddr1      = v.instr0.instr[19:15];
    v.instr0.raddr2      = v.instr0.instr[24:20];
    v.instr0.raddr3      = v.instr0.instr[31:27];
    v.instr0.caddr       = v.instr0.instr[31:20];

    v.instr1.waddr       = v.instr1.instr[11:7];
    v.instr1.raddr1      = v.instr1.instr[19:15];
    v.instr1.raddr2      = v.instr1.instr[24:20];
    v.instr1.raddr3      = v.instr1.instr[31:27];
    v.instr1.caddr       = v.instr1.instr[31:20];

    base0_in.instr       = v.instr0.instr;

    v.instr0.instr_str   = base0_out.instr_str;
    v.instr0.imm         = base0_out.imm;
    v.instr0.op.wren     = base0_out.wren;
    v.instr0.op.rden1    = base0_out.rden1;
    v.instr0.op.rden2    = base0_out.rden2;
    v.instr0.op.cwren    = base0_out.cwren;
    v.instr0.op.crden    = base0_out.crden;
    v.instr0.op.alunit   = base0_out.alunit;
    v.instr0.op.auipc    = base0_out.auipc;
    v.instr0.op.lui      = base0_out.lui;
    v.instr0.op.jal      = base0_out.jal;
    v.instr0.op.jalr     = base0_out.jalr;
    v.instr0.op.branch   = base0_out.branch;
    v.instr0.op.load     = base0_out.load;
    v.instr0.op.store    = base0_out.store;
    v.instr0.op.nop      = base0_out.nop;
    v.instr0.op.csreg    = base0_out.csreg;
    v.instr0.op.division = base0_out.division;
    v.instr0.op.mult     = base0_out.mult;
    v.instr0.op.bitm     = base0_out.bitm;
    v.instr0.op.bitc     = base0_out.bitc;
    v.instr0.op.fence    = base0_out.fence;
    v.instr0.op.ecall    = base0_out.ecall;
    v.instr0.op.ebreak   = base0_out.ebreak;
    v.instr0.op.mret     = base0_out.mret;
    v.instr0.op.wfi      = base0_out.wfi;
    v.instr0.op.valid    = base0_out.valid;
    v.instr0.alu_op      = base0_out.alu_op;
    v.instr0.bcu_op      = base0_out.bcu_op;
    v.instr0.lsu_op      = base0_out.lsu_op;
    v.instr0.csr_op      = base0_out.csr_op;
    v.instr0.div_op      = base0_out.div_op;
    v.instr0.mul_op      = base0_out.mul_op;
    v.instr0.bit_op      = base0_out.bit_op;

    base1_in.instr       = v.instr1.instr;

    v.instr1.instr_str   = base1_out.instr_str;
    v.instr1.imm         = base1_out.imm;
    v.instr1.op.wren     = base1_out.wren;
    v.instr1.op.rden1    = base1_out.rden1;
    v.instr1.op.rden2    = base1_out.rden2;
    v.instr1.op.cwren    = base1_out.cwren;
    v.instr1.op.crden    = base1_out.crden;
    v.instr1.op.alunit   = base1_out.alunit;
    v.instr1.op.auipc    = base1_out.auipc;
    v.instr1.op.lui      = base1_out.lui;
    v.instr1.op.jal      = base1_out.jal;
    v.instr1.op.jalr     = base1_out.jalr;
    v.instr1.op.branch   = base1_out.branch;
    v.instr1.op.load     = base1_out.load;
    v.instr1.op.store    = base1_out.store;
    v.instr1.op.nop      = base1_out.nop;
    v.instr1.op.csreg    = base1_out.csreg;
    v.instr1.op.division = base1_out.division;
    v.instr1.op.mult     = base1_out.mult;
    v.instr1.op.bitm     = base1_out.bitm;
    v.instr1.op.bitc     = base1_out.bitc;
    v.instr1.op.fence    = base1_out.fence;
    v.instr1.op.ecall    = base1_out.ecall;
    v.instr1.op.ebreak   = base1_out.ebreak;
    v.instr1.op.mret     = base1_out.mret;
    v.instr1.op.wfi      = base1_out.wfi;
    v.instr1.op.valid    = base1_out.valid;
    v.instr1.alu_op      = base1_out.alu_op;
    v.instr1.bcu_op      = base1_out.bcu_op;
    v.instr1.lsu_op      = base1_out.lsu_op;
    v.instr1.csr_op      = base1_out.csr_op;
    v.instr1.div_op      = base1_out.div_op;
    v.instr1.mul_op      = base1_out.mul_op;
    v.instr1.bit_op      = base1_out.bit_op;

    compress0_in.instr   = v.instr0.instr;

    if (compress0_out.valid == 1) begin
      v.instr0.instr_str = compress0_out.instr_str;
      v.instr0.imm       = compress0_out.imm;
      v.instr0.waddr     = compress0_out.waddr;
      v.instr0.raddr1    = compress0_out.raddr1;
      v.instr0.raddr2    = compress0_out.raddr2;
      v.instr0.op.wren   = compress0_out.wren;
      v.instr0.op.rden1  = compress0_out.rden1;
      v.instr0.op.rden2  = compress0_out.rden2;
      v.instr0.op.alunit = compress0_out.alunit;
      v.instr0.op.lui    = compress0_out.lui;
      v.instr0.op.jal    = compress0_out.jal;
      v.instr0.op.jalr   = compress0_out.jalr;
      v.instr0.op.branch = compress0_out.branch;
      v.instr0.op.load   = compress0_out.load;
      v.instr0.op.store  = compress0_out.store;
      v.instr0.op.nop    = compress0_out.nop;
      v.instr0.op.ebreak = compress0_out.ebreak;
      v.instr0.op.valid  = compress0_out.valid;
      v.instr0.alu_op    = compress0_out.alu_op;
      v.instr0.bcu_op    = compress0_out.bcu_op;
      v.instr0.lsu_op    = compress0_out.lsu_op;
    end

    compress1_in.instr = v.instr1.instr;

    if (compress1_out.valid == 1) begin
      v.instr1.instr_str = compress1_out.instr_str;
      v.instr1.imm       = compress1_out.imm;
      v.instr1.waddr     = compress1_out.waddr;
      v.instr1.raddr1    = compress1_out.raddr1;
      v.instr1.raddr2    = compress1_out.raddr2;
      v.instr1.op.wren   = compress1_out.wren;
      v.instr1.op.rden1  = compress1_out.rden1;
      v.instr1.op.rden2  = compress1_out.rden2;
      v.instr1.op.alunit = compress1_out.alunit;
      v.instr1.op.lui    = compress1_out.lui;
      v.instr1.op.jal    = compress1_out.jal;
      v.instr1.op.jalr   = compress1_out.jalr;
      v.instr1.op.branch = compress1_out.branch;
      v.instr1.op.load   = compress1_out.load;
      v.instr1.op.store  = compress1_out.store;
      v.instr1.op.nop    = compress1_out.nop;
      v.instr1.op.ebreak = compress1_out.ebreak;
      v.instr1.op.valid  = compress1_out.valid;
      v.instr1.alu_op    = compress1_out.alu_op;
      v.instr1.bcu_op    = compress1_out.bcu_op;
      v.instr1.lsu_op    = compress1_out.lsu_op;
    end

    if (a.f.ready0 == 1) begin
      if (v.instr0.op.valid == 0) begin
        v.instr0.op.exception = 1;
        v.instr0.op.valid     = 1;
      end
    end

    if (a.f.ready1 == 1) begin
      if (v.instr1.op.valid == 0) begin
        v.instr1.op.exception = 1;
        v.instr1.op.valid     = 1;
      end
    end

    if (v.stall == 1) begin
      v.instr0 = init_instruction;
      v.instr1 = init_instruction;
    end

    if ((a.m.calc0.op.fence | csr_out.trap | csr_out.mret | btac_out.pred_miss | clear) == 1) begin
      v.instr0 = init_instruction;
      v.instr1 = init_instruction;
    end

    rin      = v;

    y.instr0 = v.instr0;
    y.instr1 = v.instr1;
    y.stall  = v.stall;

    q.instr0 = r.instr0;
    q.instr1 = r.instr1;
    q.stall  = r.stall;

  end

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      r <= init_decode_reg;
    end else begin
      r <= rin;
    end
  end

endmodule
