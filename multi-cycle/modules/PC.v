`include "ctrl_encode_def.v"
//PC registesr
module PC(clk, rst, NPC, PC);

    input clk;//clock signal
    input rst;//reset signal
    input[31:0] NPC;//input next pc
    output reg[31:0] PC;//output pc
    
    reg first = 1;

    always @(negedge rst)
        first <= 1;

    always @(posedge clk)
    begin
        if (rst)
            PC <= 32'bz;
        else
        begin
            if (first)
            begin
                PC <= `TEXT_BASE_ADDRESS;
                first <= 0;
            end
            else
                PC <= NPC;
        end
    end
        

endmodule