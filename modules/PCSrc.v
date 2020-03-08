`include "ctrl_encode_def.v"
//Generate NPCOp signal
module PCSrc(Jump, Branch, Zero, NPCOp);
    input[1:0] Jump;//jump type
    input[1:0] Branch;//branch type
    input Zero;//ALU Zero ouput
    output reg[1:0] NPCOp;

    always @(*) 
    begin
        if (Jump == 2'd1) 
            NPCOp = `NPC_JUMP_IMM;
        else if (Jump == 2'd2)
            NPCOp = `NPC_JUMP_REG;
        else if (Branch == 2'd1 && Zero || Branch == 2'd2 && !Zero) 
            NPCOp = `NPC_BRANCH;
        else
            NPCOp = `NPC_PLUS4;
    end

endmodule // PCSrc