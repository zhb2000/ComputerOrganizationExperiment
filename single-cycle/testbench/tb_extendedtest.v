//for "extendedtest.asm"

//TEXT_BASE_ADDRESS 32'h0000_3000
//DATA_BASE_ADDRESS 32'h0000_0000

//lui ori subu addu add sub nor or and slt stlu addi
//sll srl sra sllv srlv srav
//sw sh sb
//lw lh lhu lb lbu

`timescale 1ns/1ns
`define INST_NUM 45
module tb_extendedtest();
    reg clk, rst;

    CPU cpu(.clk(clk), .rst(rst));
    integer _cnt = 0;

    initial
    begin
        //$readmemh("dat_extendedtest.txt", cpu.insMem.innerIM.ROM);
        $readmemh("C:/Users/zhb/Desktop/ComputerOrgainzationExperiment/dat/dat_extendedtest.txt", cpu.insMem.innerIM.ROM);
        $monitor("PC = 0x%8h, instruction = 0x%8h", cpu.PC, cpu.inst);
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
        
        if(_cnt == `INST_NUM)
        begin
            printRegFile;
            printDataMem;
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
            $display("m[0/4] = 0x%8h", cpu.dataMem.innerDM.dmem[0/4]);
            $display("m[4/4] = 0x%8h", cpu.dataMem.innerDM.dmem[4/4]);
            $display("m[8/4] = 0x%8h", cpu.dataMem.innerDM.dmem[8/4]);
            $display("m[0xc/4] = 0x%8h", cpu.dataMem.innerDM.dmem[32'hc/4]);
            $display("m[0x10/4] = 0x%8h", cpu.dataMem.innerDM.dmem[32'h10/4]);
            $display("m[0x14/4] = 0x%8h", cpu.dataMem.innerDM.dmem[32'h14/4]);
            $display("m[0x18/4] = 0x%8h", cpu.dataMem.innerDM.dmem[32'h18/4]);
            $display("m[0x1c/4] = 0x%8h", cpu.dataMem.innerDM.dmem[32'h1c/4]);
            $display("m[0x20/4] = 0x%8h", cpu.dataMem.innerDM.dmem[32'h20/4]);
            $stop();
        end
    endtask
endmodule // tb_extendedtest