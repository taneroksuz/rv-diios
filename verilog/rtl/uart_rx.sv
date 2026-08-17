import configure::*;
import wires::*;

module uart_rx #(
  parameter CLOCK_RATE
) (
  input  logic        reset,
  input  logic        clock,
  input  mem_in_type  uart_in,
  output mem_out_type uart_out,
  output logic        rx_irq,
  input               rx
);
  timeunit 1ns; timeprecision 1ps;

  localparam FULL = CLOCK_RATE - 1;
  localparam HALF = CLOCK_RATE + (CLOCK_RATE / 2) - 1;

  typedef struct packed {
    logic [31:0] counter;
    logic [7:0]  rdata_re;
    logic [0:0]  ready_re;
    logic [3:0]  state;
    logic [8:0]  data;
    logic [0:0]  ready;
    logic [1:0]  rx_sync;
  } register_type;

  register_type init_register = '{
      counter : 0,
      rdata_re : 0,
      ready_re : 0,
      state : 0,
      data : 0,
      ready : 0,
      rx_sync : 2'b11
  };

  register_type r, rin, v;

  always_comb begin

    v = r;

    v.rx_sync = {v.rx_sync[0], rx};

    v.counter = v.counter + 1;

    v.rdata_re = 0;
    v.ready_re = 0;

    if (uart_in.mem_valid == 1 && |uart_in.mem_wstrb == 0) begin
      if (uart_in.mem_addr == 0) begin
        v.rdata_re = v.data[8:1];
        v.ready_re = 1;
      end else if (uart_in.mem_addr == 8) begin
        v.rdata_re = {8{v.ready}};
        v.ready_re = 1;
        v.ready    = 0;
      end
    end

    case (r.state)
      0: begin
        if (r.rx_sync[1] == 0) begin
          v.state = 1;
        end
        v.counter = 0;
      end
      1: begin
        if (r.counter > HALF) begin
          v.data    = {r.rx_sync[1], v.data[8:1]};
          v.state   = v.state + 4'h1;
          v.counter = 0;
        end
      end
      9: begin
        if (r.counter > FULL) begin
          v.rdata_re = v.data[8:1];
          v.counter  = 0;
          v.state    = 0;
          v.ready    = 1;
        end
      end
      default: begin
        if (r.counter > FULL) begin
          v.data    = {r.rx_sync[1], v.data[8:1]};
          v.state   = v.state + 4'h1;
          v.counter = 0;
        end
      end
    endcase

    rin = v;

  end

  assign uart_out.mem_rdata = {24'b0, r.rdata_re};
  assign uart_out.mem_error = 0;
  assign uart_out.mem_ready = r.ready_re;
  assign rx_irq             = r.ready;

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      r <= init_register;
    end else begin
      r <= rin;
    end
  end

endmodule
