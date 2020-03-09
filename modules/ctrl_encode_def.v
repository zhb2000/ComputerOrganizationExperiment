// NPC control signal(NPCOp)
`define NPC_PLUS4 2'b00
`define NPC_BRANCH 2'b01
`define NPC_JUMP_IMM 2'b10
`define NPC_JUMP_REG 2'b11

// ALU control signal(ALUOp)
`define ALU_NOP 4'd0 
`define ALU_ADD 4'd1
`define ALU_SUB 4'd2 
`define ALU_AND 4'd3
`define ALU_OR 4'd4
`define ALU_SLT 4'd5
`define ALU_SLTU 4'd6
`define ALU_SLL 4'd7
`define ALU_SRL 4'd8
`define ALU_SRA 4'd9
`define ALU_XOR 4'd10
`define ALU_NOR 4'd11

// EXTOp
`define EXT_ZERO 1'b0
`define EXT_SIGNED 1'b1

// instruction opcode
`define OPCODE_ADDI 6'h8 // addi
`define OPCODE_ORI 6'hD // ori
`define OPCODE_LW 6'h23 // lw
`define OPCODE_SW 6'h2B // sw
`define OPCODE_BEQ 6'h4 // beq
`define OPCODE_BNE 6'h5 // bne
`define OPCODE_J 6'h2 // j
`define OPCODE_JAL 6'h3 // jal
`define OPCODE_R_JR_JALR 6'h0 // R-R instruction, jr, jalr
`define OPCODE_SLTI 6'hA // slti
`define OPCODE_ANDI 6'hC // andi
`define OPCODE_LUI 6'hF // lui

//instruction funct
`define FUNCT_ADD 6'h20 // add
`define FUNCT_SUB 6'h22 // sub
`define FUNCT_AND 6'h24 // and
`define FUNCT_OR 6'h25 // or
`define FUNCT_SLT 6'h2A // slt
`define FUNCT_SLTU 6'h2B // sltu
`define FUNCT_ADDU 6'h21 // addu
`define FUNCT_SUBU 6'h23 // subu
//`define FUNCT_NOP 6'h0 // nop TODO
`define FUNCT_JR 6'h9 // jr
`define FUNCT_JALR 6'h8 // jalr
`define FUNCT_SLL 6'h0 // sll
`define FUNCT_SRL 6'h2 // srl
`define FUNCT_SRA 6'h3 // sra
`define FUNCT_SLLV 6'h4 // sllv
`define FUNCT_SRLV 6'h6 // srlv
`define FUNCT_SRAV 6'h7 // srav
`define FUNCT_XOR 6'h26 // xor
`define FUNCT_NOR 6'h27 // nor