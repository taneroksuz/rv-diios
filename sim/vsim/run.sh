#!/bin/bash
set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

rm -rf $BASEDIR/sim/vsim/output/*

if [ ! -d "$BASEDIR/sim/vsim/work" ]; then
  mkdir $BASEDIR/sim/vsim/work
fi

rm -rf $BASEDIR/sim/vsim/work/*

cd $BASEDIR/sim/vsim/work

start=`date +%s`

$VLIB .

$VLOG -quiet -sv -svinputport=relaxed +acc=npr \
                    $BASEDIR/verilog/conf/configure.sv \
                    $BASEDIR/verilog/rtl/constants.sv \
                    $BASEDIR/verilog/rtl/functions.sv \
                    $BASEDIR/verilog/rtl/wires.sv \
                    $BASEDIR/verilog/rtl/bit_alu.sv \
                    $BASEDIR/verilog/rtl/bit_clmul.sv \
                    $BASEDIR/verilog/rtl/btac.sv \
                    $BASEDIR/verilog/rtl/alu.sv \
                    $BASEDIR/verilog/rtl/agu.sv \
                    $BASEDIR/verilog/rtl/bcu.sv \
                    $BASEDIR/verilog/rtl/lsu.sv \
                    $BASEDIR/verilog/rtl/csr_alu.sv \
                    $BASEDIR/verilog/rtl/mul.sv \
                    $BASEDIR/verilog/rtl/div.sv \
                    $BASEDIR/verilog/rtl/compress.sv \
                    $BASEDIR/verilog/rtl/decoder.sv \
                    $BASEDIR/verilog/rtl/register.sv \
                    $BASEDIR/verilog/rtl/csr.sv \
                    $BASEDIR/verilog/rtl/buffer.sv \
                    $BASEDIR/verilog/rtl/hazard.sv \
                    $BASEDIR/verilog/rtl/forwarding.sv \
                    $BASEDIR/verilog/rtl/fetch_stage.sv \
                    $BASEDIR/verilog/rtl/decode_stage.sv \
                    $BASEDIR/verilog/rtl/issue_stage.sv \
                    $BASEDIR/verilog/rtl/execute_stage.sv \
                    $BASEDIR/verilog/rtl/memory_stage.sv \
                    $BASEDIR/verilog/rtl/writeback_stage.sv \
                    $BASEDIR/verilog/rtl/arbiter.sv \
                    $BASEDIR/verilog/rtl/bridge.sv \
                    $BASEDIR/verilog/rtl/bus.sv \
                    $BASEDIR/verilog/rtl/cdc.sv \
                    $BASEDIR/verilog/rtl/clint.sv \
                    $BASEDIR/verilog/rtl/tim.sv \
                    $BASEDIR/verilog/rtl/cpu.sv \
                    $BASEDIR/verilog/rtl/rom.sv \
                    $BASEDIR/verilog/rtl/ram.sv \
                    $BASEDIR/verilog/rtl/spi.sv \
                    $BASEDIR/verilog/rtl/uart_rx.sv \
                    $BASEDIR/verilog/rtl/uart_tx.sv \
                    $BASEDIR/verilog/rtl/soc.sv \
                    $BASEDIR/verilog/tb/testbench.sv 2>&1 > /dev/null

for FILE in $BASEDIR/riscv/*.riscv; do
  BASE="${FILE##*/}"
  NAME="${BASE%.*}"
  if [[ "$NAME" == "$PROGRAM"* ]]; then
    cp $BASEDIR/riscv/$NAME.riscv $BASEDIR/sim/vsim/output/$NAME.riscv
    $RISCV/bin/riscv32-unknown-elf-nm -A $BASEDIR/sim/vsim/output/$NAME.riscv | grep -sw 'tohost' | sed -e 's/.*:\(.*\) D.*/\1/' > $BASEDIR/sim/vsim/output/$NAME.host
    $RISCV/bin/riscv32-unknown-elf-objcopy -O binary $BASEDIR/sim/vsim/output/$NAME.riscv $BASEDIR/sim/vsim/output/$NAME.bin
    $PYTHON $BASEDIR/py/bin2dat.py --input $BASEDIR/sim/vsim/output/$NAME.riscv --address 0x0 --offset 0x100000
    cp $BASEDIR/sim/vsim/output/$NAME.dat ram.dat
    cp $BASEDIR/sim/vsim/output/$NAME.host host.dat
    if [ "$DUMP" = "1" ]
    then
      $VSIM -quiet -c testbench -do "add wave -recursive *; run -all" +MAXTIME=$MAXTIME +REGFILE=$BASEDIR/sim/vsim/output/$NAME.reg +CSRFILE=$BASEDIR/sim/vsim/output/$NAME.csr +MEMFILE=$BASEDIR/sim/vsim/output/$NAME.mem -wlf $BASEDIR/sim/vsim/output/$NAME.wlf 2>&1
    else
      $VSIM -quiet -c testbench -do "run -all" +MAXTIME=$MAXTIME 2>&1
    fi
  fi
done

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
