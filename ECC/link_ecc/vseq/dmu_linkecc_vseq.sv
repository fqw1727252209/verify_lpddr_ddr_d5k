/*
 * @Project Name: 
 * @Team: verify.emu
 * @Author: zhonghuai
 * @Email: zhonghuai2056@phytium.com.cn
 * @Date: 2026-03-17 17:27:36
 * @LastEditors: fengqingwei
 * @LastEditTime: 2026-06-02 18:10:36
 * @Descripttion: 
 * @Version: 1.0
 * @Copyright (c) 2026 Phytium.co.Ltd
 */

class dmu_linkecc_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_linkecc_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  rand bit [`TB_ADDR_WIDTH-1:0] dmu_addr;
  bit [255:0] in_data;
  bit [5:0]   ch_sel;

  apb_lkecc_seq lkecc_seq;
  apb_ras_seq ras_apb_seq;
  chi_wr_seq chi_wr;

  function new(string name="dmu_linkecc_vseq");
    super.new(name);
  endfunction

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    `uvm_info(get_full_name(), "Start dmu_linkecc_vseq...", UVM_LOW)

    `uvm_do_on_with(lkecc_seq,p_sequencer.apb_sqr_[0],
                   {lkecc_seq.mode == 'h0;})

    `ifdef MEM_ATTACHED_ddr5sdram
    ch_sel = 6'b001111;
    `else
    ch_sel = 6'b000101;
    `endif

    for(int i=0;i<4;i++) begin
      fork
        automatic int k=i;
        if(ch_sel[k] == 1) begin
          `uvm_info(get_type_name(),$sformatf("Start ctl%d test !",k),UVM_MEDIUM);
          `uvm_do_on_with(chi_wr,p_sequencer.chi_vsqr.Down_seqr_ch_[k],
          {chi_wr.cnt == 100;
          chi_wr.chi_addr == ((k < 2) ? `DMU_NOC_BASE_ADDR : `DMU_NCC_BASE_ADDR) +
                              `TB_ADDR_WIDTH'hf800 +
                              ((k % 2) * `TB_ADDR_WIDTH'h10000);
          chi_wr.chi_wrdata == 256'h0123_4567_89ab_cdef_fedc_ba98_7654_3210_55aa_aa55_33cc_cc33_0f0f_f0f0_5a5a_a5a5;
          chi_wr.chi_ns == 'b0;
          chi_wr.chi_cancelOnRetryAck == 'b0;
          chi_wr.chi_qos == 'hf;
          chi_wr.chi_rsvdc == 'h0;})
        end
      join_none
    end
    wait fork;

    repeat(1000) @(tb.clk_cfg);

    `uvm_do_on_with(lkecc_seq,p_sequencer.apb_sqr_[0],
                   {lkecc_seq.mode == 'h1;})

    for(int i=0;i<4;i++) begin
      fork
        automatic int k=i;
        if(ch_sel[k] == 1) begin
          `uvm_info(get_type_name(),$sformatf("Start ctl%d test !",k),UVM_MEDIUM);
          `uvm_do_on_with(chi_wr,p_sequencer.chi_vsqr.Down_seqr_ch_[k],
          {chi_wr.cnt == 100;
          chi_wr.chi_addr == ((k < 2) ? `DMU_NOC_BASE_ADDR : `DMU_NCC_BASE_ADDR) +
                              `TB_ADDR_WIDTH'hf800 +
                              ((k % 2) * `TB_ADDR_WIDTH'h10000);
          chi_wr.chi_wrdata == 256'hfedc_ba98_7654_3210_0123_4567_89ab_cdef_a5a5_5a5a_f0f0_0f0f_cc33_33cc_aa55_55aa;
          chi_wr.chi_ns == 'b0;
          chi_wr.chi_cancelOnRetryAck == 'b0;
          chi_wr.chi_qos == 'hf;
          chi_wr.chi_rsvdc == 'h0;})
        end
      join_none
    end
    wait fork;

    `uvm_info(get_full_name(), "dmu_linkecc_vseq complete", UVM_LOW)

    if(starting_phase) starting_phase.drop_objection(this);
  endtask : body

  virtual task post_body();
    bit sys_result;

    if(starting_phase) starting_phase.raise_objection(this);
    repeat(500) @(posedge tb.clk_noc);
    `uvm_info(get_full_name(), "start post_body.", UVM_LOW)
    `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],
                    {ras_apb_seq.int_trig_mode == 1'b1;
                     ras_apb_seq.int_select    == 'hc0;})
    if(starting_phase) starting_phase.drop_objection(this);
  endtask : post_body

endclass
