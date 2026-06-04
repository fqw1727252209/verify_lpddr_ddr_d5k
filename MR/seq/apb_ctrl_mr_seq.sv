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
      get_field_by_apb("CTL_SBECCEN",sbecc_en,`1);
      get_field_by_apb("CTL_RSECCEN",rsecc_en,`1);
      ecc_en=sbecc_en||rsecc_en;

      `ifdef MEM_ATTACHED_ddr5sdram
        mr_test(`1);
        `uvm_info(get_full_name(),$sformatf("finish ddr5 ctrl0 MR test"), UVM_LOW);

        mr_test(`2);
        `uvm_info(get_full_name(),$sformatf("finish ddr5 ctrl1 MR test"), UVM_LOW);

      `endif

    if(starting_phase) starting_phase.drop_objection(this);
  endtask

  extern virtual task mr_test(input bit[31:0]ch_id);
  extern virtual task ctrl_cww_test(input bit[8:0]RCD_BIT,input bit[3:0]MR_RANK,input bit[31:0] CWW_DAT,input bit[15:0]ch_id);
  extern virtual task ctrl_cwr_test(input bit[8:0]RCD_BIT,input bit[3:0]MR_RANK,input bit[31:0]ch_id,input bit[7:0]MR_OP);
  extern virtual task ctrl_mrw_check(input bit[63:0] MRW_DAT,input bit[15:0]MRDATECC,input bit[7:0]MR_OP);
  extern virtual task ctrl_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]ch_id);
  extern virtual task ctrl_multicycle_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]ch_id);

endclass : ctrl_mr_seq

