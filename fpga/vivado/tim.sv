package tim_wires;
  timeunit 1ns; timeprecision 1ps;

  import configure::*;

  localparam TIM_WORDS = TIM_WIDTH * TIM_DEPTH;
  localparam TADDR     = $clog2(TIM_WORDS);

  typedef struct packed {
    logic [1:0][0:0]       en;
    logic [1:0][TADDR-1:0] addr;
    logic [1:0][3:0]       strb;
    logic [1:0][31:0]      data;
  } tim_ram_in_type;

  typedef struct packed {logic [1:0][31:0] data;} tim_ram_out_type;

  localparam tim_ram_in_type  init_tim_ram_in  = '{default: '0};
  localparam tim_ram_out_type init_tim_ram_out = '{default: '0};

endpackage

import configure::*;
import wires::*;
import tim_wires::*;

module tim_ram (
  input  logic            clock,
  input  tim_ram_in_type  tim_ram_in,
  output tim_ram_out_type tim_ram_out
);
  timeunit 1ns; timeprecision 1ps;

  logic we_a, we_b;
  logic [3:0] be_a, be_b;
  logic [TADDR-1:0] addr_a, addr_b;
  logic [31:0] d_a, d_b;
  logic [31:0] q_a, q_b;

  assign we_a   = tim_ram_in.en[0] && (|tim_ram_in.strb[0]);
  assign we_b   = tim_ram_in.en[1] && (|tim_ram_in.strb[1]);
  assign be_a   = tim_ram_in.strb[0];
  assign be_b   = tim_ram_in.strb[1];
  assign addr_a = tim_ram_in.addr[0];
  assign addr_b = tim_ram_in.addr[1];
  assign d_a    = tim_ram_in.data[0];
  assign d_b    = tim_ram_in.data[1];

  assign tim_ram_out.data[0] = q_a;
  assign tim_ram_out.data[1] = q_b;

  (* ram_style = "block" *) logic [31:0] mem[0:TIM_WORDS-1];

  always_ff @(posedge clock) begin
    if (we_a && be_a[0]) mem[addr_a][7:0] <= d_a[7:0];
    if (we_a && be_a[1]) mem[addr_a][15:8] <= d_a[15:8];
    if (we_a && be_a[2]) mem[addr_a][23:16] <= d_a[23:16];
    if (we_a && be_a[3]) mem[addr_a][31:24] <= d_a[31:24];
    q_a <= mem[addr_a];
  end

  always_ff @(posedge clock) begin
    if (we_b && be_b[0]) mem[addr_b][7:0] <= d_b[7:0];
    if (we_b && be_b[1]) mem[addr_b][15:8] <= d_b[15:8];
    if (we_b && be_b[2]) mem[addr_b][23:16] <= d_b[23:16];
    if (we_b && be_b[3]) mem[addr_b][31:24] <= d_b[31:24];
    q_b <= mem[addr_b];
  end

endmodule

module tim_ctrl (
  input  logic            reset,
  input  logic            clock,
  input  tim_ram_out_type dvec_out,
  output tim_ram_in_type  dvec_in,
  input  mem_in_type      tim_in  [0:1],
  output mem_out_type     tim_out [0:1]
);
  timeunit 1ns; timeprecision 1ps;

  typedef struct packed {
    logic [1:0][TADDR-1:0] did;
    logic [1:0][31:0]      data;
    logic [1:0][3:0]       strb;
    logic [1:0][0:0]       valid;
  } front_type;

  typedef struct packed {
    logic [1:0][TADDR-1:0] did;
    logic [1:0][31:0]      rdata;
    logic [1:0][31:0]      data;
    logic [1:0][3:0]       strb;
    logic [1:0][0:0]       valid;
  } back_type;

  parameter front_type init_front = 0;
  parameter back_type  init_back  = 0;

  front_type r_f, rin_f;
  front_type v_f;

  back_type r_b, rin_b;
  back_type v_b;

  always_comb begin

    v_f = r_f;

    for (int p = 0; p < 2; p++) begin
      v_f.valid[p] = 0;
      v_f.strb[p]  = 0;

      if (tim_in[p].mem_valid == 1) begin
        v_f.valid[p] = tim_in[p].mem_valid;
        v_f.strb[p]  = tim_in[p].mem_wstrb;
        v_f.data[p]  = tim_in[p].mem_wdata;
        v_f.did[p]   = tim_in[p].mem_addr[(TADDR+1):2];
      end
    end

    dvec_in = init_tim_ram_in;

    for (int p = 0; p < 2; p++) begin
      dvec_in.en[p]   = v_f.valid[p];
      dvec_in.strb[p] = v_f.strb[p];
      dvec_in.addr[p] = v_f.did[p];
      dvec_in.data[p] = v_f.data[p];
    end

    rin_f = v_f;

  end

  always_comb begin

    v_b = r_b;

    for (int p = 0; p < 2; p++) begin
      v_b.valid[p] = r_f.valid[p];
      v_b.data[p]  = r_f.data[p];
      v_b.strb[p]  = r_f.strb[p];
      v_b.did[p]   = r_f.did[p];

      v_b.rdata[p] = dvec_out.data[p];
    end

    for (int p = 0; p < 2; p++) begin
      tim_out[p].mem_rdata = v_b.rdata[p];
      tim_out[p].mem_error = 0;
      tim_out[p].mem_ready = v_b.valid[p];
    end

    rin_b = v_b;

  end

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      r_f <= init_front;
      r_b <= init_back;
    end
    else begin
      r_f <= rin_f;
      r_b <= rin_b;
    end
  end

endmodule

module tim (
  input  logic        reset,
  input  logic        clock,
  input  mem_in_type  tim0_in,
  input  mem_in_type  tim1_in,
  output mem_out_type tim0_out,
  output mem_out_type tim1_out
);
  timeunit 1ns; timeprecision 1ps;

  tim_ram_in_type  dvec_in;
  tim_ram_out_type dvec_out;

  mem_in_type  tim_in [0:1];
  mem_out_type tim_out[0:1];

  assign tim_in[0] = tim0_in;
  assign tim_in[1] = tim1_in;
  assign tim0_out  = tim_out[0];
  assign tim1_out  = tim_out[1];

  tim_ram tim_ram_comp (
    .clock      (clock),
    .tim_ram_in (dvec_in),
    .tim_ram_out(dvec_out)
  );

  tim_ctrl tim_ctrl_comp (
    .reset   (reset),
    .clock   (clock),
    .dvec_out(dvec_out),
    .dvec_in (dvec_in),
    .tim_in  (tim_in),
    .tim_out (tim_out)
  );

endmodule
