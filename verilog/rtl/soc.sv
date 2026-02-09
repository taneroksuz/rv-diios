import configure::*;
import wires::*;

module soc (
    input reset,
    input clear,
    input clock,
    output sclk,
    output mosi,
    input miso,
    output ss,
    input rx,
    output tx,
    input mem_out_type ram_out,
    output mem_in_type ram_in
);

  timeunit 1ns; timeprecision 1ps;

  mem_in_type imem0_in;
  mem_in_type imem1_in;
  mem_in_type dmem0_in;
  mem_in_type dmem1_in;

  mem_out_type imem0_out;
  mem_out_type imem1_out;
  mem_out_type dmem0_out;
  mem_out_type dmem1_out;

  mem_in_type itim0_in;
  mem_in_type itim1_in;
  mem_in_type dtim0_in;
  mem_in_type dtim1_in;

  mem_out_type itim0_out;
  mem_out_type itim1_out;
  mem_out_type dtim0_out;
  mem_out_type dtim1_out;

  mem_in_type rom_in;
  mem_in_type spi_in;
  mem_in_type clint_in;
  mem_in_type uart_rx_in;
  mem_in_type uart_tx_in;

  mem_out_type rom_out;
  mem_out_type spi_out;
  mem_out_type clint_out;
  mem_out_type uart_rx_out;
  mem_out_type uart_tx_out;

  logic [0 : 0] meip;
  logic [0 : 0] msip;
  logic [0 : 0] mtip;

  logic [0 : 0] rx_irq;
  logic [0 : 0] tx_irq;

  logic [63 : 0] mtime;

  assign meip = rx_irq | tx_irq;

  cpu cpu_comp (
      .reset(reset),
      .clear(clear),
      .clock(clock),
      .imem0_in(imem0_in),
      .imem1_in(imem1_in),
      .imem0_out(imem0_out),
      .imem1_out(imem1_out),
      .dmem0_in(dmem0_in),
      .dmem1_in(dmem1_in),
      .dmem0_out(dmem0_out),
      .dmem1_out(dmem1_out),
      .meip(meip),
      .msip(msip),
      .mtip(mtip),
      .mtime(mtime)
  );

  bus bus_comp (
      .reset(reset),
      .clear(clear),
      .clock(clock),
      .imem0_in(imem0_in),
      .imem1_in(imem1_in),
      .imem0_out(imem0_out),
      .imem1_out(imem1_out),
      .dmem0_in(dmem0_in),
      .dmem1_in(dmem1_in),
      .dmem0_out(dmem0_out),
      .dmem1_out(dmem1_out),
      .itim0_in(itim0_in),
      .itim1_in(itim1_in),
      .dtim0_in(dtim0_in),
      .dtim1_in(dtim1_in),
      .itim0_out(itim0_out),
      .itim1_out(itim1_out),
      .dtim0_out(dtim0_out),
      .dtim1_out(dtim1_out),
      .rom_in(rom_in),
      .ram_in(ram_in),
      .spi_in(spi_in),
      .clint_in(clint_in),
      .uart_rx_in(uart_rx_in),
      .uart_tx_in(uart_tx_in),
      .rom_out(rom_out),
      .ram_out(ram_out),
      .spi_out(spi_out),
      .clint_out(clint_out),
      .uart_rx_out(uart_rx_out),
      .uart_tx_out(uart_tx_out)
  );

  tim itim_comp (
      .reset(reset),
      .clock(clock),
      .tim0_in(itim0_in),
      .tim1_in(itim1_in),
      .tim0_out(itim0_out),
      .tim1_out(itim1_out)
  );

  tim dtim_comp (
      .reset(reset),
      .clock(clock),
      .tim0_in(dtim0_in),
      .tim1_in(dtim1_in),
      .tim0_out(dtim0_out),
      .tim1_out(dtim1_out)
  );

  rom rom_comp (
      .reset  (reset),
      .clock  (clock),
      .rom_in (rom_in),
      .rom_out(rom_out)
  );

  clint #(
      .clock_rate(CLK_DIVIDER_RTC)
  ) clint_comp (
      .reset(reset),
      .clock(clock),
      .clint_in(clint_in),
      .clint_out(clint_out),
      .clint_msip(msip),
      .clint_mtip(mtip),
      .clint_mtime(mtime)
  );

  spi #(
      .clock_rate(CLK_DIVIDER_PER)
  ) spi_comp (
      .reset(reset),
      .clock(clock),
      .spi_in(spi_in),
      .spi_out(spi_out),
      .sclk(sclk),
      .mosi(mosi),
      .miso(miso),
      .ss(ss)
  );

  uart_rx #(
      .clock_rate(CLK_DIVIDER_BIT)
  ) uart_rx_comp (
      .reset(reset),
      .clock(clock),
      .uart_in(uart_rx_in),
      .uart_out(uart_rx_out),
      .rx_irq(rx_irq),
      .rx(rx)
  );

  uart_tx #(
      .clock_rate(CLK_DIVIDER_BIT)
  ) uart_tx_comp (
      .reset(reset),
      .clock(clock),
      .uart_in(uart_tx_in),
      .uart_out(uart_tx_out),
      .tx_irq(tx_irq),
      .tx(tx)
  );

endmodule
