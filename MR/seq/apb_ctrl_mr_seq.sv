`ifdef SIMU_DMU_APB_FTVIP
class apb_ctrl_mr_seq extends apb_base_uvddr_seq;

  reg[143:0] mprr_data_out[];
  bit [31:0] rdata;
  int csmask0;
  int csmask1;
  bit[63:0] mrdat_data_out;
  bit[15:0] mrdatecc_out;
  int ecc_en;
  int sbecc_en;
  int rsecc_en;
  `uvm_object_utils(apb_ctrl_mr_seq)

  function new(string name = "apb_ctrl_mr_seq");
    super.new(name);
  endfunction

  virtual task body();

    repeat(1000) @(tb.clk_noc);

    if(starting_phase) starting_phase.raise_objection(this);
      `uvm_info(get_full_name(), "start init...", UVM_LOW);
      repeat(5) @(posedge tb.clk_cfg);
      ctl_phy_reg_parser();
      ctl_phy_field_parser();
      `uvm_info(get_full_name(), "end init...", UVM_LOW);
      get_field_by_apb("CTL_SBECCEN",sbecc_en,`DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_RSECCEN",rsecc_en,`DDR_CTL0_BASE_ADDR);
      ecc_en=sbecc_en||rsecc_en;

      `ifdef MEM_ATTACHED_ddr5sdram
        mr_test(`DDR_CTL0_BASE_ADDR);
        `uvm_info(get_full_name(),$sformatf("finish ddr5 ctrl0 MR test"), UVM_LOW);

        mr_test(`DDR_CTL1_BASE_ADDR);
        `uvm_info(get_full_name(),$sformatf("finish ddr5 ctrl1 MR test"), UVM_LOW);

      `else // Assume LPDDR5
        lpddr5_mr_test(`DDR_CTL0_BASE_ADDR);
        `uvm_info(get_full_name(),$sformatf("finish lpddr5 ctrl0 MR test"), UVM_LOW);

        lpddr5_mr_test(`DDR_CTL1_BASE_ADDR);
        `uvm_info(get_full_name(),$sformatf("finish lpddr5 ctrl1 MR test"), UVM_LOW);
      `endif

    if(starting_phase) starting_phase.drop_objection(this);
  endtask

  extern virtual task mr_test(input bit[31:0]base_addr);
  extern virtual task lpddr5_mr_test(input bit[31:0]base_addr);
  //extern virtual task ctrl_cww_test(input bit[8:0]RCD_BIT,input bit[3:0]MR_RANK,input bit[31:0] CWW_DAT,input bit[15:0]base_addr);
  //extern virtual task ctrl_cwr_test(input bit[8:0]RCD_BIT,input bit[3:0]MR_RANK,input bit[31:0]base_addr,input bit[7:0]MR_OP);
  extern virtual task ctrl_mrw_check(input bit[63:0] MRW_DAT,input bit[15:0]MRDATECC,input bit[7:0]MR_OP);
  extern virtual task ctrl_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]base_addr);
  extern virtual task ctrl_multicycle_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]base_addr);

endclass : apb_ctrl_mr_seq

task apb_ctrl_mr_seq::mr_test(input bit[31:0]base_addr);
    get_field_by_apb("CTL_CSMASK",csmask0,base_addr);
    //ctrl0 253/254 mrw/mrr
    `uvm_info(get_full_name(),$sformatf("start ddr5 ctrl MR test"), UVM_LOW);

    mrw_flow(253,1,'h1,base_addr);
    mrw_flow(254,1,'h1,base_addr);
    //rank 0
    mrw_flow(51,1,'h3d,base_addr);
    mrw_flow(52,1,'h2b,base_addr);
    mrr_flow(51,1,mrdat_data_out,base_addr,mrdatecc_out);
    ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3d);
    mrr_flow(52,1,mrdat_data_out,base_addr,mrdatecc_out);
    ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2b);
    //rank 1
    if(csmask0 == 1)begin
      mrw_flow(51,2,'h3c,base_addr);
      mrw_flow(52,2,'h2e,base_addr);
      mrr_flow(51,2,mrdat_data_out,base_addr,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3c);
      mrr_flow(52,2,mrdat_data_out,base_addr,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2e);

    mrw_flow(51,3,'h3c,base_addr);
    mrw_flow(52,3,'h2e,base_addr);
    for(int i=1;i<3;i++)begin
      mrr_flow(51,i,mrdat_data_out,base_addr,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3c);
      mrr_flow(52,i,mrdat_data_out,base_addr,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2e);
    end
    end

    //mrr_flow(51,3,mrdat_data_out,base_addr);

    //rank 2
    if(csmask0 == 3 )begin
      mrw_flow(51,4,'h3d,base_addr);
      mrw_flow(52,4,'h2b,base_addr);
      mrr_flow(51,4,mrdat_data_out,base_addr,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3d);
      mrr_flow(52,4,mrdat_data_out,base_addr,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2b);
      //rank 3
      mrw_flow(51,8,'h3d,base_addr);
      mrw_flow(52,8,'h2b,base_addr);
      mrr_flow(51,8,mrdat_data_out,base_addr,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3d);
      mrr_flow(52,8,mrdat_data_out,base_addr,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2b);

      //all rank
      mrw_flow(51,15,'h3d,base_addr);
      mrw_flow(52,15,'h2b,base_addr);
      for(int i=0;i<4;i++)begin
        mrr_flow(51,1<<i,mrdat_data_out,base_addr,mrdatecc_out);
        ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3d);
        mrr_flow(52,1<<i,mrdat_data_out,base_addr,mrdatecc_out);
        ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2b);
      end
    end
    mrr_flow(48,1,mrdat_data_out,base_addr,mrdatecc_out);
    mrw_flow(48,1,{1'b1,mrdat_data_out[6:0]},base_addr);
    mrr_flow(48,1,mrdat_data_out,base_addr,mrdatecc_out);
    mrw_flow(48,1,{1'b0,mrdat_data_out[6:0]},base_addr);

    //MPC test
    mrr_flow(13,1,mrdat_data_out,base_addr,mrdatecc_out);
    sw_mpc_flow(base_addr,{4'b1000,mrdat_data_out[3:0]},1);

    ctrl_mpc_test(8'b00110101,1,base_addr);
    ctrl_mpc_test(8'b00110001,1,base_addr);
    ctrl_mpc_test(8'b01000101,1,base_addr);
    //ctrl_multicycle_mpc_test(8'b01000101,1,base_addr);
    if(csmask0 == 1 )begin
      ctrl_mpc_test(8'b00110101,3,base_addr);
      ctrl_mpc_test(8'b00110001,3,base_addr);
      ctrl_mpc_test(8'b01000101,3,base_addr);
    end

    if(csmask0 == 3 )begin
      ctrl_mpc_test(8'b00110101,15,base_addr);
      ctrl_mpc_test(8'b00110001,15,base_addr);
      ctrl_mpc_test(8'b01000101,15,base_addr);
      //ctrl_multicycle_mpc_test(8'b01000101,5,`DDR_CTL0_BASE_ADDR);
    end
    //mpc_pda_test
    // `uvm_info(get_full_name(),$sformatf("start ddr5 ctrl PDA test"), UVM_LOW);
    // mrw_flow(1,15,'h5,base_addr);
    // set_field_by_apb("CTL_PDAEN",1,base_addr);
    // `ifdef MEM_DEVICE_X8
    // for(int i=0;i<5;i++)begin
    //   sw_mpc_flow(base_addr,'b01100000+i,{`RANK_NUM{1'b1}});
    // end
    // // sw_mpc_flow(base_addr,'b01100010,1<<(`RANK_NUM-1));
    // // sw_mpc_flow(base_addr,'b01100100,1<<(`RANK_NUM-1));
    // `else
    // for(int i=0;i<10;i++)begin
    //   sw_mpc_flow(base_addr,'b01100000+i,{`RANK_NUM{1'b1}});
    // end
    // `endif
    // // sw_mpc_flow(base_addr,'b01100000,1<<(`RANK_NUM-1));

    // set_field_by_apb("CTL_PDAEN",0,base_addr);

endtask

task apb_ctrl_mr_seq::ctrl_mrw_check(input bit[63:0] MRW_DAT,input bit[15:0]MRDATECC,input bit[7:0]MR_OP);
  if(ecc_en==1&&MRDATECC[7:0]!=MR_OP)
    `uvm_error(get_type_name(),$sformatf("mrr_data_ecc:%0h",MRDATECC[7:0]))
  if(`DRAM_WIDTH==8) begin
    if(MRW_DAT[7:0]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev0:%0h",MRW_DAT[7:0]))
    if(MRW_DAT[15:8]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev1:%0h",MRW_DAT[15:8]))
    if(MRW_DAT[23:16]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev2:%0h",MRW_DAT[23:16]))
    if(MRW_DAT[31:24]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev3:%0h",MRW_DAT[31:24]))
  end else if(`DRAM_WIDTH==16) begin
    if(MRW_DAT[7:0]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev0:%0h",MRW_DAT[7:0]))
    if(MRW_DAT[15:8]!=MR_OP)
      `uvm_error(get_type_name(),$sformatf("mrr_data_dev1:%0h",MRW_DAT[15:8]))
  end
endtask

task apb_ctrl_mr_seq::ctrl_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]base_addr);
  bit[31:0] mrr_data_out;
  sw_mpc_flow(base_addr,MPC_DAT,MPC_RANK);

  if(MPC_DAT[7:4]=='b0010)begin
    sw_mpc_flow(base_addr,'b00011111,MPC_RANK);
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(32,1<<i,mrr_data_out,base_addr,mrdatecc_out);
        if(mrr_data_out[2:0]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("RTT_CK:%0h",mrr_data_out[2:0]))
      end
    end
  end
  if(MPC_DAT[7:4]=='b0011)begin
    sw_mpc_flow(base_addr,'b00011111,MPC_RANK);
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(32,1<<i,mrr_data_out,base_addr,mrdatecc_out);
        if(mrr_data_out[5:3]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("RTT_CS:%0h",mrr_data_out[5:3]))
      end
    end
  end
  if(MPC_DAT[7:4]=='b0100)begin
    sw_mpc_flow(base_addr,'b00011111,MPC_RANK);
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(33,1<<i,mrr_data_out,base_addr,mrdatecc_out);
        if(mrr_data_out[2:0]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("RTT_CA:%0h",mrr_data_out[2:0]))
      end
    end
  end
  if(MPC_DAT[7:3]=='b01010)begin
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(33,1<<i,mrr_data_out,base_addr,mrdatecc_out);
        if(mrr_data_out[5:3]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("DQS_RTT_PARK:%0h",mrr_data_out[5:3]))
      end
    end
  end
  if(MPC_DAT[7:3]=='b01011)begin
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(34,1<<i,mrr_data_out,base_addr,mrdatecc_out);
        if(mrr_data_out[2:0]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("RTT_PARK:%0h",mrr_data_out[2:0]))
      end
    end
  end
endtask

task apb_ctrl_mr_seq::ctrl_multicycle_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]base_addr);
  bit[31:0] mrr_data_out;
  `uvm_info(get_type_name(),$sformatf("BEGIN multicycle rank%h_cwr_data=%0h",MPC_RANK,MPC_DAT),UVM_LOW);
  //Set MR2 to MultiCycle
  mrw_flow(2, MPC_RANK, 'b10000000, `DDR_CTL0_BASE_ADDR);
  mrw_flow(2, MPC_RANK, 'b10000000, `DDR_CTL1_BASE_ADDR);

  //Set Ctrl to MultiCycle
  set_field_by_apb("CTL_DISMULTICS", 0, `DDR_CTL0_BASE_ADDR);
  set_field_by_apb("CTL_DISMULTICS", 0, `DDR_CTL1_BASE_ADDR);

  //Set RCD to Rank 0 CA PASS Through
  // ctrl_cww_test(0,0,5,base_addr);
  $mmreadword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", mrr_data_out);
  mrr_data_out[2]=1;
  $mmwriteword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", $sformatf("0x%h",mrr_data_out));

  //Send MPC CMD to CH0 Rank0
  sw_mpc_flow(`DDR_CTL0_BASE_ADDR, 'b00110101, 1);
  sw_mpc_flow(`DDR_CTL0_BASE_ADDR, 'b00011111, 1);

  //Send MPC CMD to CH1 Rank0
  sw_mpc_flow(`DDR_CTL1_BASE_ADDR, 'b00110101, 1);
  sw_mpc_flow(`DDR_CTL1_BASE_ADDR, 'b00011111, 1);

  //Set RCD to Normal
  // ctrl_cww_test(0,0,1,base_addr);
  $mmreadword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", mrr_data_out);
  mrr_data_out[2]=0;
  $mmwriteword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", $sformatf("0x%h",mrr_data_out));

  //Set MR2 to SingleCycle
  mrw_flow(2, MPC_RANK, 'b10010000, `DDR_CTL0_BASE_ADDR);
  mrw_flow(2, MPC_RANK, 'b10010000, `DDR_CTL1_BASE_ADDR);

  //Set Ctrl to SingleCycle
  set_field_by_apb("CTL_DISMULTICS", 1, `DDR_CTL0_BASE_ADDR);
  set_field_by_apb("CTL_DISMULTICS", 1, `DDR_CTL1_BASE_ADDR);

  if(MPC_DAT[7:4]=='b0010)begin
    sw_mpc_flow(base_addr,'b00011111,MPC_RANK);
    mrr_flow(32,MPC_RANK,mrr_data_out,base_addr,mrdatecc_out);
    if(mrr_data_out[2:0]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("RTT_CK:%0h",mrr_data_out[2:0]))
  end
  if(MPC_DAT[7:4]=='b0011)begin
    sw_mpc_flow(base_addr,'b00011111,MPC_RANK);
    mrr_flow(32,MPC_RANK,mrr_data_out,base_addr,mrdatecc_out);
    if(mrr_data_out[5:3]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("RTT_CS:%0h",mrr_data_out[5:3]))
  end
  if(MPC_DAT[7:4]=='b0100)begin
    sw_mpc_flow(base_addr,'b00011111,MPC_RANK);
    mrr_flow(33,MPC_RANK,mrr_data_out,base_addr,mrdatecc_out);
    if(mrr_data_out[2:0]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("RTT_CA:%0h",mrr_data_out[2:0]))
  end
  if(MPC_DAT[7:3]=='b01010)begin
    mrr_flow(33,MPC_RANK,mrr_data_out,base_addr,mrdatecc_out);
    if(mrr_data_out[5:3]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("DQS_RTT_PARK:%0h",mrr_data_out[5:3]))
  end
  if(MPC_DAT[7:3]=='b01011)begin
    mrr_flow(34,MPC_RANK,mrr_data_out,base_addr,mrdatecc_out);
    if(mrr_data_out[2:0]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("RTT_PARK:%0h",mrr_data_out[2:0]))
  end
endtask

task apb_ctrl_mr_seq::lpddr5_mr_test(input bit[31:0]base_addr);
    bit [63:0] mrdat;
    bit [15:0] mrdatecc;

    `uvm_info(get_full_name(),$sformatf("start lpddr5 ctrl MR test, base_addr=0x%0h", base_addr), UVM_LOW);

    // 阶段一测试：基本 MRW/MRR 闭环检查
    // LPDDR5 协议中的 MR3 是常用的配置寄存器（如 DBI 开启/关闭）
    // 写 0x55 并读回
    `uvm_info(get_full_name(), "LPDDR5 MR3 write/read test 0x55", UVM_LOW);
    mrw_flow(3, 1, 8'h55, base_addr);
    mrr_flow(3, 1, mrdat, base_addr, mrdatecc);
    if(mrdat[7:0] != 8'h55) begin
        `uvm_error(get_full_name(), $sformatf("LPDDR5 MR3 read mismatch! Exp: 0x55, Act: 0x%0h", mrdat[7:0]));
    end

    // 写 0xAA 并读回
    `uvm_info(get_full_name(), "LPDDR5 MR3 write/read test 0xAA", UVM_LOW);
    mrw_flow(3, 1, 8'hAA, base_addr);
    mrr_flow(3, 1, mrdat, base_addr, mrdatecc);
    if(mrdat[7:0] != 8'hAA) begin
        `uvm_error(get_full_name(), $sformatf("LPDDR5 MR3 read mismatch! Exp: 0xAA, Act: 0x%0h", mrdat[7:0]));
    end

    // 写回 0x00（恢复默认状态）
    mrw_flow(3, 1, 8'h00, base_addr);

    // 增加对 MR13 (DM 相关的寄存器) 的基础读写测试
    `uvm_info(get_full_name(), "LPDDR5 MR13 write/read test 0x33", UVM_LOW);
    mrw_flow(13, 1, 8'h33, base_addr);
    mrr_flow(13, 1, mrdat, base_addr, mrdatecc);
    if(mrdat[7:0] != 8'h33) begin
        `uvm_error(get_full_name(), $sformatf("LPDDR5 MR13 read mismatch! Exp: 0x33, Act: 0x%0h", mrdat[7:0]));
    end
    mrw_flow(13, 1, 8'h00, base_addr);

    `uvm_info(get_full_name(),$sformatf("finish lpddr5 ctrl MR test, base_addr=0x%0h", base_addr), UVM_LOW);
endtask

`endif
