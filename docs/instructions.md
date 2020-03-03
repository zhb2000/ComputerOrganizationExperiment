单周期CPU，支持15条指令
| 信号名称 | 作用                |
| -------- | ------------------- |
| opcode   | 操作码              |
| funct    | 功能码(R型指令中用) |
| ALUOp    | ALU操作             |

| 信号名称 | 作用                 | 0                 | 1          |
| -------- | -------------------- | ----------------- | ---------- |
| RegDst   | 选择目的寄存器       | rt                | rd         |
| Jump     | 是否是跳转指令       | 否                | 是         |
| Branch   | 是否是分支指令       | 否                | 是         |
| MemtoReg | 选择写寄存器的数据源 | ALU结果           | DataMem    |
| MemWrite | 是否写DataMem        | 否                | 是         |
| ALUSrc   | 选择其中一个加数     | 寄存器堆ReadData2 | 32位立即数 |
| RegWrite | 是否写寄存器堆       | 否                | 是         |


PCSrc----选择下一条指令的地址，由Jump、Branch、Zero共同确定

# R-R运算
| 指令 | opcode/funct | RegDst | Jump | Branch | MemtoReg | ALUOp | MemWrite | ALUSrc | RegWrite |
| ---- | ------------ | ------ | ---- | ------ | -------- | ----- | -------- | ------ | -------- |
| add  | 0/20H        | 1      | 0    | 0      | 0        | add   | 0        | 0      | 1        |
| sub  | 0/22H        |        |      |        |          | sub   |          |        |          |
| and  | 0/24H        |        |      |        |          | and   |          |        |          |
| or   | 0/25H        |        |      |        |          | or    |          |        |          |
| slt  | 0/2AH        |        |      |        |          | slt   |          |        |          |
| sltu | 0/2BH        |        |      |        |          | sltu  |          |        |          |
| addu | 0/21H        |        |      |        |          | add   |          |        |          |
| subu | 0/23H        |        |      |        |          | sub   |          |        |          |

# R-I运算
| 指令 | opcode | RegDst | Jump | Branch | MemtoReg | ALUOp | MemWrite | ALUSrc | RegWrite |
| ---- | ------ | ------ | ---- | ------ | -------- | ----- | -------- | ------ | -------- |
| addi | 8H     | 0      | 0    | 0      | 0        | add   | 0        | 1      | 1        |
| ori  | DH     |        |      |        |          | or    |          |        |          |

# 加载
| 指令 | opcode | RegDst | Jump | Branch | MemtoReg | ALUOp | MemWrite | ALUSrc | RegWrite |
| ---- | ------ | ------ | ---- | ------ | -------- | ----- | -------- | ------ | -------- |
| lw   | 23H    | 0      | 0    | 0      | 1        | add   | 0        | 1      | 1        |

# 保存
| 指令 | opcode | RegDst | Jump | Branch | MemtoReg | ALUOp | MemWrite | ALUSrc | RegWrite |
| ---- | ------ | ------ | ---- | ------ | -------- | ----- | -------- | ------ | -------- |
| sw   | 2BH    | x      | 0    | 0      | x        | add   | 1        | 1      | 0        |

# 分支
| 指令 | opcode | RegDst | Jump | Branch | MemtoReg | ALUOp | MemWrite | ALUSrc | RegWrite |
| ---- | ------ | ------ | ---- | ------ | -------- | ----- | -------- | ------ | -------- |
| beq  | 4H     | x      | 0    | 1      | x        | sub   | 0        | 0      | 0        |

# 跳转
| 指令 | opcode | RegDst | Jump | Branch | MemtoReg | ALUOp | MemWrite | ALUSrc | RegWrite |
| ---- | ------ | ------ | ---- | ------ | -------- | ----- | -------- | ------ | -------- |
| j    | 2H     | x      | 1    | 0      | x        | x     | 0        | x      | 0        |
| jal  | 3H     |        |      |        |          |       |          |        |          |