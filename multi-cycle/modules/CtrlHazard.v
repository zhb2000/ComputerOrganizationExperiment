`include "ctrl_encode_def.v"
//flush the instruction when it goes away
//working at ID
module CtrlHazard(
    input[1:0] ID_NPCOp,
    output IFIDFlush
);
    wire goAway = ID_NPCOp != `NPC_PLUS4;
    assign IFIDFlush = goAway;//flush the instruction at IF

endmodule // CtrlHazard