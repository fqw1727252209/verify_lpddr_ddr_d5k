`ifndef DMU_CTRL_MR_PDA_VSEQ_SV
`define DMU_CTRL_MR_PDA_VSEQ_SV

class dmu_ctrl_mr_pda_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_mr_pda_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_mr_pda_vseq");
    super.new(name);
  endfunction

  `ifdef SIMU_DMU_APB_FTVIP
    apb_ctrl_mr_pda_seq        apb_ctrl_mr_pda_seq;
  `endif

  chi_full_wrard_seq         full_wrard_chi_seq;
  //chi_ptl_wrrd_seq           ptl_wrrd_chi_seq;
  chi_wrrd_seq               wrrd_chi_seq;
  chi_readAfterWrite_seq     readAfterWrite_chi_seq;
  chi_base_rand_seq          base_rand_chi_seq;

  bit [255:0] in_data;

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    repeat(10) @(tb.clk_noc);

    `uvm_info(get_full_name(), "Start ctrl mrw test...", UVM_LOW);

    // ctrl mr in pda test
    `uvm_do_on_with(apb_ctrl_mr_pda_seq, p_sequencer.apb_sqr_[0], {});

    `uvm_info(get_full_name(), "end ctrl mrw test...", UVM_LOW);
    repeat(100) @(tb.clk_noc);

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass

`endif // DMU_CTRL_MR_PDA_VSEQ_SV
