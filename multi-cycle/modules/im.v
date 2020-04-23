//instruction memory
module im(
    input[6:0] index,
    output[31:0] dout
);

    reg[31:0] ROM[127:0];

    assign dout = ROM[index]; // word aligned
endmodule