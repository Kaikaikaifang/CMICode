// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/04/19
// Design Name: ConvCode
// Module Name: CMI_ENC.v
// Tool versions: VsCode
// Description: CMI 码的编码
// Parameter:
// 1. 
// Input:
// 1. 
// Output:
// 1. 
// ************************************************************
module CMI_ENC (
    input clk_sig,
    input reset_sig,  // 复位信号 低电平有效
    input q_sig,      // 信息信号

    output reg [1:0] encode_sig  // 编码后信号
);
    reg [0:0] flag_sig;

    initial begin
        encode_sig <= 2'b01;
        flag_sig   <= 1'b0;
    end

    always @(posedge clk_sig) begin
        if (!reset_sig) begin
            flag_sig   <= 1'b0;
            encode_sig <= 2'b01;
        end else begin
            if (q_sig) begin
                flag_sig   <= ~flag_sig;
                encode_sig <= {~flag_sig, ~flag_sig};
            end else begin
                encode_sig <= 2'b01;
            end
        end
    end
endmodule
