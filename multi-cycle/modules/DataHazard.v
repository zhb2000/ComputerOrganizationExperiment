`include "ctrl_encode_def.v"
//stall the pipeline when data hazard occurs, working at ID
//if not, RF's output data will be wrong
module DataHazard(
    //current instruction
    input[4:0] ID_rs,
    input[4:0] ID_rt,
    input[1:0] ID_Branch,
    input[1:0] ID_Jump,
    //previous instruction(now at EX)
    input EX_RegWrite,
    input[1:0] EX_RegSrc,
    input[4:0] EX_WriteReg,
    //pre-previous instruction(now at MEM)
    input MEM_RegWrite,
    input[1:0] MEM_RegSrc,
    input[4:0] MEM_WriteReg,
    //output control signals
    output PCWr,
    output IFIDWrite,
    output IDEXClearCtrl
);
    wire useRegAtID = ID_Branch != `BRANCH_NONE || ID_Jump == `JUMP_REG;
    reg stall;

    assign PCWr = !stall;//if stall, keep PC(keep next instruction in IF)
    assign IFIDWrite = !stall;//if stall, keep IF/ID register(keep current instruction in ID)
    assign IDEXClearCtrl = stall;//if stall, clear ctrl signals of back

    always @(*) 
    begin
        //hazard with previous instruction
        if (EX_RegWrite && EX_WriteReg != 5'd0 
            && (EX_WriteReg == ID_rs || EX_WriteReg == ID_rt)
            && (EX_RegSrc == `REGSRC_DMEM
                || useRegAtID && EX_RegSrc == `REGSRC_ALU))
                stall = 1'b1;
            // begin
            //     PCWr = 1'b0;
            //     IFIDWrite = 1'b0;
            //     IDEXClearCtrl = 1'b1;
            // end
        //hazard with pre-previous instruction
        else if (MEM_RegWrite && MEM_WriteReg != 5'd0
            && (MEM_WriteReg == ID_rs || MEM_WriteReg == ID_rs)
            && (useRegAtID && MEM_RegSrc == `REGSRC_DMEM))
                stall = 1'b1;
            // begin
            //     PCWr = 1'b0;
            //     IFIDWrite = 1'b0;
            //     IDEXClearCtrl = 1'b1;
            // end
        //no data hazard or hazard can be solved by bypassing in EX or ID
        else
            stall = 1'b0;
        // begin
        //     PCWr = 1'b1;
        //     IFIDWrite = 1'b1;
        //     IDEXClearCtrl = 1'b0;
        // end 
    end

endmodule // DataHazard