
class dmu_ctrl_mr_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_mr_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_mr_vseq");
    super.new(name);
  endfunction
  `ifdef SIMU_DMU_APB_FTVIP
    apb_ctrl_mr_seq            apb_ctrl_mr_seq;
  `endif

  chi_full_wrard_seq        full_wrard_chi_seq;
  //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
  chi_wrrd_seq             wrrd_chi_seq;
  chi_readAfterWrite_seq   readAfterWrite_chi_seq;
  chi_base_rand_seq        base_rand_chi_seq;

  bit [255:0]  in_data;

`ifdef dram_lpddr5
  function automatic void lpddr5_dram_change_severity(string path, int err_id, int severity);
    automatic integer regid;
    automatic integer result;
    automatic integer error_reg;

    regid = $mminstanceid(path);
    error_reg = 0;
    error_reg = error_reg |
                (err_id   << DENALI_LPDDR5_Rpos__DEN_ERR_CTRL_ErrId) |
                (severity << DENALI_LPDDR5_Rpos__DEN_ERR_CTRL_Severity);
    result = $mmwriteword4(regid, DENALI_LPDDR5_REG_DEN_ERR_CTRL, error_reg);
  endfunction

  task lpddr5_dram_mr_error_to_info();
    for(int ch_idx = 0; ch_idx < 2; ch_idx++) begin
      for(int rank_idx = 0; rank_idx < `RANK_NUM; rank_idx++) begin
        for(int mdat_idx = 0; mdat_idx < 32/`DRAM_WIDTH; mdat_idx++) begin
          lpddr5_dram_change_severity($sformatf("tb.u_dc.lpddr5_ch%0d.rank[%0d].mdat[%0d].comp(cfg)",
                                                ch_idx, rank_idx, mdat_idx),
                                      DENALI_LPDDR5_MR_RESERVED,
                                      DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
          lpddr5_dram_change_severity($sformatf("tb.u_dc.lpddr5_ch%0d.rank[%0d].mdat[%0d].comp(cfg)",
                                                ch_idx, rank_idx, mdat_idx),
                                      DENALI_LPDDR5_MRR_TO_NON_READABLE_REG,
                                      DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
        end
      end
    end
    `uvm_info(get_full_name(), "LPDDR5 MR model reserved/non-readable errors changed to Info", UVM_LOW);
  endtask
`endif

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    repeat(10) @(tb.clk_noc);

    `uvm_info(get_full_name(), "Start ctrl mrw test...", UVM_LOW);

`ifdef dram_lpddr5
    lpddr5_dram_mr_error_to_info();
`endif

    // ctrl mrw test
    `uvm_do_on_with(apb_ctrl_mr_seq,p_sequencer.apb_sqr_[0],{});

    `uvm_info(get_full_name(), "end ctrl mrw test...", UVM_LOW);
    repeat(100) @(tb.clk_noc);

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass

