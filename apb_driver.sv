class apb_driver extends uvm_driver #(apb_txn);
  `uvm_component_utils(apb_driver)

  virtual apb_if vif;
  apb_txn txn;

  function new(string name = "apb_driver",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "virtual interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    vif.psel    = 0;
    vif.penable = 0;

    // Wait until reset is released
    @(posedge vif.presetn);

    forever begin
      seq_item_port.get_next_item(txn);
      drive(txn);
      seq_item_port.item_done();
    end
  endtask

  task drive(apb_txn txn);
    // SETUP
    @(negedge vif.clk);
    vif.psel    = 1;
    vif.penable = 0;
    vif.paddr   = txn.paddr;
    vif.pwrite  = txn.pwrite;
    vif.pwdata  = txn.pwdata;

    // ACCESS
    @(negedge vif.clk);
    vif.psel    = 1;
    vif.penable = 1;

    // Wait for slave
    do begin
      @(posedge vif.clk);
    end while (!vif.pready);

    // Transaction completed here
    if (!txn.pwrite)
      txn.prdata = vif.prdata;
    txn.pslverr = vif.pslverr;

    // IDLE
    @(negedge vif.clk);
    vif.psel    = 0;
    vif.penable = 0;
  endtask

endclass
