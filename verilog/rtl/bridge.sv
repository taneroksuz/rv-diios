import configure::*;
import wires::*;

module bridge (
    input  logic        reset,
    input  logic        clock,
    input  mem_in_type  bridge_in,
    output mem_out_type bridge_out,
    input  mem_out_type rom_out,
    input  mem_out_type ram_out,
    input  mem_out_type spi_out,
    input  mem_out_type clint_out,
    input  mem_out_type uart_rx_out,
    input  mem_out_type uart_tx_out,
    output mem_in_type  rom_in,
    output mem_in_type  ram_in,
    output mem_in_type  spi_in,
    output mem_in_type  clint_in,
    output mem_in_type  uart_rx_in,
    output mem_in_type  uart_tx_in
);
  timeunit 1ns; timeprecision 1ps;

  mem_in_type error_in;
  mem_out_type error_out;

  logic [31:0] mem_addr;
  logic [31:0] base_addr;

  always_comb begin

    rom_in             = init_mem_in;
    ram_in             = init_mem_in;
    spi_in             = init_mem_in;
    clint_in           = init_mem_in;
    uart_rx_in         = init_mem_in;
    uart_tx_in         = init_mem_in;
    error_in           = init_mem_in;

    base_addr          = 0;

    error_in.mem_valid = bridge_in.mem_valid;

    if (bridge_in.mem_valid & ~|(ROM_BASE ^ (bridge_in.mem_addr & ROM_MASK))) begin
      rom_in             = bridge_in;
      base_addr          = ROM_BASE;
      error_in.mem_valid = 0;
    end

    if (bridge_in.mem_valid & ~|(RAM_BASE ^ (bridge_in.mem_addr & RAM_MASK))) begin
      ram_in             = bridge_in;
      base_addr          = RAM_BASE;
      error_in.mem_valid = 0;
    end

    if (bridge_in.mem_valid & ~|(SPI_BASE ^ (bridge_in.mem_addr & SPI_MASK))) begin
      spi_in             = bridge_in;
      base_addr          = SPI_BASE;
      error_in.mem_valid = 0;
    end

    if (bridge_in.mem_valid & ~|(CLINT_BASE ^ (bridge_in.mem_addr & CLINT_MASK))) begin
      clint_in           = bridge_in;
      base_addr          = CLINT_BASE;
      error_in.mem_valid = 0;
    end

    if (bridge_in.mem_valid & ~|(UART_RX_BASE ^ (bridge_in.mem_addr & UART_RX_MASK))) begin
      uart_rx_in         = bridge_in;
      base_addr          = UART_RX_BASE;
      error_in.mem_valid = 0;
    end

    if (bridge_in.mem_valid & ~|(UART_TX_BASE ^ (bridge_in.mem_addr & UART_TX_MASK))) begin
      uart_tx_in         = bridge_in;
      base_addr          = UART_TX_BASE;
      error_in.mem_valid = 0;
    end

    mem_addr            = bridge_in.mem_addr - base_addr;

    rom_in.mem_addr     = mem_addr;
    ram_in.mem_addr     = mem_addr;
    spi_in.mem_addr     = mem_addr;
    clint_in.mem_addr   = mem_addr;
    uart_rx_in.mem_addr = mem_addr;
    uart_tx_in.mem_addr = mem_addr;

    bridge_out          = init_mem_out;

    if (rom_out.mem_ready == 1) bridge_out = rom_out;
    if (ram_out.mem_ready == 1) bridge_out = ram_out;
    if (spi_out.mem_ready == 1) bridge_out = spi_out;
    if (clint_out.mem_ready == 1) bridge_out = clint_out;
    if (uart_rx_out.mem_ready == 1) bridge_out = uart_rx_out;
    if (uart_tx_out.mem_ready == 1) bridge_out = uart_tx_out;

    if (error_out.mem_ready == 1) bridge_out = error_out;

  end

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      error_out <= init_mem_out;
    end else begin
      error_out.mem_rdata <= 0;
      error_out.mem_error <= error_in.mem_valid;
      error_out.mem_ready <= error_in.mem_valid;
    end
  end

endmodule
