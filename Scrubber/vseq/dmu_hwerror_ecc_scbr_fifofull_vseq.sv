class dmu_hwerror_ecc_scbr_fifofull_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_hwerror_ecc_scbr_fifofull_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_hwerror_ecc_scbr_fifofull_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    ecc_scrub_seq;
    //apb_swerror_ecc_loop_seq      ecc_reg_loop_seq;
    ecc_vip_error_seq               ecc_test_vip_seq;
    apb_ras_seq                     ras_apb_seq;
    // apb_rerst_init_seq             rerst_init_apb_seq;

    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;

    bit [255:0]                   in_data;
    bit [`TB_ADDR_WIDTH-1:0]      gen_addr;
    bit [6:0]                     gen_err_col;
    bit [17:0]                    gen_err_row;
    bit [4:0]                     gen_err_ba;
    bit [1:0]                     gen_err_cs;
    bit [2:0]                     gen_err_cid;
    bit [1:0]                     gen_err_lane;
    bit [5:0]                     gen_err_local;

    int                           success;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);

        $display("ecc config end begin data access");

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        //scbr cfg error
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==3;ecc_scrub_seq.scrub_mode==0;ecc_scrub_seq.start_addr==50;ecc_scrub_seq.end_addr==0;ecc_scrub_seq.trig_mode==2'b00;});
        repeat(50) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==1;});//enter hold_mode
        repeat(50) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==0;});//exit hold_mode

        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==0;});

        `uvm_do_on_with(ecc_test_vip_seq,p_sequencer.apb_sqr_[0],{ecc_test_vip_seq.mode==0;
                                ecc_test_vip_seq.ecc_mode==3;
                                ecc_test_vip_seq.wrback==0;
                                ecc_test_vip_seq.error_inject_model==0;
                                ecc_test_vip_seq.error_inject_trig==1;
                                });

        //scbr fifofull
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==3;ecc_scrub_seq.scrub_mode==0;ecc_scrub_seq.start_addr==0;ecc_scrub_seq.end_addr==100;ecc_scrub_seq.trig_mode==2'b00;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==3;ecc_scrub_seq.trig_mode==2'b10;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==1;});
        repeat(500) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==0;});
        repeat(100) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==0;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        `uvm_do_on_with(ecc_test_vip_seq,p_sequencer.apb_sqr_[0],{ecc_test_vip_seq.mode==0;
                                ecc_test_vip_seq.ecc_mode==3;
                                ecc_test_vip_seq.wrback==0;
                                ecc_test_vip_seq.error_inject_model==0;
                                ecc_test_vip_seq.error_inject_trig==0;
                                });
        `uvm_info(get_full_name(), "Finish ecc scrub fifo full test...", UVM_LOW);

        //fix mode
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==0;ecc_scrub_seq.scrub_mode==2'b10;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==1;});
        repeat(100) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==0;});
        repeat(1000) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==0;});

        //scbr_rd_test
        //init mode to hold mode
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==1;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==0;ecc_scrub_seq.scrub_mode=='b100;ecc_scrub_seq.start_addr==0;ecc_scrub_seq.end_addr==120;ecc_scrub_seq.rnd_interval==0;});
        repeat(500) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==0;});
        //period rd mode to hold mode
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==1;});
        repeat(500) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==7;ecc_scrub_seq.hold_mode==0;});

        //period rd mode to init mode
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==0;});
        repeat(10000) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==0;});

        `uvm_info(get_full_name(), "ras ecc_c_status clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h600c00;});

        // //rst_n
        // //denali error
        // `ddr5_alldram_changeSeverity(DENALI_DDR5SDRAM_InvalidSigValue_ck_c, DENALI_DDR5SDRAM_ERR_CONFIG_SEVERITY_Warning);
        // `ddr5_alldram_changeSeverity(DENALI_DDR5SDRAM_InvalidSigValue_ck_t, DENALI_DDR5SDRAM_ERR_CONFIG_SEVERITY_Warning);
        // for (int rcd_i=0; rcd_i<(`RANK_NUM<=2?1:2); rcd_i++) begin
        //     `ddr5_rcd_changeSeverity($sformatf("tb.u_dc.ddr5rdimm.rcd_ddr5[%0d].rcd(cfg)", rcd_i), DENALI_DDR5RCD_TCH_ABS_MIN, DENALI_DDR5RCD_ERR_CONFIG_SEVERITY_Warning);
        //     success=$mmsomaset($sformatf("tb.u_dc.ddr5rdimm.rcd_ddr5[%0d].rcd", rcd_i),"thds","0","ns");
        // end

        // `uvm_do_on(rerst_init_apb_seq,p_sequencer.apb_sqr_[0]);


        // `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
        //                 {wrrd_chi_seq.cnt                  == 100;
        //                  wrrd_chi_seq.chi_addr             == `DMU_BASE0_ADDR+`TB_ADDR_WIDTH'h40;
        //                  wrrd_chi_seq.chi_wrdata           == 0;
        //                  wrrd_chi_seq.chi_ns               == 'b0;
        //                  wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
        //                  wrrd_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
        //                  wrrd_chi_seq.chi_rsvdc            == 'h0;})

        // `ifdef MEM_ATTACHED_DDR5sdram
        // `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
        //                 {wrrd_chi_seq.cnt                  == 100;
        //                  wrrd_chi_seq.chi_addr             == `DMU_BASE0_ADDR+`TB_ADDR_WIDTH'h40;
        //                  wrrd_chi_seq.chi_wrdata           == 0;
        //                  wrrd_chi_seq.chi_ns               == 'b0;
        //                  wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
        //                  wrrd_chi_seq.chi_size             == DENALI_CHI_SIZE_FULLLINE ;
        //                  wrrd_chi_seq.chi_rsvdc            == 'h0;})
        // `endif

        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        // bit sys_result;
        // if(starting_phase) starting_phase.raise_objection(this);
        // repeat(500) @(posedge tb.clk_noc);
        // `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        // `uvm_info(get_full_name(), "ras ecc_c_status clear", UVM_LOW)
        // `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select==9'b100000;});
        // if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass