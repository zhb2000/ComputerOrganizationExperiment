`include "ctrl_encode_def.v"
//Extension Module, 8bit -> 32bit
module EXT_8_32(in8, EXTOp, out32 );
     
    input[7:0] in8;
    input EXTOp;//0: zero extension; 1: signed-extension
    output[31:0] out32;
    
    assign out32 = (EXTOp == `EXT_SIGNED) 
                        ? {{24{in8[7]}}, in8} //signed-extension
                        : {24'd0, in8}; //zero extension
         
endmodule