//Data Memory
module DataMem(clk, DMWr, address, din, dout);
    input clk;//clock signal
    input DMWr;//write signal; 1: write, 0: read
    input[31:0] address;//read/write address, //only use 10bit address
    input[31:0] din;//write data input
    output[31:0] dout;//read data output

    reg [31:0] dataMem [1023:0];//data memory(with 1023 32bit cells)

    always @(posedge clk) 
    begin
        if (DMWr)
            dataMem[address[9:0]] <= din;//only use 10bit address  
    end

    assign dout = dataMem[address[9:0]];//only use 10bit address
endmodule // DataMem