typedef class dmu_chi_mix_vseq;
class dmu_ctrl_map_addr_rand_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_map_addr_rand_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_map_addr_rand_vseq");
    super.new(name);
  endfunction

  apb_ctrl_map_addr_rand_seq ctrl_map_rand_addr_seq;

  chi_full_wrard_seq        full_wrard_chi_seq;
  //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
  chi_wrrd_seq             wrrd_chi_seq;
  chi_readAfterWrite_seq   readAfterWrite_chi_seq;
  chi_base_rand_seq        base_rand_chi_seq;
  dmu_chi_mix_vseq         chi_mix_vseq;

  bit [`TB_DATA_WIDTH-1:0]  in_data;
  int                       i;

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    `uvm_info(get_type_name(), "Start ctrl map addr rand test...", UVM_LOW);
    //for(i=0;i<20;i++)begin
      `uvm_do_on(ctrl_map_rand_addr_seq,p_sequencer.apb_sqr_[0]);
    //  fork
    //    begin
    //      `uvm_do_on_with(full_wrard_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
    //                      {full_wrard_chi_seq.cnt              == 100;
    //                       full_wrard_chi_seq.chi_addr         == `DMU_BASE0_ADDR;
    //                       full_wrard_chi_seq.chi_wrdata       == chi_addr+(1'b1<<40);
    //                       full_wrard_chi_seq.chi_ns           == 'b0;
    //                       full_wrard_chi_seq.chi_cancelOnRetryAck == 'b0;
    //                       full_wrard_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
    //                       full_wrard_chi_seq.chi_rsvdc        == 'h0;})
    //    end
        
    //    begin
    //      `ifdef MEM_ATTACHED_ddr5sdram
    //      `uvm_do_on_with(full_wrard_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
    //                      {full_wrard_chi_seq.cnt              == 100;
    //                       full_wrard_chi_seq.chi_addr         == `DMU_BASE1_ADDR;
    //                       full_wrard_chi_seq.chi_wrdata       == chi_addr+(1'b1<<40);
    //                       full_wrard_chi_seq.chi_ns           == 'b0;
    //                       full_wrard_chi_seq.chi_cancelOnRetryAck == 'b0;
    //                       full_wrard_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
    //                       full_wrard_chi_seq.chi_rsvdc        == 'h0;})
    //      `endif
    //    end
    //  join
      `uvm_do(chi_mix_vseq);
    //end

    if(starting_phase) starting_phase.drop_objection(this);
  endtask

endclass

class dmu_ctrl_map_addr_perf_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_map_addr_perf_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_map_addr_perf_vseq");
    super.new(name);
  endfunction

  apb_ctrl_map_addr_perf_seq ctrl_map_perf_addr_seq;

  chi_full_wrard_seq        full_wrard_chi_seq;
  //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
  chi_wrrd_seq             wrrd_chi_seq;
  chi_readAfterWrite_seq   readAfterWrite_chi_seq;
  chi_base_rand_seq        base_rand_chi_seq;
  dmu_chi_mix_vseq         chi_mix_vseq;

  bit [`TB_DATA_WIDTH-1:0]  in_data;
  int                       i;

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    `uvm_info(get_type_name(), "Start ctrl map addr rand test...", UVM_LOW);
    `uvm_do_on(ctrl_map_perf_addr_seq,p_sequencer.apb_sqr_[0]);
    fork
      begin
        `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                        {wrrd_chi_seq.cnt              == 100;
                         wrrd_chi_seq.chi_addr         == `DMU_BASE0_ADDR;
                         wrrd_chi_seq.chi_wrdata       == chi_addr+(1'b1<<40);
                         wrrd_chi_seq.chi_ns           == 'b0;
                         wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                         wrrd_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
                         wrrd_chi_seq.chi_rsvdc        == 'h0;})
      end
      
      begin
        `ifdef MEM_ATTACHED_ddr5sdram
        `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                        {wrrd_chi_seq.cnt              == 100;
                         wrrd_chi_seq.chi_addr         == `DMU_BASE1_ADDR;
                         wrrd_chi_seq.chi_wrdata       == chi_addr+(1'b1<<40);
                         wrrd_chi_seq.chi_ns           == 'b0;
                         wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                         wrrd_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
                         wrrd_chi_seq.chi_rsvdc        == 'h0;})
        `endif
      end
    join
    // `uvm_do(chi_mix_vseq);

    if(starting_phase) starting_phase.drop_objection(this);
  endtask

endclass