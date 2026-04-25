import configure::*;
import wires::*;

module bus (
  input  logic        reset,
  input  logic        clear,
  input  logic        clock,
  input  mem_in_type  imem0_in,
  input  mem_in_type  imem1_in,
  output mem_out_type imem0_out,
  output mem_out_type imem1_out,
  input  mem_in_type  dmem0_in,
  input  mem_in_type  dmem1_in,
  output mem_out_type dmem0_out,
  output mem_out_type dmem1_out,
  input  mem_out_type itim0_out,
  input  mem_out_type itim1_out,
  input  mem_out_type dtim0_out,
  input  mem_out_type dtim1_out,
  output mem_in_type  itim0_in,
  output mem_in_type  itim1_in,
  output mem_in_type  dtim0_in,
  output mem_in_type  dtim1_in,
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

  mem_in_type bridge_in;
  mem_in_type ibridge0_in;
  mem_in_type ibridge1_in;
  mem_in_type dbridge0_in;
  mem_in_type dbridge1_in;

  mem_out_type bridge_out;
  mem_out_type ibridge0_out;
  mem_out_type ibridge1_out;
  mem_out_type dbridge0_out;
  mem_out_type dbridge1_out;

  logic [0 : 0] itim0_rev;
  logic [0 : 0] itim1_rev;
  logic [0 : 0] dtim0_rev;
  logic [0 : 0] dtim1_rev;

  logic [0 : 0] itim0_rev_reg;
  logic [0 : 0] itim1_rev_reg;
  logic [0 : 0] dtim0_rev_reg;
  logic [0 : 0] dtim1_rev_reg;

  always_comb begin

    itim0_in    = init_mem_in;
    itim1_in    = init_mem_in;
    dtim0_in    = init_mem_in;
    dtim1_in    = init_mem_in;

    ibridge0_in = init_mem_in;
    ibridge1_in = init_mem_in;
    dbridge0_in = init_mem_in;
    dbridge1_in = init_mem_in;

    itim0_rev   = itim0_rev_reg;
    itim1_rev   = itim1_rev_reg;
    dtim0_rev   = dtim0_rev_reg;
    dtim1_rev   = dtim1_rev_reg;

    if (imem0_in.mem_valid & ~|(ITIM_BASE ^ (imem0_in.mem_addr & ITIM_MASK))) begin
      itim0_in          = imem0_in;
      itim0_in.mem_addr = imem0_in.mem_addr - ITIM_BASE;
      itim0_rev         = 0;
    end else if (dmem0_in.mem_valid & ~|(ITIM_BASE ^ (dmem0_in.mem_addr & ITIM_MASK))) begin
      itim0_in          = dmem0_in;
      itim0_in.mem_addr = dmem0_in.mem_addr - ITIM_BASE;
      itim0_rev         = 1;
    end

    if (imem1_in.mem_valid & ~|(ITIM_BASE ^ (imem1_in.mem_addr & ITIM_MASK))) begin
      itim1_in          = imem1_in;
      itim1_in.mem_addr = imem1_in.mem_addr - ITIM_BASE;
      itim1_rev         = 0;
    end else if (dmem1_in.mem_valid & ~|(ITIM_BASE ^ (dmem1_in.mem_addr & ITIM_MASK))) begin
      itim1_in          = dmem1_in;
      itim1_in.mem_addr = dmem1_in.mem_addr - ITIM_BASE;
      itim1_rev         = 1;
    end

    if (imem0_in.mem_valid & ~|(DTIM_BASE ^ (imem0_in.mem_addr & DTIM_MASK))) begin
      dtim0_in          = imem0_in;
      dtim0_in.mem_addr = imem0_in.mem_addr - DTIM_BASE;
      dtim0_rev         = 1;
    end else if (dmem0_in.mem_valid & ~|(DTIM_BASE ^ (dmem0_in.mem_addr & DTIM_MASK))) begin
      dtim0_in          = dmem0_in;
      dtim0_in.mem_addr = dmem0_in.mem_addr - DTIM_BASE;
      dtim0_rev         = 0;
    end

    if (imem1_in.mem_valid & ~|(DTIM_BASE ^ (imem1_in.mem_addr & DTIM_MASK))) begin
      dtim1_in          = imem1_in;
      dtim1_in.mem_addr = imem1_in.mem_addr - DTIM_BASE;
      dtim1_rev         = 1;
    end else if (dmem1_in.mem_valid & ~|(DTIM_BASE ^ (dmem1_in.mem_addr & DTIM_MASK))) begin
      dtim1_in          = dmem1_in;
      dtim1_in.mem_addr = dmem1_in.mem_addr - DTIM_BASE;
      dtim1_rev         = 0;
    end

    if (imem0_in.mem_valid & |(ITIM_BASE ^ (imem0_in.mem_addr & ITIM_MASK)) & |(DTIM_BASE ^ (imem0_in.mem_addr & DTIM_MASK))) begin
      ibridge0_in = imem0_in;
    end
    if (imem1_in.mem_valid & |(ITIM_BASE ^ (imem1_in.mem_addr & ITIM_MASK)) & |(DTIM_BASE ^ (imem1_in.mem_addr & DTIM_MASK))) begin
      ibridge1_in = imem1_in;
    end
    if (dmem0_in.mem_valid & |(ITIM_BASE ^ (dmem0_in.mem_addr & ITIM_MASK)) & |(DTIM_BASE ^ (dmem0_in.mem_addr & DTIM_MASK))) begin
      dbridge0_in = dmem0_in;
    end
    if (dmem1_in.mem_valid & |(ITIM_BASE ^ (dmem1_in.mem_addr & ITIM_MASK)) & |(DTIM_BASE ^ (dmem1_in.mem_addr & DTIM_MASK))) begin
      dbridge1_in = dmem1_in;
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

    if (ibridge0_out.mem_ready == 1) begin
      imem0_out = ibridge0_out;
    end
    if (ibridge1_out.mem_ready == 1) begin
      imem1_out = ibridge1_out;
    end
    if (dbridge0_out.mem_ready == 1) begin
      dmem0_out = dbridge0_out;
    end
    if (dbridge1_out.mem_ready == 1) begin
      dmem1_out = dbridge1_out;
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

  arbiter arbiter_comp (
    .reset    (reset),
    .clock    (clock),
    .imem0_in (ibridge0_in),
    .imem0_out(ibridge0_out),
    .imem1_in (ibridge1_in),
    .imem1_out(ibridge1_out),
    .dmem0_in (dbridge0_in),
    .dmem0_out(dbridge0_out),
    .dmem1_in (dbridge1_in),
    .dmem1_out(dbridge1_out),
    .mem_in   (bridge_in),
    .mem_out  (bridge_out)
  );

  bridge bridge_comp (
    .reset      (reset),
    .clock      (clock),
    .bridge_in  (bridge_in),
    .bridge_out (bridge_out),
    .rom_in     (rom_in),
    .ram_in     (ram_in),
    .spi_in     (spi_in),
    .clint_in   (clint_in),
    .uart_rx_in (uart_rx_in),
    .uart_tx_in (uart_tx_in),
    .rom_out    (rom_out),
    .ram_out    (ram_out),
    .spi_out    (spi_out),
    .clint_out  (clint_out),
    .uart_rx_out(uart_rx_out),
    .uart_tx_out(uart_tx_out)
  );

endmodule
