//~ `New testbench
`timescale 1ns / 1ps

module CMICode_tb;

    // ConvCode Parameters
    parameter PERIOD = 130;


    // ConvCode Inputs
    reg        clk_sig = 0;
    reg        reset_sig = 0;

    // ConvCode Outputs
    wire       clk480k_sig;
    wire [0:0] q_sig;
    wire [1:0] encode_sig;
    wire [0:0] serial_encode_sig;
    wire [1:0] parallel_encode_sig;
    wire [0:0] decode_sig;

    /*iverilog */
    initial begin
        $dumpfile("CMICode.vcd");  //生成的vcd文件名称
        $dumpvars(0, CMICode_tb);  //tb模块名称
    end
    /*iverilog */

    always begin
        #(PERIOD / 2) clk_sig = ~clk_sig;
    end

    initial begin
        #(PERIOD * 2) reset_sig = 1;
    end

    CMICode u_CMICode (
        .clk_sig  (clk_sig),
        .reset_sig(reset_sig),

        .clk480k_sig        (clk480k_sig),
        .q_sig              (q_sig[0:0]),
        .encode_sig         (encode_sig[1:0]),
        .serial_encode_sig  (serial_encode_sig[0:0]),
        .parallel_encode_sig(parallel_encode_sig[1:0]),
        .decode_sig         (decode_sig[0:0])
    );

    // initial begin
    //     #10000 $finish;
    // end

endmodule
