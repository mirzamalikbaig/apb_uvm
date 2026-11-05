class apb_txn extends uvm_sequence_item;

  `uvm_object_utils(apb_txn)

  rand bit [31:0] paddr;
  rand bit        pwrite;
  rand bit [31:0] pwdata;
  logic [31:0] prdata;
  logic        pslverr;

  function new(string name = "apb_txn");
    super.new(name);
  endfunction

endclass
