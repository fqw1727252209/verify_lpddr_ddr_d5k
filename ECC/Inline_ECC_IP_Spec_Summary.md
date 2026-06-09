# UniVista DDR/LPDDR 控制器 Inline ECC 与数据通路注错规范总结

> 本文档基于 IP 供应商提供的 User Guide 截图提取总结，包含 Inline ECC 的基础概念、配置约束、地址映射、配置流程、错误注入及状态检查机制，以及 UIF 和 DFI 数据通路级别的注错机制。

## 1. Inline ECC 基础概念与特性
- **算法机制**：使用汉明码（Hamming codes）实现 **SECDED**（单比特纠错与双比特检测）。典型比例为用 8-bit ECC 码保护 64-bit 数据。
- **性能优化 (Block 机制)**：每 8 笔连续地址的数据读/写命令共享 1 笔 ECC 读/写命令（8:1），以降低命令开销。每 8 个连续地址被视为一个 Block。

## 2. 核心配置约束与关键行为 (验证重点)
- **Masked Write 突变 RMW**：当开启 Inline ECC 时，产生 **Read-Modify-Write (RMW)** 的条件为：
  1. AXI Burst 的起始或结束地址没有与 64-bit 对齐。
  2. 使用了 Data Strobe (数据掩码，如 DM)，且一个 64-bit ECC 词(Word)内至少有一个 Byte 被 Mask。
- **Credit 限制**：当开启 Inline ECC，且系统有 HPR/LPR 优先级命令产生时，相应的 Credit 寄存器（`csrHprCredit` / `csrLprCredit` / `csrTpwCredit`）必须大于 1。
- **SLVERR 错误响应**：
  - 读事务 (Read)：如果检测到 ECC **Uncorrectable Error (不可纠正错误)**，或者访问了**被锁定的 ECC Code 空间**，将返回 SLVERR 响应。
  - 写事务 (Write)：如果写命令试图访问**被锁定的 ECC Code 空间**，将返回 SLVERR 响应。

## 3. 地址映射规则 (Address Map)
- **ECC 存储区分布**：ECC Code Region 永远被映射到系统地址的**最顶层**。剩余的系统地址可划分为全保护区 (All protected) 或 保护区+非保护区 (Partial protected)。
- 当开启 Inline ECC 时，SRAM/颗粒内部列地址 `col[msb-1]`, `col[msb-2]`, `col[msb-3]` **等于 `3'b111` 时**，代表此列为 ECC Code 存储位置。

## 4. 软件配置流程 (Program Sequence)
要开启并正确使用 Inline ECC，软件（或验证序列）需严格遵循以下流程：
1. 配置 `csrWrEccCredit` 到合适值 (1 ~ WR ECC CAM Depth)。
2. 配置 `csrEccRegionLock` (1 = 锁住，Master不可访问DRAM中的ECC码空间；0 = 可访问)。
3. 配置 `csrEccRegionMapGranu` (控制保护区划分粒度：0=分8份，1=16份，2=32份，3=64份)。
4. 配置 `csrEccRegionMap` (7-bit One-hot，用于指定低 7 个划分区域哪些受 ECC 保护)。
5. 配置 `csrEccRegionMapOther` (指示高于前 7 个区域的剩余空间是否受 ECC 保护)。
6. 最后，配置 **`csrIEccEn` 为 1** 以开启 Inline ECC 功能。

## 5. Inline ECC 硬件注错机制 (Error Injection)
- **写数据注错 (Write Error Injection)**:
  - `csrIEccWrDataErrInjBlkOff`: 指示在当前 Block 内，哪一个 64-bit 数据 (由低到高) 注入错误。
  - `csrIEccWrDataErrInjLoc1` & `Loc2`: 指示在该 64-bit 数据中，哪一比特(单比特)或哪两比特(双比特)需要被翻转。
  - `csrIEccWrDataErrInjAddrL` / `AddrH`: 指示注入错误的 DRAM 地址 `{cs,cid,ba,row,col}`。
  - `csrIEccWrDataErrInjEn`: 注错使能 (`2'b01` 为双比特注错，`2'b11` 为单比特注错)。
- **读数据注错 (Read Error Injection)**:
  具有完全对称的寄存器配置 (`IEccRdDataErrInjBlkOff`, `Loc1`, `Loc2`, `AddrL`, `AddrH`, `En`)，行为逻辑与写注错一致。

