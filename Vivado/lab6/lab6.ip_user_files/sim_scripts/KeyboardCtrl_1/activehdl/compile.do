vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../lab6.gen/sources_1/ip/KeyboardCtrl_1/src/Ps2Interface.v" \
"../../../../lab6.gen/sources_1/ip/KeyboardCtrl_1/src/KeyboardCtrl.v" \
"../../../../lab6.gen/sources_1/ip/KeyboardCtrl_1/sim/KeyboardCtrl_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

