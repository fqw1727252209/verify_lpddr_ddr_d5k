# Link ECC 错误注入机制

## DQ、Burst Length、Lane 和 Location 的关系

### 从协议角度理解

以 x8 DQ 为例：

- 一个 DQ beat 传输 8bit。
- BL16 表示连续 16 个 beat。
- 因此一个 x8 byte lane 在 BL16 内传输的数据量是 `8bit * 16 = 128bit`。

这 128bit 就是 Link ECC 的一个基本 data block。错误注入 CSR 里的
`DataLocaInject[6:0]` 选择的就是这个 128bit data block 内部的 bit 位置：

```text
location = 0   -> 该 128bit block 的 bit0
location = 127 -> 该 128bit block 的 bit127
```

如果是 BL32，可以理解为两个连续的 BL16 ECC 计算块：

| Burst Length | 每个 x8 byte lane 的 ECC 计算粒度 |
|--------------|-----------------------------------|
| BL16 | 1 组 128bit data block |
| BL32 | 2 组 128bit data block |

如果 DQ 宽度是 x16，可以理解为有两个 x8 byte lane 并行工作；每个 byte lane
仍然按 BL16 形成自己的 128bit ECC 计算块。当前项目按 x8 per channel 理解即可。

Link ECC 的 check bits 也和 beat 位置有关：

| 场景 | check bits 位置 |
|------|-----------------|
| BL16 Data ECC C0-C8 | beats 7-15 |
| BL32 第二组 Data ECC C0-C8 | beats 23-31 |
| Write path BL16 DMI ECC C0-C5 | beats 1-6 |
| Write path BL32 第二组 DMI ECC C0-C5 | beats 17-22 |

所以 Burst Length 会影响一个 ECC 计算块覆盖哪些 beat，但软件配置注错时一般
仍然是配置 `lane` 和 `location`，并不直接在注错 CSR 里配置 BL。

### 从 controller 内部 512bit 数据理解

当前设计会把一次 512bit 数据按 byte 重组成 4 个 128bit lane。按 byte 编号理解如下：

```text
512bit data = B0, B1, B2, ... B63

lane_0_data[127:0] = {B60, B56, B52, B48, ..., B12, B8,  B4, B0}
lane_1_data[127:0] = {B61, B57, B53, B49, ..., B13, B9,  B5, B1}
lane_2_data[127:0] = {B62, B58, B54, B50, ..., B14, B10, B6, B2}
lane_3_data[127:0] = {B63, B59, B55, B51, ..., B15, B11, B7, B3}
```

即：

| 字段 | 含义 |
|------|------|
| `LaneInject` | 选择 4 个 128bit lane 中的哪一个 lane，范围 0-3 |
| `DataLocaInject` | 选择该 lane 内部的哪一个 data bit，范围 0-127 |
| `MaskLocaInject` / `DbiLocaInject` | 选择该 lane 内部的 mask/DBI bit，范围 0-15 |

如果要把一个 512bit 数据中的 byte 位置换算成 lane/location，可以按下面理解：

```text
lane         = byte_index % 4
byte_in_lane = byte_index / 4
location     = byte_in_lane * 8 + bit_in_byte
```

示例：

| 目标 bit | Lane | Location |
|----------|------|----------|
| `B0[3]` | 0 | 3 |
| `B5[2]` | 1 | 10 |
| `B20[4]` | 0 | 44 |
| `B63[7]` | 3 | 127 |

## 写路径错误注入

### CSR 寄存器一览

| CSR 字段名 | RTL 内部信号名 | 位宽 | 功能说明 |
|------------|----------------|------|----------|
| `CTL_WRLKECCDATAINJECT1` | `wrlkecc_data_inject_1` | 1bit | 注入点1数据注入使能，1=使能 |
| `CTL_WRLKECCDATAINJECT2` | `wrlkecc_data_inject_2` | 1bit | 注入点2数据注入使能，1=使能 |
| `CTL_WRLKECCMASKINJECT1` | `wrlkecc_mask_inject_1` | 1bit | 注入点1掩码注入使能，1=使能 |
| `CTL_WRLKECCMASKINJECT2` | `wrlkecc_mask_inject_2` | 1bit | 注入点2掩码注入使能，1=使能 |
| `CTL_WRLKECCDATALANEINJECT1` | `csrWrLkeccDataLaneInject1` | 3bit | 注入点1数据 Lane 选择，范围 0-3 |
| `CTL_WRLKECCDATALANEINJECT2` | `csrWrLkeccDataLaneInject2` | 3bit | 注入点2数据 Lane 选择，范围 0-3 |
| `CTL_WRLKECCDATALOCAINJECT1` | `csrWrLkeccDataLocaInject1` | 7bit | 注入点1数据 bit 位置，范围 0-127 |
| `CTL_WRLKECCDATALOCAINJECT2` | `csrWrLkeccDataLocaInject2` | 7bit | 注入点2数据 bit 位置，范围 0-127 |
| `CTL_WRLKECCMASKLANEINJECT1` | `csrWrLkeccMaskLaneInject1` | 3bit | 注入点1掩码 Lane 选择，范围 0-3 |
| `CTL_WRLKECCMASKLANEINJECT2` | `csrWrLkeccMaskLaneInject2` | 3bit | 注入点2掩码 Lane 选择，范围 0-3 |
| `CTL_WRLKECCMASKLOCAINJECT1` | `csrWrLkeccMaskLocaInject1` | 4bit | 注入点1掩码 bit 位置，范围 0-15 |
| `CTL_WRLKECCMASKLOCAINJECT2` | `csrWrLkeccMaskLocaInject2` | 4bit | 注入点2掩码 bit 位置，范围 0-15 |

