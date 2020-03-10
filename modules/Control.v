`include "ctrl_encode_def.v"
//Center Control of MIPS CPU
module Control(
    //32bit instruction
    input[31:0] inst,
    //select the write reg
    //0: rt, 1: rd, 2: $31
    output reg[1:0] RegDst,
    //jump type, use what to write PC
    //0: not jump, 1: use imm26, 2: use reg
    output reg[1:0] Jump,
    //branch type, equal or not equal
    //0: not branch, 1: beq, 2: bne
    output reg[1:0] Branch,
    //select RF's write data
    //0: ALU result, 1: DataMem's dout, 3: pc+4
    output reg[1:0] RegSrc,
    //will be sent to ALU
    output reg[3:0] ALUOp,
    //DataMem's write signal
    output reg MemWrite,
    //choose ALU's operand1
    //0: RD1 from RF; 1: 5bit shamt
    output reg ALUSrcA,
    //choose ALU's operand2
    //0: RD2 from RF; 1: Imm32 from EXT
    output reg ALUSrcB,
    //RF's write signal
    output reg RegWrite
);
    
    wire[5:0] opcode;
    wire[5:0] funct;

    assign opcode = inst[31:26];
    assign funct = inst[5:0];

    always @(*) 
    begin
        //RegDst
        if (opcode == `OPCODE_R_JR_JALR 
            && funct != `FUNCT_JR && funct != `FUNCT_JALR)
            RegDst <= 2'd1;//R-R -- rd
        else if (opcode == `OPCODE_R_JR_JALR && funct == `FUNCT_JALR)
            RegDst <= 2'd1;//jalr -- rd
        else if (opcode == `OPCODE_JAL)
            RegDst <= 2'd2;//jal -- $31
        else
            RegDst <= 2'd0;//R-I, Load, Store -- rt
        
        //Jump
        if (opcode == `OPCODE_J || opcode == `OPCODE_JAL)
            Jump <= 2'd1;//j, jal -- imm26
        else if(opcode == `OPCODE_R_JR_JALR 
            && (funct == `FUNCT_JR || funct == `FUNCT_JALR))
            Jump <= 2'd2;//jr, jal -- reg
        else
            Jump <= 2'd0;
        
        //Branch
        if (opcode == `OPCODE_BEQ)
            Branch <= 2'd1;//beq
        else if (opcode == `OPCODE_BNE)
            Branch <= 2'd2;//bne
        else
            Branch <= 2'd0;
        
        //RegSrc
        if (opcode == `OPCODE_LW)
            RegSrc <= 2'd1;//Load -- dmem
        else if (opcode == `OPCODE_JAL || (opcode == `OPCODE_R_JR_JALR && funct == `FUNCT_JALR))
            RegSrc <= 2'd2;//jal, jalr -- pc+4
        else
            RegSrc <= 2'd0;//R-R, R-I -- ALU result

        //ALUOp
        //R-R
        if (opcode == `OPCODE_R_JR_JALR 
            && funct != `FUNCT_JR && funct != `FUNCT_JALR) 
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
                `FUNCT_SLL: ALUOp <= `ALU_SLL;
                `FUNCT_SRL: ALUOp <= `ALU_SRL;
                `FUNCT_SRA: ALUOp <= `ALU_SRA;
                `FUNCT_SLLV: ALUOp <= `ALU_SLL;
                `FUNCT_SRLV: ALUOp <= `ALU_SRL;
                `FUNCT_SRAV: ALUOp <= `ALU_SRA;
                `FUNCT_XOR: ALUOp <= `ALU_XOR;
                `FUNCT_NOR: ALUOp <= `ALU_NOR;
                default: ALUOp <= `ALU_NOP;
            endcase
        end
        //R-I
        else if (opcode == `OPCODE_ADDI)
            ALUOp <= `ALU_ADD;
        else if (opcode == `OPCODE_ORI)
            ALUOp <= `ALU_OR;
        else if (opcode == `OPCODE_SLTI)
            ALUOp <= `ALU_SLT;
        else if (opcode == `OPCODE_ANDI)
            ALUOp <= `ALU_AND;
        else if (opcode == `OPCODE_LUI)
            ALUOp <= `ALU_LUI;
        //Load, Store
        else if (opcode == `OPCODE_LW || opcode == `OPCODE_SW)
            ALUOp <= `ALU_ADD;
        // Branch
        else if (opcode == `OPCODE_BEQ || opcode == `OPCODE_BNE)
            ALUOp <= `ALU_SUB;
        else
            ALUOp <= `ALU_NOP;
        
        //MemWrite
        MemWrite <= (opcode == `OPCODE_SW);//Store

        //ALUSrcA
        ALUSrcA <= (opcode == `OPCODE_R_JR_JALR) 
            && ((funct == `FUNCT_SLL) 
             || (funct == `FUNCT_SRL) 
             || (funct == `FUNCT_SRA));//sll, srl, sra -- shamt; other -- RF's RD1
        
        //ALUSrcB
        //R-R, beq, bne: 0 -- RF's RD2
        //R-I, Load, Store: 1 -- imm32
        ALUSrcB <= (opcode == `OPCODE_R_JR_JALR 
                || opcode == `OPCODE_BEQ 
                || opcode == `OPCODE_BNE) ? 1'b0 : 1'b1;
        
        //RegWrite
        RegWrite <= ((opcode == `OPCODE_R_JR_JALR && funct != `FUNCT_JR && funct != `FUNCT_JALR)//R-R
                    //R-I
                    || opcode == `OPCODE_ADDI 
                    || opcode == `OPCODE_ORI 
                    || opcode == `OPCODE_SLTI
                    || opcode == `OPCODE_ANDI
                    || opcode == `OPCODE_LUI
                    || opcode == `OPCODE_LW//Load
                    || opcode == `OPCODE_JAL//jal
                    || (opcode == `OPCODE_R_JR_JALR && funct == `FUNCT_JALR));//jalr
    end
  
endmodule // MIPSControl