class apb_sequence extends uvm_sequence #(apb_txn);

  `uvm_object_utils(apb_sequence)

  function new(string name = "apb_sequence");
    super.new(name);
  endfunction

  task body();
    apb_txn wr_low;
    apb_txn rd_low;
    apb_txn wr_high;
    apb_txn rd_high;
    apb_txn pw_zero;
    apb_txn pw_large;
    apb_txn wr_pat0;
    apb_txn rd_pat0;
    apb_txn wr_pat1;
    apb_txn rd_pat1;
    apb_txn wr_pat2;
    apb_txn rd_pat2;
    apb_txn wr_pat3;
    apb_txn rd_pat3;

    // WRITE + LOW ADDRESS
    wr_low = apb_txn::type_id::create("wr_low");
    start_item(wr_low);
    wr_low.pwrite = 1;
    wr_low.paddr  = 5;
    wr_low.pwdata = 50;
    finish_item(wr_low);

    // READ + LOW ADDRESS
    rd_low = apb_txn::type_id::create("rd_low");
    start_item(rd_low);
    rd_low.pwrite = 0;
    rd_low.paddr  = 5;
    finish_item(rd_low);

    // WRITE + HIGH ADDRESS
    wr_high = apb_txn::type_id::create("wr_high");
    start_item(wr_high);
    wr_high.pwrite = 1;
    wr_high.paddr  = 12;
    wr_high.pwdata = 100;
    finish_item(wr_high);

    // READ + HIGH ADDRESS
    rd_high = apb_txn::type_id::create("rd_high");
    start_item(rd_high);
    rd_high.pwrite = 0;
    rd_high.paddr  = 12;
    finish_item(rd_high);

    // HIT ZERO PWDATA BIN
    pw_zero = apb_txn::type_id::create("pw_zero");
    start_item(pw_zero);
    pw_zero.pwrite = 1;
    pw_zero.paddr  = 6;
    pw_zero.pwdata = 32'h0000_0000;
    finish_item(pw_zero);

    // HIT LARGE PWDATA BIN
    pw_large = apb_txn::type_id::create("pw_large");
    start_item(pw_large);
    pw_large.pwrite = 1;
    pw_large.paddr  = 7;
    pw_large.pwdata = 500;
    finish_item(pw_large);

    // TOGGLE PATTERN 1: ALL ZERO
    wr_pat0 = apb_txn::type_id::create("wr_pat0");
    start_item(wr_pat0);
    wr_pat0.pwrite = 1;
    wr_pat0.paddr  = 1;
    wr_pat0.pwdata = 32'h0000_0000;
    finish_item(wr_pat0);

    rd_pat0 = apb_txn::type_id::create("rd_pat0");
    start_item(rd_pat0);
    rd_pat0.pwrite = 0;
    rd_pat0.paddr  = 1;
    finish_item(rd_pat0);

    // TOGGLE PATTERN 2: ALL ONE
    wr_pat1 = apb_txn::type_id::create("wr_pat1");
    start_item(wr_pat1);
    wr_pat1.pwrite = 1;
    wr_pat1.paddr  = 2;
    wr_pat1.pwdata = 32'hFFFF_FFFF;
    finish_item(wr_pat1);

    rd_pat1 = apb_txn::type_id::create("rd_pat1");
    start_item(rd_pat1);
    rd_pat1.pwrite = 0;
    rd_pat1.paddr  = 2;
    finish_item(rd_pat1);

    // TOGGLE PATTERN 3: 1010 1010 ...
    wr_pat2 = apb_txn::type_id::create("wr_pat2");
    start_item(wr_pat2);
    wr_pat2.pwrite = 1;
    wr_pat2.paddr  = 3;
    wr_pat2.pwdata = 32'hAAAA_AAAA;
    finish_item(wr_pat2);

    rd_pat2 = apb_txn::type_id::create("rd_pat2");
    start_item(rd_pat2);
    rd_pat2.pwrite = 0;
    rd_pat2.paddr  = 3;
    finish_item(rd_pat2);

    // TOGGLE PATTERN 4: 0101 0101 ...
    wr_pat3 = apb_txn::type_id::create("wr_pat3");
    start_item(wr_pat3);
    wr_pat3.pwrite = 1;
    wr_pat3.paddr  = 4;
    wr_pat3.pwdata = 32'h5555_5555;
    finish_item(wr_pat3);

    rd_pat3 = apb_txn::type_id::create("rd_pat3");
    start_item(rd_pat3);
    rd_pat3.pwrite = 0;
    rd_pat3.paddr  = 4;
    finish_item(rd_pat3);
  endtask

endclass
