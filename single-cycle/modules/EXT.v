`include "ctrl_encode_def.v"
//Extension Module, imm16 -> imm32
module EXT( Imm16, EXTOp, Imm32 );
     
    input  [15:0] Imm16;//16bit immediate input
    input         EXTOp;//0: zero extension; 1: signed-extension
    output [31:0] Imm32;//32bit immediate output
    
    assign Imm32 = (EXTOp == `EXT_SIGNED) 
                    ? {{16{Imm16[15]}}, Imm16} //signed-extension
                    : {16'd0, Imm16}; //zero extension
         
endmodule