module ID_EX_Reg(
    input clk,
    input rst,
    input clearCtrl,

    input ID_RegWrite,
    input[1:0] ID_RegDst,
    input[1:0] ID_RegSrc,

    input[3:0] ID_ALUOp,
    input ID_ALUSrcA,
    input ID_ALUSrcB,

    input ID_MemWrite,
    input ID_MemRead,
    input[1:0] ID_MemOp,
    input ID_MemEXT,
    
    input[31:0] ID_PC,
    input[31:0] ID_correctRFOut1,
    input[31:0] ID_correctRFOut2,

    input[4:0] ID_rs,
    input[4:0] ID_rd,
    input[4:0] ID_rt,
    input[31:0] ID_imm32,
    input[31:0] ID_shamt32,
    
    output reg EX_RegWrite,
    output reg[1:0] EX_RegDst,
    output reg[1:0] EX_RegSrc,

    output reg[3:0] EX_ALUOp,
    output reg EX_ALUSrcA,
    output reg EX_ALUSrcB,

    output reg EX_MemWrite,
    output reg EX_MemRead,
    output reg[1:0] EX_MemOp,
    output reg EX_MemEXT,

    output reg[31:0] EX_PC,
    output reg[31:0] EX_rfOut1,
    output reg[31:0] EX_rfOut2,

    output reg[4:0] EX_rs,
    output reg[4:0] EX_rd,
    output reg[4:0] EX_rt,
    output reg[31:0] EX_imm32,
    output reg[31:0] EX_shamt32
);
    wire clr = rst || clearCtrl;

    always @(posedge clk) 
    begin
        EX_RegWrite <= clr ? 1'b0 : ID_RegWrite;
        EX_RegDst <= clr ? 2'b0 : ID_RegDst;
        EX_RegSrc <= clr ? 2'b0 : ID_RegSrc;

        EX_ALUOp <= clr ? 3'b0 : ID_ALUOp;
        EX_ALUSrcA <= clr ? 1'b0 : ID_ALUSrcA;
        EX_ALUSrcB <= clr ? 1'b0 : ID_ALUSrcB;

        EX_MemWrite <= clr ? 1'b0 : ID_MemWrite;
        EX_MemRead <= clr ? 1'b0 : ID_MemRead;
        EX_MemOp <= clr ? 2'b0 : ID_MemOp;
        EX_MemEXT <= clr ? 1'b0 : ID_MemEXT;
        
        EX_PC <= clr ? 32'b0 : ID_PC;
        EX_rfOut1 <= clr ? 32'b0 : ID_correctRFOut1;
        EX_rfOut2 <= clr ? 32'b0 : ID_correctRFOut2;

        EX_rs <= clr ? 5'b0 : ID_rs;
        EX_rd <= clr ? 5'b0 : ID_rd;
        EX_rt <= clr ? 5'b0 : ID_rt;
        EX_imm32 <= clr ? 32'b0 : ID_imm32;
        EX_shamt32 <= clr ? 32'b0 : ID_shamt32;
    end

endmodule // ID_EX_Reg