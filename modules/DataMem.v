//Data Memory
module DataMem(clk, DMWr, address, din, dout);
    input clk;//clock signal
    input DMWr;//write signal; 1: write, 0: read
    input[6:0] address;//read/write address
    input[31:0] din;//write data input
    output[31:0] dout;//read data output

    reg [31:0] dataMem [127:0];//data memory(with 128 32bit cells)

    always @(posedge clk) 
    begin
        if (DMWr)
            dataMem[address] <= din;    
    end

    assign dout = dataMem[address];
endmodule // DataMem