`include "ctrl_encode_def.v"
//Center Control of MIPS CPU
module Control(
    input[31:0] inst, //32bit instruction
    output reg RegDst,//0: rt as write reg; 1: rd as write reg
    output reg Jump,//is a jump-inst
    output reg Branch,//is a branch-inst
    output reg MemtoReg,//0: ALU result as RF's WD; 1: DataMem's dout as RF's WD;
    output reg[2:0] ALUOp,//will be sent to ALU
    output reg MemWrite,//write data into DataMem
    output reg ALUSrc,//0: choose RD2 from RF; //1: choose Imm32 from EXT
    output reg RegWrite//write data into RF or not
);
    
    wire[5:0] opcode;
    wire[5:0] funct;

    assign opcode = inst[31:26];
    assign funct = inst[5:0];

    always @(*) 
    begin
        //RegDst
        RegDst <= (opcode == `OPCODE_R);
        //Jump
        Jump <= (opcode == `OPCODE_J);
        //Branch
        Branch <= (opcode == `OPCODE_BEQ);
        //MemtoReg
        MemtoReg <= (opcode == `OPCODE_LW);
        //ALUOp
        if (opcode == `OPCODE_R) 
        begin
            case (funct)
                `FUNCT_ADD: ALUOp <= `ALU_ADD;
                `FUNCT_SUB: ALUOp <= `ALU_SUB;
                `FUNCT_AND: ALUOp <= `ALU_AND;
                `FUNCT_OR: ALUOp <= `ALU_OR;
                `FUNCT_SLT: ALUOp <= `ALU_SLT;
                `FUNCT_SLTU: ALUOp <= `ALU_SLTU;
                `FUNCT_ADDU: ALUOp <= `ALU_ADD;
                `FUNCT_SUBU: ALUOp <= `ALU_SUB;
            endcase
        end
        else if (opcode == `OPCODE_ADDI)
            ALUOp <= `ALU_ADD;
        else if (opcode == `OPCODE_ORI)
            ALUOp <= `ALU_OR;
        else if (opcode == `OPCODE_LW || opcode == `OPCODE_SW)
            ALUOp <= `ALU_ADD;
        else if (opcode == `OPCODE_BEQ)
            ALUOp <= `ALU_SUB;
        else
            ALUOp <= `ALU_NOP;
        //MemWrite
        MemWrite <= (opcode == `OPCODE_SW);
        //ALUSrc
        ALUSrc <= (opcode == `OPCODE_R 
                || opcode == `OPCODE_BEQ);
        //RegWrite
        RegWrite <= (opcode == `OPCODE_R 
                  || opcode == `OPCODE_ADDI 
                  || opcode == `OPCODE_ORI 
                  || opcode == `OPCODE_LW);
    end
  
endmodule // MIPSControl