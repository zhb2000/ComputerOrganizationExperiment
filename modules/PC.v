//PC registesr
module PC(clk, rst, PCWr, NPC, PC);

  input clk;//clock signal
  input rst;//reset signal
  input PCWr;//PC write signal(always 1 in single cycle CPU)
  input[31:0] NPC;//input next pc
  output reg[31:0] PC;//output pc

  always @(posedge clk, posedge rst)
    if (rst) 
      PC <= 32'h0000_0000; //PC <= 32'h0000_3000;
    else if (PCWr)
      PC <= NPC;
endmodule