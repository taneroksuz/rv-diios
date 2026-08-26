import configure::*;
import wires::*;

module top (
  input         CLOCK0_50,
  input  [ 3:0] KEY,
  output [ 9:0] LEDR,
  input         FPGA_UART_RX,
  output        FPGA_UART_TX,
  output        DRAM_CLK,
  output        DRAM_CKE,
  output [ 1:0] DRAM_BA,
  output        DRAM_CS_n,
  output        DRAM_WE_n,
  output        DRAM_CAS_n,
  output        DRAM_RAS_n,
  output [12:0] DRAM_ADDR,
  output [ 3:0] DRAM_DQM,
  inout  [31:0] DRAM_DQ
);

  timeunit 1ns; timeprecision 1ps;

  logic       CLOCK_SDR;
  logic       CLOCK_CPU;
  logic       LOCKED;
  logic       RESET;
  logic [1:0] CLEAR;

  logic SCLK;
  logic MOSI;
  logic MISO;
  logic SS;

  mem_in_type  ram_in;
  mem_out_type ram_out;
  mem_in_type  sdram_in;
  mem_out_type sdram_out;

  initial begin
    SCLK = 0;
    MOSI = 0;
    MISO = 0;
    SS   = 0;
  end

  pll pll_cpu_comp (
    .refclk  (CLOCK0_50),
    .rst     (~KEY[0]),
    .outclk_0(CLOCK_CPU),
    .outclk_1(CLOCK_SDR),
    .locked  (LOCKED)
  );

  assign RESET = LOCKED & KEY[0];

  always_ff @(posedge CLOCK_CPU) begin
    if (RESET == 0) begin
      CLEAR <= 2'b11;
    end
    else begin
      CLEAR <= {1'b0, CLEAR[1]};
    end
  end

  soc soc_comp (
    .reset  (RESET),
    .clear  (CLEAR[0]),
    .clock  (CLOCK_CPU),
    .sclk   (SCLK),
    .mosi   (MOSI),
    .miso   (MISO),
    .ss     (SS),
    .rx     (FPGA_UART_RX),
    .tx     (FPGA_UART_TX),
    .ram_in (ram_in),
    .ram_out(ram_out)
  );

  always_ff @(posedge CLOCK_CPU) begin
    sdram_in <= ram_in;
    ram_out  <= sdram_out;
  end

  logic [9:0] REG_LED = 0;

  always_ff @(posedge CLOCK_CPU) begin
    if (RESET == 0) begin
      REG_LED <= 0;
    end
    else begin
      if (ram_in.mem_valid) begin
        REG_LED[9:0] <= ram_in.mem_addr[18:9];
      end
    end
  end

  assign LEDR     = REG_LED;
  assign DRAM_CLK = CLOCK_SDR;

  sdram sdram_comp (
    .reset      (RESET),
    .clock      (CLOCK_CPU),
    .sdram_in   (sdram_in),
    .sdram_out  (sdram_out),
    .sdram_clk  (CLOCK_SDR),
    .sdram_cke  (DRAM_CKE),
    .sdram_ba   (DRAM_BA),
    .sdram_cs_n (DRAM_CS_n),
    .sdram_we_n (DRAM_WE_n),
    .sdram_cas_n(DRAM_CAS_n),
    .sdram_ras_n(DRAM_RAS_n),
    .sdram_sa   (DRAM_ADDR),
    .sdram_dqm  (DRAM_DQM),
    .sdram_dq   (DRAM_DQ)
  );

endmodule
