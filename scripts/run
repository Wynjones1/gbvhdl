#!/usr/bin/env bash
set -e

PART=xc3s500e-fg320
PWD=$(pwd)
IN_FILE=$PWD/tests.prj
CONSTRAINT_FILE=$PWD/out.ucf
BUILD_DIR=build
OUT_FILE=output
OPT_MODE=Speed
OPT_LEVEL=1
STARTUP_CLK=JtagClk
BIT_FILE=output.bit
DEVICE=Nexys2

source ~/Xilinx/14.7/ISE_DS/settings64.sh
mkdir -p $BUILD_DIR
cd $BUILD_DIR
echo "run -ifn $IN_FILE -ifmt VHDL -ofn $OUT_FILE\
 -p $PART -opt_mode $OPT_MODE -opt_level $OPT_LEVEL" | xst
ngdbuild -p $PART -uc $CONSTRAINT_FILE output.ngc
map -detail -pr b output.ngd
par -mt 4 -rl std -w output.ncd parout.ncd output.pcf
bitgen -w -g StartUpClk:$STARTUP_CLK -g CRC:Enable parout.ncd $BIT_FILE output.pcf
djtgcfg -d $DEVICE prog -i 0 -f output.bit
