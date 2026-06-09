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
