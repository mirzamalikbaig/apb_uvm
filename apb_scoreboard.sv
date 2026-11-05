class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp #(apb_txn, apb_scoreboard) imp;
  logic [31:0] ref_mem[31:0];

  function new(string name = "apb_scoreboard",
               uvm_component parent = null);
    super.new(name, parent);
    imp = new("imp", this);
  endfunction

  function void write(apb_txn txn);
    if (txn.pwrite) begin
      ref_mem[txn.paddr] = txn.pwdata;
      `uvm_info(
        "SCB",
        $sformatf("WRITE addr=%0d data=%0d", txn.paddr, txn.pwdata),
        UVM_LOW
      )
    end
    else
      if (txn.prdata == ref_mem[txn.paddr])
        `uvm_info(
          "SCB",
          $sformatf(
            "PASS addr=%0d expected=%0d actual=%0d",
            txn.paddr, ref_mem[txn.paddr], txn.prdata
          ),
          UVM_LOW
        )
      else
        `uvm_error(
          "SCB",
          $sformatf(
            "FAIL addr=%0d expected=%0d actual=%0d",
            txn.paddr, ref_mem[txn.paddr], txn.prdata
          )
        )
  endfunction

endclass