task apb_ctrl_mr_seq::mr_test(input bit[31:0]ch_id);
    get_field_by_apb("CTL_CSMASK",csmask0,ch_id);
    //ctrl0 253/254 mrw/mrr
    `uvm_info(get_full_name(),$sformatf("start ddr5 ctrl MR test"), UVM_LOW);

    mrw_flow(253,1,'h1,ch_id);
    mrw_flow(254,1,'h1,ch_id);
    //rank 0
    mrw_flow(51,1,'h3d,ch_id);
    mrw_flow(52,1,'h2b,ch_id);
    mrr_flow(51,1,mrdat_data_out,ch_id,mrdatecc_out);
    ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3d);
    mrr_flow(52,1,mrdat_data_out,ch_id,mrdatecc_out);
    ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2b);
    //rank 1
    if(csmask0 == 1)begin
      mrw_flow(51,2,'h3c,ch_id);
      mrw_flow(52,2,'h2e,ch_id);
      mrr_flow(51,2,mrdat_data_out,ch_id,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3c);
      mrr_flow(52,2,mrdat_data_out,ch_id,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2e);
    end

    mrw_flow(51,3,'h3c,ch_id);
    mrw_flow(52,3,'h2e,ch_id);
    for(int i=1;i<3;i++)begin
      mrr_flow(51,i,mrdat_data_out,ch_id,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3c);
      mrr_flow(52,i,mrdat_data_out,ch_id,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2e);
    end

    //mrr_flow(51,3,mrdat_data_out,ch_id);

    //rank 2
    if(csmask0 == 3 )begin
      mrw_flow(51,4,'h3d,ch_id);
      mrw_flow(52,4,'h2b,ch_id);
      mrr_flow(51,4,mrdat_data_out,ch_id,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3d);
      mrr_flow(52,4,mrdat_data_out,ch_id,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2b);
      //rank 3
      mrw_flow(51,8,'h3d,ch_id);
      mrw_flow(52,8,'h2b,ch_id);
      mrr_flow(51,8,mrdat_data_out,ch_id,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3d);
      mrr_flow(52,8,mrdat_data_out,ch_id,mrdatecc_out);
      ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2b);

      //all rank
      mrw_flow(51,15,'h3d,ch_id);
      mrw_flow(52,15,'h2b,ch_id);
      for(int i=0;i<4;i++)begin
        mrr_flow(51,1<<i,mrdat_data_out,ch_id,mrdatecc_out);
        ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h3d);
        mrr_flow(52,1<<i,mrdat_data_out,ch_id,mrdatecc_out);
        ctrl_mrw_check(mrdat_data_out,mrdatecc_out,'h2b);
      end
    end
    mrw_flow(48,1,mrdat_data_out,ch_id,mrdatecc_out);
    mrw_flow(48,1,{1'b1,mrdat_data_out[6:0]},ch_id);
    mrr_flow(48,1,mrdat_data_out,ch_id,mrdatecc_out);
    mrw_flow(48,1,{1'b0,mrdat_data_out[6:0]},ch_id);

    //MPC test
    mrr_flow(13,1,mrdat_data_out,ch_id,mrdatecc_out);
    sw_mpc_flow(ch_id,{4'b1000,mrdat_data_out[3:0]},1);

    ctrl_mpc_test(8'b00110101,1,ch_id);
    ctrl_mpc_test(8'b00110001,1,ch_id);
    ctrl_mpc_test(8'b01000101,1,ch_id);
    //ctrl_multicycle_mpc_test(8'b01000101,1,ch_id);
    if(csmask0 == 1 )begin
      ctrl_mpc_test(8'b00110101,3,ch_id);
      ctrl_mpc_test(8'b00110001,3,ch_id);
      ctrl_mpc_test(8'b01000101,3,ch_id);
    end

    if(csmask0 == 3 )begin
      ctrl_mpc_test(8'b00110101,15,ch_id);
      ctrl_mpc_test(8'b00110001,15,ch_id);
      ctrl_mpc_test(8'b01000101,15,ch_id);
      //ctrl_multicycle_mpc_test(8'b01000101,5,`1);
    end
    //mpc_pda_test
    // `uvm_info(get_full_name(),$sformatf("start ddr5 ctrl PDA test"), UVM_LOW);
    // mrw_flow(1,15,'h5,ch_id);
    // set_field_by_apb("CTL_PDAEN",1,ch_id);
    // `ifdef MEM_DEVICE_X8
    // for(int i=0;i<5;i++)begin
    //   sw_mpc_flow(ch_id,'b01100000+i,(`RANK_NUM<1'b1));
    // end
    // // sw_mpc_flow(ch_id,'b01100010,1<<(`RANK_NUM-1));
    // // sw_mpc_flow(ch_id,'b01100100,1<<(`RANK_NUM-1));
    // `else
    // for(int i=0;i<10;i++)begin
    //   sw_mpc_flow(ch_id,'b01100000+i,(`RANK_NUM<1'b1));
    // end
    // `endif
    // // sw_mpc_flow(ch_id,'b01100000,1<<(`RANK_NUM-1));

    // set_field_by_apb("CTL_PDAEN",0,ch_id);

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

