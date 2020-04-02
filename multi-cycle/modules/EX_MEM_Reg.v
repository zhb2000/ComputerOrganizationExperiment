module EX_MEM_Reg(
    input clk,
    input[31:0] EX_aluResult,
    input EX_RegWrite,
    input[1:0] EX_RegDst,
    input[1:0] EX_RegSrc,
    input[1:0] EX_MemOp,
    input EX_MemEXT,
    input EX_MemWrite,
    input EX_MemRead,
    input[31:0] EX_rfOut2,
    input[31:0] EX_rd,
    input[31:0] EX_rt,
    input[31:0] EX_PC,

    output reg[31:0] MEM_aluResult,
    output reg MEM_RegWrite,
    output reg[1:0] MEM_RegDst,
    output reg[1:0] MEM_RegSrc,
    output reg[1:0] MEM_MemOp,
    output reg MEM_MemEXT,
    output reg MEM_MemWrite,
    output reg MEM_MemRead,
    output reg[31:0] MEM_rfOut2,
    output reg[31:0] MEM_rd,
    output reg[31:0] MEM_rt,
    output reg[31:0] MEM_PC
);

always @(posedge clk) 
begin
    MEM_aluResult <= EX_aluResult;
    MEM_RegWrite <= EX_RegWrite;
    MEM_RegDst <= EX_RegDst;
    MEM_RegSrc <= EX_RegSrc;
    MEM_MemOp <= EX_MemOp;
    MEM_MemEXT <= EX_MemEXT;
    MEM_MemWrite <= EX_MemWrite;
    MEM_MemRead <= EX_MemRead;
    MEM_rfOut2 <= EX_rfOut2;
    MEM_rd <= EX_rd;
    MEM_rt <= EX_rt;
    MEM_PC <= EX_PC;
end

endmodule // EX_MEM_Reg