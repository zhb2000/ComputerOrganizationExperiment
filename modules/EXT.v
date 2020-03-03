//Extension Module
module EXT( Imm16, EXTOp, Imm32 );
    
   input  [15:0] Imm16;//16bit immediate input
   input         EXTOp;//1: signed-extension; 0: zero extension
   output [31:0] Imm32;//32bit immediate output
   
   assign Imm32 = (EXTOp) ? {{16{Imm16[15]}}, Imm16} : {16'd0, Imm16}; // signed-extension or zero extension
       
endmodule