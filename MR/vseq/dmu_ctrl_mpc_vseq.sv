class dmu_ctrl_mpc_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_ctrl_mpc_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  function new(string name="dmu_ctrl_mpc_vseq");
    super.new(name);
  endfunction
  `ifdef SIMU_DMU_APB_FTVIP
    apb_ctrl_mr_seq          apb_ctrl_mpc_seq;
  `endif

  chi_full_wrard_seq        full_wrard_chi_seq;
  //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
  chi_wrrd_seq             wrrd_chi_seq;
  chi_wrrd_map_seq         wrrd_map_chi_seq;
  chi_readAfterWrite_seq   readAfterWrite_chi_seq;
  chi_base_rand_seq        base_rand_chi_seq;

  bit [255:0]  in_data;
  int in_cnt=1000;


  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    repeat(10) @(tb.clk_noc);

    `uvm_info(get_full_name(), "Start ctrl mpc test...", UVM_LOW);
    `uvm_do_on_with(apb_ctrl_mpc_seq,p_sequencer.apb_sqr_[0],{});

    fork
      begin
        //range0: DMU_NOC_BASE_ADDR~DMU_HIGH0_ADDR
        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0],
          {full_wrard_chi_seq.cnt            == 5;
           full_wrard_chi_seq.chi_addr       == `DMU_NOC_BASE_ADDR;
           full_wrard_chi_seq.chi_wrdata     == 'h12345678;
           full_wrard_chi_seq.chi_ns         == 'b0;
           //full_wrard_chi_seq.chi_size       == DENALI_CHI_SIZE_FULLLINE ;
           full_wrard_chi_seq.chi_rsvdc      == 'h0;})

        //range0: DMU_NOC_BASE_ADDR~DMU_HIGH0_ADDR
        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0],
          {full_wrard_chi_seq.cnt            == 5;
           full_wrard_chi_seq.chi_addr       == `DMU_NOC_BASE_ADDR + `TB_ADDR_WIDTH'h1000;
           //full_wrard_chi_seq.chi_wrdata     == chi_addr+(1'b1<<40);
           full_wrard_chi_seq.chi_ns         == 'b1;
           //full_wrard_chi_seq.chi_size       == DENALI_CHI_SIZE_FULLLINE ;
           full_wrard_chi_seq.chi_rsvdc      == 'h0;})

        `uvm_do_on_with(wrrd_map_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0],
          {wrrd_map_chi_seq.cnt              == 5;
           wrrd_map_chi_seq.chi_addr         == `DMU_NOC_BASE_ADDR;
           wrrd_map_chi_seq.step_addr        == `TB_ADDR_WIDTH'h20;
           wrrd_map_chi_seq.chi_ns           == 'b0;
           wrrd_map_chi_seq.chi_qos          == 'hf;
           wrrd_map_chi_seq.chi_cancelOnRetryAck == 'b0;
           wrrd_map_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
           wrrd_map_chi_seq.chi_rsvdc        == 'h0;})
      end
      begin
        //range0: DMU_NOC_BASE_ADDR~DMU_HIGH0_ADDR
        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[2],
          {full_wrard_chi_seq.cnt            == 5;
           full_wrard_chi_seq.chi_addr       == `DMU_NCC_BASE_ADDR;
           full_wrard_chi_seq.chi_wrdata     == 'h12345678;
           full_wrard_chi_seq.chi_ns         == 'b0;
           //full_wrard_chi_seq.chi_size       == DENALI_CHI_SIZE_FULLLINE ;
           full_wrard_chi_seq.chi_rsvdc      == 'h0;})

        //range0: DMU_NOC_BASE_ADDR~DMU_HIGH0_ADDR
        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[2],
          {full_wrard_chi_seq.cnt            == 5;
           full_wrard_chi_seq.chi_addr       == `DMU_NCC_BASE_ADDR + `TB_ADDR_WIDTH'h1000;
           //full_wrard_chi_seq.chi_wrdata     == chi_addr+(1'b1<<40);
           full_wrard_chi_seq.chi_ns         == 'b1;
           //full_wrard_chi_seq.chi_size       == DENALI_CHI_SIZE_FULLLINE ;
           full_wrard_chi_seq.chi_rsvdc      == 'h0;})

        `uvm_do_on_with(wrrd_map_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[2],
          {wrrd_map_chi_seq.cnt              == 5;
           wrrd_map_chi_seq.chi_addr         == `DMU_NCC_BASE_ADDR;
           wrrd_map_chi_seq.step_addr        == `TB_ADDR_WIDTH'h20;
           wrrd_map_chi_seq.chi_ns           == 'b0;
           wrrd_map_chi_seq.chi_qos          == 'hf;
           wrrd_map_chi_seq.chi_cancelOnRetryAck == 'b0;
           wrrd_map_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
           wrrd_map_chi_seq.chi_rsvdc        == 'h0;})
      end
      begin
        //range0: DMU_NOC_BASE_ADDR~DMU_HIGH0_ADDR
        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1],
          {full_wrard_chi_seq.cnt            == 5;
           full_wrard_chi_seq.chi_addr       == `DMU_NOC_BASE_ADDR;
           //full_wrard_chi_seq.chi_wrdata     == chi_addr+(1'b1<<40);
           full_wrard_chi_seq.chi_ns         == 'b0;
           //full_wrard_chi_seq.chi_size       == DENALI_CHI_SIZE_FULLLINE ;
           full_wrard_chi_seq.chi_rsvdc      == 'h0;})

        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1],
          {full_wrard_chi_seq.cnt            == 4;
           full_wrard_chi_seq.chi_addr       == `DMU_NOC_BASE_ADDR + 'h1000;
           //full_wrard_chi_seq.chi_wrdata     == chi_addr+(1'b1<<40);
           full_wrard_chi_seq.chi_ns         == 'b0;
           //full_wrard_chi_seq.chi_size       == DENALI_CHI_SIZE_FULLLINE ;
           full_wrard_chi_seq.chi_rsvdc      == 'h0;})

        `uvm_do_on_with(wrrd_map_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1],
          {wrrd_map_chi_seq.cnt              == 5;
           wrrd_map_chi_seq.chi_addr         == `DMU_NOC_BASE_ADDR;
           wrrd_map_chi_seq.step_addr        == `TB_ADDR_WIDTH'h20;
           wrrd_map_chi_seq.chi_ns           == 'b0;
           wrrd_map_chi_seq.chi_qos          == 'hf;
           wrrd_map_chi_seq.chi_cancelOnRetryAck == 'b0;
           wrrd_map_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
           wrrd_map_chi_seq.chi_rsvdc        == 'h0;})
      end
      begin
        //range0: DMU_NOC_BASE_ADDR~DMU_HIGH0_ADDR
        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[3],
          {full_wrard_chi_seq.cnt            == 5;
           full_wrard_chi_seq.chi_addr       == `DMU_NCC_BASE_ADDR;
           //full_wrard_chi_seq.chi_wrdata     == chi_addr+(1'b1<<40);
           full_wrard_chi_seq.chi_ns         == 'b0;
           //full_wrard_chi_seq.chi_size       == DENALI_CHI_SIZE_FULLLINE ;
           full_wrard_chi_seq.chi_rsvdc      == 'h0;})

        `uvm_do_on_with(full_wrard_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[3],
          {full_wrard_chi_seq.cnt            == 4;
           full_wrard_chi_seq.chi_addr       == `DMU_NCC_BASE_ADDR + 'h1000;
           //full_wrard_chi_seq.chi_wrdata     == chi_addr+(1'b1<<40);
           full_wrard_chi_seq.chi_ns         == 'b0;
           //full_wrard_chi_seq.chi_size       == DENALI_CHI_SIZE_FULLLINE ;
           full_wrard_chi_seq.chi_rsvdc      == 'h0;})

        `uvm_do_on_with(wrrd_map_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[3],
          {wrrd_map_chi_seq.cnt              == 5;
           wrrd_map_chi_seq.chi_addr         == `DMU_NCC_BASE_ADDR;
           wrrd_map_chi_seq.step_addr        == `TB_ADDR_WIDTH'h20;
           wrrd_map_chi_seq.chi_ns           == 'b0;
           wrrd_map_chi_seq.chi_qos          == 'hf;
           wrrd_map_chi_seq.chi_cancelOnRetryAck == 'b0;
           wrrd_map_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
           wrrd_map_chi_seq.chi_rsvdc        == 'h0;})
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
    apb_ctrl_mr_seq          apb_ctrl_mpc_2n_seq;
  `endif

  chi_full_wrard_seq        full_wrard_chi_seq;
  //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
  chi_wrrd_seq             wrrd_chi_seq;
  chi_readAfterWrite_seq   readAfterWrite_chi_seq;
  chi_base_rand_seq        base_rand_chi_seq;

  bit [255:0]  in_data;
  int in_cnt=1000;


  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    repeat(10) @(tb.clk_noc);

    `uvm_info(get_full_name(), "Start ctrl mpc 2n test...", UVM_LOW);
    `uvm_do_on_with(apb_ctrl_mpc_2n_seq,p_sequencer.apb_sqr_[0],{});
    fork
      begin
        `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                      {wrrd_chi_seq.cnt              == in_cnt;
                       wrrd_chi_seq.chi_addr         == `DMU_BASE0_ADDR;
                       //wrrd_chi_seq.chi_wrdata       == chi_addr+(1'b1<<40);
                       wrrd_chi_seq.chi_ns           == 'b0;
                       wrrd_chi_seq.chi_qos          == 'hf;
                       wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                       wrrd_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
                       wrrd_chi_seq.chi_rsvdc        == 'h0;})
      end

      begin
        `ifdef MEM_ATTACHED_ddr5sdram
        `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                      {wrrd_chi_seq.cnt              == in_cnt;
                       wrrd_chi_seq.chi_addr         == `DMU_BASE0_ADDR;
                       //wrrd_chi_seq.chi_wrdata       == chi_addr+(1'b1<<40);
                       wrrd_chi_seq.chi_ns           == 'b0;
                       wrrd_chi_seq.chi_qos          == 'hf;
                       wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                       wrrd_chi_seq.chi_size         == DENALI_CHI_SIZE_FULLLINE ;
                       wrrd_chi_seq.chi_rsvdc        == 'h0;})
        `endif
      end
    join


    `uvm_info(get_full_name(), "end ctrl mpc 2n test...", UVM_LOW);
    repeat(100) @(tb.clk_noc);

    if(starting_phase) starting_phase.drop_objection(this);

  endtask

endclass
