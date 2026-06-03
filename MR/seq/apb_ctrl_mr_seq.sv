`ifndef APB_CTRL_MR_SEQ_SV
`define APB_CTRL_MR_SEQ_SV

`ifdef SIMU_DMU_APB_FTVIP
class apb_ctrl_mr_seq extends apb_base_uvddr_seq;
  `uvm_object_utils(apb_ctrl_mr_seq)
  
  reg [143:0] mprr_data_out[];
  bit [31:0] rdata;
  int csmask0;
  int csmask1;
  bit [15:0] mrdat_data_out;
  bit [15:0] mrdatecc_out;
  int ecc_en;
  int sbecc_en;
  int rsecc_en;

  function new(string name="apb_ctrl_mr_seq");
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

    get_field_by_apb("CTL_SBECCEN", sbecc_en, `DDR_CTL0_BASE_ADDR);
    get_field_by_apb("CTL_RSECCEN", rsecc_en, `DDR_CTL0_BASE_ADDR);
    ecc_en = sbecc_en || rsecc_en;

    `ifndef dram_lpddr5
      mr_test(`DDR_CTL0_BASE_ADDR);
      `uvm_info(get_full_name(), $sformatf("finish ddr5 ctrl0 MR test"), UVM_LOW);
    `else
      lpddr5_mr_test(`DDR_CTL0_BASE_ADDR);
      `uvm_info(get_full_name(), $sformatf("finish lpddr5 ctrl0 MR test"), UVM_LOW);
    `endif

    if(starting_phase) starting_phase.drop_objection(this);
  endtask

  extern virtual task mr_test(input bit[31:0] base_addr);
  extern virtual task lpddr5_mr_test(input bit[31:0] base_addr);
  extern virtual task ctrl_cww_test(input bit[8:0] RCD_BIT, input bit[3:0] MR_RANK, input bit[31:0] CWW_DAT, input bit[15:0] base_addr);
  extern virtual task ctrl_mrw_check(input bit[63:0] MRW_DAT, input bit[15:0] MRDATECC, input bit[7:0] MR_OP);
  extern virtual task ctrl_mpc_test(input bit[7:0] MPC_DAT, input bit[3:0] MPC_RANK, input bit[31:0] base_addr);
  extern virtual task ctrl_multicycle_mpc_test(input bit[7:0] MPC_DAT, input bit[3:0] MPC_RANK, input bit[31:0] base_addr);
  extern virtual task sw_mpc_flow(int ch_id, bit [7:0] mpc_op, bit [3:0] cs); // Declared based on usage

  // ---------- Extracted Flow Tasks ----------
  extern virtual task mrr_flow(int ch_id, bit [3:0] cs, bit [8:0] mraddr, output bit [15:0] mrdat);
  extern virtual task mrw_flow(int ch_id, bit [3:0] cs, bit [8:0] mraddr, bit [15:0] mrdat);
  
  // ---------- Extracted Handle Tasks ----------
  extern virtual task mrr_handle(int ch_id, bit [3:0] cs, bit [8:0] mraddr, output bit [15:0] mrdat);
  extern virtual task mrw_handle(int ch_id, bit [3:0] cs, bit [8:0] mraddr, bit [15:0] mrdat);
  extern virtual task mpr_rd_handle(int ch_id, bit [3:0] prank, int lrank, output bit [31:0] mpr_data);
  extern virtual task mpr_wr_handle(int ch_id, bit [3:0] prank, int lrank, bit [31:0] mpr_data);
  
endclass : apb_ctrl_mr_seq

// ----------- Handles Implementation -----------
task apb_ctrl_mr_seq::mrr_handle(int ch_id, bit [3:0] cs, bit [8:0] mraddr, output bit [15:0] mrdat);
  set_field_by_apb("CTL_MRRANK", cs, ch_id);
  set_field_by_apb("CTL_MRADDR", mraddr, ch_id);
  set_field_by_apb("CTL_MRTYPE", 1, ch_id);
  set_field_by_apb("CTL_MRTRIG", 1, ch_id);
  wait_field_2ch("CTL_MRTRIG", 0, ch_id);
  wait_field_2ch("CTL_MRBUSY", 0, ch_id);
  
  get_field_by_apb("CTL_MRRDAT0", mrdat, ch_id);
  $display($sformatf("%0t, mrr_handle done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h", $time, ch_id, cs, mraddr, mrdat));
endtask

task apb_ctrl_mr_seq::mrw_handle(int ch_id, bit [3:0] cs, bit [8:0] mraddr, bit [15:0] mrdat);
  set_field_by_apb("CTL_MRRANK", cs, ch_id);
  set_field_by_apb("CTL_MRADDR", mraddr, ch_id);
  set_field_by_apb("CTL_MRWDAT", mrdat, ch_id);
  set_field_by_apb("CTL_MRTYPE", 0, ch_id);
  set_field_by_apb("CTL_MRTRIG", 1, ch_id);
  wait_field_2ch("CTL_MRTRIG", 0, ch_id);
  wait_field_2ch("CTL_MRBUSY", 0, ch_id);
  
  $display($sformatf("%0t, mrw_handle done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h", $time, ch_id, cs, mraddr, mrdat));
endtask

task apb_ctrl_mr_seq::mpr_rd_handle(int ch_id, bit [3:0] prank, int lrank, output bit [31:0] mpr_data);
  int mpr_read_addr;
  std::randomize(mpr_read_addr) with {mpr_read_addr >= 0; mpr_read_addr < 4; };
  set_field_by_apb("CTL_MRRANK", prank, ch_id);
  set_field_by_apb("CTL_MPRCID", lrank, ch_id);
  set_field_by_apb("CTL_MRADDR", mpr_read_addr, ch_id);
  set_field_by_apb("CTL_MRTYPE", 1, ch_id);
  set_field_by_apb("CTL_MRTRIG", 1, ch_id);
  wait_field_2ch("CTL_MRTRIG", 0, ch_id);
  wait_field_2ch("CTL_MRBUSY", 0, ch_id);
  
  get_field_by_apb("CTL_MPRDAT0", mpr_data, ch_id);
  $display($sformatf("%0t, mpr_rd_handle done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h", $time, ch_id, prank, mpr_read_addr, mpr_data));
endtask

task apb_ctrl_mr_seq::mpr_wr_handle(int ch_id, bit [3:0] prank, int lrank, bit [31:0] mpr_data);
  set_field_by_apb("CTL_MRRANK", prank, ch_id);
  set_field_by_apb("CTL_MPRCID", lrank, ch_id);
  set_field_by_apb("CTL_MRADDR", 0, ch_id);
  set_field_by_apb("CTL_MRWDAT", mpr_data, ch_id);
  set_field_by_apb("CTL_MRTYPE", 0, ch_id);
  set_field_by_apb("CTL_MRTRIG", 1, ch_id);
  wait_field_2ch("CTL_MRTRIG", 0, ch_id);
  wait_field_2ch("CTL_MRBUSY", 0, ch_id);
endtask

// ----------- Flows Implementation -----------
task apb_ctrl_mr_seq::mrr_flow(int ch_id, bit [3:0] cs, bit [8:0] mraddr, output bit [15:0] mrdat);
  bit pdnen, sren;
  hold_xmu_uif(ch_id);
  exit_low_power_state(ch_id, pdnen, sren);
  set_field_by_apb("CTL_SWCMDSTART", 1, ch_id);
  mrr_handle(ch_id, cs, mraddr, mrdat);
  set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
  set_field_by_apb("CTL_SREN", sren, ch_id);
  unhold_xmu_uif(ch_id);
  set_field_by_apb("CTL_SWCMDSTART", 0, ch_id);
  $display($sformatf("%0t, mrr_flow done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h", $time, ch_id, cs, mraddr, mrdat));
endtask

task apb_ctrl_mr_seq::mrw_flow(int ch_id, bit [3:0] cs, bit [8:0] mraddr, bit [15:0] mrdat);
  bit pdnen, sren;
  hold_xmu_uif(ch_id);
  exit_low_power_state(ch_id, pdnen, sren);
  set_field_by_apb("CTL_SWCMDSTART", 1, ch_id);
  mrw_handle(ch_id, cs, mraddr, mrdat);
  set_field_by_apb("CTL_PDNEN", pdnen, ch_id);
  set_field_by_apb("CTL_SREN", sren, ch_id);
  unhold_xmu_uif(ch_id);
  set_field_by_apb("CTL_SWCMDSTART", 0, ch_id);
  $display($sformatf("%0t, mrw_flow done, ch_id is %0h, cs is %0h, mraddr is %0h, mrdat is %0h", $time, ch_id, cs, mraddr, mrdat));
endtask

// ----------- DDR5 MR Test -----------
task apb_ctrl_mr_seq::mr_test(input bit[31:0] base_addr);
  get_field_by_apb("CTL_CSMASK", csmask0, base_addr);
  `uvm_info(get_full_name(), $sformatf("start ddr5 ctrl MR test"), UVM_LOW);
  
  //ctrl0 253/254 mrw/mrr
  mrw_flow(base_addr, 1, 253, 'h1);
  mrw_flow(base_addr, 1, 254, 'h1);

  //rank 0
  mrw_flow(base_addr, 1, 51, 'h3d);
  mrw_flow(base_addr, 1, 52, 'h2b);
  mrr_flow(base_addr, 1, 51, mrdat_data_out);
  // ctrl_mrw_check(mrdat_data_out, mrdatecc_out, 'h3d);
  mrr_flow(base_addr, 1, 52, mrdat_data_out);
  // ctrl_mrw_check(mrdat_data_out, mrdatecc_out, 'h2b);

  // rank 1
  if(csmask0 == 1) begin
    mrw_flow(base_addr, 2, 51, 'h3c);
    mrw_flow(base_addr, 2, 52, 'h2e);
    mrr_flow(base_addr, 2, 51, mrdat_data_out);
    mrr_flow(base_addr, 2, 52, mrdat_data_out);
  end

  // all rank
  for(int i=1; i<4; i++) begin
    mrw_flow(base_addr, 1<<i, 51, 'h3d);
    mrw_flow(base_addr, 1<<i, 52, 'h2b);
    mrr_flow(base_addr, 1<<i, 51, mrdat_data_out);
    mrr_flow(base_addr, 1<<i, 52, mrdat_data_out);
  end
  
  // MPC test
  mrw_flow(base_addr, 1, 13, 'h3d);
  
  if (csmask0 == 3) begin
    ctrl_mpc_test(8'b00110101, 15, base_addr);
    ctrl_mpc_test(8'b00110001, 15, base_addr);
    ctrl_mpc_test(8'b01000101, 15, base_addr);
    //ctrl_multicycle_mpc_test(8'b01000101, 5, `DDR_CTL0_BASE_ADDR);
  end

  // mpc_pda_test
  // `uvm_info(get_full_name(), $sformatf("start ddr5 ctrl PDA test"), UVM_LOW);
  // mrw_flow(1, 15, 'h5, base_addr);
  // set_field_by_apb("CTL_PDAEN", 1, base_addr);
  // `ifdef MEM_DEVICE_X8
  //   for (int i=0; i<5; i++) begin
  //     sw_mpc_flow(base_addr, 'b01100000+i, 1<<(RANK_NUM(1'b1)));
  //   end
  // ... (PDA omitted in comment block)
endtask

// ----------- LPDDR5 MR Test (Added properly) -----------
task apb_ctrl_mr_seq::lpddr5_mr_test(input bit[31:0] base_addr);
  get_field_by_apb("CTL_CSMASK", csmask0, base_addr);
  `uvm_info(get_full_name(), $sformatf("start lpddr5 ctrl MR test"), UVM_LOW);
  
  // rank 0
  mrw_flow(base_addr, 1, 15, 'h5A);
  mrr_flow(base_addr, 1, 15, mrdat_data_out);
  
  // rank 1
  if(csmask0 == 1) begin
    mrw_flow(base_addr, 2, 15, 'h5A);
    mrr_flow(base_addr, 2, 15, mrdat_data_out);
  end
endtask

// ----------- Check & MPC Implementation -----------
task apb_ctrl_mr_seq::ctrl_mrw_check(input bit[63:0] MRW_DAT, input bit[15:0] MRDATECC, input bit[7:0] MR_OP);
  if(ecc_en==1 && MRDATECC[7:0] != MR_OP)
    `uvm_error(get_type_name(), $sformatf("mrr_data_ecc:%0h", MRDATECC[7:0]))
  if(`DRAM_WIDTH==8) begin
    if(MRW_DAT[7:0] != MR_OP)
      `uvm_error(get_type_name(), $sformatf("mrr_data_dev0:%0h", MRW_DAT[7:0]))
    if(MRW_DAT[15:8] != MR_OP)
      `uvm_error(get_type_name(), $sformatf("mrr_data_dev1:%0h", MRW_DAT[15:8]))
    if(MRW_DAT[23:16] != MR_OP)
      `uvm_error(get_type_name(), $sformatf("mrr_data_dev2:%0h", MRW_DAT[23:16]))
    if(MRW_DAT[31:24] != MR_OP)
      `uvm_error(get_type_name(), $sformatf("mrr_data_dev3:%0h", MRW_DAT[31:24]))
  end else if(`DRAM_WIDTH==16) begin
    if(MRW_DAT[7:0] != MR_OP)
      `uvm_error(get_type_name(), $sformatf("mrr_data_dev0:%0h", MRW_DAT[7:0]))
    if(MRW_DAT[15:8] != MR_OP)
      `uvm_error(get_type_name(), $sformatf("mrr_data_dev1:%0h", MRW_DAT[15:8]))
  end
endtask

task apb_ctrl_mr_seq::ctrl_mpc_test(input bit[7:0] MPC_DAT, input bit[3:0] MPC_RANK, input bit[31:0] base_addr);
  bit [31:0] mrr_data_out;
  sw_mpc_flow(base_addr, MPC_DAT, MPC_RANK);

  if(MPC_DAT[7:4] == 'b0010) begin
    sw_mpc_flow(base_addr, 'b00011111, MPC_RANK);
    for(int i=0; i<4; i++) begin
      if(MPC_RANK[i] == 1) begin
        mrr_flow(32, 1<<i, mrr_data_out, base_addr);
        if(mrr_data_out[2:0] != MPC_DAT[2:0])
          `uvm_error(get_type_name(), $sformatf("RTT_CK:%0h", mrr_data_out[2:0]))
      end
    end
  end
  if(MPC_DAT[7:4] == 'b0011) begin
    sw_mpc_flow(base_addr, 'b00011111, MPC_RANK);
    for(int i=0; i<4; i++) begin
      if(MPC_RANK[i] == 1) begin
        mrr_flow(32, 1<<i, mrr_data_out, base_addr);
        if(mrr_data_out[5:3] != MPC_DAT[2:0])
          `uvm_error(get_type_name(), $sformatf("RTT_CS:%0h", mrr_data_out[5:3]))
      end
    end
  end
  if(MPC_DAT[7:4] == 'b0100) begin
    sw_mpc_flow(base_addr, 'b00011111, MPC_RANK);
    for(int i=0; i<4; i++) begin
      if(MPC_RANK[i] == 1) begin
        mrr_flow(33, 1<<i, mrr_data_out, base_addr);
        if(mrr_data_out[2:0] != MPC_DAT[2:0])
          `uvm_error(get_type_name(), $sformatf("RTT_CA:%0h", mrr_data_out[2:0]))
      end
    end
  end
  if(MPC_DAT[7:3] == 'b01010) begin
    for(int i=0; i<4; i++) begin
      if(MPC_RANK[i] == 1) begin
        mrr_flow(33, 1<<i, mrr_data_out, base_addr);
        if(mrr_data_out[5:3] != MPC_DAT[2:0])
          `uvm_error(get_type_name(), $sformatf("DQS_RTT_PARK:%0h", mrr_data_out[5:3]))
      end
    end
  end
  if(MPC_DAT[7:3] == 'b01011) begin
    for(int i=0; i<4; i++) begin
      if(MPC_RANK[i] == 1) begin
        mrr_flow(34, 1<<i, mrr_data_out, base_addr);
        if(mrr_data_out[2:0] != MPC_DAT[2:0])
          `uvm_error(get_type_name(), $sformatf("RTT_PARK:%0h", mrr_data_out[2:0]))
      end
    end
  end
endtask

task apb_ctrl_mr_seq::ctrl_multicycle_mpc_test(input bit[7:0] MPC_DAT, input bit[3:0] MPC_RANK, input bit[31:0] base_addr);
  bit [31:0] mrr_data_out;
  `uvm_info(get_type_name(), $sformatf("BEGIN multicycle rank%h_cww_data=%0h", MPC_RANK, MPC_DAT), UVM_LOW);
  
  // Set MR2 to MultiCycle
  mrw_flow(2, MPC_RANK, 'b10000000, `DDR_CTL0_BASE_ADDR);
  mrw_flow(2, MPC_RANK, 'b10000000, `DDR_CTL1_BASE_ADDR);

  // Set Ctrl to MultiCycle
  set_field_by_apb("CTL_DISMULTICS", 0, `DDR_CTL0_BASE_ADDR);
  set_field_by_apb("CTL_DISMULTICS", 0, `DDR_CTL1_BASE_ADDR);

  // Set RCD to Rank 0 CA PASS Through
  // ctrl_cww_test(0, 0, 5, base_addr);
  $mmreadword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", mrr_data_out);
  mrr_data_out[2] = 1;
  $mmwriteword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", $sformatf("0x%h", mrr_data_out));

  // Send MPC CMD to CH0 Rank0
  sw_mpc_flow(`DDR_CTL0_BASE_ADDR, 'b00110101, 1);
  sw_mpc_flow(`DDR_CTL0_BASE_ADDR, 'b00011111, 1);

  // Send MPC CMD to CH1 Rank0
  sw_mpc_flow(`DDR_CTL1_BASE_ADDR, 'b00110101, 1);
  sw_mpc_flow(`DDR_CTL1_BASE_ADDR, 'b00011111, 1);

  // Set RCD to Normal
  // ctrl_cww_test(0, 0, 1, base_addr);
  $mmreadword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", mrr_data_out);
  mrr_data_out[2] = 0;
  $mmwriteword($sformatf("tb.memory.rcd_ddr5[0].rcd(CH-A RW)"), "0x00", $sformatf("0x%h", mrr_data_out));

  // Set MR2 to SingleCycle
  mrw_flow(2, MPC_RANK, 'b10010000, `DDR_CTL0_BASE_ADDR);
  mrw_flow(2, MPC_RANK, 'b10010000, `DDR_CTL1_BASE_ADDR);

  // Set Ctrl to SingleCycle
  set_field_by_apb("CTL_DISMULTICS", 1, `DDR_CTL0_BASE_ADDR);
  set_field_by_apb("CTL_DISMULTICS", 1, `DDR_CTL1_BASE_ADDR);

  if(MPC_DAT[7:4] == 'b0010) begin
    sw_mpc_flow(base_addr, 'b00011111, MPC_RANK);
    mrr_flow(32, MPC_RANK, mrr_data_out, base_addr);
    if(mrr_data_out[2:0] != MPC_DAT[2:0])
      `uvm_error(get_type_name(), $sformatf("RTT_CK:%0h", mrr_data_out[2:0]))
  end
  if(MPC_DAT[7:4] == 'b0011) begin
    sw_mpc_flow(base_addr, 'b00011111, MPC_RANK);
    mrr_flow(32, MPC_RANK, mrr_data_out, base_addr);
    if(mrr_data_out[5:3] != MPC_DAT[2:0])
      `uvm_error(get_type_name(), $sformatf("RTT_CS:%0h", mrr_data_out[5:3]))
  end
  if(MPC_DAT[7:4] == 'b0100) begin
    sw_mpc_flow(base_addr, 'b00011111, MPC_RANK);
    mrr_flow(33, MPC_RANK, mrr_data_out, base_addr);
    if(mrr_data_out[2:0] != MPC_DAT[2:0])
      `uvm_error(get_type_name(), $sformatf("RTT_CA:%0h", mrr_data_out[2:0]))
  end
  if(MPC_DAT[7:3] == 'b01010) begin
    mrr_flow(33, MPC_RANK, mrr_data_out, base_addr);
    if(mrr_data_out[5:3] != MPC_DAT[2:0])
      `uvm_error(get_type_name(), $sformatf("DQS_RTT_PARK:%0h", mrr_data_out[5:3]))
  end
  if(MPC_DAT[7:3] == 'b01011) begin
    mrr_flow(34, MPC_RANK, mrr_data_out, base_addr);
    if(mrr_data_out[2:0] != MPC_DAT[2:0])
      `uvm_error(get_type_name(), $sformatf("RTT_PARK:%0h", mrr_data_out[2:0]))
  end
endtask

`endif
`endif // APB_CTRL_MR_SEQ_SV
