//Center Control of MIPS CPU
module Control(
    input[31:0] inst, //32bit instruction
    output[1:0] NPCOp,//will be sent to NPC
    output MemtoReg,//1: DataMem's dout as RF's WD; 0: ALU result as RF's WD
    output[2:0] ALUOp,//will be sent to ALU
    output MemWrite,//write data into DataMem
    output ALUSrc,//0: choose RD2 from RF; //1: choose Imm32 from EXT
    output RegWrite//write data into RF
    
    wire[5:0] opcode;
    wire[5:0] funct;

    assign opcode = inst[31:26];
    assign funct = inst[5:0];

    
);

    
endmodule // MIPSControl