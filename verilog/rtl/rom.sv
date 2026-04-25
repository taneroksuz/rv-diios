import configure::*;
import wires::*;

module rom (
  input  logic        reset,
  input  logic        clock,
  input  mem_in_type  rom_in,
  output mem_out_type rom_out
);
  timeunit 1ns; timeprecision 1ps;

  logic [31 : 0] rdata;
  logic [ 0 : 0] ready;

  generate

    if (HARDWARE == 0) begin : rom_simulation

      logic [4 : 0] raddr;

      assign raddr = rom_in.mem_addr[6:2];

      always_ff @(posedge clock) begin
        case (raddr)
          5'b00000: rdata <= 32'h41014081;
          5'b00001: rdata <= 32'h42014181;
          5'b00010: rdata <= 32'h43014281;
          5'b00011: rdata <= 32'h44014381;
          5'b00100: rdata <= 32'h45014481;
          5'b00101: rdata <= 32'h46014581;
          5'b00110: rdata <= 32'h47014681;
          5'b00111: rdata <= 32'h48014781;
          5'b01000: rdata <= 32'h49014881;
          5'b01001: rdata <= 32'h4A014981;
          5'b01010: rdata <= 32'h4B014A81;
          5'b01011: rdata <= 32'h4C014B81;
          5'b01100: rdata <= 32'h4D014C81;
          5'b01101: rdata <= 32'h4E014D81;
          5'b01110: rdata <= 32'h4F014E81;
          5'b01111: rdata <= 32'h82934F81;
          5'b10000: rdata <= 32'hA0736002;
          5'b10001: rdata <= 32'h02B73002;
          5'b10010: rdata <= 32'h80678000;
          5'b10011: rdata <= 32'h00000002;
          5'b10100: rdata <= 32'h00000000;
          5'b10101: rdata <= 32'h00000000;
          5'b10110: rdata <= 32'h00000000;
          5'b10111: rdata <= 32'h00000000;
          5'b11000: rdata <= 32'h00000000;
          5'b11001: rdata <= 32'h00000000;
          5'b11010: rdata <= 32'h00000000;
          5'b11011: rdata <= 32'h00000000;
          5'b11100: rdata <= 32'h00000000;
          5'b11101: rdata <= 32'h00000000;
          5'b11110: rdata <= 32'h00000000;
          5'b11111: rdata <= 32'h00000000;
        endcase
      end

    end

    if (HARDWARE == 1) begin : rom_hardware

      logic [5 : 0] raddr;

      assign raddr = rom_in.mem_addr[7:2];

      always_ff @(posedge clock) begin
        case (raddr)
          6'b000000: rdata <= 32'h41014081;
          6'b000001: rdata <= 32'h42014181;
          6'b000010: rdata <= 32'h43014281;
          6'b000011: rdata <= 32'h44014381;
          6'b000100: rdata <= 32'h45014481;
          6'b000101: rdata <= 32'h46014581;
          6'b000110: rdata <= 32'h47014681;
          6'b000111: rdata <= 32'h48014781;
          6'b001000: rdata <= 32'h49014881;
          6'b001001: rdata <= 32'h4A014981;
          6'b001010: rdata <= 32'h4B014A81;
          6'b001011: rdata <= 32'h4C014B81;
          6'b001100: rdata <= 32'h4D014C81;
          6'b001101: rdata <= 32'h4E014D81;
          6'b001110: rdata <= 32'h4F014E81;
          6'b001111: rdata <= 32'h62F94F81;
          6'b010000: rdata <= 32'h60028293;
          6'b010001: rdata <= 32'h3002A073;
          6'b010010: rdata <= 32'hA07342A1;
          6'b010011: rdata <= 32'h62853002;
          6'b010100: rdata <= 32'h80028293;
          6'b010101: rdata <= 32'h3042A073;
          6'b010110: rdata <= 32'h00000297;
          6'b010111: rdata <= 32'h02028293;
          6'b011000: rdata <= 32'h30529073;
          6'b011001: rdata <= 32'h010002B7;
          6'b011010: rdata <= 32'h033702C1;
          6'b011011: rdata <= 32'h43818000;
          6'b011100: rdata <= 32'h00080E37;
          6'b011101: rdata <= 32'h0001A001;
          6'b011110: rdata <= 32'h01000F37;
          6'b011111: rdata <= 32'h2F830F61;
          6'b100000: rdata <= 32'h0F13000F;
          6'b100001: rdata <= 32'h0B630FF0;
          6'b100010: rdata <= 32'h0F3701FF;
          6'b100011: rdata <= 32'h0F210100;
          6'b100100: rdata <= 32'h000F2F83;
          6'b100101: rdata <= 32'h0FF00F13;
          6'b100110: rdata <= 32'h30200073;
          6'b100111: rdata <= 32'h00028E83;
          6'b101000: rdata <= 32'h01D30023;
          6'b101001: rdata <= 32'h03850305;
          6'b101010: rdata <= 32'h01C3D463;
          6'b101011: rdata <= 32'h30200073;
          6'b101100: rdata <= 32'h800000B7;
          6'b101101: rdata <= 32'h00008067;
          6'b101110: rdata <= 32'h00000000;
          6'b101111: rdata <= 32'h00000000;
          6'b110000: rdata <= 32'h00000000;
          6'b110001: rdata <= 32'h00000000;
          6'b110010: rdata <= 32'h00000000;
          6'b110011: rdata <= 32'h00000000;
          6'b110100: rdata <= 32'h00000000;
          6'b110101: rdata <= 32'h00000000;
          6'b110110: rdata <= 32'h00000000;
          6'b110111: rdata <= 32'h00000000;
          6'b111000: rdata <= 32'h00000000;
          6'b111001: rdata <= 32'h00000000;
          6'b111010: rdata <= 32'h00000000;
          6'b111011: rdata <= 32'h00000000;
          6'b111100: rdata <= 32'h00000000;
          6'b111101: rdata <= 32'h00000000;
          6'b111110: rdata <= 32'h00000000;
          6'b111111: rdata <= 32'h00000000;
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
