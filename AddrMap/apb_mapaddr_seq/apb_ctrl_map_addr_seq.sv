/*
 * @Project Name: 
 * @Team: soc/ddr
 * @Author: fengqingwei
 * @Email: fengqingwei2361@phytium.com.cn
 * @Date: 2026-03-24 16:26:49
 * @LastEditors: fengqingwei
 * @LastEditTime: 2026-05-25 16:28:45
 * @Description: 
 * @Copyright (c) 2026 Phytium.co.Ltd
 */
`ifdef SIMU_DMU_APB_FTVIP
class apb_ctrl_map_addr_rand_seq extends apb_base_seq;

  `uvm_object_utils(apb_ctrl_map_addr_rand_seq)
  pytmApbTransfer apb_tr;

  randc bit[5:0]            rand_val;
  bit[5:0]                  val[27];
  int                       i;
  //virtual Misc_if misc_if ;

  // constraint val_range{
  //   rand_val inside {[0:34]};
  // }
  function new(string name = "apb_ctrl_map_addr_rand_seq");
    super.new(name);
  endfunction

  `include "init_config_task.sv"

  virtual task pre_body();

    if(starting_phase) starting_phase.raise_objection(this);
      `uvm_info(get_full_name(), "wait rst!", UVM_LOW);
      repeat(5) @(posedge tb.clk_cfg);
    if(starting_phase) starting_phase.drop_objection(this);

  endtask

  virtual task body();

    if(starting_phase) starting_phase.raise_objection(this);
      `uvm_info(get_full_name(), "start set ctrl addr map...", UVM_LOW);

      get_field_by_apb("CTL_COL0POS",   val[0], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_COL1POS",   val[1], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_COL2POS",   val[2], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_COL3POS",   val[3], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_COL4POS",   val[4], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_COL5POS",   val[5], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW0POS",   val[6], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW1POS",   val[7], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW2POS",   val[8], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW3POS",   val[9], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW4POS",   val[10], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW5POS",   val[11], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW6POS",   val[12], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW7POS",   val[13], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW8POS",   val[14], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW9POS",   val[15], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW10POS",  val[16], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW11POS",  val[17], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW12POS",  val[18], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW13POS",  val[19], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW14POS",  val[20], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_ROW15POS",  val[21], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_BA2POS",    val[22], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_BA3POS",    val[23], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_BA4POS",    val[24], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_BA0POS",    val[25], `DDR_CTL0_BASE_ADDR);
      get_field_by_apb("CTL_BA1POS",    val[26], `DDR_CTL0_BASE_ADDR);
      val.shuffle();

      set_field_by_apb("CTL_COL0POS",   val[0], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL1POS",   val[1], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL2POS",   val[2], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL3POS",   val[3], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL4POS",   val[4], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL5POS",   val[5], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW0POS",   val[6], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW1POS",   val[7], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW2POS",   val[8], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW3POS",   val[9], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW4POS",   val[10], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW5POS",   val[11], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW6POS",   val[12], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW7POS",   val[13], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW8POS",   val[14], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW9POS",   val[15], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW10POS",  val[16], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW11POS",  val[17], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW12POS",  val[18], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW13POS",  val[19], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW14POS",  val[20], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW15POS",  val[21], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA2POS",    val[22], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA3POS",    val[23], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA4POS",    val[24], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA0POS",    val[25], `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA1POS",    val[26], `DDR_CTL0_BASE_ADDR);

      `ifdef MEM_ATTACHED_ddr5sdram
      set_field_by_apb("CTL_COL0POS",   val[0], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL1POS",   val[1], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL2POS",   val[2], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL3POS",   val[3], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL4POS",   val[4], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL5POS",   val[5], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW0POS",   val[6], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW1POS",   val[7], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW2POS",   val[8], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW3POS",   val[9], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW4POS",   val[10], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW5POS",   val[11], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW6POS",   val[12], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW7POS",   val[13], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW8POS",   val[14], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW9POS",   val[15], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW10POS",  val[16], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW11POS",  val[17], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW12POS",  val[18], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW13POS",  val[19], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW14POS",  val[20], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW15POS",  val[21], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA2POS",    val[22], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA3POS",    val[23], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA4POS",    val[24], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA0POS",    val[25], `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA1POS",    val[26], `DDR_CTL1_BASE_ADDR);
      `endif

      `uvm_info(get_full_name(), "complete initialize!!!", UVM_LOW);
    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass : apb_ctrl_map_addr_rand_seq

class apb_ctrl_map_addr_perf_seq extends apb_base_seq;

  `uvm_object_utils(apb_ctrl_map_addr_perf_seq)
  pytmApbTransfer apb_tr;

  randc bit[5:0]            rand_val;
  bit[5:0]                  val[35];
  int                       i;
  //virtual Misc_if misc_if ;

  function new(string name = "apb_ctrl_map_addr_perf_seq");
    super.new(name);
  endfunction

  `include "init_config_task.sv"

  virtual task pre_body();

    if(starting_phase) starting_phase.raise_objection(this);
      `uvm_info(get_full_name(), "wait rst!", UVM_LOW);
      repeat(5) @(posedge tb.clk_cfg);
    if(starting_phase) starting_phase.drop_objection(this);

  endtask

  virtual task body();

    if(starting_phase) starting_phase.raise_objection(this);
      `uvm_info(get_full_name(), "start set ctrl perf addr map...", UVM_LOW);
      set_field_by_apb("CTL_COL0POS",   1, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL1POS",   2, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL2POS",   3, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL3POS",   6, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL4POS",   7, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL5POS",   8, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_COL6POS",   9, `DDR_CTL0_BASE_ADDR);

      set_field_by_apb("CTL_ROW0POS",   16, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW1POS",   17, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW2POS",   18, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW3POS",   19, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW4POS",   20, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW5POS",   21, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW6POS",   22, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW7POS",   23, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW8POS",   24, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW9POS",   25, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW10POS",  26, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW11POS",  27, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW12POS",  28, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW13POS",  29, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW14POS",  30, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_ROW15POS",  31, `DDR_CTL0_BASE_ADDR);
      // set_field_by_apb("CTL_ROW16POS",  32, `DDR_CTL0_BASE_ADDR);
      // set_field_by_apb("CTL_ROW17POS",  33, `DDR_CTL0_BASE_ADDR);

      set_field_by_apb("CTL_BA2POS",    0, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA3POS",    4, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA4POS",    5, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA0POS",    10, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_BA1POS",    11, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_CID0POS",   13, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_CID1POS",   14, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_CID2POS",   15, `DDR_CTL0_BASE_ADDR);
      set_field_by_apb("CTL_CS0POS",    12, `DDR_CTL0_BASE_ADDR);

      `ifdef MEM_ATTACHED_ddr5sdram
      set_field_by_apb("CTL_COL0POS",   1, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL1POS",   2, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL2POS",   3, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL3POS",   6, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL4POS",   7, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL5POS",   8, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_COL6POS",   9, `DDR_CTL1_BASE_ADDR);

      set_field_by_apb("CTL_ROW0POS",   16, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW1POS",   17, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW2POS",   18, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW3POS",   19, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW4POS",   20, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW5POS",   21, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW6POS",   22, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW7POS",   23, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW8POS",   24, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW9POS",   25, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW10POS",  26, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW11POS",  27, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW12POS",  28, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW13POS",  29, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW14POS",  30, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_ROW15POS",  31, `DDR_CTL1_BASE_ADDR);
      // set_field_by_apb("CTL_ROW16POS",  32, `DDR_CTL1_BASE_ADDR);
      // set_field_by_apb("CTL_ROW17POS",  33, `DDR_CTL1_BASE_ADDR);

      set_field_by_apb("CTL_BA2POS",    0, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA3POS",    4, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA4POS",    5, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA0POS",    10, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_BA1POS",    11, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_CID0POS",   13, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_CID1POS",   14, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_CID2POS",   15, `DDR_CTL1_BASE_ADDR);
      set_field_by_apb("CTL_CS0POS",    12, `DDR_CTL1_BASE_ADDR);
      `endif

      `uvm_info(get_full_name(), "complete initialize!!!", UVM_LOW);
    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass : apb_ctrl_map_addr_perf_seq

`endif