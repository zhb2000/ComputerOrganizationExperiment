//Instruction Register
module InsReg(clk, rst, IRWr, iMemOut, inst);
    input clk;
    input rst;
    input IRWr;
    input[31:0] iMemOut;
    output reg[31:0] inst;
    
    always @(posedge clk or posedge rst) 
    begin
        if(rst)
            inst <= 0;
        else if (IRWr)
            inst <= iMemOut;
    end
endmodule // InsReg