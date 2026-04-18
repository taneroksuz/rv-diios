package tim_wires;
  timeunit 1ns; timeprecision 1ps;

  import configure::*;

  localparam DEPTH = $clog2(TIM_DEPTH);
  localparam WIDTH = $clog2(TIM_WIDTH);

  typedef struct packed {
    logic [0 : 0] en0;
    logic [0 : 0] en1;
    logic [DEPTH-1 : 0] addr0;
    logic [DEPTH-1 : 0] addr1;
    logic [3 : 0] strb0;
    logic [3 : 0] strb1;
    logic [31 : 0] data0;
    logic [31 : 0] data1;
  } tim_ram_in_type;

  typedef struct packed {
    logic [31 : 0] data0;
    logic [31 : 0] data1;
  } tim_ram_out_type;

  typedef tim_ram_in_type tim_vec_in_type[TIM_WIDTH];
  typedef tim_ram_out_type tim_vec_out_type[TIM_WIDTH];

  localparam tim_vec_in_type init_tim_vec_in = '{default: '0};
  localparam tim_vec_out_type init_tim_vec_out = '{default: '0};

endpackage

import configure::*;
import wires::*;
import tim_wires::*;

module tim_ram (
    input logic clock,
    input tim_ram_in_type tim_ram_in,
    output tim_ram_out_type tim_ram_out
);
  timeunit 1ns; timeprecision 1ps;

  localparam DEPTH = $clog2(TIM_DEPTH);
  localparam WIDTH = $clog2(TIM_WIDTH);

  generate

    if (RAM_TYPE == 0) begin

      logic [31 : 0] tim_ram[0:TIM_DEPTH-1] = '{default: '0};

      always_ff @(posedge clock) begin
        if (tim_ram_in.en0 == 1) begin
          if (tim_ram_in.strb0[0]) tim_ram[tim_ram_in.addr0][7:0] <= tim_ram_in.data0[7:0];
          if (tim_ram_in.strb0[1]) tim_ram[tim_ram_in.addr0][15:8] <= tim_ram_in.data0[15:8];
          if (tim_ram_in.strb0[2]) tim_ram[tim_ram_in.addr0][23:16] <= tim_ram_in.data0[23:16];
          if (tim_ram_in.strb0[3]) tim_ram[tim_ram_in.addr0][31:24] <= tim_ram_in.data0[31:24];
          tim_ram_out.data0 <= tim_ram[tim_ram_in.addr0];
        end
      end
      always_ff @(posedge clock) begin
        if (tim_ram_in.en1 == 1) begin
          if (tim_ram_in.strb1[0]) tim_ram[tim_ram_in.addr1][7:0] <= tim_ram_in.data1[7:0];
          if (tim_ram_in.strb1[1]) tim_ram[tim_ram_in.addr1][15:8] <= tim_ram_in.data1[15:8];
          if (tim_ram_in.strb1[2]) tim_ram[tim_ram_in.addr1][23:16] <= tim_ram_in.data1[23:16];
          if (tim_ram_in.strb1[3]) tim_ram[tim_ram_in.addr1][31:24] <= tim_ram_in.data1[31:24];
          tim_ram_out.data1 <= tim_ram[tim_ram_in.addr1];
        end
      end

    end

    if (RAM_TYPE == 1) begin

      logic [3 : 0][7 : 0] tim_ram[0:TIM_DEPTH-1] = '{default: '0};

      always_ff @(posedge clock) begin
        if (tim_ram_in.strb0[0]) tim_ram[tim_ram_in.addr0][0] <= tim_ram_in.data0[7:0];
        if (tim_ram_in.strb0[1]) tim_ram[tim_ram_in.addr0][1] <= tim_ram_in.data0[15:8];
        if (tim_ram_in.strb0[2]) tim_ram[tim_ram_in.addr0][2] <= tim_ram_in.data0[23:16];
        if (tim_ram_in.strb0[3]) tim_ram[tim_ram_in.addr0][3] <= tim_ram_in.data0[31:24];
        tim_ram_out.data0 <= tim_ram[tim_ram_in.addr0];
      end
      always_ff @(posedge clock) begin
        if (tim_ram_in.strb1[0]) tim_ram[tim_ram_in.addr1][0] <= tim_ram_in.data1[7:0];
        if (tim_ram_in.strb1[1]) tim_ram[tim_ram_in.addr1][1] <= tim_ram_in.data1[15:8];
        if (tim_ram_in.strb1[2]) tim_ram[tim_ram_in.addr1][2] <= tim_ram_in.data1[23:16];
        if (tim_ram_in.strb1[3]) tim_ram[tim_ram_in.addr1][3] <= tim_ram_in.data1[31:24];
        tim_ram_out.data1 <= tim_ram[tim_ram_in.addr1];
      end

    end

  endgenerate

endmodule

