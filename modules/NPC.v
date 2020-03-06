`include "ctrl_encode_def.v"
//decide next PC
module NPC(rst, PC, NPCOp, IMM, NPC);  // next pc module
   input rst;
   input[31:0] PC;// pc
   input[1:0]  NPCOp;// next pc operation
   input[25:0] IMM;// 26-bit immediate
   output reg [31:0] NPC;// next pc
   
   wire [31:0] PCPLUS4;//the value of PC + 4
   
   assign PCPLUS4 = PC + 4; // pc + 4
   
   always @(posedge rst)
   begin
      NPC = 32'h0000_0000;
   end

   always @(*) 
   begin
      if (!rst)
         case (NPCOp)
            `NPC_PLUS4:  NPC = PCPLUS4;
            `NPC_BRANCH: NPC = PCPLUS4 + {{14{IMM[15]}}, IMM[15:0], 2'b00};
            `NPC_JUMP:   NPC = {PCPLUS4[31:28], IMM[25:0], 2'b00};
            default:     NPC = PCPLUS4;
         endcase
   end // end always
   
endmodule
