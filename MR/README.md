# MR 模式寄存器读写测试（MRW / MRR）

本目录用于存放模式寄存器（Mode Register）读写相关的验证用例和脚本。

## 测试范围

- **MRW（Mode Register Write）**：验证模式寄存器写入命令的时序与数据正确性
- **MRR（Mode Register Read）**：验证模式寄存器读取命令返回数据的正确性
- 各模式寄存器字段的合法值与非法值处理

## 目录结构建议

```
MR/
├── tc/      # 测试用例
├── seq/     # 测试序列
├── ref/     # 参考文档
└── README.md
```
验证功能点：

| **测试项** | **测试项-level1** | **测试项-level2**          | **测试项-level3**        | **需求基线功能** | **场景描述**                                                 | **测试方法及配置说明**                                       | **元素(覆盖组or断言覆盖?)** |
| ---------- | ----------------- | -------------------------- | ------------------------ | ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------- |
| MR功能测试 |                   |                            |                          |                  |                                                              |                                                              |                             |
|            | DDR5功能测试      |                            |                          |                  |                                                              |                                                              |                             |
|            |                   | CTL MRW测试                |                          | 否               | 通过配置DDR5中的MR寄存器，先往MR寄存器写入数据，再读出。检测写入与读出数据间的正确性； | 预期结果：在DRAM接口上观察到MR write操作发出，将配置的数据写入对应的模式寄存器。之后继续对该模式寄存器进行read操作，在DRAM接口上观察到MR read操作发出。同时可从csrMrrDat*寄存器读出数据并与写入数据进行比较。MRW操作，测试方法：1. 阻塞数据事务 a. 将csrXmuHold设置为1，以防止DMU接收新的CHI事务。 b. 轮询csrXmuIdle直到为高，然后将csrUifHold设置为1。 c. 轮询csrMcIdle直到为高，表示命令完成清空且DDRCTL处于空闲状态。2. 退出低功耗状态。 a. 将csrPdnEn和csrSrEn设置为0。 b. 读取csrSwSr。如果其值为1，则执行软件自刷新退出流程。并保持csrUifHold和csrXmuHold不清零。 c. 读取csrSwMpsm。如果其值为1，则执行MPSM退出流程。并保持csrUifHold和csrXmuHold不清零。 d. 轮询csrDdrLpState直到其值为0。3. 将csrSwCmdStart设置为1。4. MRW步骤。 a. 轮询csrMrTrig和csrMrBusy直到其值为低。 b. 配置csrMrwDat，csrMrAddr和csrMrRank。将csrMrType设置为0x0，并将csrMrTrig设置为0x1。 c. 轮询csrMrTrig和csrMrBusy直到其值为低，表示MRW成功传输至SDRAM。5. 恢复过程 a. 如有必要，恢复csrPdnEn/csrSrEn。 b. 将csrUifHold和csrXmuHold设置为0。 c. 将csrSwCmdStart设置为0。MRR操作，测试方法：1. 阻塞数据事务。 a. 将csrXmuHold寄存器设置为1，以防止DMU接收新的CHI事务。 b. 轮询csrXmuIdle直到为高，然后将csrUifHold设置为1。 c. 轮询csrMcIdle直到为高电平，表示所有命令已经清空，DDRCTL处于空闲状态。 | 覆盖组                      |
|            |                   | CTL MRR测试                |                          | 否               | 测试场景一：通过MR配置DDR5中的MR寄存器，先往MR寄存器写入数据，再读出。检测写入与读出数据的正确性； 测试场景二：直接读MR寄存器配置默认值。检测读取的数据和协议规定的默认值是否一致。 | 场景一测试结果：在DRAM接口上观察到MR write操作发出，将配置的数据写入对应的模式寄存器。之后继续对该模式寄存器进行read操作，在DRAM接口上观察到MR read操作发出。同时可从csrMrrDat*寄存器读出数据并与写入数据进行比较。 场景二测试结果：从csrMrrDat*寄存器读出数据和协议中规定的MR寄存器默认值一致，数据对比正确。 MRW操作，测试方法：1. 阻塞数据事务 a. 将csrXmuHold设置为1，以防止DMU接收新的CHI事务。 b. 轮询csrXmuIdle直到为高，然后将csrUifHold设置为1。 c. 轮询csrMcIdle直到为高，表示命令完成清空且DDRCTL处于空闲状态。2. 退出低功耗状态。 a. 将csrPdnEn和csrSrEn设置为0。 b. 读取csrSwSr。如果其值为1，则执行软件自刷新退出流程。并保持csrUifHold和csrXmuHold不清零。 c. 读取csrSwMpsm。如果其值为1，则执行MPSM退出流程。并保持csrUifHold和csrXmuHold不清零。 d. 轮询csrDdrLpState直到其值为0。3. 将csrSwCmdStart设置为1。4. MRR步骤。 a. 轮询csrMrTrig和csrMrBusy直到其值为低。 b. 配置csrMrwDat，csrMrAddr和csrMrRank。将csrMrType设置为0x0，并将csrMrTrig设置为0x1。 c. 轮询csrMrTrig和csrMrBusy直到其值为低，表示MRW成功传输至SDRAM。5. 恢复过程 a. 如有必要，恢复csrPdnEn/csrSrEn。 b. 将csrUifHold和csrXmuHold设置为0。 c. 将csrSwCmdStart设置为0。 MRR操作，测试方法：1. 阻塞数据事务。 a. 将csrXmuHold寄存器设置为1，以防止DMU接收新的CHI事务。 | 覆盖组                      |
|            |                   | CTL MPC测试                |                          | 否               | 通过软件MPC命令配置发送MPC命令，检测MPC能正常发出且被模型接受 | 测试结果：通过MPC配置RTT_CK后，使用MRR读取MR32的结果为配置的有效值。 测试方法：1. 按照IP手册通过软件配置控制器寄存器，使其发出MPC序列00110xxxB，配置GroupA RTT_CS，等待MPC完成；2. 按照MRR测试方法将MR32寄存器中的值读出，对比读出的ori[6:3]为配置值。 | 覆盖组                      |
|            |                   | 单个颗粒MR测试             |                          |                  |                                                              |                                                              |                             |
|            |                   |                            | 1N 模式                  | 否               | 通过MPC命令进入PDA模式，在PDA模式下对单个颗粒进行MRW和MRR操作 | 测试方法：1. 发送MPC命令，具体操作见MPC测试，开启PDA模式 2. 对单个颗粒进行MR操作，MR操作流程与MRW和MRR流程一致，检查MR读取的结果是否与写入一致 | 覆盖组                      |
|            |                   |                            | 2N 模式                  | 否               | 测试开启2N模式下，对单个颗粒进行MRW和MRR操作是否正常         | 测试方法：开启2N mode，测试方法与1N模式相同，检查MR读取的结果是否与写入一致 | 覆盖组                      |
|            |                   | 软件控制字写到DDR5 RCD测试 |                          | 否               | 测试场景一：通过MRW操作配置RCD，先写入数据，再读出。检测写入与读出数据的正确性； 测试场景二：直接通过MRR操作读取RCD。检测读取的数据和协议规定的默认值是否一致。 | 预期结果：从csrMrrDat0读到的数据和写入的数据一致。 控制字写入 RCD，测试方法：1. 控制字写入 (CWW) RCD a. 阻塞数据事务。①将csrXmuHold寄存器设置为1，以防止DMU接收新的CHI事务 ②轮询csrXmuIdle直到为高电平，然后将csrUifHold设置为1。 ③轮询csrMcIdle直到为高电平，表示所有命令已经清空，DDRCTL处于空闲状态。 b. 退出低功耗状态。①将csrPdnEn和csrSrEn设置为0 ②读取csrSwSr。如果其值为1，则执行软件自刷新退出流程退出SrSr。同时保持csrUifHold和csrXmuHold不清零。 ③读取csrSwMpsm。如果其值为1，则执行MPSM退出流程，同时保持csrUifHold和csrXmuHold不变。 ④ 轮询csrDdrLpState直到为0。 c. 将csrSwCmdStart设置为1。 d. 执行以下CWW到RCD写序列：①配置csrMrwDat、csrMrAddr（位8设置为1）和csrMrRank。设置csrMrType为0x0且csrMrTrig为0x1。 ②轮询csrMrTrig直到为低电平。轮询csrMrBusy直到为低电平以确认MRW传输到RCD。 ③根据来自Registering Clock Driver Definition (DDR5RCD04) JESD82-514.01的表203-(输入定时要求)等待所需的t周期。 e. 恢复过程 ①如有必要，恢复csrPdnEn/csrSrEn。 ②将csrUifHold和csrXmuHold设置为0。 ③将csrSwCmdStart设置为0。 控制字读取 RCD，测试方法：2. 控制字读取 (CWR) 到 RCD a. 阻塞数据事务。 场景一预期结果：从csrMrrDat0读到的数据和写入的数据一致。 场景二预期结果：从csrMrrDat0读到的数据与协议的默认值一致。 控制字写入 RCD，测试方法：1. 控制字写入 (CWW) RCD a. 阻塞数据事务。①将csrXmuHold寄存器设置为1，以防止DMU接收新的CHI事务 ②轮询csrXmuIdle直到为高电平，然后将csrUifHold设置为1。 ③轮询csrMcIdle直到为高电平，表示所有命令已经清空，DDRCTL处于空闲状态 b. 退出低功耗状态。 | 覆盖组                      |
|            | LPDDR5模式        |                            |                          |                  |                                                              |                                                              |                             |
|            |                   | CTL MRW测试                |                          |                  | 通过MRW配置DDR5中的MR寄存器，先往MR寄存器写入数据，再读出。检测写入与读出数据的正确性； |                                                              | 覆盖组                      |
|            |                   | CTL MRR测试                |                          |                  | 测试场景一：通过MR配置DDR5中的MR寄存器，先往MR寄存器写入数据，再读出。检测写入与读出数据的正确性； 测试场景二：直接读MR寄存器配置默认值。检测读取的数据和协议规定的默认值是否一致。 |                                                              | 覆盖组                      |
|            |                   | MPC测试                    |                          |                  | 通过软件MPC命令配置发送MPC命令，检测MPC能正常发出且被模型接受 |                                                              | 覆盖组                      |
|            |                   | 测试DBI功能                |                          |                  | 测试DBI和DMI以及的操作正常                                   |                                                              | 覆盖组                      |
|            |                   |                            | 打开DM，关闭DBI测试      |                  | 通过MC配置打开DM使能，关闭DBI功能进行测试                   |                                                              | 覆盖组                      |
|            |                   |                            | 打开DBI，关闭DM，读测试  |                  | 通过MC配置打开DBI，读DBI，关闭DM功能测试                    |                                                              | 覆盖组                      |
|            |                   |                            | 打开DBI，打开DM，读测试  |                  | 通过MC配置打开DBI，读DBI，打开DM功能测试                    |                                                              | 覆盖组                      |



