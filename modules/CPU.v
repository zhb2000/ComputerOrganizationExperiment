module CPU(clk, rst);
    input clk;//clock signal
    input rst;//reset signal

    wire RegDst;
    wire Jump;
    wire Branch;
    wire MemtoReg;
    wire[2:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;

    wire[31:0] inst;//32-bit instruction
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign imm16 = inst[15:0];
    assign imm26 = inst[25:0];

    assign PCWr = 1;
    wire[31:0] PC;

    wire[31:0] iMemOut;
    assign IRWr = 1;//instruction register write signal

    wire[31:0] rfReadData1, rfReadData2;
    wire[31:0] rfWriteData;
    wire[4:0] rfAddr3;//write register address

    wire[31:0] imm32;
    wire[31:0] operand2;//ALU's second operand
    wire[31:0] aluResult;
    wire Zero;

    wire[31:0] dmReadData;

    wire[31:0] NPC;
    wire[1:0] NPCOp;


    PC pc(.clk(clk),
              .rst(rst),
              .PCWr(PCWr),
              .NPC(NPC),
              .PC(PC));
        
    InsMem insMem(.address(PC), .dout(iMemOut));
    InsReg insReg(.clk(clk), 
                  .rst(rst), 
                  .IRWr(1), 
                  .iMemOut(iMemOut), 
                  .inst(inst));    

    Control control(.inst(inst),
                    .RegDst(RegDst), 
                    .Jump(Jump), 
                    .Branch(Branch), 
                    .MemtoReg(MemtoReg), 
                    .ALUOp(ALUOp), 
                    .MemWrite(MemWrite), 
                    .ALUSrc(ALUSrc), 
                    .RegWrite(RegWrite));

    mux2 #(5) selWriteReg(.d0(rt), .d1(rd),
                          .s(RegDst),
                          .y(rfAddr3));
        
    RF regFile(.clk(clk), 
               .rst(rst),
               .RFWr(RegWrite),
               .A1(rs), .A2(rt), .A3(rfAddr3),
               .WD(rfWriteData),
               .RD1(rfReadData1), .RD2(rfReadData2));
    
    EXT extension(.Imm16(imm16), .EXTOp(1), .Imm32(imm32));

    mux2 #(32) selOperand2(.d0(rfReadData2), .d1(imm32), 
                           .s(ALUSrc),
                           .y(operand2));
    
    alu mALU(.A(rfReadData1), .B(operand2), 
              .ALUOp(ALUOp),
              .C(aluResult), 
              .Zero(Zero));

    DataMem dataMem(.clk(clk), 
                    .DMWr(MemWrite), 
                    .address(aluResult), 
                    .din(rfReadData2), 
                    .dout(daReadData));

    mux2 #(32) selRFWriteData(.d0(aluResult), .d1(dmReadData),
                              .s(MemtoReg),
                              .y(rfWriteData));
    
    PCSrc pcsrc(.Jump(Jump), .Branch(Branch), .Zero(Zero), .NPCOp(NPCOp));

    NPC npc(.PC(PC), 
            .NPCOp(NPCOp), 
            .IMM(imm26), 
            .NPC(NPC));

endmodule // CPU