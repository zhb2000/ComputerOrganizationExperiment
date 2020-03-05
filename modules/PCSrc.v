`include "ctrl_encode_def.v"
//Generate NPCOp signal
module PCSrc(Jump, Branch, Zero, NPCOp);
    input Jump;//is jump instruction
    input Branch;//is branch instruction
    input Zero;//ALU Zero ouput
    output reg[1:0] NPCOp;

    always @(*) 
    begin
        if (Jump) 
            NPCOp = `NPC_JUMP;
        else if (Branch && Zero) 
            NPCOp = `NPC_BRANCH;
        else
            NPCOp = `NPC_PLUS4;
    end

endmodule // PCSrc