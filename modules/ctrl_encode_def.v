// NPC control signal(NPCOp)
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10

// ALU control signal(ALUOp)
`define ALU_NOP   3'b000 
`define ALU_ADD   3'b001
`define ALU_SUB   3'b010 
`define ALU_AND   3'b011
`define ALU_OR    3'b100
`define ALU_SLT   3'b101
`define ALU_SLTU  3'b110

// EXTOp
`define EXT_ZERO 1'b0
`define EXT_SIGNED 1'b1

// instruction opcode
`define OPCODE_ADDI 6'h8 // addi
`define OPCODE_ORI 6'hD // ori
`define OPCODE_LW 6'h23 // lw
`define OPCODE_SW 6'h2B // sw
`define OPCODE_BEQ 6'h4 // beq
`define OPCODE_J 6'h2 // j
`define OPCODE_JAL 6'h3 // jal

`define OPCODE_R 6'h0 // R-R instruction
//instruction funct
`define FUNCT_ADD 6'h20 // add
`define FUNCT_SUB 6'h22 // sub
`define FUNCT_AND 6'h24 // and
`define FUNCT_OR 6'h25 // or
`define FUNCT_SLT 6'h2A // slt
`define FUNCT_SLTU 6'h2B // sltu
`define FUNCT_ADDU 6'h21 // addu
`define FUNCT_SUBU 6'h23 // subu
`define FUNCT_NOP 6'h0 // nop TODO