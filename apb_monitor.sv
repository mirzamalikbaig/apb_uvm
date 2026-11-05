class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  uvm_analysis_port #(apb_txn) ap;
  virtual apb_if vif;

  function new(string name = "apb_monitor",
               uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "virtual interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    apb_txn txn;

    forever begin
      @(posedge vif.clk);
      if (vif.psel && vif.penable && vif.pready) begin
        txn = apb_txn::type_id::create("txn");
        txn.pwrite  = vif.pwrite;
        txn.paddr   = vif.paddr;
        txn.pwdata  = vif.pwdata;
        txn.prdata  = vif.prdata;
        txn.pslverr = vif.pslverr;
        ap.write(txn);
      end
    end
  endtask

endclass
