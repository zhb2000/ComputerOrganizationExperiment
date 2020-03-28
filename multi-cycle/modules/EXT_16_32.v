`include "ctrl_encode_def.v"
//Extension Module, 16bit -> 32bbit
module EXT_16_32(in16, EXTOp, out32 );
     
    input[15:0] in16;
    input EXTOp;//0: zero extension; 1: signed-extension
    output[31:0] out32;
    
    assign out32 = (EXTOp == `EXT_SIGNED) 
                        ? {{16{in16[15]}}, in16} //signed-extension
                        : {16'd0, in16}; //zero extension
         
endmodule