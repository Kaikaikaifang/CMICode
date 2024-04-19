// ************************************************************
// Engineer: kaikai
//
// Create Date: 2024/04/19
// Design Name: ConvCode
// Module Name: CMICode.v
// Tool versions: VsCode
// Description: CMI 码的编译码
// Parameter:
// 1. None
// Input:
// 1. clk_sig: 时钟信号 7.68 MHz
// 2. reset_sig: 复位信号
// Output:
// 1. encode_sig: 编码后的信号
// 2. decode_sig: 解码后的信号
// 3. noise_sig: 噪声信号
// 4. encode_noise_sig: 编码后的信号加噪声
// 5. q_sig: ROM 中的数据
// ************************************************************
module CMICode (
    input clk_sig,
    input reset_sig, // 复位信号 低电平有效

    output wire       clk480k_sig,
    output wire [0:0] q_sig,                // 信源信号
    output wire [1:0] encode_sig,           // 编码后信号
    output wire [0:0] serial_encode_sig,    // 编码后串行信号
    output wire [1:0] parallel_encode_sig,  // 编码后并行加噪信号
    output wire [0:0] decode_sig
);
    wire [10:0] address_sig;
    wire [ 0:0] reset_sig_p;
    wire [ 0:0] clk960k_sig;

    assign reset_sig_p = ~reset_sig;

    // 0. 十六分频生成 960 kHz 时钟信号
    div #(
        .NUM (8),
        .DUTY(4)
    ) div_inst_1 (
        .clk_sig(clk_sig),
        .div_sig(clk960k_sig)
    );

    // 0. 二分频生成 480 kHz 时钟信号
    div #(
        .NUM (2),
        .DUTY(1)
    ) div_inst_2 (
        .clk_sig(clk960k_sig),
        .div_sig(clk480k_sig)
    );

    // 1. 生成 ROM 的地址信号
    counter #(
        .NUM(15)
    ) counter_inst (
        .clk_sig    (clk480k_sig),
        .reset_sig  (reset_sig),
        .counter_sig(address_sig)
    );
    // 2. 获取 ROM 中存储的数据
    rom rom_inst (
        .address(address_sig),
        .clock  (clk480k_sig),  // 480 kHz
        .q      (q_sig)         // 480 kbps
    );

    // 3. 信道编码：CMI 码
    CMI_ENC CMI_ENC_inst (
        .clk_sig   (clk480k_sig),
        .reset_sig (reset_sig),
        .q_sig     (q_sig),
        .encode_sig(encode_sig)    // 编码后的信号 2 位 960 kbps
    );

    // 4. 并串转换：将编码后的信号转换为串行信号
    parallel2serial #(
        .WIDTH(2)
    ) parallel2serial_inst (
        .clk_sig     (clk960k_sig),       // 2 * WIDTH * ? kHz = 960 kHz
        .reset_sig   (reset_sig),
        .parallel_sig(encode_sig),        // 编码后并行信号 2 位 960 kbps
        .serial_sig  (serial_encode_sig)  // 串行信号 1 位 960 kbps
    );

    // 5. 串并转换：将串行信号转换为并行信号
    serial2parallel #(
        .WIDTH(2)
    ) serial2parallel_inst (
        .clk_sig     (clk960k_sig),         // 960 kHz
        .reset_sig   (reset_sig),
        .serial_sig  (serial_encode_sig),   // 编码后串行信号 960 kbps
        .parallel_sig(parallel_encode_sig)  // 串并转换后并行信号 2 位 1920 kHz
    );

    // 6. CMI 码解码
    CMI_DEC CMI_DEC_inst (
        .clk_sig   (clk480k_sig),
        .reset_sig (reset_sig),
        .encode_sig(encode_sig),   // 编码后的信号 2 位 960 kbps
        .decode_sig(decode_sig)    // 解码后的信号 1 位 480 kbps
    );
endmodule
