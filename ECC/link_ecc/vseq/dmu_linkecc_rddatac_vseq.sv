/*
 * @Project Name: 
 * @Team: verify.emu
 * @Author: zhonghuai
 * @Email: zhonghuai2056@phytium.com.cn
 * @Date: 2026-04-01 21:45:02
 * @LastEditors: fengqingwei
 * @LastEditTime: 2026-06-02 18:10:18
 * @Descripttion: 
 * @Version: 1.0
 * @Copyright (c) 2026 Phytium.co.Ltd
 */

class dmu_linkecc_rddatac_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_linkecc_rddatac_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  rand bit [`TB_ADDR_WIDTH-1:0] dmu_addr;
  bit [255:0] in_data;
  bit [5:0]   ch_sel;

  apb_lkecc_seq lkecc_seq;
  chi_full_wrard_seq chi_wrard;

  function new(string name="dmu_linkecc_rddatac_vseq");
    super.new(name);
  endfunction

  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    // mr read test
    `uvm_info(get_full_name(), "Start dmu_linkecc_rddatac_vseq...", UVM_LOW)

    `uvm_do_on_with(lkecc_seq,p_sequencer.apb_sqr_[0],
                   {lkecc_seq.mode    == 'h0;})

    // ch_sel = `SIMU_DMU_CH_SEL;
    ch_sel = 6'b001111;

    repeat(1000) @(tb.clk_cfg);

    for (int m = 0; m<128;m++) begin
      `uvm_do_on_with(lkecc_seq,p_sequencer.apb_sqr_[0],
                     {lkecc_seq.mode    == 'h5;})

      for(int i=0;i<4;i++) begin
        fork
          automatic int k=i;
          if(ch_sel[k] == 1) begin
            `uvm_info(get_type_name(),$sformatf("Start ctl%d test !",k),UVM_MEDIUM);
            `uvm_do_on_with(chi_wrard,p_sequencer.chi_vsqr.Down_seqr_ch_[k],
            {chi_wrard.cnt == 1;
            chi_wrard.chi_addr == `DMU_NOC_BASE_ADDR+'h40*m;})
          end
        join_none
      end
      wait fork;
      repeat(100) @(tb.clk_cfg);
    end

    `uvm_info(get_full_name(), "dmu_linkecc_rddatac_vseq complete", UVM_LOW)

    if(starting_phase) starting_phase.drop_objection(this);
  endtask : body

endclass