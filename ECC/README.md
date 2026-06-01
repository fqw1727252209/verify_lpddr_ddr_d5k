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

## 目录结构建议

```
ECC/
├── tc/      # 测试用例
├── seq/     # 测试序列
├── ref/     # 参考文档
└── README.md
```