### 注入目标说明

```text
每个 lane 的写路径对象：

lane_*_data[127:0]      -> 128bit 写数据，可注入错误
lane_*_data_mask[15:0]  -> 16bit 写 mask/DMI，可注入错误
lane_*_ecc[15:0]        -> 已生成的 Link ECC，不直接注入
```

写路径注错的关键点是：数据或 mask 被 XOR 翻转，但对应的 ECC 码不随之重新计算。
因此 DRAM 侧收到的数据和 ECC 不匹配，从而检测到 Link ECC 错误。

### 写路径单 Bit 数据错误示例

场景：向 `lane_1_data[50]` 注入单 bit 错误。

| 配置项 | 配置值 | 说明 |
|--------|--------|------|
| `CTL_WRLKECCDATAINJECT1` | 1 | 使能注入点1数据注入 |
| `CTL_WRLKECCDATALANEINJECT1` | 1 | 选择 lane1 |
| `CTL_WRLKECCDATALOCAINJECT1` | 50 | 选择 bit50 |
| `CTL_WRLKECCDATAINJECT2` | 0 | 不使用注入点2 |
| `CTL_WRLKECCMASKINJECT1` | 0 | 不注入 mask |
| `CTL_WRLKECCMASKINJECT2` | 0 | 不注入 mask |

硬件效果：

```text
wr_lkecc_data_loca_inject_1 = 128'b1 << 50
lane_1_data[50] = raw_lane_1_data[50] ^ 1'b1
lane_1_ecc      = raw_lane_1_ecc
```

### 写路径双 Bit 数据错误示例

场景：向同一个 lane 的两个不同 bit 注入错误，例如 `lane_1_data[20]` 和
`lane_1_data[80]`。

| 配置项 | 配置值 | 说明 |
|--------|--------|------|
| `CTL_WRLKECCDATAINJECT1` | 1 | 使能注入点1 |
| `CTL_WRLKECCDATALANEINJECT1` | 1 | 注入点1选择 lane1 |
| `CTL_WRLKECCDATALOCAINJECT1` | 20 | 注入点1选择 bit20 |
| `CTL_WRLKECCDATAINJECT2` | 1 | 使能注入点2 |
| `CTL_WRLKECCDATALANEINJECT2` | 1 | 注入点2选择 lane1 |
| `CTL_WRLKECCDATALOCAINJECT2` | 80 | 注入点2选择 bit80 |
| `CTL_WRLKECCMASKINJECT1` | 0 | 不注入 mask |
| `CTL_WRLKECCMASKINJECT2` | 0 | 不注入 mask |

一般来说，单 bit 错误用于可纠错误场景，双 bit 错误用于不可纠错误场景。为了稳定
构造不可纠错误，建议优先把两个错误放在同一个 lane 的不同 location。

## 读路径错误注入

### CSR 寄存器一览

