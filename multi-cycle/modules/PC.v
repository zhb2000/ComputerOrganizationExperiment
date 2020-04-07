`include "ctrl_encode_def.v"
//PC registesr
module PC(
    input clk,//clock signal
    input rst,//reset signal
    input PCWr,//write signal
    input[31:0] NPC,//input next pc
    output reg[31:0] PC//output pc
);
    reg start;

    always @(posedge clk)
    begin
        if (rst)//rst
        begin
            PC <= 32'bz;
            start <= 1'b0;
        end
        else//not rst
        begin
            if (!start)
            begin
                PC <= 32'd0;
                start <= 1'b1;
            end
            else if (PCWr)
                PC <= NPC;
        end
    end

endmodule