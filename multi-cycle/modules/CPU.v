`include "ctrl_encode_def.v"
module CPU(clk, rst);
    input clk;
    input rst;

    //IF
    wire[31:0] IF_PC;
    wire[31:0] IF_inst;
    wire[31:0] IF_NPC;
    
    //Hazard
    wire PCWr_DataHazard;
    wire IFIDWrite_DataHazard;
    wire IDEXClearCtrl_DataHazard;
    wire IFIDFlush_CtrlHazard;

    //ID
    wire[1:0] ID_Jump;
    wire[1:0] ID_Branch;

    wire ID_RegWrite;
    wire[1:0] ID_RegDst;
    wire[1:0] ID_RegSrc;
    
    wire[3:0] ID_ALUOp;
    wire ID_ALUSrcA;
    wire ID_ALUSrcB;

    wire ID_MemWrite;
    wire ID_MemRead;
    wire[1:0] ID_MemOp;
    wire ID_MemEXT;
    
    wire[31:0] ID_inst;
    wire[4:0] ID_rs = ID_inst[25:21];
    wire[4:0] ID_rt = ID_inst[20:16];
    wire[4:0] ID_rd = ID_inst[15:11];
    wire[4:0] ID_shamt5 = ID_inst[10:6];
    wire[31:0] ID_shamt32;
    wire[15:0] ID_imm16 = ID_inst[15:0];
    wire[31:0] ID_imm32;
    wire[25:0] ID_imm26 = ID_inst[25:0];
    
    wire[31:0] ID_PC;
    wire[31:0] ID_rfOut1;
    wire[31:0] ID_correctRFOut1;
    wire[31:0] ID_rfOut2;
    wire[31:0] ID_correctRFOut2;
    wire[1:0] ID_NPCOp;

    //EX
    wire[31:0] EX_PC;
    wire[4:0] EX_rs;
    wire[4:0] EX_rd;
    wire[4:0] EX_rt;

    wire EX_RegWrite;
    wire[1:0] EX_RegDst;
    wire[1:0] EX_RegSrc;
    wire[4:0] EX_WriteReg;

    wire[3:0] EX_ALUOp;
    wire EX_ALUSrcA;
    wire EX_ALUSrcB;
    wire[31:0] EX_rfOut1;
    wire[31:0] EX_rfOut2;
    wire[31:0] EX_correctRFOut1;
    wire[31:0] EX_correctRFOut2;
    wire[31:0] EX_shamt32;
    wire[31:0] EX_imm32;
    wire[31:0] EX_operand1;
    wire[31:0] EX_operand2;
    wire[31:0] EX_aluResult;
    wire EX_Zero;

    wire[1:0] EX_MemOp;
    wire EX_MemEXT;
    wire EX_MemWrite;
    wire EX_MemRead;

    //MEM
    wire[31:0] MEM_PC;
    wire MEM_RegWrite;
    wire[4:0] MEM_WriteReg;
    wire[1:0] MEM_RegSrc;

    wire MEM_MemWrite;
    wire MEM_MemRead;
    wire[1:0] MEM_MemOp;
    wire MEM_MemEXT;
    wire[31:0] MEM_rfOut2;
    wire[31:0] MEM_aluResult;
    wire[31:0] MEM_dmOut;

    //WB
    wire WB_RegWrite;
    wire[4:0] WB_WriteReg;
    wire[1:0] WB_RegSrc;
    wire[31:0] WB_aluResult;
    wire[31:0] WB_dmOut;
    wire[31:0] WB_PC;
    wire[31:0] WB_rfWriteData;


    PC pc(
        .clk(clk),
        .rst(rst),
        .PCWr(PCWr_DataHazard),
        .NPC(IF_NPC),
        .PC(IF_PC)
    );

    NPC npc(
        .NPCOp(ID_NPCOp),
        .IF_PC(IF_PC), 
        .ID_PC(ID_PC),
        .ID_imm26(ID_imm26),
        .addr32(ID_correctRFOut1),
        .ID_imm16(ID_imm16),
        .NPC(IF_NPC)
    );

    InsMem insMem(
        .rst(rst), 
        .address(IF_PC), 
        .dout(IF_inst)
    );

    IF_ID_Reg if_id_reg(
        .clk(clk),
        .rst(rst),
        .IFIDWrite(IFIDWrite_DataHazard),
        .IFIDFlush(IFIDFlush_CtrlHazard),
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
        .MemRead(ID_MemRead),
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
        .A3(WB_WriteReg),
        .WD(WB_rfWriteData),
        .RD1(ID_rfOut1), 
        .RD2(ID_rfOut2)
    );

    ByPassingID bypassingID(
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_Branch(ID_Branch),
        .ID_Jump(ID_Jump),
        .EX_RegWrite(EX_RegWrite),
        .EX_RegSrc(EX_RegSrc),
        .EX_WriteReg(EX_WriteReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_RegSrc(MEM_RegSrc),
        .MEM_WriteReg(MEM_WriteReg),
        .ID_rfOut1(ID_rfOut1),
        .ID_rfOut2(ID_rfOut2),
        .EX_PC(EX_PC),
        .MEM_PC(MEM_PC),
        .MEM_aluResult(MEM_aluResult),
        .ID_correctRFOut1(ID_correctRFOut1),
        .ID_correctRFOut2(ID_correctRFOut2)
    );

    DataHazard dataHazard(
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_Branch(ID_Branch),
        .ID_Jump(ID_Jump),
        .EX_RegWrite(EX_RegWrite),
        .EX_RegSrc(EX_RegSrc),
        .EX_WriteReg(EX_WriteReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_RegSrc(MEM_RegSrc),
        .MEM_WriteReg(MEM_WriteReg),
        .PCWr(PCWr_DataHazard),
        .IFIDWrite(IFIDWrite_DataHazard),
        .IDEXClearCtrl(IDEXClearCtrl_DataHazard)
    );

    PCSrc pcsrc(
        .ID_Jump(ID_Jump), 
        .ID_Branch(ID_Branch), 
        .ID_Equal(ID_correctRFOut1 == ID_correctRFOut2), 
        .ID_NPCOp(ID_NPCOp)
    );

    CtrlHazard ctrlHazard(
        .ID_NPCOp(ID_NPCOp),
        .IFIDFlush(IFIDFlush_CtrlHazard)
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
        .rst(rst),
        .clearCtrl(IDEXClearCtrl_DataHazard),
        .ID_RegWrite(ID_RegWrite),
        .ID_RegDst(ID_RegDst),
        .ID_RegSrc(ID_RegSrc),
        .ID_ALUOp(ID_ALUOp),
        .ID_ALUSrcA(ID_ALUSrcA),
        .ID_ALUSrcB(ID_ALUSrcB),
        .ID_MemWrite(ID_MemWrite),
        .ID_MemRead(ID_MemRead),
        .ID_MemOp(ID_MemOp),
        .ID_MemEXT(ID_MemEXT),
        .ID_PC(ID_PC),
        .ID_correctRFOut1(ID_correctRFOut1),
        .ID_correctRFOut2(ID_correctRFOut2),
        .ID_rs(ID_rs),
        .ID_rd(ID_rd),
        .ID_rt(ID_rt),
        .ID_imm32(ID_imm32),
        .ID_shamt32(ID_shamt32),
        .EX_RegWrite(EX_RegWrite),
        .EX_RegDst(EX_RegDst),
        .EX_RegSrc(EX_RegSrc),
        .EX_ALUOp(EX_ALUOp),
        .EX_ALUSrcA(EX_ALUSrcA),
        .EX_ALUSrcB(EX_ALUSrcB),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemRead(EX_MemRead),
        .EX_MemOp(EX_MemOp),
        .EX_MemEXT(EX_MemEXT),
        .EX_PC(EX_PC),
        .EX_rfOut1(EX_rfOut1),
        .EX_rfOut2(EX_rfOut2),
        .EX_rs(EX_rs),
        .EX_rd(EX_rd),
        .EX_rt(EX_rt),
        .EX_imm32(EX_imm32),
        .EX_shamt32(EX_shamt32)
    );

    ByPassingEX bypassingEX(
        .EX_rs(EX_rs),
        .EX_rt(EX_rt),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_RegSrc(MEM_RegSrc),
        .MEM_WriteReg(MEM_WriteReg),
        .WB_RegWrite(WB_RegWrite),
        .WB_RegSrc(WB_RegSrc),
        .WB_WriteReg(WB_WriteReg),
        .EX_rfOut1(EX_rfOut1),
        .EX_rfOut2(EX_rfOut2),
        .MEM_aluResult(MEM_aluResult),
        .MEM_PC(MEM_PC),
        .WB_rfWriteData(WB_rfWriteData),
        .EX_correctRFOut1(EX_correctRFOut1),
        .EX_correctRFOut2(EX_correctRFOut2)
    );
    
    mux2 #(32) selOperand1(
        .d0(EX_correctRFOut1), 
        .d1(EX_shamt32),
        .s(EX_ALUSrcA),
        .y(EX_operand1)
    );
    mux2 #(32) selOperand2(
        .d0(EX_correctRFOut2), 
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

    mux4 #(5) selWriteReg(
        .d0(EX_rt), 
        .d1(EX_rd), 
        .d2(5'd31), 
        .d3(5'bz),
        .s(EX_RegDst),
        .y(EX_WriteReg)
    );
    
    EX_MEM_Reg ex_mem_reg(
        .clk(clk),
        .rst(rst),
        .EX_PC(EX_PC),
        .EX_RegWrite(EX_RegWrite),
        .EX_WriteReg(EX_WriteReg),
        .EX_RegSrc(EX_RegSrc),
        .EX_MemWrite(EX_MemWrite),
        .EX_MemRead(EX_MemRead),
        .EX_MemOp(EX_MemOp),
        .EX_MemEXT(EX_MemEXT),
        .EX_correctRFOut2(EX_correctRFOut2),
        .EX_aluResult(EX_aluResult),
        .MEM_PC(MEM_PC),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_WriteReg(MEM_WriteReg),
        .MEM_RegSrc(MEM_RegSrc),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_MemRead(MEM_MemRead),
        .MEM_MemOp(MEM_MemOp),
        .MEM_MemEXT(MEM_MemEXT),
        .MEM_rfOut2(MEM_rfOut2),
        .MEM_aluResult(MEM_aluResult)
    );

    DataMem dataMem(
        .clk(clk), 
        .DMWr(MEM_MemWrite),
        .MemRead(MEM_MemRead),
        .MemOp(MEM_MemOp),
        .MemEXT(MEM_MemEXT),
        .address(MEM_aluResult), 
        .din(MEM_rfOut2), 
        .dout(MEM_dmOut)
    );

    MEM_WB_Reg mem_wb_reg(
        .clk(clk),
        .rst(rst),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_WriteReg(MEM_WriteReg),
        .MEM_RegSrc(MEM_RegSrc),
        .MEM_aluResult(MEM_aluResult),
        .MEM_dmOut(MEM_dmOut),
        .MEM_PC(MEM_PC),
        .WB_RegWrite(WB_RegWrite),
        .WB_WriteReg(WB_WriteReg),
        .WB_RegSrc(WB_RegSrc),
        .WB_aluResult(WB_aluResult),
        .WB_dmOut(WB_dmOut),
        .WB_PC(WB_PC)
    );

    mux4 #(32) selRFWriteData(
        .d0(WB_aluResult), 
        .d1(WB_dmOut), 
        .d2(WB_PC + 32'd4), 
        .d3(32'bz),
        .s(WB_RegSrc),
        .y(WB_rfWriteData)
    );

endmodule // CPU