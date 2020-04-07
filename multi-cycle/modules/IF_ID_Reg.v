module IF_ID_Reg(
    input clk,
    input rst,
    input IFIDWrite,
    input IFIDFlush,

    input[31:0] IF_PC,
    input[31:0] IF_inst,

    output reg[31:0] ID_PC,
    output reg[31:0] ID_inst
);

    always @(posedge clk)
    begin
        //flush and rst have higher priority than IFIDWrite
        if (IFIDFlush || rst)
        begin
            ID_PC <= 32'd0;
            ID_inst <= 32'd0;
        end
        else if (IFIDWrite)
        begin
            ID_PC <= IF_PC;
            ID_inst <= IF_inst;
        end
    end

endmodule // IF_ID_Reg