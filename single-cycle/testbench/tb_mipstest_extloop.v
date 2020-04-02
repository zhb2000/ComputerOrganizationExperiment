//for "mipstest_extloop.asm"

//TEXT_BASE_ADDRESS 32'h0000_3000
//DATA_BASE_ADDRESS 32'h0000_0000

//add sub and or slt addi lw sw beq j

`timescale 1ns/1ns
module tb_mipstest_extloop();
    reg clk, rst;

    CPU cpu(.clk(clk), .rst(rst));
    integer i = 0;
    integer cnt = 0;

    initial
    begin
        //$readmemh("dat_mipstestloopjal_sim.txt", cpu.insMem.insMem);
        $readmemh("C:/Users/zhb/Desktop/ComputerOrgainzationExperiment/single-cycle/dat/dat_mipstest_extloop.txt", cpu.insMem.insMem);

        //$monitor("PC = 0x%8h, instruction = 0x%8h", cpu.PC, cpu.inst);
    end

    initial
        clk = 0;

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
            $display("PC = 0x%8h, instruction = 0x%8h", cpu.PC, cpu.inst);
            //$display("A = 0x%8h, B = 0x%8h", cpu.operand1, cpu.operand2);
            //$display("rfWriteData = %d, RegSrc = %d", cpu.rfWriteData, cpu.RegSrc);
            cnt = cnt + 1;
        end
        
        if(cnt == 40)
        begin
            printregFile;
            $display("m[80/4] = %d", cpu.dataMem.dataMem[80/4]);
            $display("m[84/4] = %d", cpu.dataMem.dataMem[84/4]);
            $stop();
        end
    end

    task printregFile;
        begin
            $display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, cpu.regFile.rf[1], cpu.regFile.rf[2], cpu.regFile.rf[3], cpu.regFile.rf[4], cpu.regFile.rf[5], cpu.regFile.rf[6], cpu.regFile.rf[7]);
            $display("r[08-15]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", cpu.regFile.rf[8], cpu.regFile.rf[9], cpu.regFile.rf[10], cpu.regFile.rf[11], cpu.regFile.rf[12], cpu.regFile.rf[13], cpu.regFile.rf[14], cpu.regFile.rf[15]);
            $display("r[16-23]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", cpu.regFile.rf[16], cpu.regFile.rf[17], cpu.regFile.rf[18], cpu.regFile.rf[19], cpu.regFile.rf[20], cpu.regFile.rf[21], cpu.regFile.rf[22], cpu.regFile.rf[23]);
            $display("r[24-31]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", cpu.regFile.rf[24], cpu.regFile.rf[25], cpu.regFile.rf[26], cpu.regFile.rf[27], cpu.regFile.rf[28], cpu.regFile.rf[29], cpu.regFile.rf[30], cpu.regFile.rf[31]);
        end
    endtask
endmodule // tb_mipstest_extloop