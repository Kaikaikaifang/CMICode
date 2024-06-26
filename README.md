# CMICode

# 基于 FPGA 的 CMI 编译码

## Requirement

1. NRZ 码 
2. CMI 编码
	- 0 码: 01; 
	- 1 码: 00/11 交替;
1. CMI 译码（帧同步）
2. Modelsim 仿真
3. 上板验证（EP3C25E144C8）

## 输入

	000, 0101, 1001, 0001

## 仿真

输入

十进制：1425

二进制：

```txt
15'b000010110010001
```

> 1 bit 持续时长大约为 2100 ns, 即 2.1 us，对应信息速率为 476 kbps，考虑到估读误差的存在，可以认为我们产生了信息速率为 480 kbps 的信源。

1. `q_sig` 为信源，图中产生的序列为 `01011001` 对比可知是 15 位学号的一部分；
2. `encode_sig` 为编码输出，`q_sig` `0` 输出 `01`, `1` 交替输出 `00`，`11`，符合编码设计；
3. `serial_encode_sig` 为并串转换后串行编码信号；
4. `decode_sig` 为译码输出信号，对比 `q_sig` 可知，译码输出正确。