`include "ctrl_encode_def.v"
//Data Memory
module DataMem(
    input clk,//clock signal
    input DMWr,//write signal; 1: write, 0: read only
    input[1:0] MemOp,//byte, half or word
    input MemEXT,//0: zero-extenstion, 1: signed-extension
    input[31:0] address,//read/write address, //only use 10bit address
    input[31:0] din,//write data input
    output reg[31:0] dout//read data output
);

    //offset from data base address(byte address)
    wire[31:0] baseOffset = address - `DATA_BASE_ADDRESS;
    //index of the cell(word address, 7 bit)
    wire[6:0] index = baseOffset[8:2];
    //the word data of dm[index]
    wire[31:0] indexData;
    //the word used to write dm[index]
    reg[31:0] indexWriteData;

    dm innerDM(
        .clk(!clk),
        .DMWr(DMWr),
        .index(index),
        .din(indexWriteData),
        .dout(indexData)
    );
    
    reg[7:0] byteRead;
    reg[15:0] halfRead;
    wire[31:0] out_8_32, out_16_32;
    EXT_8_32 byteExt(.in8(byteRead), .EXTOp(MemEXT), .out32(out_8_32));
    EXT_16_32 halfExt(.in16(halfRead), .EXTOp(MemEXT), .out32(out_16_32));

    //prepare write data
    always @(*)
    begin
        case (MemOp)
            `MEM_BYTE:
            begin
                case (baseOffset[1:0])
                    2'd0: indexWriteData = {indexData[31:8], din[7:0]}; 
                    2'd1: indexWriteData = {indexData[31:16], din[7:0], indexData[7:0]};
                    2'd2: indexWriteData = {indexData[31:24], din[7:0], indexData[15:0]};
                    2'd3: indexWriteData = {din[7:0], indexData[23:0]};
                endcase
            end
            `MEM_HALF:
            begin
                case (baseOffset[1:0])
                    2'd0: indexWriteData = {indexData[31:16], din[15:0]};
                    2'd2: indexWriteData = {din[15:0], indexData[15:0]};
                endcase
            end
            `MEM_WORD: indexWriteData = din;
        endcase
    end

    //print write data
    always @(negedge clk)
    begin
        if (DMWr)
        begin
            case (MemOp)
                `MEM_BYTE:
                begin
                    $display("store byte, m[%d/4=%d] = 0x%8h", baseOffset, index, indexWriteData);
                    $display("inner-address: %d, WD = 0x%2h", baseOffset[1:0], din[7:0]);
                end
                `MEM_HALF:
                begin
                    if (baseOffset[1:0] == 2'd1 || baseOffset[1:0] == 2'd3)
                        $display("store half, wrong boundary!");
                    else
                    begin
                        $display("store half, m[%d/4=%d] = 0x%8h", baseOffset, index, indexWriteData);
                        $display("inner-address: %d, WD = 0x%4h", baseOffset[1:0], din[15:0]); 
                    end
                end
                `MEM_WORD:
                    $display("store word, m[%d/4=%d] = 0x%8h", baseOffset, index, indexWriteData);
            endcase
        end
    end

    //deal with read data
    always @(*) 
    begin
        case (MemOp)
            `MEM_BYTE:
            begin
                case (baseOffset[1:0])
                    2'd0: byteRead = indexData[7:0];
                    2'd1: byteRead = indexData[15:8];
                    2'd2: byteRead = indexData[23:16];
                    2'd3: byteRead = indexData[31:24];
                endcase
                dout = out_8_32;
            end 
            `MEM_HALF:
            begin
                case (baseOffset[1:0])
                    2'd0: halfRead = indexData[15:0];
                    2'd2: halfRead = indexData[31:16];
                    default: if (!DMWr) $display("read half, wrong boundary!");
                endcase
                dout = out_16_32;
            end
            `MEM_WORD: dout = indexData;
        endcase
    end
    
endmodule // DataMem