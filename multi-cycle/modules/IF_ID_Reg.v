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
        //rst has higher priority than IFIDWrite, otherwise
        //you can't reset CPU correctly.
        if (rst)
        begin
            ID_PC <= 32'd0;
            ID_inst <= 32'd0;
        end
        //IFIDWrite(data hazard stall) has higher priority 
        //than IFIDFlush(control hazard flush).
        //You should get correct data first, or it won't 
        //jump/branch correctly.
        else if (IFIDWrite)
        begin
            ID_PC <= IFIDFlush ? 32'd0 : IF_PC;
            ID_inst <= IFIDFlush ? 32'd0 : IF_inst;
        end
    end

endmodule // IF_ID_Reg