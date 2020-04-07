`include "ctrl_encode_def.v"
//ByPassing module working at ID
//correct RF's output, which will be used in Branch(beq, bne) or Jump(jr, jalr)
module ByPassingID(
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
    //candidates
    input[31:0] ID_rfOut1,
    input[31:0] ID_rfOut2,
    input[31:0] EX_PC,
    input[31:0] MEM_PC,
    input[31:0] MEM_aluResult,
    //output: correct RF's output
    output reg[31:0] ID_correctRFOut1,
    output reg[31:0] ID_correctRFOut2
);

    wire useRegAtID = ID_Branch != `BRANCH_NONE || ID_Jump == `JUMP_REG;

    //ID_correctRFOut1
    always @(*) 
    begin
        if (useRegAtID)//use at ID
        begin
            //forward from previous instruction(now at EX)
            if (EX_RegWrite && EX_WriteReg != 5'd0 && EX_WriteReg == ID_rs)
                if (EX_RegSrc == `REGSRC_PCPLUS4)
                    ID_correctRFOut1 = EX_PC + 32'd4;//from previous PC+4
                /*REGSRC_DMEM or REGSRC_ALU will cause stall*/
            //forward from pre-previous instruction(now at WB)
            else if (MEM_RegWrite && MEM_WriteReg != 5'd0 && MEM_WriteReg == ID_rs)
                case (MEM_RegSrc)
                    `REGSRC_PCPLUS4: ID_correctRFOut1 = MEM_PC + 32'd4;
                    `REGSRC_ALU: ID_correctRFOut1 = MEM_aluResult;
                    /*REGSRC_DMEM will cause stall*/
                endcase
            //use at ID but no data hazard
            else
                ID_correctRFOut1 = ID_rfOut1;
        end
        else//not use reg at ID
            ID_correctRFOut1 = ID_rfOut1;
    end

    //ID_correctRFOut2
    always @(*) 
    begin
        if (useRegAtID)//use at ID
        begin
            //forward from previous instruction(now at EX)
            if (EX_RegWrite && EX_WriteReg != 5'd0 && EX_WriteReg == ID_rt)
                if (EX_RegSrc == `REGSRC_PCPLUS4)
                    ID_correctRFOut2 = EX_PC + 32'd4;//from previous PC+4
                /*REGSRC_DMEM or REGSRC_ALU will cause stall*/
            //forward from pre-previous instruction(now at WB)
            else if (MEM_RegWrite && MEM_WriteReg != 5'd0 && MEM_WriteReg == ID_rt)
                case (MEM_RegSrc)
                    `REGSRC_PCPLUS4: ID_correctRFOut2 = MEM_PC + 32'd4;
                    `REGSRC_ALU: ID_correctRFOut2 = MEM_aluResult;
                    /*REGSRC_DMEM will cause stall*/
                endcase
            //use at ID but no data hazard
            else
                ID_correctRFOut2 = ID_rfOut2;
        end
        else//not use reg at ID
            ID_correctRFOut2 = ID_rfOut2;
    end

endmodule // ByPassingID