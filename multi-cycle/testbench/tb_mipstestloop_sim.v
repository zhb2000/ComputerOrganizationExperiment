//for "mipstestloop_sim.asm"

//TEXT_BASE_ADDRESS 32'h0000_3000
//DATA_BASE_ADDRESS 32'h0000_0000

//add, sub, and, or, slt, addi, lw, sw, beq, j

`timescale 1ns/1ns
`define INST_NUM 19
module tb_mipstestloop_sim();
    reg clk, rst;
    CPU cpu(.clk(clk), .rst(rst));

    wire[31:0] p1_IF_PC = cpu.IF_PC;
    wire[31:0] p2_ID_PC = cpu.ID_PC;
    wire[31:0] p3_EX_PC = cpu.EX_PC;
    wire[31:0] p4_MEM_PC = cpu.MEM_PC;
    wire[31:0] p5_WB_PC = cpu.WB_PC;

    wire[1:0] d_ID_NPCOp = cpu.ID_NPCOp;
    wire[1:0] d_ID_Branch = cpu.ID_Branch;
    wire[4:0] d_ID_rs = cpu.ID_rs;
    wire[4:0] d_ID_rt = cpu.ID_rt;
    wire[31:0] d_ID_crf1 = cpu.ID_correctRFOut1;
    wire[31:0] d_ID_crf2 = cpu.ID_correctRFOut2;
    wire d_useRegAtID = cpu.bypassingID.useRegAtID;
    wire[31:0] d_MEM_aluResult = cpu.MEM_aluResult;
    wire d_MEM_RegWrite = cpu.MEM_RegWrite;
    wire[4:0] d_MEM_WriteReg = cpu.MEM_WriteReg;
    wire[1:0] d_MEM_RegSrc = cpu.MEM_RegSrc;

    integer _cnt = 0;

    initial
    begin
        //$readmemh("dat_mipstestloop_sim.txt", cpu.insMem.innerIM.ROM);
        $readmemh("C:/Users/zhb/Desktop/ComputerOrgainzationExperiment/dat/dat_mipstestloop_sim.txt", cpu.insMem.innerIM.ROM);
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
            _cnt = _cnt + 1;
        
        if(_cnt == (`INST_NUM+10)*5)
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
            $display("m[80/4] = %d", cpu.dataMem.innerDM.dmem[80/4]);
            $display("m[84/4] = %d", cpu.dataMem.innerDM.dmem[84/4]);
        end
    endtask
endmodule // tb_mipstestloop_sim