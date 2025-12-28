import configure::*;
import wires::*;

module rom (
    input logic reset,
    input logic clock,
    input mem_in_type rom_in,
    output mem_out_type rom_out
);
  timeunit 1ns; timeprecision 1ps;

  logic [63 : 0] rdata;
  logic [ 0 : 0] ready;

  generate

    if (hardware == 0) begin : rom_simulation

      logic [3 : 0] raddr;

      assign raddr = rom_in.mem_addr[6:3];

      always_ff @(posedge clock) begin
        case (raddr)
          4'b0000: rdata <= 64'h4201418141014081;
          4'b0001: rdata <= 64'h4401438143014281;
          4'b0010: rdata <= 64'h4601458145014481;
          4'b0011: rdata <= 64'h4801478147014681;
          4'b0100: rdata <= 64'h4A01498149014881;
          4'b0101: rdata <= 64'h4C014B814B014A81;
          4'b0110: rdata <= 64'h4E014D814D014C81;
          4'b0111: rdata <= 64'h82934F814F014E81;
          4'b1000: rdata <= 64'h02B73002A0736002;
          4'b1001: rdata <= 64'h0000000280678000;
          4'b1010: rdata <= 64'h0000000000000000;
          4'b1011: rdata <= 64'h0000000000000000;
          4'b1100: rdata <= 64'h0000000000000000;
          4'b1101: rdata <= 64'h0000000000000000;
          4'b1110: rdata <= 64'h0000000000000000;
          4'b1111: rdata <= 64'h0000000000000000;
        endcase
      end

    end

    if (hardware == 1) begin : rom_hardware

      logic [4 : 0] raddr;

      assign raddr = rom_in.mem_addr[7:3];

      always_ff @(posedge clock) begin
        case (raddr)
          5'b00000: rdata <= 64'h4201418141014081;
          5'b00001: rdata <= 64'h4401438143014281;
          5'b00010: rdata <= 64'h4601458145014481;
          5'b00011: rdata <= 64'h4801478147014681;
          5'b00100: rdata <= 64'h4A01498149014881;
          5'b00101: rdata <= 64'h4C014B814B014A81;
          5'b00110: rdata <= 64'h4E014D814D014C81;
          5'b00111: rdata <= 64'h62F94F814F014E81;
          5'b01000: rdata <= 64'h3002A07360028293;
          5'b01001: rdata <= 64'h62853002A07342A1;
          5'b01010: rdata <= 64'h3042A07380028293;
          5'b01011: rdata <= 64'h0202829300000297;
          5'b01100: rdata <= 64'h010002B730529073;
          5'b01101: rdata <= 64'h43818000033702C1;
          5'b01110: rdata <= 64'h0001A00100080E37;
          5'b01111: rdata <= 64'h2F830F6101000F37;
          5'b10000: rdata <= 64'h17E30FF00F13000F;
          5'b10001: rdata <= 64'h002300028E83FFFF;
          5'b10010: rdata <= 64'hD4630385030501D3;
          5'b10011: rdata <= 64'h00B73020007301C3;
          5'b10100: rdata <= 64'h0001000080678000;
          5'b10101: rdata <= 64'h0000000000000000;
          5'b10110: rdata <= 64'h0000000000000000;
          5'b10111: rdata <= 64'h0000000000000000;
          5'b11000: rdata <= 64'h0000000000000000;
          5'b11001: rdata <= 64'h0000000000000000;
          5'b11010: rdata <= 64'h0000000000000000;
          5'b11011: rdata <= 64'h0000000000000000;
          5'b11100: rdata <= 64'h0000000000000000;
          5'b11101: rdata <= 64'h0000000000000000;
          5'b11110: rdata <= 64'h0000000000000000;
          5'b11111: rdata <= 64'h0000000000000000;
        endcase
      end

    end

  endgenerate

  always_ff @(posedge clock) begin

    if (rom_in.mem_valid == 1) begin
      ready <= 1;
    end else begin
      ready <= 0;
    end

  end

  assign rom_out.mem_rdata = rdata;
  assign rom_out.mem_error = 0;
  assign rom_out.mem_ready = ready;


endmodule
