`include "ctrl_encode_def.v"
//next pc module, decide next PC
module NPC(
    input[1:0] NPCOp,//next pc operation
    input[31:0] IF_PC,
    input[31:0] ID_PC,
    input[25:0] ID_imm26,//26bit immediate, for jump_imm
    input[31:0] addr32,//32bit jump address, for jump_reg
    input[15:0] ID_imm16,//16bit immediate, for branch
    output reg [31:0] NPC//next pc
);
    wire[31:0] IF_PC_PLUS4 = IF_PC + 32'd4;
    wire[31:0] ID_PC_PLUS4 = ID_PC + 32'd4;
  
    always @(*) 
    begin
        case (NPCOp)
            `NPC_PLUS4: NPC = IF_PC_PLUS4;
            `NPC_BRANCH: NPC = ID_PC_PLUS4 + {{14{ID_imm16[15]}}, ID_imm16, 2'b00};
            `NPC_JUMP_IMM: NPC = {ID_PC_PLUS4[31:28], ID_imm26[25:0], 2'b00};
            `NPC_JUMP_REG: NPC = addr32;
        endcase
    end // end always
    
endmodule