## 附录：LPDDR5 DBI/DMI 功能协议分析与验证说明

### 1. DMI 信号基础
在 LPDDR5 中，DM 信号线更名为 **DMI 信号**，它具备三个主要功能：
1. **Data Mask (DM)**：在 mask write 时作为 DM 信号。
2. **Data Bus Inversion (DBI)**：告知颗粒该 byte 数据是否需要按位取反（翻转）。
3. **Link ECC**：用于读写的 link ecc 功能。

### 2. DBI 功能详解
当 DMI 用作 DBI 时，信号用来通知颗粒该 byte 是否需要进行按位取反。
- **当 DMI=0 时**：该笔数据直接写入颗粒。
- **当 DMI=1 时**：写入颗粒的数据需要按位取反。

> **协议特殊规定**：为了降低功耗，颗粒希望看到 DQ 上尽可能少的 1。因此，只有该 byte 的高 6bits（即 DQ[2:7] 或 DQ[10:15]）中 **1 的数量 <= 4** 的时候，才能进行 DBI 功能。

**举例说明**：
假设 `DQ=16'b01010101_00001100`, `DMI=2'b01`，那么真正写入颗粒的信息为：
`DQ=16'b01010101_11110011`

### 3. 多功能使能组合与场景
在实际应用中，DRAM 允许同时使能多于一种功能（例如同时使能 DM 和 DBI），具体含义由相关模式寄存器控制：
- **只使能 DBI (MR3 OP[7]=1)**：在 normal write command 时，DMI 用作 DBI，按 byte 粒度进行翻转。此时 mask write 命令是被禁止的。
- **只使能 DM (MR13 OP[5]=1)**：在 normal write command 时，DMI 必须为 `2'b00`（因为不能选择性写入）；而在 mask write 时，可按 byte 粒度进行 mask。
- **同时使能 DM 和 DBI**：
  - 在 normal write 时，DMI 用作 DBI。
  - 在 mask write 时，行为较为特殊（即 DM & DBI data input）。

