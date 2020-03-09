单周期CPU，支持15条指令
| 信号名称 | 作用                |
| -------- | ------------------- |
| opcode   | 操作码              |
| funct    | 功能码(R型指令中用) |
| ALUOp    | ALU操作             |

| 信号名称 | 作用           | 0                 | 1          |
| -------- | -------------- | ----------------- | ---------- |
| MemWrite | 是否写DataMem  | 否                | 是         |
| ALUSrcA  | 选择操作数A    | 寄存器堆ReadData1 | 5位移位量  |
| ALUSrcB  | 选择操作数B    | 寄存器堆ReadData2 | 32位立即数 |
| RegWrite | 是否写寄存器堆 | 否                | 是         |

| 信号名称 | 作用                 | 0       | 1            | 2            |
| -------- | -------------------- | ------- | ------------ | ------------ |
| RegDst   | 选择目的寄存器       | rt      | rd           | 31           |
| RegSrc   | 选择写寄存器的数据源 | ALU结果 | DataMem      | PC+4         |
| Jump     | 跳转指令的种类       | 否      | 用立即数写PC | 用寄存器写PC |
| Branch   | 是否是分支指令       | 否      | beq          | bne          |


PCSrc----选择下一条指令的地址，由Jump、Branch、Zero共同确定

除了sll、srl、sra以外，其余情况ALUSrcA均为0

# R-R运算
| 指令 | opcode/funct | RegDst | Jump | Branch | RegSrc | ALUOp | MemWrite | ALUSrcA/B | RegWrite |
| ---- | ------------ | ------ | ---- | ------ | ------ | ----- | -------- | --------- | -------- |
| add  | 0/20H        | 1      | 0    | 0      | 0      | add   | 0        | 0/0       | 1        |
| sub  | 0/22H        |        |      |        |        | sub   |          |           |          |
| and  | 0/24H        |        |      |        |        | and   |          |           |          |
| or   | 0/25H        |        |      |        |        | or    |          |           |          |
| slt  | 0/2AH        |        |      |        |        | slt   |          |           |          |
| sltu | 0/2BH        |        |      |        |        | sltu  |          |           |          |
| addu | 0/21H        |        |      |        |        | add   |          |           |          |
| subu | 0/23H        |        |      |        |        | sub   |          |           |          |
| sll  | 0/0H         |        |      |        |        | sll   |          | 1/0       |          |
| srl  | 0/2H         |        |      |        |        | srl   |          | 1/0       |          |
| sra  | 0/3H         |        |      |        |        | sra   |          | 1/0       |          |
| sllv | 0/4H         |        |      |        |        | sll   |          | 0/0       |          |
| srlv | 0/6H         |        |      |        |        | srl   |          | 0/0       |          |
| srav | 0/7H         |        |      |        |        | sra   |          | 0/0       |          |
| xor  | 0/26H        |        |      |        |        | xor   |          |           |          |
| nor  | 0/27H        |        |      |        |        | nor   |          |           |          |

# R-I运算
| 指令 | opcode | RegDst | Jump | Branch | RegSrc | ALUOp | MemWrite | ALUSrcB | RegWrite |
| ---- | ------ | ------ | ---- | ------ | ------ | ----- | -------- | ------- | -------- |
| addi | 8H     | 0      | 0    | 0      | 0      | add   | 0        | 1       | 1        |
| ori  | DH     |        |      |        |        | or    |          |         |          |
| slti | AH     |        |      |        |        | slt   |          |         |          |
| andi | CH     |        |      |        |        | and   |          |         |          |
| lui  | FH     |        |      |        |        |       |          |         |          |

# 加载
| 指令 | opcode | RegDst | Jump | Branch | RegSrc | ALUOp | MemWrite | ALUSrcB | RegWrite |
| ---- | ------ | ------ | ---- | ------ | ------ | ----- | -------- | ------- | -------- |
| lw   | 23H    | 0      | 0    | 0      | 1      | add   | 0        | 1       | 1        |
| lb   | 20H    |
| lh   | 21H    |
| lbu  | 24H    |
| lhu  | 25H    |

# 保存
| 指令 | opcode | RegDst | Jump | Branch | RegSrc | ALUOp | MemWrite | ALUSrcB | RegWrite |
| ---- | ------ | ------ | ---- | ------ | ------ | ----- | -------- | ------- | -------- |
| sw   | 2BH    | x      | 0    | 0      | x      | add   | 1        | 1       | 0        |
| sb   | 28H    |
| sh   | 29H    |

# 分支
| 指令 | opcode | RegDst | Jump | Branch | RegSrc | ALUOp | MemWrite | ALUSrcB | RegWrite |
| ---- | ------ | ------ | ---- | ------ | ------ | ----- | -------- | ------- | -------- |
| beq  | 4H     | x      | 0    | 1      | x      | sub   | 0        | 0       | 0        |
| bne  | 5H     |        |      | 2      |        |       |          |         |          |

# 跳转
| 指令 | opcode | RegDst | Jump | Branch | RegSrc | ALUOp | MemWrite | ALUSrcB | RegWrite |
| ---- | ------ | ------ | ---- | ------ | ------ | ----- | -------- | ------- | -------- |
| j    | 2H     | x      | 1    | 0      | x      | x     | 0        | x       | 0        |
| jal  | 3H     | 2      | 1    |        | 2      |       |          |         | 1        |
| jr   | 0/8H   | x      | 2    |        | x      |       |          |         | 0        |
| jalr | 0/9H   | 1      | 2    |        | 2      |       |          |         | 1        |