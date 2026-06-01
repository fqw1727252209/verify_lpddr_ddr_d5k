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
