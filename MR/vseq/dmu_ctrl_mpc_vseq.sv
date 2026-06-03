`ifndef DMU_CTRL_MPC_VSEQ_SV
`define DMU_CTRL_MPC_VSEQ_SV

class dmu_ctrl_mpc_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_mpc_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_mpc_vseq");
    super.new(name);
  endfunction

  `ifdef SIMU_DMU_APB_FTVIP
    apb_ctrl_test_mpc_seq      apb_ctrl_mpc_seq;
  `endif

  chi_full_wrard_seq         full_wrard_chi_seq;
  //chi_ptl_wrrd_seq           ptl_wrrd_chi_seq;
  chi_wrrd_seq               wrrd_chi_seq;
  chi_readAfterWrite_seq     readAfterWrite_chi_seq;
  chi_base_rand_seq          base_rand_chi_seq;

  bit [255:0] in_data;
  int in_cnt=1000;

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    repeat(10) @(tb.clk_noc);

    `uvm_info(get_full_name(), "Start ctrl mpc test...", UVM_LOW);
    fork
      begin
        // ctrl mpc test
        `uvm_do_on_with(apb_ctrl_mpc_seq,p_sequencer.apb_sqr_[0],{});
      end
      begin
        `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                        {wrrd_chi_seq.cnt                 == in_cnt;
                         wrrd_chi_seq.chi_addr            == `DMU_BASE0_ADDR;
                         //wrrd_chi_seq.chi_wrdata        == chi_addr+(1'b1<<40);
                         wrrd_chi_seq.chi_ns              == 'b0;
                         wrrd_chi_seq.chi_qos             == 'hf;
                         wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                         wrrd_chi_seq.chi_size            == DENALI_CHI_SIZE_FULLLINE ;
                         wrrd_chi_seq.chi_rsvdc           == 'h0;})
      end
      begin
        `ifndef dram_lpddr5
        `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                        {wrrd_chi_seq.cnt                 == in_cnt;
                         wrrd_chi_seq.chi_addr            == `DMU_BASE0_ADDR;
                         //wrrd_chi_seq.chi_wrdata        == chi_addr+(1'b1<<40);
                         wrrd_chi_seq.chi_ns              == 'b0;
                         wrrd_chi_seq.chi_qos             == 'hf;
                         wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                         wrrd_chi_seq.chi_size            == DENALI_CHI_SIZE_FULLLINE ;
                         wrrd_chi_seq.chi_rsvdc           == 'h0;})
        `endif
      end
    join

    `uvm_info(get_full_name(), "end ctrl mpc test...", UVM_LOW);
    repeat(100) @(tb.clk_noc);

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass

class dmu_ctrl_mpc_2n_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_mpc_2n_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_mpc_2n_vseq");
    super.new(name);
  endfunction

  `ifdef SIMU_DMU_APB_FTVIP
    apb_ctrl_mpc_2n_seq      apb_ctrl_mpc_2n_seq;
  `endif

  chi_full_wrard_seq         full_wrard_chi_seq;
  //chi_ptl_wrrd_seq           ptl_wrrd_chi_seq;
  chi_wrrd_seq               wrrd_chi_seq;
  chi_readAfterWrite_seq     readAfterWrite_chi_seq;
  chi_base_rand_seq          base_rand_chi_seq;

  bit [255:0] in_data;
  int in_cnt=1000;

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    repeat(10) @(tb.clk_noc);

    `uvm_info(get_full_name(), "Start ctrl mpc 2n test...", UVM_LOW);
    // set dfi2nmode=0
    `uvm_do_on_with(apb_ctrl_mpc_2n_seq,p_sequencer.apb_sqr_[0],{apb_ctrl_mpc_2n_seq.mode_2n==0;});
    // enable ctrl mpc 2n test
    `uvm_do_on_with(apb_ctrl_mpc_2n_seq,p_sequencer.apb_sqr_[0],{apb_ctrl_mpc_2n_seq.mode_2n==1;});
    fork
      begin
        `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                        {wrrd_chi_seq.cnt                 == in_cnt;
                         wrrd_chi_seq.chi_addr            == `DMU_BASE0_ADDR;
                         //wrrd_chi_seq.chi_wrdata        == chi_addr+(1'b1<<40);
                         wrrd_chi_seq.chi_ns              == 'b0;
                         wrrd_chi_seq.chi_qos             == 'hf;
                         wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                         wrrd_chi_seq.chi_size            == DENALI_CHI_SIZE_FULLLINE ;
                         wrrd_chi_seq.chi_rsvdc           == 'h0;})
      end

      begin
        `ifndef dram_lpddr5
        `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                        {wrrd_chi_seq.cnt                 == in_cnt;
                         wrrd_chi_seq.chi_addr            == `DMU_BASE0_ADDR;
                         //wrrd_chi_seq.chi_wrdata        == chi_addr+(1'b1<<40);
                         wrrd_chi_seq.chi_ns              == 'b0;
                         wrrd_chi_seq.chi_qos             == 'hf;
                         wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                         wrrd_chi_seq.chi_size            == DENALI_CHI_SIZE_FULLLINE ;
                         wrrd_chi_seq.chi_rsvdc           == 'h0;})
        `endif
      end
    join

    `uvm_info(get_full_name(), "end ctrl mpc 2n test...", UVM_LOW);
    repeat(100) @(tb.clk_noc);

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass

`endif // DMU_CTRL_MPC_VSEQ_SV
