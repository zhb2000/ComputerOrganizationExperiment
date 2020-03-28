`include "ctrl_encode_def.v"
//decide next PC
module NPC(PC, NPCOp, imm26, addr32, NPC);  // next pc module
    input[31:0] PC;//pc
    input[1:0]  NPCOp;//next pc operation
    input[25:0] imm26;//26bit imm26ediate
    input[31:0] addr32;//32bit address
    output reg [31:0] NPC;//next pc
    
    wire [31:0] PCPLUS4;//the value of PC + 4
    
    assign PCPLUS4 = PC + 4; //pc + 4
  
    always @(*) 
    begin
        case (NPCOp)
            `NPC_PLUS4: NPC = PCPLUS4;
            `NPC_BRANCH: NPC = PCPLUS4 + {{14{imm26[15]}}, imm26[15:0], 2'b00};
            `NPC_JUMP_IMM: NPC = {PCPLUS4[31:28], imm26[25:0], 2'b00};
            `NPC_JUMP_REG: NPC = addr32;
        endcase
    end // end always
    
endmodule