task apb_ctrl_mr_seq::ctrl_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]ch_id);
  bit[31:0] mrr_data_out;
  sw_mpc_flow(ch_id,MPC_DAT,MPC_RANK);

  if(MPC_DAT[7:4]=='b0010)begin
    sw_mpc_flow(ch_id,'b00011111,MPC_RANK);
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(32,1<<i,mrr_data_out,ch_id);
        if(mrr_data_out[2:0]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("RTT_CK:%0h",mrr_data_out[2:0]))
      end
    end
  end
  if(MPC_DAT[7:4]=='b0011)begin
    sw_mpc_flow(ch_id,'b00011111,MPC_RANK);
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(32,1<<i,mrr_data_out,ch_id);
        if(mrr_data_out[5:3]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("RTT_CS:%0h",mrr_data_out[5:3]))
      end
    end
  end
  if(MPC_DAT[7:4]=='b0100)begin
    sw_mpc_flow(ch_id,'b00011111,MPC_RANK);
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(33,1<<i,mrr_data_out,ch_id);
        if(mrr_data_out[2:0]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("RTT_CA:%0h",mrr_data_out[2:0]))
      end
    end
  end
  if(MPC_DAT[7:3]=='b01010)begin
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(33,1<<i,mrr_data_out,ch_id);
        if(mrr_data_out[5:3]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("DQS_RTT_PARK:%0h",mrr_data_out[5:3]))
      end
    end
  end
  if(MPC_DAT[7:3]=='b01011)begin
    for(int i=0;i<4;i++)begin
      if(MPC_RANK[i]==1)begin
        mrr_flow(34,1<<i,mrr_data_out,ch_id);
        if(mrr_data_out[2:0]!=MPC_DAT[2:0])
          `uvm_error(get_type_name(),$sformatf("RTT_PARK:%0h",mrr_data_out[2:0]))
      end
    end
  end
endtask

task apb_ctrl_mr_seq::ctrl_multicycle_mpc_test(input bit[7:0]MPC_DAT,input bit[3:0]MPC_RANK,input bit[31:0]ch_id);
  bit[31:0] mrr_data_out;
  `uvm_info(get_type_name(),$sformatf("BEGIN multicycle rank%h cwn_data=%0h",MPC_RANK,MPC_DAT),UVM_LOW);
  //Set MR2 to MultiCycle
  mrw_flow(2, MPC_RANK, 'b10000000, `1);
  mrw_flow(2, MPC_RANK, 'b10000000, `2);

  //Set Ctrl to MultiCycle
  set_field_by_apb("CTL_DISMULTICS", 0, `1);
  set_field_by_apb("CTL_DISMULTICS", 0, `2);

  //Set RCD to Rank 0 CA PASS Through
  // ctrl_cww_test(0,0,5,ch_id);
  $mmreadword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", mrr_data_out);
  mrr_data_out[2]=1;
  $mmwriteword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", $sformatf("0x%h",mrr_data_out));

  //Send MPC CMD to CH0 Rank0
  sw_mpc_flow(`1, 'b00110101, 1);
  sw_mpc_flow(`1, 'b00011111, 1);

  //Send MPC CMD to CH1 Rank0
  sw_mpc_flow(`2, 'b00110101, 1);
  sw_mpc_flow(`2, 'b00011111, 1);

  //Set RCD to Normal
  // ctrl_cww_test(0,0,1,ch_id);
  $mmreadword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", mrr_data_out);
  mrr_data_out[2]=0;
  $mmwriteword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", $sformatf("0x%h",mrr_data_out));

  //Set MR2 to SignleCycle
  mrw_flow(2, MPC_RANK, 'b10010000, `1);
  mrw_flow(2, MPC_RANK, 'b10010000, `2);

  //Set Ctrl to SignleCycle
  set_field_by_apb("CTL_DISMULTICS", 1, `1);
  set_field_by_apb("CTL_DISMULTICS", 1, `2);

  if(MPC_DAT[7:4]=='b0010)begin
    sw_mpc_flow(ch_id,'b00011111,MPC_RANK);
    mrr_flow(32,MPC_RANK,mrr_data_out,ch_id);
    if(mrr_data_out[2:0]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("RTT_CK:%0h",mrr_data_out[2:0]))
  end
  if(MPC_DAT[7:4]=='b0011)begin
    sw_mpc_flow(ch_id,'b00011111,MPC_RANK);
    mrr_flow(32,MPC_RANK,mrr_data_out,ch_id);
    if(mrr_data_out[5:3]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("RTT_CS:%0h",mrr_data_out[5:3]))
  end
  if(MPC_DAT[7:4]=='b0100)begin
    sw_mpc_flow(ch_id,'b00011111,MPC_RANK);
    mrr_flow(33,MPC_RANK,mrr_data_out,ch_id);
    if(mrr_data_out[2:0]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("RTT_CA:%0h",mrr_data_out[2:0]))
  end
  if(MPC_DAT[7:3]=='b01010)begin
    mrr_flow(33,MPC_RANK,mrr_data_out,ch_id);
    if(mrr_data_out[5:3]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("DQS_RTT_PARK:%0h",mrr_data_out[5:3]))
  end
  if(MPC_DAT[7:3]=='b01011)begin
    mrr_flow(34,MPC_RANK,mrr_data_out,ch_id);
    if(mrr_data_out[2:0]!=MPC_DAT[2:0])
      `uvm_error(get_type_name(),$sformatf("RTT_PARK:%0h",mrr_data_out[2:0]))
  end
endtask
`endif