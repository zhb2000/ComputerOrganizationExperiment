`include "ctrl_encode_def.v"
//PC registesr
module PC(clk, rst, PCWr, NPC, PC);

  input clk;//clock signal
  input rst;//reset signal
  input PCWr;//PC write signal(always 1 in single cycle CPU)
  input[31:0] NPC;//input next pc
  output reg[31:0] PC;//output pc

  always @(posedge clk or posedge rst)
    if (rst) 
      PC <= `TEXT_BASE_ADDRESS;
    else if (PCWr)
      PC <= NPC;
endmodule