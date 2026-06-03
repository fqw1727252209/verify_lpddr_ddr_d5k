`ifndef DMU_MRR_MRW_VSEQ_SV
`define DMU_MRR_MRW_VSEQ_SV

function automatic void lpddr5_dram_changeSeverity(string PATH, int ERRID, int SVR);
  automatic integer regid;
  automatic integer result;
  automatic integer error_reg;
  regid = $mminstanceid(PATH);
  error_reg = 0;
  // Note: Using generic types for DENALI constants assuming they are defined elsewhere in the environment.
  error_reg = error_reg | (ERRID << DENALI_LPDDR5_Rpos__DEN_ERR_CTRL_ErrId) | (SVR << DENALI_LPDDR5_Rpos__DEN_ERR_CTRL_Severity) ;
  result = $mmwriteword4(regid, DENALI_LPDDR5_REG_DEN_ERR_CTRL, error_reg);
endfunction

class dmu_mrr_mrw_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_mrr_mrw_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  rand bit [`TB_ADDR_WIDTH-1:0] dmu_addr;
  bit [255:0] in_data;

  apb_mr_seq mr_apb_seq;

  function new(string name="dmu_mrr_mrw_vseq");
    super.new(name);
  endfunction

  `define MRW_VIOLATED(index) \
    begin \
      integer result; \
      for (int j=0; j<`RANK_NUM; j++) begin \
        for (int k=0; k<32/`DRAM_WIDTH; k++) begin \
          lpddr5_dram_changeSeverity($sformatf("tb.lpddr5_ch%0d.rank[%0d].mdat[%0d].comp(cfg)", index, j, k), DENALI_LPDDR5_MR_RESERVED, DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info); \
          lpddr5_dram_changeSeverity($sformatf("tb.lpddr5_ch%0d.rank[%0d].mdat[%0d].comp(cfg)", index, j, k), DENALI_LPDDR5_MRR_TO_NON_READABLE_REG, DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info); \
        end \
      end \
    end

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);
    if(ch_sel[0] == 'b1) begin
      `MRW_VIOLATED(0)
    end
    if(ch_sel[1] == 'b1) begin
      `MRW_VIOLATED(1)
    end
    if(ch_sel[2] == 'b1) begin
      `MRW_VIOLATED(2)
    end
    if(ch_sel[3] == 'b1) begin
      `MRW_VIOLATED(3)
    end
    if(ch_sel[4] == 'b1) begin
      `MRW_VIOLATED(4)
    end
    if(ch_sel[5] == 'b1) begin
      `MRW_VIOLATED(5)
    end

    // mr read test
    `uvm_info(get_full_name(), "Start dmu_mrr_mrw_vseq...", UVM_LOW);

    `uvm_do_on_with(mr_apb_seq, p_sequencer.apb_sqr_[0],
                    {mr_apb_seq.mode == 'h0;})

    // mr write after read test and check
    `uvm_do_on_with(mr_apb_seq, p_sequencer.apb_sqr_[0],
                    {mr_apb_seq.mode == 'h1;})

    `uvm_do_on_with(mr_apb_seq, p_sequencer.apb_sqr_[0],
                    {mr_apb_seq.mode == 'h2;})

    `uvm_info(get_full_name(), "dmu_mrr_mrw_vseq complete", UVM_LOW);

    if(starting_phase) starting_phase.drop_objection(this);
  endtask : body

endclass

`endif // DMU_MRR_MRW_VSEQ_SV
