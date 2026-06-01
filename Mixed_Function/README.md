# Mixed_Function 部分功能混合测试

本目录用于存放多功能场景混合执行的验证用例和脚本。

## 测试范围

- **功能交叉场景**：将 AddrMap、MR、BIST、SRAM_Config、ECC、BoundaryCheck 等功能组合，验证并发或顺序场景下的系统行为
- **压力混合测试**：高负载场景下多功能并发，验证系统稳定性
- **端到端回归**：覆盖典型应用场景，用于整体回归验证

## 目录结构建议

```
Mixed_Function/
├── tc/      # 测试用例
├── seq/     # 测试序列
├── ref/     # 参考文档
└── README.md
```
