module ID_EX_Reg(
    input clk,
    input rst,
    input clear,
    input[1:0] ID_RegDst,
    input[1:0] ID_Branch,
    input[1:0] ID_RegSrc,
    input[3:0] ID_ALUOp,
    input[1:0] ID_MemOp,
    input ID_MemEXT,
    input ID_MemWrite,
    input ID_MemRead,
    input ID_ALUSrcA,
    input ID_ALUSrcB,
    input ID_RegWrite,
    input[31:0] ID_rfOut1,
    input[31:0] ID_rfOut2,
    input[15:0] ID_imm16,
    input[31:0] ID_imm32,
    input[31:0] ID_shamt32,
    input[31:0] ID_PC,
    input[4:0] ID_rd,
    input[4:0] ID_rt,
    
    output reg[1:0] EX_RegDst,
    output reg[1:0] EX_Branch,
    output reg[1:0] EX_RegSrc,
    output reg[3:0] EX_ALUOp,
    output reg[1:0] EX_MemOp,
    output reg EX_MemEXT,
    output reg EX_MemWrite,
    output reg EX_MemRead,
    output reg EX_ALUSrcA,
    output reg EX_ALUSrcB,
    output reg EX_RegWrite,
    output reg[31:0] EX_rfOut1,
    output reg[31:0] EX_rfOut2,
    output reg[15:0] EX_imm16,
    output reg[31:0] EX_imm32,
    output reg[31:0] EX_shamt32,
    output reg[31:0] EX_PC,
    output reg[4:0] EX_rd,
    output reg[4:0] EX_rt
);

always @(posedge clk) 
begin
    EX_RegDst <= ID_RegDst;
    EX_Branch <= ID_Branch;
    EX_RegSrc <= ID_RegSrc;
    EX_ALUOp <= ID_ALUOp;
    EX_MemOp <= ID_MemOp;
    EX_MemEXT <= ID_MemEXT;
    EX_MemWrite <= ID_MemWrite;
    EX_MemRead <= ID_MemRead;
    EX_ALUSrcA <= ID_ALUSrcA;
    EX_ALUSrcB <= ID_ALUSrcB;
    EX_RegWrite <= ID_RegWrite;
    EX_rfOut1 <= ID_rfOut1;
    EX_rfOut2 <= ID_rfOut2;
    EX_imm16 <= ID_imm16;
    EX_imm32 <= ID_imm32;
    EX_shamt32 <= ID_shamt32;
    EX_PC <= ID_PC;
    EX_rd <= ID_rd;
    EX_rt <= ID_rt;
end

always @(negedge clk)
    if (rst || clear)
    begin
        EX_RegDst <= 0;
        EX_Branch <= 0;
        EX_RegSrc <= 0;
        EX_ALUOp <= 0;
        EX_MemOp <= 0;
        EX_MemEXT <= 0;
        EX_MemWrite <= 0;
        EX_MemRead <= 0;
        EX_ALUSrcA <= 0;
        EX_ALUSrcB <= 0;
        EX_RegWrite <= 0;
        EX_rfOut1 <= 0;
        EX_rfOut2 <= 0;
        EX_imm16 <= 0;
        EX_imm32 <= 0;
        EX_shamt32 <= 0;
        EX_PC <= 0;
        EX_rd <= 0;
        EX_rt <= 0;
    end

endmodule // ID_EX_Reg