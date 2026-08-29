#!/bin/bash
set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

cd ${BASEDIR}/fpga/quartus

if [ "$SYNTHESIS" = "1" ]
then
  ${QUARTUS}_sh -t synthesis.tcl
fi

if pgrep -x "jtagd" > /dev/null
then
  killall jtagd
fi
$JTAGCONFIG
${QUARTUS}_pgm -m jtag -o "p;${BASEDIR}/fpga/quartus/top.sof"