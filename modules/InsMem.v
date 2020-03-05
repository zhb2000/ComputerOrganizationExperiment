//Instrction Memory
module InsMem(address, dout);
    input[31:0] address;//only use 10bit address
    output[31:0] dout;//data output

    reg [31:0] insMem [1023:0];//instruction memory(with 1024 32bit cells)

    assign dout = insMem[address[9:0]];//only use 10bit address
    
endmodule // InsMem