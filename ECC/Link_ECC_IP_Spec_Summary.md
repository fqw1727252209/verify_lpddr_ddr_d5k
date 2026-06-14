# LPDDR5 Link ECC IP 规范总结

> 本文整理当前 DMU 验证里需要关注的 LPDDR5 Link ECC 协议点、IP CSR 配置
> 流程以及现有 UVM 激励的检查闭环。重点是把 write-side 和 read-side 的
> 检查对象区分清楚，避免把 DRAM 侧错误只拿 controller read status 去判断。

## 1. 功能范围

Link ECC 用于保护 controller 和 LPDDR5 DRAM 之间的物理链路传输。它和
Inline ECC 不是同一类功能：

- Link ECC 检查的是 DRAM bus 上的传输数据。
- Inline ECC 检查的是 controller 侧存储/读回的数据内容。

当前项目假设：

- 内存类型是 LPDDR5。
- 当前拓扑是双通道，每个通道两个 CHI port。
- CHI port 0/1 属于 channel 0，CHI port 2/3 属于 channel 1。
- 当前 LPDDR5 目标配置是 x8 per channel。
- 当前 Link ECC 激励按 DVFSC disabled 场景处理。

## 2. 需要和协议对齐的点

LPDDR5 Link ECC 的 write path 和 read path 含义不一样：

- Write Link ECC 传输 15bit check bits：
  - 9bit write DQ data ECC。
  - 6bit write DMI ECC。
  - 这些 check bits 通过协议/IP 定义的 parity/RDQS_t 相关链路传输。
- Read Link ECC 只传输 9bit read DQ data ECC：
  - read Link ECC check bits 走 DMI。
  - read path 没有和 write path 同等含义的 DMI ECC。
- Read Link ECC 和 Read DBI 互斥。
- Read Link ECC 和 Read Data Copy 互斥。
- Read Link ECC enable 时，Read command 的 CAS(B3) 必须为 0。
- 如果打开 write DBI，write data ECC 应基于 DBI encoding 之后的数据计算。
- Masked Write 场景下，ECC 应匹配 mask 处理后的最终写入数据。

ECC 计算粒度是 16 beats：

- BL16：每个 byte lane 有 1 组 ECC 计算单元。
- BL32：每个 byte lane 有 2 组 ECC 计算单元。
- 当前 x8 per channel 时，每个 channel 只有 1 个 byte lane。
- 如果是 x16 full channel，BL16 有 2 组 ECC，BL32 有 4 组 ECC。

check-bit beat 位置：

- Data ECC C0-C8 位于 BL16 的 beats 7-15。
- BL32 的第二组 Data ECC 位于 beats 23-31。
- DMI ECC C0-C5 位于 write path BL16 的 beats 1-6。
- BL32 的第二组 DMI ECC 位于 beats 17-22。

当前激励暂不覆盖 Data Copy。如果后续加入 Data Copy，需要按协议特殊处理：
DRAM 只驱动 DQ[0] 和 DQ[8]，其它 DQ bit 参与 ECC 计算时按 0 处理。

## 3. Link ECC 使能流程

基础流程如下：

1. 在改变 Link ECC 状态前，先 hold 或停止 traffic。
2. 通过 MRW 配置 DRAM MR22：
   - `MR22 OP[5:4] = 01b`：enable Write Link ECC。
   - `MR22 OP[7:6] = 01b`：enable Read Link ECC。
   - 当前 sequence 写入 `MR22 = 8'h50`。
3. baseline Link ECC 测试中关闭 DBI：
   - `CTL_CTLRDDBIEN = 0`，因为 Read DBI 和 Read Link ECC 互斥。
   - 当前 baseline 也设置 `CTL_CTLWRDBIEN = 0`，先保证场景简单稳定。
4. 打开 controller Link ECC CSR：
   - `CTL_WRLKECCENABLE = 1`。
   - `CTL_RDLKECCENABLE = 1`。
