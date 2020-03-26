//Instruction Register
module InsReg(clk, rst, IRWr, iMemOut, inst);
    input clk;
    input rst;
    input IRWr;
    input[31:0] iMemOut;
    output reg[31:0] inst;
    
    always @(posedge rst)
    begin
        inst = 0;
    end

    always @(*) 
    begin
        if (!rst && IRWr)
            inst = iMemOut;
        //$display("insReg: inst = 0x%8h", inst);//debug
    end
endmodule // InsReg