//ByPassing module working at EX
//correct RF's output data
module ByPassing(
    //current instruction
    //input EX_ALUSrcA,//0: GPR[rs](rfOut1), 1: shamt
    //input EX_ALUSrcB,//0: GPR[rt](rfOut2), 1:imm32
    input[4:0] EX_rs,
    input[4:0] EX_rt,
    //previous instruction
    input MEM_RegWrite,
    input[4:0] MEM_WriteReg,
    //pre-previous instruction
    input WB_RegWrite,
    input[4:0] WB_WriteReg,
    //select one data to correct RF's output
    //0: current data, 1: previous aluResult, 2: pre-previous aluResult
    output reg[1:0] rfOutForwardA,
    output reg[1:0] rfOutForwardB
);
    
    //rfOutForwardA
    always @(*) 
    begin
        //forward from previous instruction(now at MEM)
        if (MEM_RegWrite && MEM_WriteReg != 5'd0
            && MEM_WriteReg == EX_rs)
            rfOutForwardA = 2'd1;
        //forward from pre-previous instruction(now at WB)
        else if (WB_RegWrite && WB_WriteReg != 5'd0
            && WB_WriteReg == EX_rs)
            rfOutForwardA = 2'd2;
        else
            rfOutForwardA = 2'd0;
    end

    //rfOutForwardB
    always @(*)
    begin
        //forward from previous instruction(now at MEM)
        if (MEM_RegWrite && MEM_WriteReg != 5'd0
            && MEM_WriteReg == EX_rt)
            rfOutForwardB = 2'd1;
        //forward from pre-previous instruction(now at WB)
        else if (WB_RegWrite && WB_WriteReg != 5'd0
            && WB_WriteReg ==EX_rt)
            rfOutForwardB = 2'd2;
        else
            rfOutForwardB = 2'd0;
    end
endmodule // ByPassing