module IF_ID_Reg(
    input clk,
    input rst,
    input clear,
    input[31:0] IF_PC,
    input[31:0] IF_inst,
    output reg[31:0] ID_PC,
    output reg[31:0] ID_inst
);

always @(posedge clk) 
begin
    ID_PC <= IF_PC;
    ID_inst <= IF_inst;
end

always @(negedge clk)
    if (rst || clear)
    begin
        ID_PC <= 0;
        ID_inst <= 0;
    end

endmodule // IF_ID_Reg