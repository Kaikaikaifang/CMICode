// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/04/19
// Design Name: ConvCode
// Module Name: CMI_DEC.v
// Tool versions: VsCode
// Description: CMI 码的解编码
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module CMI_DEC (
    input       clk_sig,
    input       reset_sig,  // 复位信号 低电平有效
    input [1:0] encode_sig, // 编码后信号

    output reg decode_sig
);
    initial begin
        decode_sig <= 1'b0;
    end

    always @(posedge clk_sig) begin
        if (!reset_sig) begin
            decode_sig <= 1'b0;
        end else begin
            case (encode_sig)
                2'b00:   decode_sig <= 1'b1;
                2'b01:   decode_sig <= 1'b0;
                2'b10:   decode_sig <= 1'b0;
                2'b11:   decode_sig <= 1'b1;
                default: decode_sig <= 1'b0;
            endcase
        end
    end
endmodule