5. 打开 read-side counter 和 interrupt：
   - `CTL_RDLKECCCORRCNTEN = 1`。
   - `CTL_RDLKECCUNCORRCNTEN = 1`。
   - `CTL_RDLKECCCORRINTEN = 1`。
   - `CTL_RDLKECCUNCORRINTEN = 1`。
6. release traffic。

## 4. Write-Side 错误检查

Write Link ECC 的错误由 DRAM model/device 检测，所以闭环检查应读取 DRAM
Mode Register，而不是只看 controller 的 `RDLKECC*` read-side status。

推荐流程：

1. 通过 MR22 和 controller CSR 使能 Link ECC。
2. injected traffic 前先读一次 MR43。读 MR43 会清 DRAM 侧 write Link ECC
   error status/counter。
3. 配置 controller write-side injection CSR：
   - `CTL_WRLKECCDATAINJECT1/2`。
   - `CTL_WRLKECCDATALANEINJECT1/2`。
   - `CTL_WRLKECCDATALOCAINJECT1/2`。
   - `CTL_WRLKECCMASKINJECT1/2`。
   - `CTL_WRLKECCMASKLANEINJECT1/2`。
   - `CTL_WRLKECCMASKLOCAINJECT1/2`。
4. 发送 CHI traffic。
5. traffic 后读取 MR43/MR44/MR45：
   - MR43 OP[5:0]：SBE count。
   - MR43 OP[6]：SBE count rule。
   - MR43 OP[7]：DBE flag。
   - MR44 OP[7:0]：Data ECC syndrome 低 8bit。
   - MR45 OP[7]：Data ECC syndrome bit 8。
   - MR45 OP[6]：error byte lane。
   - MR45 OP[5:0]：DMI ECC syndrome。

期望结果：

- single-bit write injection：MR43 SBE count 非 0，且 MR43 DBE flag 不应置位。
- double-bit write injection：MR43 DBE flag 应置位。
- syndrome 精确定位可以等 lane/location 映射通过 waveform/log 确认后再加。

## 5. Read-Side 错误检查

Read Link ECC 的错误由 controller 检测，所以 read-side injection 先检查
controller status 是合理的：

- `CTL_RDLKECCCORRCNT`。
- `CTL_RDLKECCUNCORRCNT`。
- `CTL_RDLKECCCORRINT`。
- `CTL_RDLKECCUNCORRINT`。

读取后通过以下字段清状态：

- `CTL_RDLKECCCORRCNTCLR`。
- `CTL_RDLKECCUNCORRCNTCLR`。
- `CTL_RDLKECCCORRINTCLR`。
- `CTL_RDLKECCUNCORRINTCLR`。

## 6. 当前激励映射

当前 `apb_lkecc_seq` 的 mode 映射如下：

- `h0`：Link ECC 配置，包括 MR22 和 controller CSR。
- `h1`：write-side single-bit data injection。
- `h2`：write-side double-bit data injection。
- `h3`：read-side DBI-path injection 1。
- `h4`：read-side DBI-path injection 1+2。
- `h5`：read-side data injection 1。
- `h6`：read-side data injection 1+2。
- `h7`：write-side single-bit mask injection。
- `h8`：write-side double-bit mask injection。
- `h9`：write-side single-bit data injection variant。
- `hA`：write-side double-bit data injection variant。
- `hB`：读取 controller read-side Link ECC status。
- `hC`：清 controller read-side Link ECC status。
- `hD`：通过读取 MR43 清 DRAM write-side Link ECC status。
- `hE`：读取 MR43/MR44/MR45，检查 DRAM write-side correctable status。
- `hF`：读取 MR43/MR44/MR45，检查 DRAM write-side uncorrectable status。

write-side 测试推荐顺序：

1. `h0`。
2. `hD`。
3. correctable 场景使用 `h1/h7/h9`，uncorrectable 场景使用 `h2/h8/hA`。
4. CHI traffic。
5. correctable 场景使用 `hE`，uncorrectable 场景使用 `hF`。

read-side 测试保持 controller status 闭环：

1. `h0`。
2. 使用 `h3/h4/h5/h6` 中的 read-side injection mode。
3. CHI read traffic。
4. `hB`。
5. `hC`。
