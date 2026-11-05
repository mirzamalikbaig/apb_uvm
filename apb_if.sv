interface apb_if(input logic clk,
                 input logic presetn);

  logic [31:0] paddr;
  logic [31:0] pwdata;
  logic        pwrite;
  logic        penable;
  logic        psel;
  logic        pready;
  logic [31:0] prdata;
  logic        pslverr;

endinterface
