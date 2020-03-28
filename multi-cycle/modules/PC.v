`include "ctrl_encode_def.v"
//PC registesr
module PC(clk, rst, PCWr, NPC, PC);

    input clk;//clock signal
    input rst;//reset signal
    input PCWr;//PC write signal(always 1 in single cycle CPU)
    input[31:0] NPC;//input next pc
    output reg[31:0] PC;//output pc
    
    reg first;

    always @(negedge rst)
        first = 1;

    always @(posedge clk)
    begin
        if (!rst && PCWr)
            if (first)
            begin
                PC = `TEXT_BASE_ADDRESS;
                first = 0;
            end
        else
            PC = NPC;
    end
        

endmodule