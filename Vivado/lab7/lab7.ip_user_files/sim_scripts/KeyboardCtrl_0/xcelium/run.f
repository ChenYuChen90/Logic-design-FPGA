-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../lab7.gen/sources_1/ip/KeyboardCtrl_0/src/Ps2Interface.v" \
  "../../../../lab7.gen/sources_1/ip/KeyboardCtrl_0/src/KeyboardCtrl.v" \
  "../../../../lab7.gen/sources_1/ip/KeyboardCtrl_0/sim/KeyboardCtrl_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

