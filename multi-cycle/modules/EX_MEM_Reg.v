module EX_MEM_Reg(
    input clk,
    input rst,

    input[31:0] EX_PC,

    input EX_RegWrite,
    input[4:0] EX_WriteReg,
    input[1:0] EX_RegSrc,

    input EX_MemWrite,
    input EX_MemRead,
    input[1:0] EX_MemOp,
    input EX_MemEXT,
    input[31:0] EX_correctRFOut2,
    input[31:0] EX_aluResult,

    output reg[31:0] MEM_PC,

    output reg MEM_RegWrite,
    output reg[4:0] MEM_WriteReg,
    output reg[1:0] MEM_RegSrc,

    output reg MEM_MemWrite,
    output reg MEM_MemRead,
    output reg[1:0] MEM_MemOp,
    output reg MEM_MemEXT,
    output reg[31:0] MEM_rfOut2,
    output reg[31:0] MEM_aluResult
);

    always @(posedge clk) 
    begin
        MEM_PC <= rst ? 32'b0 : EX_PC;

        MEM_RegWrite <= rst ? 1'b0 : EX_RegWrite;
        MEM_WriteReg <= rst ? 5'b0 : EX_WriteReg;
        MEM_RegSrc <= rst ? 2'b0 : EX_RegSrc;

        MEM_MemWrite <= rst ? 1'b0 : EX_MemWrite;
        MEM_MemRead <= rst ? 1'b0 : EX_MemRead;
        MEM_MemOp <= rst ? 2'b0 : EX_MemOp;
        MEM_MemEXT <= rst ? 1'b0 : EX_MemEXT;
        
        MEM_rfOut2 <= rst ? 32'b0 : EX_correctRFOut2;
        MEM_aluResult <= rst ? 32'b0 : EX_aluResult;
    end

endmodule // EX_MEM_Reg