module RF(input         clk,//clock signal
          input         rst,//reset signal
          input         RFWr,//register file write signal
          input  [4:0]  A1, A2, A3,//address 1, 2, 3
          input  [31:0] WD,//write data
          output [31:0] RD1, RD2//read data 1, 2
          );

  reg [31:0] rf[31:0];//register file (with 32 32bit-registers)
  assign RD1 = (A1 != 0) ? rf[A1] : 0;
  assign RD2 = (A2 != 0) ? rf[A2] : 0;
  integer i;

  always @(negedge rst)//reset
    for (i = 1; i < 32; i = i + 1)
        rf[i] = 0;
  
  always @(negedge clk)// write back
    if (!rst && RFWr && A3 != 0)
    begin
      rf[A3] = WD;
      $display("r[%d] = %d(0x%8h)", A3, WD, WD);
    end

endmodule