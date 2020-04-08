# mipstest_pipelined.asm
# You could use it to test if there is data hazard and control hazard.
# If successful, it should write value 12 to address 80 and 84, and register $7 should be 12

# Configuration: Compact, Data at Address 0
# text base address 0x0000_3000, data base address 0x0000_0000

#       Assembly            Description          Address   Machine
# Test if there is data hazard 
main:   addi $2, $0, 5      # initialize $2 = 5    00      20020005
        ori  $3, $0, 12     # initialize $3 = 12   04      3403000c
        subu $1, $3, $2     # $1 = 12 - 5 = 7      08      00620823
        srl  $7, $1, 1      # $7 = 7 >> 1 = 3      0c      00013842
call_a: j    a              # jump to a            10      08000c15
        or   $4, $7, $2     # $4 = (3 or 5) = 7    14      00e22025
        and  $5, $3, $4     # $5 = (12 and 7) = 4  18      00642824
        add  $5, $5, $4     # $5 = 4 + 7 = 11      1c      00a42820
        beq  $5, $7, end    # should not be taken  20      10a70018
        sltu $4, $3, $4     # $4 = (12 < 7) = 0    24      0064202b
#Test if there is control hazard
        beq  $4, $0, around # should be taken      28      10800003
        addi $5, $0, 0      # should not happen    2c      20050000
        addi $5, $0, 0      # should not happen    30      20050000
        addi $5, $0, 0      # should not happen    34      20050000
around: slt  $4, $7, $2     # $4 = 3 < 5 = 1       38      00e2202a
        addu $7, $4, $5     # $7 = 1 + 11 = 12     3c      00853821
        sub  $7, $7, $2     # $7 = 12 - 5 = 7      40      00e23822
        sw   $7, 68($3)     # [80] = 7             44      ac670044
        lw   $2, 80($0)     # $2 = [80] = 7        48      8c020050
        j    end            # should be taken      4c      08000c21
        addi $2, $0, 1      # should not happen    50      20020001
a:      sll  $7, $7, 2      # $7 = 3 << 2 = 12     54      00073880
call_b: jal  b              # jump to b            58      0c000c19
        addi $31,$0,0x3014  # $31 <= 0x3014        5c      201f3014
        jr   $31            # return to call_a     60      03e00008
b:      lui  $1, 0xFFAA     # $1 <= 0xFFAA0000     64      3c01ffaa
        slt  $1, $7, $1     # $1 <= 0              68      00e1082a
        bne  $1, $0, end    # should not be taken  6c      14200005
        sub  $7, $7, $2     # $7 = 12 - 5 = 7      70      00e23822
        srl  $7, $7, 1      # $7 = 7 >> 1 = 3      74      00073842
        nor  $1, $7, $1     # $1 = 0xFFFFFFFC      78      00e10827
        sltu $1, $1, $7     # $1 <= 0              7c      0027082b
        jr   $31            # return to call_b     80      03e00008
# Test if there is load use hazard
end:    sw   $3, 84($0)     # [84] = 12            84      ac030054
        lw   $7, 72($3)     # $7 = [84] = 12       88      8c670048
        sw   $7, 68($3)     # [80] = 12            8c      ac670044
        lw   $6, 68($3)     # $6 = [80] = 12       88      8c660044
        add  $6, $6, $5     # $6 = 12 + 11 = 23    90      00c53020
loop:   j    loop           # dead loop            94      08000c26


# $0  = 0  # $1  = 0  # $2  = 7   # $3  = c
# $4  = 1  # $5  = b  # $6  = 17h # $7  = c
# $31  = 0x3014

# m[80] = 32'd12  # m[84] = 32'd12