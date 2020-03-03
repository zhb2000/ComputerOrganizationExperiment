module CPU(clk, rst);
    input clk;
    input rst;

    wire RegDst;
    wire Jump;
    wire Branch;
    wire MemtoReg;
    wire[2:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire Zero;

    wire inst[31:0];
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign imm16 = inst[15:0];
    assign imm = inst[25:0];

    assign PCWr = 1;
    wire[31:0] NPC;
    wire[31:0] PC;

    always @(posedge clk or posedge rst) 
    begin
        PC pc(.clk(clk),.rst(rst),.PCWr(PCWr),.NPC(NPC),.PC(PC));
        
    end

endmodule // CPU