**关于 DM & DBI data input 的协议补充说明**：
当同时使能 DM 和 DBI 时，假设 DMI 为 `0` 且 DQ 的高 6bit 中 **1 的数量 >= 5**（代表 1 比较多），颗粒会认为该 byte 是需要被 Mask 掉的，此时 DMI 真正起到了 DM 的作用。
除此之外的场景，DMI 均用作 DBI（即 DMI=0 不翻转，DMI=1 实际写入按位翻转后的数据）。此时数据仅在 bus 上翻转，实际存储在颗粒内的数据是正常的未翻转数据。

### 4. 验证理解与说明（来自内部文档）
相关 CSR 控制位：
- `CTL_CTLWRDBIEN`、`CTL_CTLRDDBIEN`：表示是否使能写/读 DBI 功能。
- `CTL_DMDIS`：表示是否禁用 DM 功能（0: Enable, 1: Disable）。

**验证测试要点：**
1. **配置流程**：在配置好对应的控制器寄存器后，需要手动配置 LPDDR5 的模式寄存器 **MR3（DBI）** 和 **MR13（DM）**。
2. **验证手段**：
   - 通过总线断言（Assertion）观察总线上的数据是否真实发生了翻转。
   - 通过 CHI 写读比对，验证最终读出的数据是否与原始写入的数据一致（证明总线翻转且存储还原正常）。
3. **覆盖率要求**：
   - 必须覆盖 DM 和 DBI **同时使能** 的情况。
   - 必须覆盖 Mask 写操作时的各种 DMI 组合情况：`2'b00`, `2'b01`, `2'b10`, `2'b11`。
