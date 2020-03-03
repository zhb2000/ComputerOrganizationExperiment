//Instrction Memory
module InsMem(address, dout);
    input[6:0] address;
    output[31:0] dout;//data output

    reg [31:0] insMem [127:0];//instruction memory(with 128 32bit cells)

    assign dout = insMem[address];
    
endmodule // InsMem