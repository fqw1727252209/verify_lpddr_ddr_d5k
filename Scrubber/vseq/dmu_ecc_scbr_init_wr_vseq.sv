class dmu_ecc_scbr_init_wr_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_ecc_scbr_init_wr_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_ecc_scbr_init_wr_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_CHI_CHECKERON
    virtual function void configSeq();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].reconfigure();

        `ifdef MEM_ATTACHED_ddr5sdram
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].reconfigure();
        `endif
    endfunction:configSeq
    `else
    virtual function void configSeq();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].reconfigure();

        `ifdef MEM_ATTACHED_ddr5sdram
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].reconfigure();
        `endif
    endfunction:configSeq
    `endif

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    ecc_scrub_seq;
    ecc_vip_error_seq               ecc_test_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "Start ecc_scrub init wr set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==0;ecc_scrub_seq.scrub_mode==1;ecc_scrub_seq.start_addr==0;ecc_scrub_seq.end_addr==100;ecc_scrub_seq.wdata=='h1234_5678;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==1;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==1;});
        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        repeat(1000) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_test_seq,p_sequencer.apb_sqr_[0],{ecc_test_seq.mode==0;ecc_test_seq.wrback==0;ecc_test_seq.ecc_mode==3;ecc_test_seq.error_inject_trig==0;});

        fork
        begin
            `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                            {rd_seq.cnt                  == 100;
                             rd_seq.chi_addr             == `DMU_BASE0_ADDR;
                             rd_seq.chi_ns               == 'b0;
                             rd_seq.chi_cancelOnRetryAck == 'b0;
                             rd_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             rd_seq.chi_rsvdc            == 'h0;})

        end

        begin
            `ifdef MEM_ATTACHED_ddr5sdram
            `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                            {rd_seq.cnt                  == 100;
                             rd_seq.chi_addr             == `DMU_BASE0_ADDR;
                             rd_seq.chi_ns               == 'b0;
                             rd_seq.chi_cancelOnRetryAck == 'b0;
                             rd_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                             rd_seq.chi_rsvdc            == 'h0;})

            `endif
        end
        join
        vsqr_chireq_finish(2);
        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Finish ecc scrub init wr test...", UVM_LOW);

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

class dmu_advecc_scbr_init_wr_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_advecc_scbr_init_wr_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_advecc_scbr_init_wr_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_CHI_CHECKERON
    virtual function void configSeq();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].reconfigure();

        `ifdef MEM_ATTACHED_ddr5sdram
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].cfg.UsingMainMemory = 1;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].reconfigure();
        `endif
    endfunction:configSeq
    `else
    virtual function void configSeq();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[0].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[0].reconfigure();

        `ifdef MEM_ATTACHED_ddr5sdram
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].cfg.UsingMainMemory = 0;
        p_sequencer.chi_vsqr.pEnv.passiveUp_ch_[1].reconfigure();
        p_sequencer.chi_vsqr.pEnv.activeDown_ch_[1].reconfigure();
        `endif
    endfunction:configSeq
    `endif

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    advecc_scrub_seq;
    apb_hwerror_advecc_seq          advecc_test_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "Start advecc_scrub init wr set...", UVM_LOW);
        for(int i=3;i<6;i++)begin
            `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==1;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr==100;advecc_scrub_seq.wdata=='habcdef01;advecc_scrub_seq.grp_type==i;});
            `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==1;});
            `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==1;});
            `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
            repeat(1000) @(posedge tb.clk_noc);
            `uvm_do_on_with(advecc_test_seq,p_sequencer.apb_sqr_[0],{advecc_test_seq.mode==0;advecc_test_seq.rsecc_mode==3;advecc_test_seq.grp_type==i;});
            fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                  == 100;
                                 rd_seq.chi_addr             == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns               == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc            == 'h0;})

            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                  == 100;
                                 rd_seq.chi_addr             == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns               == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc            == 'h0;})

                `endif
            end
            join
            vsqr_chireq_finish(2);
            repeat(100) @(posedge tb.clk_noc);
        end

        `uvm_info(get_full_name(), "Finish ecc scrub init wr test...", UVM_LOW);

        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h00600000;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass