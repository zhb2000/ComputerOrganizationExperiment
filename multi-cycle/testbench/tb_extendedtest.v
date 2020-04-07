//for "extendedtest.asm"

//TEXT_BASE_ADDRESS 32'h0000_3000
//DATA_BASE_ADDRESS 32'h0000_0000

//lui ori subu addu add sub nor or and slt stlu addi
//sll srl sra sllv srlv srav
//sw sh sb
//lw lh lhu lb lbu

`timescale 1ns/1ns
module tb_extendedtest();
    reg clk, rst;
    CPU cpu(.clk(clk), .rst(rst));

    wire[31:0] p1_IF_PC = cpu.IF_PC;
    wire[31:0] p2_ID_PC = cpu.ID_PC;
    wire[31:0] p3_EX_PC = cpu.EX_PC;
    wire[31:0] p4_MEM_PC = cpu.MEM_PC;
    wire[31:0] p5_WB_PC = cpu.WB_PC;

    //wire[31:0] d_WB_rfWriteData = cpu.WB_rfWriteData;

    wire[31:0] d_ID_crf1 = cpu.ID_correctRFOut1;
    wire[31:0] d_ID_crf2 = cpu.ID_correctRFOut2;
    //wire[1:0] d_MEM_RegSrc = cpu.MEM_RegSrc;

    // wire[31:0] d3_EX_aluResult = cpu.EX_aluResult;
    // wire[31:0] d4_MEM_aluResult = cpu.MEM_aluResult;
    // wire[31:0] d4_WB_aluResult = cpu.WB_aluResult;
    
    // wire[1:0] d2_ID_RegSrc = cpu.ID_RegSrc;
    // wire[1:0] d3_EX_RegSrc = cpu.EX_RegSrc;
    // wire[1:0] d4_MEM_RegSrc = cpu.MEM_RegSrc;
    // wire[1:0] d5_WB_RegSrc = cpu.WB_RegSrc;

    // wire d2_ID_RegWrite = cpu.ID_RegWrite;
    // wire d3_EX_RegWrite = cpu.EX_RegWrite;
    // wire d4_MEM_RegWrite = cpu.MEM_RegWrite;
    // wire d5_WB_RegWrite = cpu.WB_RegWrite;

    //wire[31:0] i1_IF_inst = cpu.IF_inst;
    //wire[31:0] i2_ID_inst = cpu.ID_inst;
    //wire[31:0] i3_EX_inst = cpu.EX_inst;
    //wire[31:0] i4_MEM_inst = cpu.MEM_inst;
    //wire[31:0] i5_WB_inst = cpu.WB_inst;

    //wire d_PCWr = cpu.PCWr_DataHazard;
    //wire d_IFIDWrite = cpu.IFIDWrite_DataHazard;
    //wire d_IFIDFlush = cpu.IFIDFlush_CtrlHazard;
    //wire d_EX_RegWrite = cpu.EX_RegWrite;
    //wire d_MEM_RegWrite = cpu.MEM_RegWrite;

    integer _cnt = 0;

    initial
    begin
        //$readmemh("dat_extendedtest.txt", cpu.insMem.insMem);
        $readmemh("C:/Users/zhb/Desktop/ComputerOrgainzationExperiment/multi-cycle/dat/dat_extendedtest.txt", cpu.insMem.insMem);
        //$monitor("PC = 0x%8h, instruction = 0x%8h", cpu.PC, cpu.inst);
        _cnt = 0;
        clk = 0;
    end

    initial
    begin
        rst = 1;
        #18
        rst = 0;
    end

    always
    begin
        #5 clk = ~clk;
        if (clk)
        begin
            _cnt = _cnt + 1;
        end
        
        if(_cnt == (45+20)*5)
        begin
            printRegFile;
            printDataMem;
            $stop();
        end
    end

    task printRegFile;
        begin
            $display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, cpu.regFile.rf[1], cpu.regFile.rf[2], cpu.regFile.rf[3], cpu.regFile.rf[4], cpu.regFile.rf[5], cpu.regFile.rf[6], cpu.regFile.rf[7]);
            $display("r[08-15]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", cpu.regFile.rf[8], cpu.regFile.rf[9], cpu.regFile.rf[10], cpu.regFile.rf[11], cpu.regFile.rf[12], cpu.regFile.rf[13], cpu.regFile.rf[14], cpu.regFile.rf[15]);
            $display("r[16-23]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", cpu.regFile.rf[16], cpu.regFile.rf[17], cpu.regFile.rf[18], cpu.regFile.rf[19], cpu.regFile.rf[20], cpu.regFile.rf[21], cpu.regFile.rf[22], cpu.regFile.rf[23]);
            $display("r[24-31]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", cpu.regFile.rf[24], cpu.regFile.rf[25], cpu.regFile.rf[26], cpu.regFile.rf[27], cpu.regFile.rf[28], cpu.regFile.rf[29], cpu.regFile.rf[30], cpu.regFile.rf[31]);
        end
    endtask

    task printDataMem;
        begin
            $display("m[0/4] = 0x%8h", cpu.dataMem.dataMem[0/4]);
            $display("m[4/4] = 0x%8h", cpu.dataMem.dataMem[4/4]);
            $display("m[8/4] = 0x%8h", cpu.dataMem.dataMem[8/4]);
            $display("m[0xc/4] = 0x%8h", cpu.dataMem.dataMem[32'hc/4]);
            $display("m[0x10/4] = 0x%8h", cpu.dataMem.dataMem[32'h10/4]);
            $display("m[0x14/4] = 0x%8h", cpu.dataMem.dataMem[32'h14/4]);
            $display("m[0x18/4] = 0x%8h", cpu.dataMem.dataMem[32'h18/4]);
            $display("m[0x1c/4] = 0x%8h", cpu.dataMem.dataMem[32'h1c/4]);
            $display("m[0x20/4] = 0x%8h", cpu.dataMem.dataMem[32'h20/4]);
        end
    endtask
endmodule // tb_extendedtest