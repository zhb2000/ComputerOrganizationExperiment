`include "ctrl_encode_def.v"
//Data Memory
module DataMem(clk, DMWr, address, din, dout);
    input clk;//clock signal
    input DMWr;//write signal; 1: write, 0: read
    input[31:0] address;//read/write address, //only use 10bit address
    input[31:0] din;//write data input
    output[31:0] dout;//read data output

    reg [31:0] dataMem [1023:0];//data memory(with 1023 32bit cells)

    wire[31:0] baseOffset;//offset from data base address
    assign baseOffset = address - `DATA_BASE_ADDRESS;
    
    wire[9:0] index;//index of the cell
    assign index = baseOffset[11:2];//only use 10bit address

    //TODO
    always @(posedge clk) 
        if (DMWr)
        begin
            dataMem[index] <= din;//only use 10bit address
            $display("m[%d / 4 = %d] = %d,", baseOffset, index, din);
        end
            

    assign dout = dataMem[index];//only use 10bit address
endmodule // DataMem