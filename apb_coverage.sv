class apb_coverage extends uvm_subscriber #(apb_txn);
  `uvm_component_utils(apb_coverage)

  apb_txn tr;

  covergroup apb_cg;
    option.per_instance = 1;

    apb_pwrite: coverpoint tr.pwrite {
      bins read_bin  = {0};
      bins write_bin = {1};
    }

    apb_paddr: coverpoint tr.paddr {
      bins low  = {[0:7]};
      bins high = {[8:15]};
    }

    apb_pwdata: coverpoint tr.pwdata iff (tr.pwrite) {
      bins bin_zero  = {32'h0000_0000};
      bins bin_small = {[1:255]};
      bins bin_large = {[256:32'hFFFF_FFFF]};
    }

    cross_pwrite_paddr: cross apb_pwrite, apb_paddr;
  endgroup

  function new(string name = "apb_coverage",
               uvm_component parent = null);
    super.new(name, parent);
    apb_cg = new;
  endfunction

  function void write(apb_txn t);
    tr = t;
    apb_cg.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(
      "COV",
      $sformatf("APB Functional Coverage = %0.2f%%", apb_cg.get_inst_coverage()),
      UVM_LOW
    )
  endfunction

endclass
