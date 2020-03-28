# 计算机组成与设计课程实验
单周期、多周期的 MIPS CPU

## 实验任务
### 单周期
- [x] 实现单周期CPU，支持15条指令
- [x] 对单周期CPU进行指令扩展，支持35条指令

### 多周期
- [ ] 实现流水线（没有解决冒险）
- [ ] 解决数据冒险
- [ ] 解决控制冒险

## 实现的指令
实现了以下35条指令
### R-R运算
add, sub, and, or, slt, sltu, addu, subu, sll, srl, sra, sllv, srlv, srav, xor, nor 
### R-I运算
addi, ori, slti, andi, lui 
### 加载
lw, lb, lh, lbu, lhu 
### 保存
sw, sb, sh
### 分支
beq, bne
### 跳转
j, jal, jr, jalr

## 起始地址设置
本实验中，指令和数据分开存放在两个独立的存储器中。然而在 MARS MIPS simulator 中，指令和数据合用一个存储器。为了与 MARS 汇编出的机器指令兼容，使用 `TEXT_BASE_ADDRESS` 和 `DATA_BASE_ADDRESS` 这两个宏设定指令和数据的“起始地址”。

| TEXT_BASE_ADDRESS | DATA_BASE_ADDRESS | 备注                                           |
| ----------------- | ----------------- | ---------------------------------------------- |
| 32'h0000_3000     | 32'h0000_0000     | MARS Configuration: Compact, Data at Address 0 |
| 32'h0000_0000     | 32'h0000_2000     | MARS Configuration: Compact, Text at Address 0 |
| 32'h0000_0000     | 32'h0000_0000     | 指令和数据均从 0 开始编址                      |
