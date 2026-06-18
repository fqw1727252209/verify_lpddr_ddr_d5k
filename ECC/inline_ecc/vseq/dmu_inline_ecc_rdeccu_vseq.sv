/*
 * @Project Name: 
 * @Team: verify.emu
 * @Author: zhonghuai
 * @Email: zhonghuai2056@phytium.com.cn
 * @Date: 2026-04-01 11:32:03
 * @LastEditors: fengqingwei
 * @LastEditTime: 2026-06-02 18:17:53
 * @Descripttion: 
 * @Version: 1.0
 * @Copyright (c) 2026 Phytium.co.Ltd
 */

class dmu_inline_ecc_rdeccu_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_inline_ecc_rdeccu_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  rand bit [`TB_ADDR_WIDTH-1:0] dmu_addr;
  bit [255:0] in_data;
  bit [5:0]   ch_sel;
  rand bit [2:0] sel_blk_off;
  rand bit [7:0] sel_loc1;
  rand bit [7:0] sel_loc2;

  apb_inline_ecc_seq inline_ecc_seq;
  apb_ras_seq ras_apb_seq;
  chi_wrrd_seq chi_wrrd;
  


  function new(string name="dmu_inline_ecc_rdeccu_vseq");
    super.new(name);
  endfunction

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    // mr read test
    `uvm_info(get_full_name(), "Start dmu_inline_ecc_rdeccu_vseq...", UVM_LOW)

    `uvm_do_on_with(inline_ecc_seq,p_sequencer.apb_sqr_[0],
                   {inline_ecc_seq.mode    == 'h0;})

    `uvm_do_on_with(inline_ecc_seq,p_sequencer.apb_sqr_[0],
                   {inline_ecc_seq.mode    == 'h7;})


    repeat(100) @(tb.clk_cfg);

    // ch_sel = `SIMU_DMU_CH_SEL;
`ifdef MEM_ATTACHED_ddr5sdram
    ch_sel = 6'b001111;
`else
    ch_sel = 6'b000101;
`endif
    `uvm_info(get_type_name(),$sformatf("Starting blk_off loop: blk_off range 0-3"),UVM_MEDIUM);
    for(int blk_off = 0; blk_off < 4; blk_off++) begin
        `uvm_info(get_type_name(),$sformatf("Starting blk_off=%d iteration",blk_off),UVM_MEDIUM);
        `uvm_info(get_type_name(),$sformatf("Starting loc1 loop: loc1 range 0-7 for blk_off=%d",blk_off),UVM_MEDIUM);
        for(int loc1 = 0; loc1 < 8; loc1++) begin
            `uvm_info(get_type_name(),$sformatf("Starting loc1=%d iteration for blk_off=%d",loc1,blk_off),UVM_MEDIUM);
            `uvm_info(get_type_name(),$sformatf("Starting channel loop: i range 0-5 for blk_off=%d, loc1=%d",blk_off,loc1),UVM_MEDIUM);
            for(int i=0;i<4;i++) begin
                automatic int k=i;
                if(ch_sel[k] == 1) begin
                    `uvm_do_on_with(inline_ecc_seq,p_sequencer.apb_sqr_[0],
                                   {inline_ecc_seq.mode        == 'h6;
                                    inline_ecc_seq.sel_blk_off == blk_off;
                                    inline_ecc_seq.sel_loc1    == loc1;
                                    inline_ecc_seq.ch_sel      == ((k < 2) ? 6'b000001 : 6'b000010);
                                    inline_ecc_seq.sel_loc2    == loc1 + 1;})
                    `uvm_info(get_type_name(),$sformatf("Start ctl%d test !",k),UVM_MEDIUM);
                    // p_sequencer.axi4_sqr_[k].env.setMchkState(0);
                    // p_sequencer.axi4_sqr_[k].cfg.no_resp_report=1;
                    `uvm_do_on_with(chi_wrrd,p_sequencer.chi_vsqr.Down_seqr_ch_[k],
                    {chi_wrrd.cnt == 1;
                    chi_wrrd.chi_addr == ((k < 2) ? `DMU_NOC_BASE_ADDR : `DMU_NCC_BASE_ADDR) +
                                          `TB_ADDR_WIDTH'hf200;
                    chi_wrrd.chi_ns == 'b0;
                    chi_wrrd.chi_cancelOnRetryAck == 'b0;
                    chi_wrrd.chi_qos == 'hf;
                    chi_wrrd.chi_rsvdc == 'h0;})
                end
            end
            `uvm_info(get_type_name(),$sformatf("Completed channel loop for blk_off=%d, loc1=%d",blk_off,loc1),UVM_MEDIUM);
        end
        `uvm_info(get_type_name(),$sformatf("Completed loc1 loop for blk_off=%d",blk_off),UVM_MEDIUM);
    end
    `uvm_info(get_type_name(),$sformatf("Completed blk_off loop: all iterations finished"),UVM_MEDIUM);

    `uvm_do_on_with(inline_ecc_seq,p_sequencer.apb_sqr_[0],
                   {inline_ecc_seq.mode    == 'h2;})

    `uvm_info(get_full_name(), "dmu_inline_ecc_rdeccu_vseq complete", UVM_LOW)

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
