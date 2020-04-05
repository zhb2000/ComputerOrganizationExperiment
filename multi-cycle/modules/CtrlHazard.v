`include "ctrl_encode_def.v"
//flush the instruction when it goes away
//working at ID
module CtrlHazard(
    input[1:0] ID_NPCOp,
    output IFIDClearCtrl,
    output IDEXClearCtrl
);
    wire goAway = ID_NPCOp != `NPC_PLUS4;
    assign IFIDClearCtrl = goAway;//flush the instruction at IF
    assign IDEXClearCtrl = goAway;//flush the instruction at ID

endmodule // CtrlHazard