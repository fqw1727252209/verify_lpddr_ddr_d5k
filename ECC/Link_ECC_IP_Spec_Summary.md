# UniVista LPDDR5 控制器 Link ECC 规范总结

> 本文档基于 IP 供应商提供的 User Guide 截图提取总结，重点关注 LPDDR5 特有的 Link ECC 功能的初始化配置、注错流程及相关的模式寄存器（Mode Register）交互操作。

## 1. Link ECC 基础概念与特性
- **功能定位**：Link ECC 是 LPDDR5 的可选功能，主要用于保护控制器与 DRAM 颗粒之间的物理链路数据传输。
- **编码格式与纠错能力 (SECDED)**：
  - **DQ 数据**：128-bit 数据对应 9-bit ECC。支持单比特纠错 (SBE) 与双比特检测 (DBE)。计算单元为 16 beats 的 DQ[7:0]。
  - **DMI 数据**：16-bit 数据对应 6-bit ECC。支持单比特纠错 (SBE) 与双比特检测 (DBE)。计算单元为 16 beats 的 DMI。
- **规范标准**：ECC 校验矩阵严格遵循 JEDEC JESD209-5B 规范。

## 2. Link ECC 初始化序列 (Initial Sequence)
在验证环境中，开启 Link ECC 必须严格遵守以下 4 步流程：
1. **拦截数据流**：在必要的系统初始化后，挂起 (Hold) 读写数据流。
2. **配置颗粒 Mode Register (MR22)**：通过发送 MRW (Mode Register Write) 命令配置颗粒侧的使能。
   - `MR22 OP[5:4] (WECC)`：设为 `01b` 以开启 Write link ECC。
   - `MR22 OP[7:6] (RECC)`：设为 `01b` 以开启 Read link ECC。
3. **配置控制器 CSR**：使能 Controller 内部的相关逻辑及中断。
   - `WrLkeccEnable` = 1
   - `RdLkeccEnable` = 1
   - `RdLkeccCorrIntEn` / `RdLkeccUncorrIntEn` = 1 (开启可纠正/不可纠正错误中断)
4. **恢复数据流**：释放挂起 (Release hold)，允许总线开始读写。

## 3. Link ECC 写注错序列 (Write Error Injection)
写注错验证是确认链路错误能否被颗粒正确捕获和报告的核心。执行步骤如下：
1. **初始化并使能**：执行上述的初始化序列，确保 Write link ECC 处于开启状态。
2. **清空颗粒错误状态 (Read MR43)**：
   - 发送 MRR 读取 **MR43**，读取该寄存器会自动清除内部的错误标志 (Error flag) 和错误计数 (Error count)，相当于给颗粒复位状态。
3. **控制器注错配置**：配置控制器的 `Link ECC-related MC CSR` 注入 1-bit 或 2-bit 的写错误。相关注错寄存器包含三组维度 (Lane, Loca, Data/Mask)：
   - `WrLkeccMaskInject1/2`, `WrLkeccDataInject1/2`
   - `WrLkeccMaskLaneInject1/2`, `WrLkeccDataLaneInject1/2`
   - `WrLkeccMaskLocaInject1/2`, `WrLkeccDataLocaInject1/2`
4. **验证注错是否生效 (Check MR43)**：
   - 在数据写入（带错）后，再次发送 MRR 读取 **MR43**。
   - 检查 `MR43 OP[7] (DBE_flag)`：如果注入了双比特错误，此位应为 1。
   - 检查 `MR43 OP[5:0] (SBE_count)`：确认单比特错误计数是否增加了对应的次数。
   - 检查 `MR43 OP[6] (SBEC_Rule)`：根据配置，确认是对每个 Byte 独立计数还是合并计数。
5. **提取并校验伴随式 (Syndrome from MR44 & MR45)**：
   - 发送 MRR 读取 **MR44** 和 **MR45**。
   - **MR44 OP[7:0]**：获取 Data ECC Syndrome 的低 8 位 `S[7:0]`。
   - **MR45 OP[7]**：获取 Data ECC Syndrome 的最高位 `S[8]`。
   - **MR45 OP[6] (Error Byte Lane)**：0=表示错误发生在 DQ[7:0]/DMI0；1=表示错误发生在 DQ[15:8]/DMI1。
   - **MR45 OP[5:0]**：获取 DMI ECC Syndrome `DS[5:0]`。
   - **闭环比对**：将读取到的 Syndrome (伴随式) 代入生成器多项式计算出 Error locator，验证计算出的物理错误位置与步骤 3 中我们注入的 `Loca/Lane` 是否完全一致。

---
> **验证策略提示**：
> 与 Inline ECC 不同，Link ECC 强依赖于与颗粒的 MR (Mode Register) 交互。
> 未来的 VSEQ 需要在下发 Traffic 前插播 `apb_ctrl_mr_seq`（或者在 CHI port 上触发底层的 MRW/MRR），并在 Traffic 结束后再次下发 MRR 去颗粒里捞取校验数据。
