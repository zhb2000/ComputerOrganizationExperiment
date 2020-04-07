`include "ctrl_encode_def.v"
//Instrction Memory
module InsMem(rst, address, dout);
    input rst;
    input[31:0] address;//only use 10bit address
    output reg[31:0] dout;//instruction output

    reg[31:0] insMem [1023:0];//instruction memory(with 1024 32bit cells)
    
    wire[31:0] baseOffset;//offset from text base address
    assign baseOffset = address - `TEXT_BASE_ADDRESS;
    
    wire[9:0] index;//index of the cell
    assign index = baseOffset[11:2];//only use 10bit address

    always @(negedge rst)
        dout <= 0;

    always @(*)
        if (rst)
            dout = 0;
        else
            dout = insMem[index];
    
endmodule // InsMem