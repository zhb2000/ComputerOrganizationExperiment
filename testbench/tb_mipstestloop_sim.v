//for "mipstestloop_sim.asm"
`timescale 1ns/1ns
module tb_mipstestloop_sim();
    reg clk, rst;

    CPU cpu(.clk(clk), .rst(rst));
    integer i = 0;

    initial
    begin
        //$readmemh("dat_mipstestloop_sim.txt", cpu.insMem.insMem);
        $readmemh("C:/Users/zhb/Desktop/ComputerOrgainzationExperiment/dat/dat_mipstestloop_sim.txt", cpu.insMem.insMem);
        
        for(i=0;i<=20;i=i+1)
            $display("im[%d] = 0x%8h", i, cpu.insMem.insMem[i]);
        i = 0;
        
        $monitor("PC = 0x%8h, instruction = 0x%8h", cpu.PC, cpu.inst); 
    end

    initial
        clk = 0;

    initial
    begin
        rst = 0;
        #5
        rst = 1;
        #5
        rst = 0;
    end

    always
        #5 clk = ~clk; 
         

    // always
    // begin
    //     #(20) clk = ~clk; 
    //     i = i + 1;
    //     if(clk)
    //         $display("PC = 0x%8h, instruction = 0x%8h, rst: %1b, clk: %1b", cpu.insMem.address, cpu.inst, rst, clk);
    //     if (i/2==20)
    //         $stop();
    // end
        


endmodule // tb_mipstestloop_sim