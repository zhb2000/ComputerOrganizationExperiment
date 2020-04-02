`include "ctrl_encode_def.v"
module CPU(clk, rst);
    input clk;//clock signal
    input rst;//reset signal

    wire[1:0] RegDst;//select the write reg
    wire[1:0] Jump;//jump type, use what to write PC
    wire[1:0] Branch;//branch type, equal or not equal
    wire[1:0] RegSrc;//select RF's write data
    wire[3:0] ALUOp;  
    wire[1:0] MemOp;//operate byte, half word or word in DataMem
    wire MemEXT;//EXTOp in DataMem
    wire MemWrite;//DataMem's write signal
    wire ALUSrcA;//choose ALU's operand1
    wire ALUSrcB;//choose ALU's operand2
    wire RegWrite;//RF's write signal

    wire[31:0] inst;//32bit instruction
    wire[5:0] opcode = inst[31:26];
    wire[5:0] funct = inst[5:0];
    wire[4:0] rs = inst[25:21];
    wire[4:0] rt = inst[20:16];
    wire[4:0] rd = inst[15:11];
    wire[4:0] shamt = inst[10:6];
    wire[15:0] imm16 = inst[15:0];
    wire[25:0] imm26 = inst[25:0];

    wire[31:0] PC;

    wire[31:0] rfReadData1, rfReadData2;
    wire[31:0] rfWriteData;
    wire[4:0] rfAddr3;//write register address

    wire[31:0] shamt32;
    wire[31:0] imm32;
    wire[31:0] operand1, operand2;//ALU's operand
    wire[31:0] aluResult;
    wire Zero;

    wire[31:0] dmReadData;

    wire[31:0] NPC;
    wire[1:0] NPCOp;


    PC pc(.clk(clk),
          .rst(rst),
          .NPC(NPC),
          .PC(PC));

    InsMem insMem(.rst(rst), .address(PC), .dout(inst));

    Control control(.inst(inst),
                    .RegDst(RegDst), 
                    .Jump(Jump), 
                    .Branch(Branch), 
                    .RegSrc(RegSrc), 
                    .ALUOp(ALUOp), 
                    .MemOp(MemOp),
                    .MemEXT(MemEXT),
                    .MemWrite(MemWrite),
                    .ALUSrcA(ALUSrcA), 
                    .ALUSrcB(ALUSrcB), 
                    .RegWrite(RegWrite));

    mux4 #(5) selWriteReg(.d0(rt), .d1(rd), .d2(5'd31), .d3(5'bz),
                          .s(RegDst),
                          .y(rfAddr3));
        
    RF regFile(.clk(clk), 
               .rst(rst),
               .RFWr(RegWrite),
               .A1(rs), .A2(rt), .A3(rfAddr3),
               .WD(rfWriteData),
               .RD1(rfReadData1), .RD2(rfReadData2));
    
    EXT extension(.Imm16(imm16), .EXTOp(`EXT_SIGNED), .Imm32(imm32));
    EXT_5_32 ext_5_32(.shamt(shamt), .EXTOp(`EXT_ZERO), .out32(shamt32));

    mux2 #(32) selOperand1(.d0(rfReadData1), .d1(shamt32),
                           .s(ALUSrcA),
                           .y(operand1));
    mux2 #(32) selOperand2(.d0(rfReadData2), .d1(imm32), 
                           .s(ALUSrcB),
                           .y(operand2));                           
    
    alu mALU(.A(operand1), .B(operand2), 
             .ALUOp(ALUOp),
             .C(aluResult), 
             .Zero(Zero));

    DataMem dataMem(.clk(clk), 
                    .DMWr(MemWrite), 
                    .MemOp(MemOp),
                    .MemEXT(MemEXT),
                    .address(aluResult), 
                    .din(rfReadData2), 
                    .dout(dmReadData));

    mux4 #(32) selRFWriteData(.d0(aluResult), .d1(dmReadData), .d2(PC + 32'd4), .d3(32'bz),
                              .s(RegSrc),
                              .y(rfWriteData));
    
    PCSrc pcsrc(.Jump(Jump), .Branch(Branch), .Zero(Zero), .NPCOp(NPCOp));

    NPC npc(.PC(PC), 
            .NPCOp(NPCOp), 
            .imm26(imm26), 
            .addr32(rfReadData1),
            .NPC(NPC));

endmodule // CPU