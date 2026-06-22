typedef class dmu_chi_mix_vseq;
class dmu_ecc_scbr_rand_mix_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_ecc_scbr_rand_mix_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_ecc_scbr_rand_mix_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq


    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    ecc_scrub_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;
    chi_rand_wrrd_seq             rand_wrrd_chi_seq;
    dmu_chi_mix_vseq              chi_mix_vseq;

    bit [255:0]                   in_data;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==0;ecc_scrub_seq.scrub_mode==3'b100;start_addr==0;end_addr==1000;});

        `uvm_do(chi_mix_vseq);

        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==3'b100;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==3'b100;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        repeat(1000) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish ecc scrub test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h180;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_sbecc_scbr_port_mix_err_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_sbecc_scbr_port_mix_err_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_sbecc_scbr_port_mix_err_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    ecc_scrub_seq;
    apb_ras_seq                     ras_apb_seq;
    apb_swerror_ecc_loop_seq        ecc_reg_loop_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;
    chi_rand_wrrd_seq             rand_wrrd_chi_seq;
    dmu_chi_mix_vseq              chi_mix_vseq;

    bit [255:0]                   in_data;
    bit [`TB_ADDR_WIDTH-1:0]      gen_addr;
    bit [1:0]                     gen_err_lane;
    bit [5:0]                     gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        gen_addr=(200*(`TB_ADDR_WIDTH'h40))>>6;
        gen_err_lane=$urandom_range(0,3);
        gen_err_local=$urandom_range(0,63);

        `uvm_do_on_with(ecc_reg_loop_seq,p_sequencer.apb_sqr_[0],{ecc_reg_loop_seq.mode==0;
                                ecc_reg_loop_seq.err_mode==2'b10;
                                ecc_reg_loop_seq.ecc_mode==3;
                                ecc_reg_loop_seq.wrback==0;
                                ecc_reg_loop_seq.addr_gen==gen_addr;
                                ecc_reg_loop_seq.err_lane==gen_err_lane;
                                ecc_reg_loop_seq.err_local==gen_err_local;});

        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==0;ecc_scrub_seq.scrub_mode==3'b100;start_addr==180;end_addr==250;});
        fork
        begin
            `uvm_do_on_with(full_wrard_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                            {full_wrard_chi_seq.cnt                  == 10;
                             full_wrard_chi_seq.chi_addr             == `DMU_BASE0_ADDR+`TB_ADDR_WIDTH'h40;
                             full_wrard_chi_seq.chi_wrdata           == chi_addr+(1'b1<<40);
                             full_wrard_chi_seq.chi_ns               == 'b0;
                             //full_wrard_chi_seq.chi_cancelOnRetryAck == 'b0;
                             full_wrard_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             full_wrard_chi_seq.chi_rsvdc            == 'h0;})

        end
        begin
            `ifdef SIMU_DDR_INJECT_MODEL
            `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0001);
                #750ns;
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

            `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0001);
                #750ns;
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);
            `endif
        end
        join
        fork
        begin
            `ifdef MEM_ATTACHED_ddr5sdram
            `uvm_do_on_with(full_wrard_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                            {full_wrard_chi_seq.cnt                  == 10;
                             full_wrard_chi_seq.chi_addr             == `DMU_BASE0_ADDR+`TB_ADDR_WIDTH'h40;
                             full_wrard_chi_seq.chi_wrdata           == chi_addr+(1'b1<<40);
                             full_wrard_chi_seq.chi_ns               == 'b0;
                             //full_wrard_chi_seq.chi_cancelOnRetryAck == 'b0;
                             full_wrard_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             full_wrard_chi_seq.chi_rsvdc            == 'h0;})

            `endif
        end
        begin
            `ifdef SIMU_DDR_INJECT_MODEL
            `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch1 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0001);
                #750ns;
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

            `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch1 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0001);
                #750ns;
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);
            `endif
        end
        join
        `uvm_do(chi_mix_vseq);
        // state check
        `uvm_do_on_with(ecc_reg_loop_seq,p_sequencer.apb_sqr_[0],{ecc_reg_loop_seq.mode==1;ecc_reg_loop_seq.ecc_mode==3;ecc_reg_loop_seq.err_mode==2'b10;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==5;ecc_scrub_seq.err_mode==2'b00;});
        //end scbr
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==3'b100;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==3'b100;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        repeat(1000) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish ecc scrub test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h202080;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_sbecc_scbr_port_mix_uncorrerr_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_sbecc_scbr_port_mix_uncorrerr_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_sbecc_scbr_port_mix_uncorrerr_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_CHI_CHECKERON
    virtual function void configSeq();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.activeUp_ch_[0].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].reconfigure();

        `ifdef MEM_ATTACHED_ddr5sdram
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.activeUp_ch_[1].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].reconfigure();
        `endif
    endfunction:configSeq
    `else
    virtual function void configSeq();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.activeUp_ch_[0].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].reconfigure();

        `ifdef MEM_ATTACHED_ddr5sdram
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.activeUp_ch_[1].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].reconfigure();
        `endif
    endfunction:configSeq
    `endif

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    ecc_scrub_seq;
    apb_ras_seq                     ras_apb_seq;
    apb_swerror_ecc_loop_seq        ecc_reg_loop_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;
    chi_rand_wrrd_seq             rand_wrrd_chi_seq;
    dmu_chi_mix_vseq              chi_mix_vseq;

    bit [255:0]                   in_data;
    bit [`TB_ADDR_WIDTH-1:0]      gen_addr;
    bit [1:0]                     gen_err_lane;
    bit [5:0]                     gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        gen_addr=(200*(`TB_ADDR_WIDTH'h40))>>6;
        gen_err_lane=$urandom_range(0,3);
        gen_err_local=$urandom_range(0,63);

        `uvm_do_on_with(ecc_reg_loop_seq,p_sequencer.apb_sqr_[0],{ecc_reg_loop_seq.mode==0;
                                ecc_reg_loop_seq.err_mode==2'b11;
                                ecc_reg_loop_seq.ecc_mode==3;
                                ecc_reg_loop_seq.wrback==0;
                                ecc_reg_loop_seq.addr_gen==gen_addr;
                                ecc_reg_loop_seq.err_lane==gen_err_lane;
                                ecc_reg_loop_seq.err_local==gen_err_local;});

        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==0;ecc_scrub_seq.scrub_mode==3'b100;start_addr==180;end_addr==250;});
        fork
        begin
            `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                            {wrrd_chi_seq.cnt                  == 10;
                             wrrd_chi_seq.chi_addr             == `DMU_BASE0_ADDR+`TB_ADDR_WIDTH'h40;
                             wrrd_chi_seq.chi_wrdata           == chi_addr+(1'b1<<40);
                             wrrd_chi_seq.chi_ns               == 'b0;
                             //wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                             wrrd_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             wrrd_chi_seq.chi_rsvdc            == 'h0;})

        end
        begin
            `ifdef SIMU_DDR_INJECT_MODEL
            `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0003);
                #750ns;
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

            `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0003);
                #750ns;
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);
            `endif
        end
        join
        fork
        begin
            `ifdef MEM_ATTACHED_ddr5sdram
            `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                            {wrrd_chi_seq.cnt                  == 10;
                             wrrd_chi_seq.chi_addr             == `DMU_BASE0_ADDR+`TB_ADDR_WIDTH'h40;
                             wrrd_chi_seq.chi_wrdata           == chi_addr+(1'b1<<40);
                             wrrd_chi_seq.chi_ns               == 'b0;
                             //wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                             wrrd_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             wrrd_chi_seq.chi_rsvdc            == 'h0;})

            `endif
        end
        begin
            `ifdef SIMU_DDR_INJECT_MODEL
            `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0003);
                #750ns;
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

            `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0003);
                #750ns;
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);
            `endif
        end
        join
        // state check
        `uvm_do_on_with(ecc_reg_loop_seq,p_sequencer.apb_sqr_[0],{ecc_reg_loop_seq.mode==1;ecc_reg_loop_seq.ecc_mode==3;ecc_reg_loop_seq.err_mode==2'b11;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==5;ecc_scrub_seq.err_mode==2'b01;});
        //end scbr
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==3'b100;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==3'b100;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        repeat(1000) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish ecc scrub test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h111180;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_advecc_scbr_rand_mix_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_advecc_scbr_rand_mix_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_advecc_scbr_rand_mix_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    ecc_scrub_seq;
    apb_hwerror_advecc_seq          advecc_test_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;
    chi_mix_vseq                  chi_mix_vseq;
    chi_rand_wrrd_seq             rand_wrrd_chi_seq;

    bit [255:0]                   in_data;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "config advecc set...", UVM_LOW);
        `uvm_do_on_with(advecc_test_seq,p_sequencer.apb_sqr_[0],{advecc_test_seq.mode==0;advecc_test_seq.rsecc_mode==3;advecc_test_seq.grp_type==3;});

        `uvm_info(get_full_name(), "Start advecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==4;ecc_scrub_seq.scrub_mode==3'b100;start_addr==0;ecc_scrub_seq.end_addr==1000;ecc_scrub_seq.grp_type==3;});

        `uvm_do(chi_mix_vseq);

        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==3;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==3;});

        `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
        repeat(1000) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish advecc scrub test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h0180;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_advecc_scbr_port_mix_err_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_advecc_scbr_port_mix_err_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_advecc_scbr_port_mix_err_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    ecc_scrub_seq;
    apb_swerror_advecc_loop_seq     advecc_reg_test_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;
    chi_rand_wrrd_seq             rand_wrrd_chi_seq;
    dmu_chi_mix_vseq              chi_mix_vseq;

    bit [255:0]                   in_data;
    bit [`TB_ADDR_WIDTH-1:0]      gen_addr;
    bit [1:0]                     gen_err_lane;
    bit [5:0]                     gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "config advecc set...", UVM_LOW);
        gen_addr=(200*(`TB_ADDR_WIDTH'h40))>>6;
        `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                advecc_reg_test_seq.rsecc_mode==3;
                                advecc_reg_test_seq.err_mode==3'b011;
                                advecc_reg_test_seq.grp_type==3;
                                advecc_reg_test_seq.addr_gen==gen_addr;
                                });

        `uvm_info(get_full_name(), "Start advecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==4;ecc_scrub_seq.scrub_mode==3;ecc_scrub_seq.start_addr==191;ecc_scrub_seq.end_addr==245;ecc_scrub_seq.grp_type==3;});

        fork
        begin
            `uvm_do_on_with(full_wrard_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                            {full_wrard_chi_seq.cnt                  == 10;
                             full_wrard_chi_seq.chi_addr             == `DMU_BASE0_ADDR;
                             full_wrard_chi_seq.chi_wrdata           == chi_addr+(1'b1<<40);
                             full_wrard_chi_seq.chi_ns               == 'b0;
                             //full_wrard_chi_seq.chi_cancelOnRetryAck == 'b0;
                             full_wrard_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             full_wrard_chi_seq.chi_rsvdc            == 'h0;})
        end
        begin
            `ifdef SIMU_DDR_INJECT_MODEL
            `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0fff);
                #750ns;
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

            `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0fff);
                #750ns;
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);
            `endif
        end
        join
        fork
        begin
            `ifdef MEM_ATTACHED_ddr5sdram
            `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                            {wrrd_chi_seq.cnt                  == 10;
                             wrrd_chi_seq.chi_addr             == `DMU_BASE0_ADDR+3*(`TB_ADDR_WIDTH'h40);
                             wrrd_chi_seq.chi_wrdata           == chi_addr+(1'b1<<40);
                             wrrd_chi_seq.chi_ns               == 'b0;
                             //wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                             wrrd_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             wrrd_chi_seq.chi_rsvdc            == 'h0;})
        end
        begin
            `ifdef SIMU_DDR_INJECT_MODEL
            `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0fff);
                #750ns;
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

            `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0fff);
                #750ns;
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);
            `endif
        end
        join
        //state check
        `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==1;advecc_reg_test_seq.rsecc_mode==3;advecc_reg_test_seq.err_mode==3'b011;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==5;ecc_scrub_seq.err_mode==2'b10;});

        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==3;});
        repeat(5000) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==3;});

        `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
        repeat(100) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish advecc scrub test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_advecc_scbr_port_mix_uncorrerr_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_advecc_scbr_port_mix_uncorrerr_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_advecc_scbr_port_mix_uncorrerr_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_CHI_CHECKERON
    virtual function void configSeq();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.activeUp_ch_[0].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].reconfigure();

        `ifdef MEM_ATTACHED_ddr5sdram
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.activeUp_ch_[1].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].reconfigure();
        `endif
    endfunction:configSeq
    `else
    virtual function void configSeq();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.activeUp_ch_[0].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].reconfigure();

        `ifdef MEM_ATTACHED_ddr5sdram
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.activeUp_ch_[1].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].reconfigure();
        `endif
    endfunction:configSeq
    `endif

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    ecc_scrub_seq;
    apb_swerror_advecc_loop_seq     advecc_reg_test_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;
    chi_rand_wrrd_seq             rand_wrrd_chi_seq;
    dmu_chi_mix_vseq              chi_mix_vseq;

    bit [255:0]                   in_data;
    bit [`TB_ADDR_WIDTH-1:0]      gen_addr;
    bit [1:0]                     gen_err_lane;
    bit [5:0]                     gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "config advecc set...", UVM_LOW);
        gen_addr=(200*(`TB_ADDR_WIDTH'h40))>>6;
        `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                advecc_reg_test_seq.rsecc_mode==3;
                                advecc_reg_test_seq.err_mode==3'b011;
                                advecc_reg_test_seq.grp_type==3;
                                advecc_reg_test_seq.addr_gen==gen_addr;
                                });

        `uvm_info(get_full_name(), "Start advecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==4;ecc_scrub_seq.scrub_mode==3;ecc_scrub_seq.start_addr==191;ecc_scrub_seq.end_addr==245;ecc_scrub_seq.grp_type==3;});

        fork
        begin
            `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                            {wrrd_chi_seq.cnt                  == 10;
                             wrrd_chi_seq.chi_addr             == `DMU_BASE0_ADDR;
                             wrrd_chi_seq.chi_wrdata           == chi_addr+(1'b1<<40);
                             wrrd_chi_seq.chi_ns               == 'b0;
                             //wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                             wrrd_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             wrrd_chi_seq.chi_rsvdc            == 'h0;})
        end
        begin
            `ifdef SIMU_DDR_INJECT_MODEL
            `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_ffff);
                #750ns;
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

            `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_ffff);
                #750ns;
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);
            `endif
        end
        join
        fork
        begin
            `ifdef MEM_ATTACHED_ddr5sdram
            `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                            {wrrd_chi_seq.cnt                  == 10;
                             wrrd_chi_seq.chi_addr             == `DMU_BASE0_ADDR+3*(`TB_ADDR_WIDTH'h40);
                             wrrd_chi_seq.chi_wrdata           == chi_addr+(1'b1<<40);
                             wrrd_chi_seq.chi_ns               == 'b0;
                             //wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                             wrrd_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             wrrd_chi_seq.chi_rsvdc            == 'h0;})
        end
        begin
            `ifdef SIMU_DDR_INJECT_MODEL
            `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_ffff);
                #750ns;
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

            `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch0 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_ffff);
                #750ns;
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);
            `endif
        end
        join
        //state check
        `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==1;advecc_reg_test_seq.rsecc_mode==3;advecc_reg_test_seq.err_mode==3'b011;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==5;ecc_scrub_seq.err_mode==2'b11;});

        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==3;});
        repeat(5000) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==3;});

        `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
        repeat(100) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish advecc scrub test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h0633000;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass