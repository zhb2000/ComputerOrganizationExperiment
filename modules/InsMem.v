//Instrction Memory
module InsMem(address, dout);
    input[31:0] address;//only use 10bit address
    output[31:0] dout;//instruction output

    reg [31:0] insMem [1023:0];//instruction memory(with 1024 32bit cells)

    assign dout = insMem[address[11:2]];//only use 10bit address

    // always @(address) 
    // begin
    //     $display("insMem: address = 0x%8h, inst = 0x%8h", address, dout);//debug
    // end
    
endmodule // InsMem