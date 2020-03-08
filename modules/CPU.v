`include "ctrl_encode_def.v"
module CPU(clk, rst);
    input clk;//clock signal
    input rst;//reset signal

    wire[1:0] RegDst;//select the write reg
    wire[1:0] Jump;//jump type, use what to write PC
    wire Branch;
    wire[1:0] RegSrc;//select RF's write data
    wire[2:0] ALUOp;    
    wire MemWrite;//DataMem's write signal
    wire ALUSrc;//choose ALU's operand
    wire RegWrite;//RF's write signal

    wire[31:0] inst;//32bit instruction
    wire[5:0] opcode;
    wire[5:0] funct;
    wire[4:0] rs, rt, rd;
    wire[15:0] imm16;
    wire[25:0] imm26;
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign imm16 = inst[15:0];
    assign imm26 = inst[25:0];

    wire[31:0] PC;
    wire PCWr;
    assign PCWr = 1;

    wire[31:0] iMemOut;//instruction memory read data
    wire IRWr;//instruction register write signal
    assign IRWr = 1;
      
    wire[31:0] rfReadData1, rfReadData2;
    wire[31:0] rfWriteData;
    wire[4:0] rfAddr3;//write register address

    wire EXTOp;
    assign EXTOp = `EXT_SIGNED;
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
    InsReg insReg(.rst(rst), 
                  .IRWr(IRWr), 
                  .iMemOut(iMemOut), 
                  .inst(inst));    

    Control control(.inst(inst),
                    .RegDst(RegDst), 
                    .Jump(Jump), 
                    .Branch(Branch), 
                    .RegSrc(RegSrc), 
                    .ALUOp(ALUOp), 
                    .MemWrite(MemWrite), 
                    .ALUSrc(ALUSrc), 
                    .RegWrite(RegWrite));

    mux4 #(5) selWriteReg(.d0(rt), .d1(rd), .d2(31), .d3(0),
                          .s(RegDst),
                          .y(rfAddr3));
        
    RF regFile(.clk(clk), 
               .rst(rst),
               .RFWr(RegWrite),
               .A1(rs), .A2(rt), .A3(rfAddr3),
               .WD(rfWriteData),
               .RD1(rfReadData1), .RD2(rfReadData2));
    
    EXT extension(.Imm16(imm16), .EXTOp(EXTOp), .Imm32(imm32));

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
                    .dout(dmReadData));

    mux4 #(32) selRFWriteData(.d0(aluResult), .d1(dmReadData), .d2(PC + 4), .d3(0),
                              .s(RegSrc),
                              .y(rfWriteData));
    
    PCSrc pcsrc(.Jump(Jump), .Branch(Branch), .Zero(Zero), .NPCOp(NPCOp));

    NPC npc(.rst(rst),
            .PC(PC), 
            .NPCOp(NPCOp), 
            .imm26(imm26), 
            .addr32(rfReadData1),
            .NPC(NPC));

endmodule // CPU