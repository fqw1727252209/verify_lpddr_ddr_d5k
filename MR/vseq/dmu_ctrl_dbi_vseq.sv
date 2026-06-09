`ifndef DMU_CTRL_DBI_VSEQ_SV
`define DMU_CTRL_DBI_VSEQ_SV

class dmu_ctrl_dbi_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_dbi_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_dbi_vseq");
    super.new(name);
  endfunction

  `ifdef SIMU_DMU_APB_FTVIP
    apb_ctrl_mr_seq            apb_ctrl_mr_seq;
  `endif

  base_rand_chi_seq         base_rand_chi_seq_inst;
  int                       in_cnt = 200; // 随机跑 200 笔

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    repeat(10) @(tb.clk_noc);

    `uvm_info(get_full_name(), "Start ctrl DBI/DM test...", UVM_LOW);

    // 1. 跑底层的 MR 配置序列，把 DBI 和 DM 相关的寄存器开关打开
    // （在 apb_ctrl_mr_seq_inst 执行完后，控制器的 DBI 将处于开启状态）
    `uvm_do_on_with(apb_ctrl_mr_seq, p_sequencer.apb_sqr_[0], {});

    `uvm_info(get_full_name(), "MR and CSR configuration done, start sending CHI traffic...", UVM_LOW);

    // 2. 发起高度随机的 CHI 激励
    // 使用 base_rand_chi_seq 来在指定地址范围内下发大量的随机读写请求
    // 配合 DBI/DM 开启，这些随机数据会在底层物理线上自动触发随机的反转和掩码行为
    fork
      begin
        // ch_[0]
        `uvm_do_on_with(base_rand_chi_seq_inst, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
          base_rand_chi_seq_inst.cnt                == in_cnt;
          base_rand_chi_seq_inst.prefetch_mode      == 1'b1;
          base_rand_chi_seq_inst.cmo_mode           == 1'b1;
          base_rand_chi_seq_inst.low_boundary_addr  == `DMU_NOC_BASE_ADDR;
          base_rand_chi_seq_inst.high_boundary_addr == `DMU_NOC_HIGH_ADDR;
        })
      end
      begin
        // ch_[2]
        `uvm_do_on_with(base_rand_chi_seq_inst, p_sequencer.chi_vsqr.Down_seqr_ch_[2], {
          base_rand_chi_seq_inst.cnt                == in_cnt;
          base_rand_chi_seq_inst.prefetch_mode      == 1'b1;
          base_rand_chi_seq_inst.cmo_mode           == 1'b1;
          base_rand_chi_seq_inst.low_boundary_addr  == `DMU_NCC_BASE_ADDR;
          base_rand_chi_seq_inst.high_boundary_addr == `DMU_NCC_HIGH_ADDR;
        })
      end
      begin
        `ifdef MEM_ATTACHED_ddr5sdram
        // ch_[1]
        `uvm_do_on_with(base_rand_chi_seq_inst, p_sequencer.chi_vsqr.Down_seqr_ch_[1], {
          base_rand_chi_seq_inst.cnt                == in_cnt;
          base_rand_chi_seq_inst.prefetch_mode      == 1'b1;
          base_rand_chi_seq_inst.cmo_mode           == 1'b1;
          base_rand_chi_seq_inst.low_boundary_addr  == `DMU_NOC_BASE_ADDR;
          base_rand_chi_seq_inst.high_boundary_addr == `DMU_NOC_HIGH_ADDR;
        })
        `endif
      end
      begin
        `ifdef MEM_ATTACHED_ddr5sdram
        // ch_[3]
        `uvm_do_on_with(base_rand_chi_seq_inst, p_sequencer.chi_vsqr.Down_seqr_ch_[3], {
          base_rand_chi_seq_inst.cnt                == in_cnt;
          base_rand_chi_seq_inst.prefetch_mode      == 1'b1;
          base_rand_chi_seq_inst.cmo_mode           == 1'b1;
          base_rand_chi_seq_inst.low_boundary_addr  == `DMU_NCC_BASE_ADDR;
          base_rand_chi_seq_inst.high_boundary_addr == `DMU_NCC_HIGH_ADDR;
        })
        `endif
      end
    join

    // 3. 断言(Assertion)检查说明:
    // 在这个随机激励执行期间，因为写数据是彻底随机的，必然会产生大量满足 `count_ones > 4` 的数据，从而触发 DBI 翻转。
    // 我们需要在物理层接口 (如 DFI 或 PHY 接口) 上绑定断言来做严格的时序及数据校验。
    // 请确保验证环境中已通过 bind 将断言模块连接到物理信号上。
    
    `uvm_info(get_full_name(), "End ctrl DBI/DM test...", UVM_LOW);
    repeat(100) @(tb.clk_noc);

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass

`endif