## 6. Inline ECC 错误状态检查与清除 (Check & Clear)
当发生 ECC 错误时，需要读取以下状态寄存器以定位错误，并在处理后清除：
- **可纠正错误 (Correctable Error, CErr)**:
  - 读取 `csrRdEccCErr` 判断是否发生，读取 `csrIEccCErrCnt` 获取计数值。
  - 读取 `csrIEccCCs`, `csrIEccCBa`, `csrIEccCCol`, `csrIEccCRow` 获取出错的具体物理位置。
  - 读取 `csrIEccCSyndromDatah/l`, `csrIEccCSyndromCode` 提取伴随式/校验码信息。
  - 读取 `csrIEccCMaskh/l` 获取被纠正后的 64-bit 数据。
  - 处理完毕后，**必须写入 `csrIEccCErrClr`** 来清空计数器和日志。
- **不可纠正错误 (Uncorrectable Error, UcErr)**:
  - 同样有一套对称的寄存器 (`csrRdEccUcErr`, `csrIEccUcErrCnt`, `csrIEccUcCs`, 等等)。
  - 处理完毕后，**必须写入 `csrIEccUcErrClr`** 清空。

## 7. UIF 数据通路注错 (UIF Data Path Error Injection)
*说明：此机制作用于 CHI Port 与 UIF 接口之间。*
- **机制原理**：通过 Mask 掩码指定哪些位需要发生改变，将被 Mask 选中的原始数据位，直接替换为 Data 寄存器中对应的位。
- **相关寄存器**：
  - 使能：`csrUifWrDataErrInjectionEn` / `csrUifRdDataErrInjectionEn`
  - 掩码：`csrUifWrDataErrInjectionMaskN` (N=0..7)
  - 错误数据：`csrUifWrDataErrInjectionDataN` (N=0..7)

## 8. DFI 接口级物理注错 (DFI Data Path Error Injection)
*说明：此机制作用于控制器最底层的 DFI 接口，比 UIF 注错更接近物理颗粒，支持对 Data, ECC, Mask 等所有物理信号进行注错。*
- **机制原理**：通过 `Pattern` 和 `Mask` 寄存器。若 Mask 位为 `1'b1`，则对应 `dfi_wrdata` / `dfi_rddata` 会被替换为 `Pattern` 中对应的比特；若 Mask 位为 `1'b0`，则保持原始值不变。
- **映射关系**（以写为例）：
  - `DAT0 ~ DAT7` 及 `DAT_CRC`：映射到 `csrDfiWrdataErrorInjectPattern/Mask 0~17`。
  - `ECC0 ~ ECC7` 及 `ECC_CRC`：映射到 `csrDfiWrsbeccErrorInjectPattern/Mask 0~4`。
  - `MSK0 ~ MSK7` 及 `MSK_CRC`：映射到 `csrDfiWrMaskErrorInjectPattern/Mask 0~2`。
  - 对应地，读数据也有一套 `csrDfiRddataErrorInject...` 寄存器用于读注错。

**标准 DFI 注错测试序列 (非常重要！)**
为保证在数据传输中注错的稳定性，文档规定了强制的“**挂起-注错-恢复**”六步执行序列：
1. **拦截数据传输 (Block data transaction)**：
   - 写 `csrPortHold` = `0x1`，通知 CHI port 停止接收新事务。
   - 轮询 `csrPortIdle` 直至为 high，然后写 `csrUifHold` = `0x1`。
   - 轮询 `csrMcIdle` 直至为 high（说明所有命令已经排空，DDR 控制器已进入空闲）。
2. **配置注错寄存器 (Config error inject csr)**：配置所有的 Data、SBECC、Mask 的 Pattern 与 Mask 寄存器。
3. **使能注错 (Set error inject enable)**：写 `csrDfiWrErrorInjectHold` = `1'b1`。
4. **恢复数据传输 (Re-enable data transaction)**：
   - 写 `csrUifHold` = `0x0`。
   - 写 `csrPortHold` = `0x0` 重启 CHI 事务。
5. **等待注错完成 (Wait for error inject done)**：轮询读取 `csrDfiWrErrorInjectDone`，直到其值为 `0x1`。
6. **清除注错使能 (Clear error injecting enable csr)**：
   - 写 `csrDfiWrErrorInjectHold` = `1'b0`，此时硬件会自动清空 `csrDfiWrErrorInjectDone` 标志。
