import configure::*;
import wires::*;

module uart_tx #(
    parameter clock_rate
) (
    input logic reset,
    input logic clock,
    input mem_in_type uart_in,
    output mem_out_type uart_out,
    output logic tx_irq,
    output tx
);
  timeunit 1ns; timeprecision 1ps;

  generate

    if (hardware == 0) begin : uart_simulation

      always_ff @(posedge clock) begin

        if (uart_in.mem_valid == 1) begin

          $write("%c", uart_in.mem_wdata[7:0]);

          uart_out.mem_rdata <= 0;
          uart_out.mem_error <= 0;
          uart_out.mem_ready <= 1;

        end else begin

          uart_out.mem_rdata <= 0;
          uart_out.mem_error <= 0;
          uart_out.mem_ready <= 0;

        end

      end

    end

    if (hardware == 1) begin : uart_hardware

      localparam full = clock_rate - 1;

      typedef struct packed {
        logic [31 : 0] counter;
        logic [7 : 0]  rdata_re;
        logic [0 : 0]  ready_re;
        logic [3 : 0]  state;
        logic [9 : 0]  data;
        logic [0 : 0]  ready;
      } register_type;

      register_type init_register = '{state : 0, data : 10'h3FF, counter : 0, ready : 0};

      register_type r, rin, v;

      always_comb begin

        v = r;

        v.counter = v.counter + 1;

        v.rdata_re = 0;
        v.ready_re = 0;

        if (uart_in.mem_valid == 1) begin
          if (|uart_in.mem_wstrb == 1 && uart_in.mem_addr == 0 && v.state == 0) begin
            v.ready_re = 1;
            v.data = {1'b1, uart_in.mem_wdata[7:0], 1'b0};
            v.state = 1;
          end else if (|uart_in.mem_wstrb == 0 && uart_in.mem_addr == 8) begin
            v.rdata_re = {8{v.ready}};
            v.ready_re = 1;
            v.ready = 0;
          end
        end

        case (r.state)
          0: begin
            v.counter = 0;
          end
          10: begin
            if (r.counter > full) begin
              v.counter = 0;
              v.state   = 0;
              v.ready   = 1;
            end
          end
          default: begin
            if (r.counter > full) begin
              v.data = {1'b1, v.data[9:1]};
              v.state = v.state + 4'h1;
              v.counter = 0;
            end
          end
        endcase

        rin = v;

      end

      assign uart_out.mem_rdata = {56'b0, r.rdata_re};
      assign uart_out.mem_error = 0;
      assign uart_out.mem_ready = r.ready_re;
      assign tx_irq = r.ready;
      assign tx = r.data[0];

      always_ff @(posedge clock) begin
        if (reset == 0) begin
          r <= init_register;
        end else begin
          r <= rin;
        end
      end

    end

  endgenerate

endmodule
