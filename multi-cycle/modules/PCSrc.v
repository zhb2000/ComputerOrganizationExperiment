`include "ctrl_encode_def.v"
//Generate NPCOp signal, working at ID
module PCSrc(
    input[1:0] ID_Jump,//jump type
    input[1:0] ID_Branch,//branch type
    input ID_Equal,//GPR[rs]==GPR[rt]
    output reg[1:0] ID_NPCOp
);
    always @(*) 
    begin
        if (ID_Jump == `JUMP_IMM) 
            ID_NPCOp = `NPC_JUMP_IMM;
        else if (ID_Jump == `JUMP_REG)
            ID_NPCOp = `NPC_JUMP_REG;
        else if (ID_Branch == `BRANCH_BEQ && ID_Equal
            || ID_Branch == `BRANCH_BNE && !ID_Equal) 
            ID_NPCOp = `NPC_BRANCH;
        else
            ID_NPCOp = `NPC_PLUS4;
    end

endmodule // PCSrc