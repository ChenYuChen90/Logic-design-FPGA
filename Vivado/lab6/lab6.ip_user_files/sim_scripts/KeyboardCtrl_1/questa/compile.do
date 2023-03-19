vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr -mfcu \
"../../../../lab6.gen/sources_1/ip/KeyboardCtrl_1/src/Ps2Interface.v" \
"../../../../lab6.gen/sources_1/ip/KeyboardCtrl_1/src/KeyboardCtrl.v" \
"../../../../lab6.gen/sources_1/ip/KeyboardCtrl_1/sim/KeyboardCtrl_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

