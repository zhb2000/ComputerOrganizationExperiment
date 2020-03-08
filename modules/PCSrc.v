`include "ctrl_encode_def.v"
//Generate NPCOp signal
module PCSrc(Jump, Branch, Zero, NPCOp);
    input Jump;//jump type
    input Branch;//is branch instruction
    input Zero;//ALU Zero ouput
    output reg[1:0] NPCOp;

    always @(*) 
    begin
        if (Jump == 1) 
            NPCOp = `NPC_JUMP_IMM;
        else if (Jump == 2)
            NPCOp = `NPC_JUMP_REG;
        else if (Branch && Zero) 
            NPCOp = `NPC_BRANCH;
        else
            NPCOp = `NPC_PLUS4;
    end

endmodule // PCSrc