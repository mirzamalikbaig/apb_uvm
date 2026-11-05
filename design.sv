// Code your design here
module slave (
  input  logic        clk,
  input  logic        presetn,
  input  logic [31:0] paddr,
  input  logic [31:0] pwdata,
  input  logic        pwrite,
  input  logic        psel,
  input  logic        penable,
  output logic [31:0] prdata,
  output logic        pready,
  output logic        pslverr
);

  logic [31:0] mem [0:31];

  // Fast slave: always ready
  assign pready = 1'b1;

  // No error handling for now
  assign pslverr = 1'b0;

  // READ
  assign prdata = mem[paddr[4:0]];

  // WRITE
  always_ff @(posedge clk or negedge presetn) begin
    if (!presetn) begin
      for (int i = 0; i < 32; i++)
        mem[i] <= '0;
    end
    else if (psel && penable && pready && pwrite) begin
      mem[paddr[4:0]] <= pwdata;
    end
  end

endmodule
