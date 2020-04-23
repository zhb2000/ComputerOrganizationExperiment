`include "ctrl_encode_def.v"
//Instrction Memory
module InsMem(rst, address, dout);
    input rst;
    input[31:0] address;//only use 10bit address
    output reg[31:0] dout;//instruction output
    
    //offset from text base address(byte address)
    wire[31:0] baseOffset = address - `TEXT_BASE_ADDRESS;
    //index of the cell(word address, 7 bit)
    wire[6:0] index = baseOffset[8:2];
    //im's dout
    wire[31:0] imOut;

    im innerIM(.index(index), .dout(imOut));

    always @(negedge rst)
        dout = 0;

    always @(*)
        if (rst)
            dout = 0;
        else
            dout = imOut;
    
endmodule // InsMem