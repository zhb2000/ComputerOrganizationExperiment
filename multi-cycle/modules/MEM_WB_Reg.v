module MEM_WB_Reg(
    input clk,
    input[31:0] MEM_aluResult,
    input[31:0] MEM_dmOut,
    input[1:0] MEM_RegSrc,
    input[31:0] MEM_rt,
    input[31:0] MEM_rd,
    input[1:0] MEM_RegDst,
    input MEM_RegWrite,
    input[31:0] MEM_PC,

    output reg[31:0] WB_aluResult,
    output reg[31:0] WB_dmOut,
    output reg[1:0] WB_RegSrc,
    output reg[31:0] WB_rt,
    output reg[31:0] WB_rd,
    output reg[1:0] WB_RegDst,
    output reg WB_RegWrite,
    output reg[31:0] WB_PC
);

always @(posedge clk) 
begin
    WB_aluResult <= MEM_aluResult;
    WB_dmOut <= MEM_dmOut;
    WB_RegSrc <= MEM_RegSrc;
    WB_rt <= MEM_rt;
    WB_rd <= MEM_rd;
    WB_RegDst <= MEM_RegDst;
    WB_RegWrite <= MEM_RegWrite;
    WB_PC <= MEM_PC;
end

endmodule // MEM_WB_Reg