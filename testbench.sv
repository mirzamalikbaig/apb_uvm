`include "uvm_macros.svh"
import uvm_pkg::*;

`include "apb_if.sv"
`include "apb_txn.sv"
`include "apb_sequence.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_scoreboard.sv"
`include "apb_coverage.sv"
`include "apb_agent.sv"
`include "apb_env.sv"
`include "apb_test.sv"

// =================================================
// TOP
// =================================================
module top;

  logic clk = 0;
  logic presetn;

  always #5 clk = ~clk;

  apb_if pif(clk, presetn);

  slave dut (
    .clk     (pif.clk),
    .presetn (pif.presetn),
    .paddr   (pif.paddr),
    .pwdata  (pif.pwdata),
    .pwrite  (pif.pwrite),
    .psel    (pif.psel),
    .penable (pif.penable),
    .prdata  (pif.prdata),
    .pready  (pif.pready),
    .pslverr (pif.pslverr)
  );

  // RESET THREAD
  initial begin
    presetn = 0;
    repeat(2)
      @(posedge clk);
    presetn = 1;
  end

  // UVM THREAD
  initial begin
    uvm_config_db #(virtual apb_if)::set(
      null, "*", "vif", pif
    );
    run_test("apb_test"); // starts at t=0
  end

endmodule
