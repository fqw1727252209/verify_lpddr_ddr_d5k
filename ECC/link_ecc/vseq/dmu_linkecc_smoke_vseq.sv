/*
 * @Project Name:
 * @Team: verify.emu
 * @Author: zhonghuai
 * @Email: zhonghuai2056@phytium.com.cn
 * @Date: 2026-06-16
 * @LastEditors: fengqingwei
 * @LastEditTime: 2026-06-16
 * @Descripttion:
 * @Version: 1.0
 * @Copyright (c) 2026 Phytium.co.Ltd
 */

class dmu_linkecc_smoke_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_linkecc_smoke_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  localparam int SMOKE_CHI_PORT = 0;

  bit [`TB_ADDR_WIDTH-1:0] smoke_addr;
  bit [5:0]                apb_ch_sel;

  apb_lkecc_seq lkecc_seq;
  chi_wr_seq chi_wr;

  function new(string name="dmu_linkecc_smoke_vseq");
    super.new(name);
  endfunction

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    `uvm_info(get_full_name(), "Start dmu_linkecc_smoke_vseq...", UVM_LOW)

    apb_ch_sel = 6'b000001;
    smoke_addr = `DMU_NOC_BASE_ADDR + `TB_ADDR_WIDTH'hf200;

    $display("%0t LKECC_SMOKE: configure Link ECC ch_sel=0x%0h", $time, apb_ch_sel);
    `uvm_do_on_with(lkecc_seq,p_sequencer.apb_sqr_[0],
                   {lkecc_seq.mode   == 'h0;
                    lkecc_seq.ch_sel == apb_ch_sel;})

    repeat(1000) @(tb.clk_cfg);

    $display("%0t LKECC_SMOKE: clear DRAM write status ch_sel=0x%0h", $time, apb_ch_sel);
    `uvm_do_on_with(lkecc_seq,p_sequencer.apb_sqr_[0],
                   {lkecc_seq.mode   == 'hD;
                    lkecc_seq.ch_sel == apb_ch_sel;})

    repeat(100) @(tb.clk_cfg);

    $display("%0t LKECC_SMOKE: arm one write data injection port=%0d addr=0x%0h",
             $time, SMOKE_CHI_PORT, smoke_addr);
    `uvm_do_on_with(lkecc_seq,p_sequencer.apb_sqr_[0],
                   {lkecc_seq.mode                   == 'h1;
                    lkecc_seq.ch_sel                 == apb_ch_sel;
                    lkecc_seq.data_lane_inject1_rand == 0;
                    lkecc_seq.data_loca_inject1_rand == 0;
                    lkecc_seq.mask_lane_inject1_rand == 0;
                    lkecc_seq.mask_loca_inject1_rand == 0;})

    `uvm_do_on_with(chi_wr,p_sequencer.chi_vsqr.Down_seqr_ch_[SMOKE_CHI_PORT],
                   {chi_wr.cnt                 == 1;
                    chi_wr.chi_addr            == smoke_addr;
                    chi_wr.chi_wrdata          == 256'h0123_4567_89ab_cdef_fedc_ba98_7654_3210_55aa_aa55_33cc_cc33_0f0f_f0f0_5a5a_a5a5;
                    chi_wr.chi_ns              == 'b0;
                    chi_wr.chi_cancelOnRetryAck == 'b0;
                    chi_wr.chi_qos             == 'hf;
                    chi_wr.chi_rsvdc           == 'h0;})
    vsqr_chireq_finish(SMOKE_CHI_PORT);

    repeat(500) @(tb.clk_cfg);

    $display("%0t LKECC_SMOKE: check DRAM write status ch_sel=0x%0h", $time, apb_ch_sel);
    `uvm_do_on_with(lkecc_seq,p_sequencer.apb_sqr_[0],
                   {lkecc_seq.mode   == 'hE;
                    lkecc_seq.ch_sel == apb_ch_sel;})

    `uvm_info(get_full_name(), "dmu_linkecc_smoke_vseq complete", UVM_LOW)

    if(starting_phase) starting_phase.drop_objection(this);
  endtask : body

endclass
