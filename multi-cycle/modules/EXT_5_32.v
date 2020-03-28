`include "ctrl_encode_def.v"
//Extension Module, 5bit shamt -> 32bit operand32
module EXT_5_32(shamt, EXTOp, out32);
     
    input [4:0] shamt;//5bit shamt
    input EXTOp;//0: zero extension; 1: signed-extension
    output [31:0] out32;//32bit operand for ALU
    
    assign out32 = (EXTOp == `EXT_SIGNED) 
                     ? {{27{shamt[4]}}, shamt} //signed-extension
                     : {27'd0, shamt}; //zero extension
         
endmodule