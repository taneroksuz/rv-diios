#!/bin/bash
set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

rm -rf $BASEDIR/sim/xsim/output/*

if [ ! -d "$BASEDIR/sim/xsim/work" ]; then
  mkdir $BASEDIR/sim/xsim/work
fi

rm -rf $BASEDIR/sim/xsim/work/*

cd $BASEDIR/sim/xsim/work

start=`date +%s`

$XVLOG -nolog --sv \
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

$XELAB -nolog -top testbench -snapshot testbench_snapshot 2>&1 > /dev/null

for FILE in $BASEDIR/riscv/*.riscv; do
  BASE="${FILE##*/}"
  NAME="${BASE%.*}"
  if [[ "$NAME" == "$PROGRAM"* ]]; then
    cp $BASEDIR/riscv/$NAME.riscv $BASEDIR/sim/xsim/output/$NAME.riscv
    $RISCV/bin/riscv32-unknown-elf-nm -A $BASEDIR/sim/xsim/output/$NAME.riscv | grep -sw 'tohost' | sed -e 's/.*:\(.*\) D.*/\1/' > $BASEDIR/sim/xsim/output/$NAME.host
    $RISCV/bin/riscv32-unknown-elf-objcopy -O binary $BASEDIR/sim/xsim/output/$NAME.riscv $BASEDIR/sim/xsim/output/$NAME.bin
    $PYTHON $BASEDIR/py/bin2dat.py --input $BASEDIR/sim/xsim/output/$NAME.riscv --address 0x0 --offset 0x100000
    cp $BASEDIR/sim/xsim/output/$NAME.dat ram.dat
    cp $BASEDIR/sim/xsim/output/$NAME.host host.dat
    if [ "$DUMP" = "1" ]
    then
      $XSIM testbench_snapshot -nolog -testplusarg "MAXTIME=$MAXTIME" -testplusarg "REGFILE=$BASEDIR/sim/xsim/output/$NAME.reg" -testplusarg "CSRFILE=$BASEDIR/sim/xsim/output/$NAME.csr" -testplusarg "MEMFILE=$BASEDIR/sim/xsim/output/$NAME.mem" -tclbatch $BASEDIR/sim/xsim/run.tcl --wdb $BASEDIR/sim/xsim/output/$NAME.wdb 2>&1
    else
      $XSIM testbench_snapshot -nolog -R -testplusarg "MAXTIME=$MAXTIME" 2>&1
    fi
  fi
done

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
