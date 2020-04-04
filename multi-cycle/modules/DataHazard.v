//stall the pipeline when data hazard occurs
//working at ID
//correct RF's output data
module DataHazard(
    input[4:0] ID_rs,
    input[4:0] ID_rt,
    input EX_MemRead,
    input[4:0] EX_WriteReg,
    output reg PCWr,
    output reg IFIDWrite,
    output reg IDEXClearCtrl
);

    always @(*) 
    begin
        if (EX_MemRead &&
            (EX_WriteReg == ID_rs || EX_WriteReg == ID_rt))
        begin
            PCWr = 1'd0;
            IFIDWrite = 1'd0;
            IDEXClearCtrl = 1'd1;
        end
    end

endmodule // DataHazard