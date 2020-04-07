`include "ctrl_encode_def.v"
//ByPassing module working at EX
//correct RF's output data, which will be used as ALU's operand or DataMem's din
module ByPassingEX(
    //current instruction
    input[4:0] EX_rs,
    input[4:0] EX_rt,
    //previous instruction(now at MEM)
    input MEM_RegWrite,
    input[1:0] MEM_RegSrc,
    input[4:0] MEM_WriteReg,
    //pre-previous instruction(now at WB)
    input WB_RegWrite,
    input[1:0] WB_RegSrc,
    input[4:0] WB_WriteReg,
    //candidates
    input[31:0] EX_rfOut1,
    input[31:0] EX_rfOut2,
    input[31:0] MEM_aluResult,
    input[31:0] MEM_PC,
    input[31:0] WB_rfWriteData,
    //output: correct RF's output
    output reg[31:0] EX_correctRFOut1,
    output reg[31:0] EX_correctRFOut2
);
    
    //EX_correctRFOut1
    always @(*) 
    begin
        //forward from previous instruction(now at MEM)
        if (MEM_RegWrite && MEM_WriteReg != 5'd0 && MEM_WriteReg == EX_rs)
        begin
            case (MEM_RegSrc)
                `REGSRC_ALU: EX_correctRFOut1 = MEM_aluResult;//from previous aluResult
                `REGSRC_PCPLUS4: EX_correctRFOut1 = MEM_PC + 32'd4;//from previous PC+4
                /*REGSRC_DMEM will cause stall*/
            endcase
        end
        //forward from pre-previous instruction(now at WB)
        else if (WB_RegWrite && WB_WriteReg != 5'd0 && WB_WriteReg == EX_rs)
            EX_correctRFOut1 = WB_rfWriteData;
        else
            EX_correctRFOut1 = EX_rfOut1;
    end

    //EX_correctRFOut2
    always @(*) 
    begin
        //forward from previous instruction(now at MEM)
        if (MEM_RegWrite && MEM_WriteReg != 5'd0 && MEM_WriteReg == EX_rt)
        begin
            case (MEM_RegSrc)
                `REGSRC_ALU: EX_correctRFOut2 = MEM_aluResult;///from previous aluResult
                `REGSRC_PCPLUS4: EX_correctRFOut2 = MEM_PC + 32'd4;//from previous PC+4
                /*REGSRC_DMEM will cause stall*/
            endcase
        end
        //forward from pre-previous instruction(now at WB)
        else if (WB_RegWrite && WB_WriteReg != 5'd0 && WB_WriteReg == EX_rt)
            EX_correctRFOut2 = WB_rfWriteData;
        else
            EX_correctRFOut2 = EX_rfOut2;
    end

endmodule // ByPassingEX