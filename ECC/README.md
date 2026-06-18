# ECC 纠错码测试（Inline ECC & Link ECC）

本目录用于存放 Inline ECC 与 Link ECC 相关的验证用例和脚本。

## 测试范围

### Inline ECC
- 单 bit 错误注入、检测与纠正验证
- 双 bit 错误检测验证
- ECC 错误上报寄存器验证

### Link ECC
- Link 层错误注入验证
- Link ECC 错误检测与上报验证
## 验证功能点 (基于需求列表)

| **测试大类** | **测试项-level1** | **测试项-level2** | **测试项-level3** | **需求基线功能** |
| :--- | :--- | :--- | :--- | :---: |
| ECC功能测试 | Inline ECC功能测试 (LPDDR5) | 硬件注错测试 | ECC 1bit错误读写测试 | 是 |
| | | | ECC 2bit错误读写测试 | 是 |
| | | 软件注错测试 | ECC 1bit错误读写测试 | 是 |
| | | | ECC 2bit错误读写测试 | 是 |
| | | | ECC循环注错遍历测试 | 是 |
| | Link ECC功能测试 (LPDDR5) | 硬件注错测试 | ECC 1bit错误读写测试 | 是 |
| | | | ECC 2bit错误读写测试 | 是 |
| | | 软件注错测试 | ECC 1bit错误读写测试 | 是 |
| | | | ECC 2bit错误读写测试 | 是 |
| | | | ECC循环注错遍历测试 | 是 |

## Link ECC 激励初始化开关

当前 `ECC/link_ecc/vseq` 目录下的 Link ECC 激励建议统一使用如下初始化开关：

- `WECC = 1`
- `RECC = 1`
- `DBI = 0`
- `DM_EN = 0`

说明：

- `RECC` 与 Read DBI 互斥，因此 Link ECC 测试不能沿用默认 `DBI = 1`。
- `DM_EN = 0` 表示关闭 DM 功能；如果底层寄存器使用 `CTL_DMDIS`，需要注意它和 `DM_EN` 是反向语义。
- `dmu_linkecc_rd_dbic_vseq` 和 `dmu_linkecc_rd_dbiu_vseq` 名字中的 `dbi` 指 Link ECC read-side 的 `RDLKECCDBIINJECT` 注错路径，不表示需要打开系统 DBI 功能。
- `dmu_linkecc_wr_maskc_vseq` 和 `dmu_linkecc_wr_masku_vseq` 名字中的 `mask` 指 write Link ECC 的 mask/DMI ECC 注错路径，不表示需要打开 LPDDR5 DM 功能。

| vseq | 测试内容 | WECC | RECC | DBI | DM_EN |
| :--- | :--- | :---: | :---: | :---: | :---: |
| `dmu_linkecc_smoke_vseq.sv` | write Link ECC 冒烟测试 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_vseq.sv` | 基础 Link ECC 测试 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_wrc_vseq.sv` | write correctable data 注错 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_wr_datac_vseq.sv` | write data correctable 注错 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_wr_datau_vseq.sv` | write data uncorrectable 注错 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_wr_maskc_vseq.sv` | write mask/DMI correctable 注错 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_wr_masku_vseq.sv` | write mask/DMI uncorrectable 注错 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_rddatac_vseq.sv` | read data correctable 注错 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_rddatau_vseq.sv` | read data uncorrectable 注错 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_rd_dbic_vseq.sv` | read-side DBI-path correctable 注错 | 1 | 1 | 0 | 0 |
| `dmu_linkecc_rd_dbiu_vseq.sv` | read-side DBI-path uncorrectable 注错 | 1 | 1 | 0 | 0 |
