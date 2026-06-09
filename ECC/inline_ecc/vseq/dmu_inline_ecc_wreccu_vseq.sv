/*
 * @Project Name: 
 * @Team: verify.emu
 * @Author: zhonghuai
 * @Email: zhonghuai2056@phytium.com.cn
 * @Date: 2026-04-01 09:38:44
 * @LastEditors: fengqingwei
 * @LastEditTime: 2026-06-02 18:18:32
 * @Descripttion: 
 * @Version: 1.0
 * @Copyright (c) 2026 Phytium.co.Ltd
 */

class dmu_inline_ecc_wreccu_vseq extends dmu_base_vseq;

  `uvm_object_utils(dmu_inline_ecc_wreccu_vseq)
  `uvm_declare_p_sequencer(my_vsqr)

  rand bit [`TB_ADDR_WIDTH-1:0] dmu_addr;
  bit [255:0] in_data;
  bit [5:0]   ch_sel;
  rand bit [2:0] sel_blk_off;
  rand bit [7:0] sel_loc1;
  rand bit [7:0] sel_loc2;

  apb_inline_ecc_seq inline_ecc_seq;
  // axi_base_seq axi_base;
  // axi_fixed_addr_seq axi_fixed_addr;


  function new(string name="dmu_inline_ecc_wreccu_vseq");
    super.new(name);
  endfunction


  virtual task body();
    if(starting_phase) starting_phase.raise_objection(this);

    // mr read test
    `uvm_info(get_full_name(), "Start dmu_inline_ecc_wreccu_vseq...", UVM_LOW)

    `uvm_do_on_with(inline_ecc_seq,p_sequencer.apb_sqr_[0],
                   {inline_ecc_seq.mode    == 'h0;})



    repeat(100) @(tb.clk_cfg);

    for (int i=0; i<6; i++) begin

    end

    // ch_sel = `SIMU_DMU_CH_SEL;
    ch_sel = 6'b111111;
    for(int blk_off = 0; blk_off < 4; blk_off++) begin
        for(int loc1 = 0; loc1 < 8; loc1++) begin
            `uvm_do_on_with(inline_ecc_seq,p_sequencer.apb_sqr_[0],
                           {inline_ecc_seq.mode    == 'h4;})

            for(int i=0;i<6;i++) begin
                fork
                    automatic int k=i;
                    if(ch_sel[k] == 1) begin
                        `uvm_info(get_type_name(),$sformatf("Start ctl%d test !",k),UVM_MEDIUM);
                        // p_sequencer.axi4_sqr_[k].env.setMchkState(0);
                        // p_sequencer.axi4_sqr_[k].cfg.no_resp_report=1;
                        // `uvm_do_on_with(axi_fixed_addr,p_sequencer.axi4_sqr_[k],
                        //                 {axi_fixed_addr.req_cnt == 1;
                        //                  axi_fixed_addr.addr == 'hf800;})
                    end
                join_none
            end
            wait fork;
        end
    end

    `uvm_info(get_full_name(), "dmu_inline_ecc_wreccu_vseq complete", UVM_LOW)

    if(starting_phase) starting_phase.drop_objection(this);
  endtask : body

endclass