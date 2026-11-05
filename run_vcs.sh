#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

vcs -full64 -licqueue -sverilog -ntb_opts uvm-1.2 \
  -timescale=1ns/1ns \
  -cm line+branch+tgl+fsm+cond \
  design.sv testbench.sv

./simv -cm line+branch+tgl+fsm+cond
urg -dir simv.vdb -format text
cat urgReport/dashboard.txt
