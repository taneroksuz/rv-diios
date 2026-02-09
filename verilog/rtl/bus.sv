import configure::*;
import wires::*;

module bus (
    input logic reset,
    input logic clear,
    input logic clock,
    input mem_in_type imem0_in,
    input mem_in_type imem1_in,
    output mem_out_type imem0_out,
    output mem_out_type imem1_out,
    input mem_in_type dmem0_in,
    input mem_in_type dmem1_in,
    output mem_out_type dmem0_out,
    output mem_out_type dmem1_out,
    input mem_out_type itim0_out,
    input mem_out_type itim1_out,
    input mem_out_type dtim0_out,
    input mem_out_type dtim1_out,
    output mem_in_type itim0_in,
    output mem_in_type itim1_in,
    output mem_in_type dtim0_in,
    output mem_in_type dtim1_in,
    input mem_out_type rom_out,
    input mem_out_type ram_out,
    input mem_out_type spi_out,
    input mem_out_type clint_out,
    input mem_out_type uart_rx_out,
    input mem_out_type uart_tx_out,
    output mem_in_type rom_in,
    output mem_in_type ram_in,
    output mem_in_type spi_in,
    output mem_in_type clint_in,
    output mem_in_type uart_rx_in,
    output mem_in_type uart_tx_in
);
  timeunit 1ns; timeprecision 1ps;

  mem_in_type iper0_in;
  mem_in_type iper1_in;
  mem_in_type dper0_in;
  mem_in_type dper1_in;

  mem_out_type iper0_out;
  mem_out_type iper1_out;
  mem_out_type dper0_out;
  mem_out_type dper1_out;

  mem_in_type per_in;
  mem_in_type error_in;

  mem_out_type per_out;
  mem_out_type error_out;

  logic [0 : 0] itim0_rev;
  logic [0 : 0] itim1_rev;
  logic [0 : 0] dtim0_rev;
  logic [0 : 0] dtim1_rev;

  logic [0 : 0] itim0_rev_reg;
  logic [0 : 0] itim1_rev_reg;
  logic [0 : 0] dtim0_rev_reg;
  logic [0 : 0] dtim1_rev_reg;

  logic [31 : 0] mem_addr;
  logic [31 : 0] base_addr;

  always_comb begin

    itim0_in  = init_mem_in;
    itim1_in  = init_mem_in;
    dtim0_in  = init_mem_in;
    dtim1_in  = init_mem_in;

    iper0_in  = init_mem_in;
    iper1_in  = init_mem_in;
    dper0_in  = init_mem_in;
    dper1_in  = init_mem_in;

    itim0_rev = itim0_rev_reg;
    itim1_rev = itim1_rev_reg;
    dtim0_rev = dtim0_rev_reg;
    dtim1_rev = dtim1_rev_reg;

    if (imem0_in.mem_valid & ~|(ITIM_BASE ^ (imem0_in.mem_addr & ITIM_MASK))) begin
      itim0_in = imem0_in;
      itim0_in.mem_addr = imem0_in.mem_addr - ITIM_BASE;
      itim0_rev = 0;
    end else if (dmem0_in.mem_valid & ~|(ITIM_BASE ^ (dmem0_in.mem_addr & ITIM_MASK))) begin
      itim0_in = dmem0_in;
      itim0_in.mem_addr = dmem0_in.mem_addr - ITIM_BASE;
      itim0_rev = 1;
    end

    if (imem1_in.mem_valid & ~|(ITIM_BASE ^ (imem1_in.mem_addr & ITIM_MASK))) begin
      itim1_in = imem1_in;
      itim1_in.mem_addr = imem1_in.mem_addr - ITIM_BASE;
      itim1_rev = 0;
    end else if (dmem1_in.mem_valid & ~|(ITIM_BASE ^ (dmem1_in.mem_addr & ITIM_MASK))) begin
      itim1_in = dmem1_in;
      itim1_in.mem_addr = dmem1_in.mem_addr - ITIM_BASE;
      itim1_rev = 1;
    end

    if (imem0_in.mem_valid & ~|(DTIM_BASE ^ (imem0_in.mem_addr & DTIM_MASK))) begin
      dtim0_in = imem0_in;
      dtim0_in.mem_addr = imem0_in.mem_addr - DTIM_BASE;
      dtim0_rev = 1;
    end else if (dmem0_in.mem_valid & ~|(DTIM_BASE ^ (dmem0_in.mem_addr & DTIM_MASK))) begin
      dtim0_in = dmem0_in;
      dtim0_in.mem_addr = dmem0_in.mem_addr - DTIM_BASE;
      dtim0_rev = 0;
    end

    if (imem1_in.mem_valid & ~|(DTIM_BASE ^ (imem1_in.mem_addr & DTIM_MASK))) begin
      dtim1_in = imem1_in;
      dtim1_in.mem_addr = imem1_in.mem_addr - DTIM_BASE;
      dtim1_rev = 1;
    end else if (dmem1_in.mem_valid & ~|(DTIM_BASE ^ (dmem1_in.mem_addr & DTIM_MASK))) begin
      dtim1_in = dmem1_in;
      dtim1_in.mem_addr = dmem1_in.mem_addr - DTIM_BASE;
      dtim1_rev = 0;
    end

    if (imem0_in.mem_valid & |(ITIM_BASE ^ (imem0_in.mem_addr & ITIM_MASK)) & |(DTIM_BASE ^ (imem0_in.mem_addr & DTIM_MASK))) begin
      iper0_in = imem0_in;
    end
    if (imem1_in.mem_valid & |(ITIM_BASE ^ (imem1_in.mem_addr & ITIM_MASK)) & |(DTIM_BASE ^ (imem1_in.mem_addr & DTIM_MASK))) begin
      iper1_in = imem1_in;
    end
    if (dmem0_in.mem_valid & |(ITIM_BASE ^ (dmem0_in.mem_addr & ITIM_MASK)) & |(DTIM_BASE ^ (dmem0_in.mem_addr & DTIM_MASK))) begin
      dper0_in = dmem0_in;
    end
    if (dmem1_in.mem_valid & |(ITIM_BASE ^ (dmem1_in.mem_addr & ITIM_MASK)) & |(DTIM_BASE ^ (dmem1_in.mem_addr & DTIM_MASK))) begin
      dper1_in = dmem1_in;
    end

    imem0_out = init_mem_out;
    imem1_out = init_mem_out;
    dmem0_out = init_mem_out;
    dmem1_out = init_mem_out;

    if (itim0_out.mem_ready == 1 && itim0_rev_reg == 0) begin
      imem0_out = itim0_out;
    end
    if (itim0_out.mem_ready == 1 && itim0_rev_reg == 1) begin
      dmem0_out = itim0_out;
    end
    if (itim1_out.mem_ready == 1 && itim1_rev_reg == 0) begin
      imem1_out = itim1_out;
    end
    if (itim1_out.mem_ready == 1 && itim1_rev_reg == 1) begin
      dmem1_out = itim1_out;
    end

    if (dtim0_out.mem_ready == 1 && dtim0_rev_reg == 1) begin
      imem0_out = dtim0_out;
    end
    if (dtim0_out.mem_ready == 1 && dtim0_rev_reg == 0) begin
      dmem0_out = dtim0_out;
    end
    if (dtim1_out.mem_ready == 1 && dtim1_rev_reg == 1) begin
      imem1_out = dtim1_out;
    end
    if (dtim1_out.mem_ready == 1 && dtim1_rev_reg == 0) begin
      dmem1_out = dtim1_out;
    end

    if (iper0_out.mem_ready == 1) begin
      imem0_out = iper0_out;
    end
    if (iper1_out.mem_ready == 1) begin
      imem1_out = iper1_out;
    end
    if (dper0_out.mem_ready == 1) begin
      dmem0_out = dper0_out;
    end
    if (dper1_out.mem_ready == 1) begin
      dmem1_out = dper1_out;
    end

  end

  always_ff @(posedge clock) begin
    if (reset == 0) begin
      itim0_rev_reg <= 0;
      itim1_rev_reg <= 0;
      dtim0_rev_reg <= 0;
      dtim1_rev_reg <= 0;
    end else begin
      itim0_rev_reg <= itim0_rev;
      itim1_rev_reg <= itim1_rev;
      dtim0_rev_reg <= dtim0_rev;
      dtim1_rev_reg <= dtim1_rev;
    end
  end

  always_comb begin

    rom_in = init_mem_in;
    ram_in = init_mem_in;
    spi_in = init_mem_in;
    clint_in = init_mem_in;
    error_in = init_mem_in;
    uart_rx_in = init_mem_in;
    uart_tx_in = init_mem_in;

    base_addr = 0;

    error_in.mem_valid = per_in.mem_valid;

    if (per_in.mem_valid & ~|(ROM_BASE ^ (per_in.mem_addr & ROM_MASK))) begin
      rom_in = per_in;
      base_addr = ROM_BASE;
      error_in.mem_valid = 0;
    end
    if (per_in.mem_valid & ~|(RAM_BASE ^ (per_in.mem_addr & RAM_MASK))) begin
      ram_in = per_in;
      base_addr = RAM_BASE;
      error_in.mem_valid = 0;
    end
    if (per_in.mem_valid & ~|(SPI_BASE ^ (per_in.mem_addr & SPI_MASK))) begin
      spi_in = per_in;
      base_addr = SPI_BASE;
      error_in.mem_valid = 0;
    end
    if (per_in.mem_valid & ~|(CLINT_BASE ^ (per_in.mem_addr & CLINT_MASK))) begin
      clint_in = per_in;
      base_addr = CLINT_BASE;
      error_in.mem_valid = 0;
    end
    if (per_in.mem_valid & ~|(UART_RX_BASE ^ (per_in.mem_addr & UART_RX_MASK))) begin
      uart_rx_in = per_in;
      base_addr = UART_RX_BASE;
      error_in.mem_valid = 0;
    end
    if (per_in.mem_valid & ~|(UART_TX_BASE ^ (per_in.mem_addr & UART_TX_MASK))) begin
      uart_tx_in = per_in;
      base_addr = UART_TX_BASE;
      error_in.mem_valid = 0;
    end

    mem_addr = per_in.mem_addr - base_addr;

    rom_in.mem_addr = mem_addr;
    ram_in.mem_addr = mem_addr;
    spi_in.mem_addr = mem_addr;
    clint_in.mem_addr = mem_addr;
    uart_rx_in.mem_addr = mem_addr;
    uart_tx_in.mem_addr = mem_addr;

    per_out = init_mem_out;

    if (rom_out.mem_ready == 1) begin
      per_out = rom_out;
    end
    if (ram_out.mem_ready == 1) begin
      per_out = ram_out;
    end
    if (spi_out.mem_ready == 1) begin
      per_out = spi_out;
    end
    if (clint_out.mem_ready == 1) begin
      per_out = clint_out;
    end
    if (error_out.mem_ready == 1) begin
      per_out = error_out;
    end
    if (uart_rx_out.mem_ready == 1) begin
      per_out = uart_rx_out;
    end
    if (uart_tx_out.mem_ready == 1) begin
      per_out = uart_tx_out;
    end

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

  arbiter arbiter_comp (
      .reset(reset),
      .clock(clock),
      .imem0_in(iper0_in),
      .imem0_out(iper0_out),
      .imem1_in(iper1_in),
      .imem1_out(iper1_out),
      .dmem0_in(dper0_in),
      .dmem0_out(dper0_out),
      .dmem1_in(dper1_in),
      .dmem1_out(dper1_out),
      .mem_in(per_in),
      .mem_out(per_out)
  );

endmodule
