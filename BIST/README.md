# BIST 内置自测试

本目录用于存放 BIST（Built-In Self-Test）相关的验证用例和脚本。

## 测试范围

- BIST 引擎启动与配置验证
- BIST 执行流程及完成状态上报验证
- BIST 错误场景覆盖（注入错误、结果比对失败等）

## 目录结构建议

```
BIST/
├── tc/      # 测试用例
├── seq/     # 测试序列
├── ref/     # 参考文档
└── README.md
```
