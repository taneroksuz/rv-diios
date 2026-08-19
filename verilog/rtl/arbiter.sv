import wires::*;
import constants::*;

module arbiter (
  input  logic        reset,
  input  logic        clock,
  input  mem_in_type  imem0_in,
  input  mem_in_type  imem1_in,
  output mem_out_type imem0_out,
  output mem_out_type imem1_out,
  input  mem_in_type  dmem0_in,
  input  mem_in_type  dmem1_in,
  output mem_out_type dmem0_out,
  output mem_out_type dmem1_out,
  output mem_in_type  mem_in,
  input  mem_out_type mem_out
);
  timeunit 1ns; timeprecision 1ps;

  localparam [2:0] no_access = 0;
  localparam [2:0] instr0_access = 1;
  localparam [2:0] instr1_access = 2;
  localparam [2:0] data0_access = 3;
  localparam [2:0] data1_access = 4;

  typedef struct packed {
    logic [2:0] access_type;
    mem_in_type mem_in;
    mem_in_type imem0_in;
    mem_in_type imem1_in;
    mem_in_type dmem0_in;
    mem_in_type dmem1_in;
    logic [0:0] iactive0;
    logic [0:0] iactive1;
    logic [0:0] dactive0;
    logic [0:0] dactive1;
  } reg_type;

  localparam reg_type init_reg = '{default: 0};

  reg_type r, rin;
  reg_type v;

  always_comb begin

    v = r;

    v.mem_in = init_mem_in;

    if (mem_out.mem_ready == 1) begin
      v.access_type = no_access;
    end

    v.iactive0 = (v.access_type == instr0_access);
    v.iactive1 = (v.access_type == instr1_access);
    v.dactive0 = (v.access_type == data0_access);
    v.dactive1 = (v.access_type == data1_access);

    if (dmem0_in.mem_valid == 1 && v.dmem0_in.mem_valid == 0 && v.dactive0 == 0) begin
      v.dmem0_in = dmem0_in;
    end
    if (dmem1_in.mem_valid == 1 && v.dmem1_in.mem_valid == 0 && v.dactive1 == 0) begin
      v.dmem1_in = dmem1_in;
    end
    if (imem0_in.mem_valid == 1 && v.imem0_in.mem_valid == 0 && v.iactive0 == 0) begin
      v.imem0_in = imem0_in;
    end
    if (imem1_in.mem_valid == 1 && v.imem1_in.mem_valid == 0 && v.iactive1 == 0) begin
      v.imem1_in = imem1_in;
    end

    if (v.access_type == no_access) begin
      if (v.dmem0_in.mem_valid == 1) begin
        v.access_type = data0_access;
        v.mem_in      = v.dmem0_in;
        v.dmem0_in    = init_mem_in;
      end else if (v.dmem1_in.mem_valid == 1) begin
        v.access_type = data1_access;
        v.mem_in      = v.dmem1_in;
        v.dmem1_in    = init_mem_in;
      end else if (v.imem0_in.mem_valid == 1) begin
        v.access_type = instr0_access;
        v.mem_in      = v.imem0_in;
        v.imem0_in    = init_mem_in;
      end else if (v.imem1_in.mem_valid == 1) begin
        v.access_type = instr1_access;
        v.mem_in      = v.imem1_in;
        v.imem1_in    = init_mem_in;
      end
    end

    mem_in = v.mem_in;

    rin = v;

    dmem0_out = (r.access_type == data0_access) ? mem_out : init_mem_out;
    dmem1_out = (r.access_type == data1_access) ? mem_out : init_mem_out;
    imem0_out = (r.access_type == instr0_access) ? mem_out : init_mem_out;
    imem1_out = (r.access_type == instr1_access) ? mem_out : init_mem_out;

  end

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      r <= init_reg;
    end else begin
      r <= rin;
    end
  end

endmodule
