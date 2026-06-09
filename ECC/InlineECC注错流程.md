### 首先，wr与rd的flow如下图所示：

![image-20260508161620176](D:\0_Phytium\2_Verify\Tiger_lpddr5\ECC\assets\image-20260508161620176.png)

![image-20260508161628990](D:\0_Phytium\2_Verify\Tiger_lpddr5\ECC\assets\image-20260508161628990.png)

### 这个flow相关配置的验证代码如下

![image-20260508161657237](D:\0_Phytium\2_Verify\Tiger_lpddr5\ECC\assets\image-20260508161657237.png)

![image-20260508161702811](D:\0_Phytium\2_Verify\Tiger_lpddr5\ECC\assets\image-20260508161702811.png)

![image-20260508161707773](D:\0_Phytium\2_Verify\Tiger_lpddr5\ECC\assets\image-20260508161707773.png)

### 1. Write data Error Injection 配置说明

1. Set `IEccWrDataErrInjBlkOff` to a proper value, indicates which 64-bit data from the lowest to the highest.
2. Set `IEccWrDataErrInjLoc1` to a proper value, indicates which bit in 64-bit data to be reverted.
3. Set `IEccWrDataErrInjLoc2` to a proper value, indicates which bit in 64-bit data to be reverted for double bits error.
4. Set `IEccWrDataErrInjAddrL` to a proper value, indicates which DRAM address to be inject error, `{cs,cid,ba,row,col}`.
5. Set `IEccWrDataErrInjAddrH` to a proper value if DRAM address is over 32bit.
6. Set `IEccWrDataErrInjEn` to `2'b01` for double bits error injection and to `2'b11` for single bit error injection.

### 2. Read data Error Injection 配置说明

1. Set `IEccRdDataErrInjBlkOff` to a proper value, indicates which 64-bit data from the lowest to the highest.
2. Set `IEccRdDataErrInjLoc1` to a proper value, indicates which bit in 64-bit data to be reverted.
3. Set `IEccRdDataErrInjLoc2` to a proper value, indicates which bit in 64-bit data to be reverted for double bits error.
4. Set `IEccRdDataErrInjAddrL` to a proper value, indicates which DRAM address to be inject error, `{cs,cid,ba,row,col}`.
5. Set `IEccRdDataErrInjAddrH` to a proper value if DRAM address is over 32bit.
6. Set `IEccRdDataErrInjEn` to `2'b01` for double bits error injection and to `2'b11` for single bit error injection.

### 3. 验证代码实现

**随机化注错位置和类型：**
```systemverilog
`define IECC_UC_ERR 2'b01
`define IECC_C_ERR  2'b11

if(DataErrInjEn == `IECC_UC_ERR)begin
    std::randomize(DataErrInjLoc1) with {DataErrInjLoc1 < 64;};
    std::randomize(DataErrInjLoc2) with {DataErrInjLoc1 != DataErrInjLoc2; DataErrInjLoc1 < 64; DataErrInjLoc2 < 64;};
end
else if(DataErrInjEn == `IECC_C_ERR)begin
    std::randomize(DataErrInjLoc1) with {DataErrInjLoc1 < 64;};
end
else begin
    assert(0);
end

std::randomize(DataErrInjBlkOff) with {
    if(regcfg.CTL_DQBUSWIDTH == 0){
        DataErrInjBlkOff < [% CTL_DQ_SIZE * 16 / 64 %];
    } else if(regcfg.CTL_DQBUSWIDTH == 1){
        DataErrInjBlkOff < [% CTL_DQ_SIZE * 16 / 64 / 2 %];
    } else if(regcfg.CTL_DQBUSWIDTH == 2){
        DataErrInjBlkOff < [% CTL_DQ_SIZE * 16 / 64 / 4 %];
    }
};
endtask
```

**更新注错地址 (Addr)：**
```systemverilog
virtual task update_inj_err_addr(bit cmd_type);
/*{{{{*/
    DataInjectAddr = {addr_trans.DataInjectCs, addr_trans.DataInjectBa, addr_trans.DataInjectRow, addr_trans.DataInjectCol};
    if(cmd_type == `WR)begin
[% IF CTL_CMD_ADDR_W > 32 %]
        `SET_FIELD_AROUND(csrIEccWrDataErrInjAddrH, DataInjectAddr[$CTL_CMD_ADDR_W:32]);
        `SET_FIELD_AROUND(csrIEccWrDataErrInjAddrL, DataInjectAddr[31:0]);
[% ELSE %]
        `SET_FIELD_AROUND(csrIEccWrDataErrInjAddr , DataInjectAddr);
[% END %]
    end
    else begin
[% IF CTL_CMD_ADDR_W > 32 %]
        `SET_FIELD_AROUND(csrIEccRdDataErrInjAddrH, DataInjectAddr[$CTL_CMD_ADDR_W:32]);
        `SET_FIELD_AROUND(csrIEccRdDataErrInjAddrL, DataInjectAddr[31:0]);
[% ELSE %]
        `SET_FIELD_AROUND(csrIEccRdDataErrInjAddr , DataInjectAddr);
[% END %]
    end
/*}}}}*/
endtask
```

**更新注错信息配置 (Info)：**
```systemverilog
virtual task update_inj_err_info(bit cmd_type);
/*{{{{*/
    if(cmd_type == `WR)begin
        `SET_FIELD_AROUND(csrIEccWrDataErrInjEn,      DataErrInjEn)
        `SET_FIELD_AROUND(csrIEccWrDataErrInjLoc1,    DataErrInjLoc1)
        `SET_FIELD_AROUND(csrIEccWrDataErrInjLoc2,    DataErrInjLoc2)
        `SET_FIELD_AROUND(csrIEccWrDataErrInjBlkOff,  DataErrInjBlkOff)
    end
    else begin
        `SET_FIELD_AROUND(csrIEccRdDataErrInjEn,      DataErrInjEn)
        `SET_FIELD_AROUND(csrIEccRdDataErrInjLoc1,    DataErrInjLoc1)
        `SET_FIELD_AROUND(csrIEccRdDataErrInjLoc2,    DataErrInjLoc2)
        `SET_FIELD_AROUND(csrIEccRdDataErrInjBlkOff,  DataErrInjBlkOff)
    end
/*}}}}*/
endtask
```