| CSR 字段名 | RTL 内部信号名 | 位宽 | 功能说明 |
|------------|----------------|------|----------|
| `CTL_RDLKECCDATAINJECT1` | `rdlkecc_data_inject_1` | 1bit | 注入点1数据注入使能，1=使能 |
| `CTL_RDLKECCDATAINJECT2` | `rdlkecc_data_inject_2` | 1bit | 注入点2数据注入使能，1=使能 |
| `CTL_RDLKECCDBIINJECT1` | `rdlkecc_dbi_inject_1` | 1bit | 注入点1 DBI/ECC 链路位注入使能，1=使能 |
| `CTL_RDLKECCDBIINJECT2` | `rdlkecc_dbi_inject_2` | 1bit | 注入点2 DBI/ECC 链路位注入使能，1=使能 |
| `CTL_RDLKECCDATALANEINJECT1` | `csrRdLkeccDataLaneInject1` | 3bit | 注入点1数据 Lane 选择，范围 0-3 |
| `CTL_RDLKECCDATALANEINJECT2` | `csrRdLkeccDataLaneInject2` | 3bit | 注入点2数据 Lane 选择，范围 0-3 |
| `CTL_RDLKECCDATALOCAINJECT1` | `csrRdLkeccDataLocaInject1` | 7bit | 注入点1数据 bit 位置，范围 0-127 |
| `CTL_RDLKECCDATALOCAINJECT2` | `csrRdLkeccDataLocaInject2` | 7bit | 注入点2数据 bit 位置，范围 0-127 |
| `CTL_RDLKECCDBILANEINJECT1` | `csrRdLkeccDbiLaneInject1` | 3bit | 注入点1 DBI/ECC Lane 选择，范围 0-3 |
| `CTL_RDLKECCDBILANEINJECT2` | `csrRdLkeccDbiLaneInject2` | 3bit | 注入点2 DBI/ECC Lane 选择，范围 0-3 |
| `CTL_RDLKECCDBILOCAINJECT1` | `csrRdLkeccDbiLocaInject1` | 4bit | 注入点1 DBI/ECC bit 位置，范围 0-15 |
| `CTL_RDLKECCDBILOCAINJECT2` | `csrRdLkeccDbiLocaInject2` | 4bit | 注入点2 DBI/ECC bit 位置，范围 0-15 |

### 注入目标说明

```text
每个 lane 的读路径对象：

lane_*_data[127:0]  -> 128bit 读数据，可注入错误
lane_*_dbi[15:0]    -> 16bit DBI/ECC 链路位，可注入错误
```

读路径注错后，controller 侧 read Link ECC checker 会重新计算并比较 ECC，
从而产生 correctable 或 uncorrectable 状态。

### 读路径单 Bit 数据错误示例

场景：向 `lane_2_data[30]` 注入单 bit 错误。

| 配置项 | 配置值 | 说明 |
|--------|--------|------|
| `CTL_RDLKECCDATAINJECT1` | 1 | 使能注入点1数据注入 |
| `CTL_RDLKECCDATALANEINJECT1` | 2 | 选择 lane2 |
| `CTL_RDLKECCDATALOCAINJECT1` | 30 | 选择 bit30 |
| `CTL_RDLKECCDATAINJECT2` | 0 | 不使用注入点2 |
| `CTL_RDLKECCDBIINJECT1` | 0 | 不注入 DBI/ECC 链路位 |
| `CTL_RDLKECCDBIINJECT2` | 0 | 不注入 DBI/ECC 链路位 |

硬件效果：

```text
rd_lkecc_data_loca_inject_1 = 128'b1 << 30
lane_2_data = raw_lane_2_data ^ rd_lkecc_data_loca_inject_1
```

## 状态检查

### Write-side 状态

Write Link ECC 错误由 DRAM 侧检测，通常通过 MR43/MR44/MR45 观察：

| MR | Field | 含义 |
|----|-------|------|
| MR43 | OP[5:0] | SBE count |
| MR43 | OP[6] | SBE count rule |
| MR43 | OP[7] | DBE flag |
| MR44 | OP[7:0] | Data ECC syndrome low bits |
| MR45 | OP[7] | Data ECC syndrome bit8 |
| MR45 | OP[6] | Error byte lane |
| MR45 | OP[5:0] | DMI ECC syndrome |

注意：MR43 在一些模型/实现中可能具有 clear-on-read 行为。如果要同时观察
MR44/MR45 syndrome 和 MR43 status，建议先读 MR44/MR45，再读 MR43。

### Read-side 状态

Read Link ECC 错误由 controller 侧检测，常见状态寄存器包括：

| CSR 字段名 | 含义 |
|------------|------|
| `CTL_RDLKECCCORRCNT` | Read Link ECC correctable counter |
| `CTL_RDLKECCUNCORRCNT` | Read Link ECC uncorrectable counter |
| `CTL_RDLKECCCORRINT` | Read Link ECC correctable interrupt |
| `CTL_RDLKECCUNCORRINT` | Read Link ECC uncorrectable interrupt |
| `CTL_RDLKECCCORRCNTCLR` | Clear correctable counter |
| `CTL_RDLKECCUNCORRCNTCLR` | Clear uncorrectable counter |
| `CTL_RDLKECCCORRINTCLR` | Clear correctable interrupt |
| `CTL_RDLKECCUNCORRINTCLR` | Clear uncorrectable interrupt |
