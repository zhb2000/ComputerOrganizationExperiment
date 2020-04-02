`include "ctrl_encode_def.v"
module CPU(
    input clk,
    input rst
);

    wire[31:0] IF_PC;
    wire[31:0] IF_inst;
    wire[1:0] IF_NPCOp;
    wire[31:0] IF_NPC;

    wire[31:0] ID_PC;
    wire[31:0] ID_inst;
    wire[31:0] ID_rs = ID_inst[25:21];
    wire[31:0] ID_rt = ID_inst[20:16];
    wire[31:0] ID_rd = ID_inst[15:11];
    wire[4:0] ID_shamt5 = ID_inst[10:6];
    wire[15:0] ID_imm16 = ID_inst[15:0];
    wire[25:0] ID_imm26 = ID_inst[25:0];
    wire[31:0] ID_imm32;
    wire[31:0] ID_shamt32;
    wire[1:0] ID_RegDst;
    wire[1:0] ID_Branch;
    wire[1:0] ID_RegSrc;
    wire[3:0] ID_ALUOp;
    wire[1:0] ID_MemOp;
    wire ID_MemEXT;
    wire ID_MemWrite;
    wire ID_MemRead;
    wire ID_ALUSrcA;
    wire ID_ALUSrcB;
    wire ID_RegWrite;
    wire[31:0] ID_rfOut1;
    wire[31:0] ID_rfOut2;
    wire[1:0] ID_Jump;

    wire[1:0] EX_RegDst;
    wire[1:0] EX_Branch;
    wire[1:0] EX_RegSrc;
    wire[3:0] EX_ALUOp;
    wire[1:0] EX_MemOp;
    wire EX_MemEXT;
    wire EX_MemWrite;
    wire EX_MemRead;
    wire EX_ALUSrcA;
    wire EX_ALUSrcB;
    wire EX_RegWrite;
    wire[31:0] EX_rfOut1;
    wire[31:0] EX_rfOut2;
    wire[31:0] EX_imm16;
    wire[31:0] EX_imm32;
    wire[31:0] EX_shamt32;
    wire[31:0] EX_PC;
    wire[31:0] EX_rd;
    wire[31:0] EX_rt;
    wire[31:0] EX_aluResult;
    wire[31:0] EX_operand1;
    wire[31:0] EX_operand2;
    wire EX_Zero;

    wire[31:0] MEM_aluResult;
    wire MEM_RegWrite;
    wire[1:0] MEM_RegDst;
    wire[1:0] MEM_RegSrc;
    wire[1:0] MEM_MemOp;
    wire MEM_MemEXT;
    wire MEM_MemWrite;
    wire MEM_MemRead;
    wire[31:0] MEM_rfOut2;
    wire[31:0] MEM_rd;
    wire[31:0] MEM_rt;
    wire[31:0] MEM_PC;
    wire[31:0] MEM_dmOut;

    wire[31:0] WB_aluResult;
    wire[31:0] WB_dmOut;
    wire[1:0] WB_RegSrc;
    wire[31:0] WB_rt;
    wire[31:0] WB_rd;
    wire[1:0] WB_RegDst;
    wire WB_RegWrite;
    wire[31:0] WB_PC;
    wire[31:0] WB_rfWriteAddr;
    wire[31:0] WB_rfWriteData;


    PC pc(
        .clk(clk),
        .rst(rst),
        .PCWr(1'b1),
        .NPC(IF_NPC),
        .PC(IF_PC)
    );

    PCSrc pcsrc(
        .Jump(ID_Jump), 
        .Branch(EX_Branch), 
        .Zero(EX_Zero), 
        .NPCOp(IF_NPCOp)
    );

    NPC npc(
        .NPCOp(IF_NPCOp),
        .IF_PC(IF_PC), 
        .ID_PC(ID_PC),
        .EX_PC(EX_PC),
        .ID_imm26(ID_imm26),
        .EX_imm16(EX_imm16),
        .addr32(ID_rfOut1),
        .NPC(IF_NPC)
    );

    InsMem insMem(
        .rst(rst), 
        .address(IF_PC), 
        .dout(IF_inst)
    );

    IF_ID_Reg if_id_reg(
        .clk(clk),
        .IF_PC(IF_PC),
        .IF_inst(IF_inst),
        .ID_PC(ID_PC),
        .ID_inst(ID_inst)
    );

    Control control(
        .inst(ID_inst),
        .RegDst(ID_RegDst), 
        .Jump(ID_Jump), 
        .Branch(ID_Branch), 
        .RegSrc(ID_RegSrc), 
        .ALUOp(ID_ALUOp), 
        .MemOp(ID_MemOp),
        .MemEXT(ID_MemEXT),
        .MemWrite(ID_MemWrite),
        .ALUSrcA(ID_ALUSrcA), 
        .ALUSrcB(ID_ALUSrcB), 
        .RegWrite(ID_RegWrite)
    );

    RF regFile(
        .clk(clk), 
        .rst(rst),
        .RFWr(WB_RegWrite),
        .A1(ID_rs), 
        .A2(ID_rt), 
        .A3(WB_rfWriteAddr),
        .WD(WB_rfWriteData),
        .RD1(ID_rfOut1), 
        .RD2(ID_rfOut2)
    );
    
    EXT ext_16_32(
        .Imm16(ID_imm16), 
        .EXTOp(`EXT_SIGNED), 
        .Imm32(ID_imm32)
    );
    EXT_5_32 ext_5_32(
        .shamt(ID_shamt5), 
        .EXTOp(`EXT_ZERO), 
        .out32(ID_shamt32)
    );

    ID_EX_Reg id_ex_reg(
        .clk(clk),
        .ID_RegDst(ID_RegDst),
        .ID_Branch(ID_Branch),
        .ID_RegSrc(ID_RegSrc),
        .ID_ALUOp(ID_ALUOp),
        .ID_MemOp(ID_MemOp),
        .ID_MemEXT(ID_MemEXT),
        .ID_MemWrite(ID_MemWrite),
        .ID_MemRead(ID_MemRead),
        .ID_ALUSrcA(ID_ALUSrcA),
        .ID_ALUSrcB(ID_ALUSrcB),
        .ID_RegWrite(ID_RegWrite),
        .ID_rfOut1(ID_rfOut1),
        .ID_rfOut2(ID_rfOut2),
        .ID_imm16(ID_imm16),
        .ID_imm32(ID_imm32),
        .ID_shamt32(ID_shamt32),
        .ID_PC(ID_PC),
        .ID_rd(ID_rd),
        .ID_rt(ID_rt),
        .EX_RegDst(EX_RegDst),
        .EX_Branch(EX_Branch),
        .EX_RegSrc(EX_RegDst),
        .EX_ALUOp(EX_ALUOp),
        .EX_MemOp(EX_MemOp),
        .EX_MemEXT(EX_MemEXT),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemRead(EX_MemRead),
        .EX_ALUSrcA(EX_ALUSrcA),
        .EX_ALUSrcB(EX_ALUSrcB),
        .EX_RegWrite(EX_RegWrite),
        .EX_rfOut1(EX_rfOut1),
        .EX_rfOut2(EX_rfOut2),
        .EX_imm16(EX_imm16),
        .EX_imm32(EX_imm32),
        .EX_shamt32(EX_shamt32),
        .EX_PC(EX_PC),
        .EX_rd(EX_rd),
        .EX_rt(EX_rt)
    );

    mux2 #(32) selOperand1(
        .d0(EX_rfOut1), 
        .d1(EX_shamt32),
        .s(EX_ALUSrcA),
        .y(EX_operand1)
    );
    mux2 #(32) selOperand2(
        .d0(EX_rfOut2), 
        .d1(EX_imm32), 
        .s(EX_ALUSrcB),
        .y(EX_operand2)
    );                           
    
    alu mALU(
        .A(EX_operand1), 
        .B(EX_operand2), 
        .ALUOp(EX_ALUOp),
        .C(EX_aluResult), 
        .Zero(EX_Zero)
    );
    
    EX_MEM_Reg ex_mem_reg(
        .clk(clk),
        .EX_aluResult(EX_aluResult),
        .EX_RegWrite(EX_RegWrite),
        .EX_RegDst(EX_RegDst),
        .EX_RegSrc(EX_RegSrc),
        .EX_MemOp(EX_MemOp),
        .EX_MemEXT(EX_MemEXT),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemRead(EX_MemRead),
        .EX_rfOut2(EX_rfOut2),
        .EX_rd(EX_rd),
        .EX_rt(EX_rt),
        .EX_PC(EX_PC),
        .MEM_aluResult(MEM_aluResult),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_RegDst(MEM_RegDst),
        .MEM_RegSrc(MEM_RegSrc),
        .MEM_MemOp(MEM_MemOp),
        .MEM_MemEXT(MEM_MemEXT),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_MemRead(MEM_MemRead),
        .MEM_rfOut2(MEM_rfOut2),
        .MEM_rd(MEM_rd),
        .MEM_rt(MEM_rt),
        .MEM_PC(MEM_PC)
    );

    DataMem dataMem(
        .clk(clk), 
        .DMWr(MEM_MemWrite), 
        .MemOp(MEM_MemOp),
        .MemEXT(MEM_MemEXT),
        .address(MEM_aluResult), 
        .din(MEM_rfOut2), 
        .dout(MEM_dmOut)
    );

    MEM_WB_Reg mem_wb_reg(
        .clk(clk),
        .MEM_aluResult(MEM_aluResult),
        .MEM_dmOut(MEM_dmOut),
        .MEM_RegSrc(MEM_RegSrc),
        .MEM_rt(MEM_rt),
        .MEM_rd(MEM_rd),
        .MEM_RegDst(MEM_RegDst),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_PC(MEM_PC),
        .WB_aluResult(WB_aluResult),
        .WB_dmOut(WB_dmOut),
        .WB_RegSrc(WB_RegSrc),
        .WB_rt(WB_rt),
        .WB_rd(WB_rd),
        .WB_RegDst(WB_RegDst),
        .WB_RegWrite(WB_RegWrite),
        .WB_PC(WB_PC)
    );

    mux4 #(32) selRFWriteData(
        .d0(WB_aluResult), 
        .d1(WB_dmOut), 
        .d2(WB_PC + 32'd4), 
        .d3(32'bz),
        .s(WB_RegSrc),
        .y(WB_rfWriteData));

    mux4 #(5) selWriteReg(
        .d0(WB_rt), 
        .d1(WB_rd), 
        .d2(5'd31), 
        .d3(5'bz),
        .s(WB_RegDst),
        .y(WB_rfWriteAddr));

endmodule // CPU