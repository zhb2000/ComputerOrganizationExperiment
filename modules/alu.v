`include "ctrl_encode_def.v"
//32 bit Arithmetic Logic Unit
module alu(A, B, ALUOp, C, Zero);
           
   input  signed [31:0] A, B;//operand A, B
   input         [2:0]  ALUOp;//ALU control signal
   output signed [31:0] C;//result C
   output Zero;//whether C is equal to 0
   
   reg [31:0] C;
   integer    i;
       
   always @( * ) begin
      case ( ALUOp )
          `ALU_NOP:  C = A;                          // NOP
          `ALU_ADD:  C = A + B;                      // ADD
          `ALU_SUB:  C = A - B;                      // SUB
          `ALU_AND:  C = A & B;                      // AND/ANDI
          `ALU_OR:   C = A | B;                      // OR/ORI
          `ALU_SLT:  C = (A < B) ? 32'd1 : 32'd0;    // SLT/SLTI
          `ALU_SLTU: C = ({1'b0, A} < {1'b0, B}) ? 32'd1 : 32'd0;
          default:   C = A;                          // Undefined
      endcase
   end // end always
   
   assign Zero = (C == 32'b0);

endmodule