module tim_ctrl (
    input logic reset,
    input logic clock,
    input tim_vec_out_type dvec_out,
    output tim_vec_in_type dvec_in,
    input mem_in_type tim0_in,
    input mem_in_type tim1_in,
    output mem_out_type tim0_out,
    output mem_out_type tim1_out
);
  timeunit 1ns; timeprecision 1ps;

  localparam DEPTH = $clog2(TIM_DEPTH);
  localparam WIDTH = $clog2(TIM_WIDTH);

  typedef struct packed {
    logic [WIDTH-1:0] wid0;
    logic [WIDTH-1:0] wid1;
    logic [DEPTH-1:0] did0;
    logic [DEPTH-1:0] did1;
    logic [31:0] data0;
    logic [31:0] data1;
    logic [3:0] strb0;
    logic [3:0] strb1;
    logic [0:0] valid0;
    logic [0:0] valid1;
  } front_type;

  typedef struct packed {
    logic [WIDTH-1:0] wid0;
    logic [WIDTH-1:0] wid1;
    logic [DEPTH-1:0] did0;
    logic [DEPTH-1:0] did1;
    logic [31:0] rdata0;
    logic [31:0] rdata1;
    logic [31:0] data0;
    logic [31:0] data1;
    logic [3:0] strb0;
    logic [3:0] strb1;
    logic [0:0] valid0;
    logic [0:0] valid1;
  } back_type;

  parameter front_type init_front = 0;
  parameter back_type init_back = 0;

  front_type r_f, rin_f;
  front_type v_f;

  back_type r_b, rin_b;
  back_type v_b;

  always_comb begin

    v_f = r_f;

    v_f.valid0 = 0;
    v_f.valid1 = 0;
    v_f.strb0 = 0;
    v_f.strb1 = 0;

    if (tim0_in.mem_valid == 1) begin
      v_f.valid0 = tim0_in.mem_valid;
      v_f.strb0  = tim0_in.mem_wstrb;
      v_f.data0  = tim0_in.mem_wdata;
      v_f.did0   = tim0_in.mem_addr[(DEPTH+WIDTH+1):(WIDTH+2)];
      v_f.wid0   = tim0_in.mem_addr[(WIDTH+1):2];
    end

    if (tim1_in.mem_valid == 1) begin
      v_f.valid1 = tim1_in.mem_valid;
      v_f.strb1  = tim1_in.mem_wstrb;
      v_f.data1  = tim1_in.mem_wdata;
      v_f.did1   = tim1_in.mem_addr[(DEPTH+WIDTH+1):(WIDTH+2)];
      v_f.wid1   = tim1_in.mem_addr[(WIDTH+1):2];
    end

    dvec_in = init_tim_vec_in;

    dvec_in[v_f.wid0].en0 = v_f.valid0;
    dvec_in[v_f.wid1].en1 = v_f.valid1;
    dvec_in[v_f.wid0].strb0 = v_f.strb0;
    dvec_in[v_f.wid1].strb1 = v_f.strb1;
    dvec_in[v_f.wid0].addr0 = v_f.did0;
    dvec_in[v_f.wid1].addr1 = v_f.did1;
    dvec_in[v_f.wid0].data0 = v_f.data0;
    dvec_in[v_f.wid1].data1 = v_f.data1;

    rin_f = v_f;

  end

  always_comb begin

    v_b = r_b;

    v_b.valid0 = r_f.valid0;
    v_b.valid1 = r_f.valid1;
    v_b.data0 = r_f.data0;
    v_b.data1 = r_f.data1;
    v_b.strb0 = r_f.strb0;
    v_b.strb1 = r_f.strb1;
    v_b.wid0 = r_f.wid0;
    v_b.wid1 = r_f.wid1;
    v_b.did0 = r_f.did0;
    v_b.did1 = r_f.did1;

    v_b.rdata0 = dvec_out[v_b.wid0].data0;
    v_b.rdata1 = dvec_out[v_b.wid1].data1;

    tim0_out.mem_rdata = v_b.rdata0;
    tim0_out.mem_error = 0;
    tim0_out.mem_ready = v_b.valid0;

    tim1_out.mem_rdata = v_b.rdata1;
    tim1_out.mem_error = 0;
    tim1_out.mem_ready = v_b.valid1;

    rin_b = v_b;

  end

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      r_f <= init_front;
      r_b <= init_back;
    end else begin
      r_f <= rin_f;
      r_b <= rin_b;
    end
  end

endmodule

module tim (
    input logic reset,
    input logic clock,
    input mem_in_type tim0_in,
    input mem_in_type tim1_in,
    output mem_out_type tim0_out,
    output mem_out_type tim1_out
);
  timeunit 1ns; timeprecision 1ps;

  tim_vec_in_type  dvec_in;
  tim_vec_out_type dvec_out;

  generate

    genvar i;

    for (i = 0; i < TIM_WIDTH; i = i + 1) begin : tim_ram
      tim_ram tim_ram_comp (
          .clock(clock),
          .tim_ram_in(dvec_in[i]),
          .tim_ram_out(dvec_out[i])
      );
    end

  endgenerate

  tim_ctrl tim_ctrl_comp (
      .reset(reset),
      .clock(clock),
      .dvec_out(dvec_out),
      .dvec_in(dvec_in),
      .tim0_in(tim0_in),
      .tim1_in(tim1_in),
      .tim0_out(tim0_out),
      .tim1_out(tim1_out)
  );

endmodule
