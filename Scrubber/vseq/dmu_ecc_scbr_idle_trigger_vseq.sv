class dmu_ecc_scbr_idle_trigger_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_ecc_scbr_idle_trigger_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_ecc_scbr_idle_trigger_vseq");
        super.new(name);
    endfunction

    //for reconfig
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

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq ecc_scrub_seq;
    ecc_vip_error_seq            ecc_test_seq;
    apb_ras_seq                  ras_apb_seq;
    `endif

    chi_full_wrard_seq       full_wrard_chi_seq;
    chi_wrrd_seq             wrrd_chi_seq;
    chi_readAfterWrite_seq   readAfterWrite_chi_seq;
    chi_base_rand_seq        base_rand_chi_seq;
    chi_rd_compare_seq       rd_compare_seq;

    // Test parameters
    rand bit [15:0] idle_cnt_value;
    rand int         normal_req_delay;
    rand int         post_scbr_delay;

    constraint c_idle_cnt {
        idle_cnt_value inside {16'd990, 16'd500, 16'd100, 16'd10};
    }

    constraint c_delay {
        normal_req_delay inside {1000, 800, 600};
        post_scbr_delay inside {2000, 3000, 5000};
    }

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);

        //==============================================================
        // Test Case 1: Idle trigger with normal request interrupt
        //==============================================================
        `uvm_info(get_full_name(), "=== Test Case 1: Idle trigger with interrupt ===", UVM_LOW);
        test_idle_trigger_with_interrupt();

        repeat(1000) @(posedge tb.clk_noc);

        //==============================================================
        // Test Case 2: Idle trigger completes before normal request
        //==============================================================
        `uvm_info(get_full_name(), "=== Test Case 2: Idle trigger completes early ===", UVM_LOW);
        test_idle_trigger_early_complete();

        repeat(1000) @(posedge tb.clk_noc);

        //==============================================================
        // Test Case 3: Idle trigger disabled (idle_cnt = 0)
        //==============================================================
        `uvm_info(get_full_name(), "=== Test Case 3: Idle trigger disabled ===", UVM_LOW);
        test_idle_trigger_disabled();

        repeat(1000) @(posedge tb.clk_noc);

        //==============================================================
        // Test Case 4: RndInterval between rounds (multiple rounds)
        //==============================================================
        `uvm_info(get_full_name(), "=== Test Case 4: RndInterval between rounds ===", UVM_LOW);
        test_rnd_interval_between_rounds();

        `uvm_info(get_full_name(), "Finish ecc scrub idle trigger test...", UVM_LOW);

        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    //--------------------------------------------------------------------------
    // Test Case 1: Idle trigger works, but normal request interrupts
    //--------------------------------------------------------------------------
    virtual task test_idle_trigger_with_interrupt();
        // Configure Scrubber with idle_cnt = 990, normal request delay = 1000
        `uvm_info(get_full_name(), $sformatf("Config: idle_cnt=%0d, normal_req_delay=%0d", idle_cnt_value, normal_req_delay), UVM_LOW);

        fork
            begin
                // Scrubber process
                // Configure with idle_cnt and long period
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 0;
                    ecc_scrub_seq.scrub_mode  == 3;      // Periodic RMW
                    ecc_scrub_seq.start_addr  == 0;
                    ecc_scrub_seq.end_addr    == 50;
                    ecc_scrub_seq.idle_cnt    == 16'd990; // Idle trigger after 990 cycles
                });

                // Wait for scrubber to be triggered by idle
                `uvm_info(get_full_name(), "Waiting for scrubber round done...", UVM_LOW);
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 1;
                    ecc_scrub_seq.scrub_mode  == 3;
                });

                // End scrubber
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 2;
                    ecc_scrub_seq.scrub_mode  == 3;
                });
            end
            begin
                // Normal request process with delay
                // Delay to let idle trigger happen first
                repeat(1000) @(posedge tb.clk_noc);

                `uvm_info(get_full_name(), "Normal requests start (interrupting scrubber)...", UVM_LOW);
                fork
                    begin
                        `uvm_do_on_with(wrrd_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
                            wrrd_chi_seq.cnt                == 50;
                            wrrd_chi_seq.chi_addr           == `DMU_BASE0_ADDR;
                            wrrd_chi_seq.chi_ns             == 'b0;
                            wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                            wrrd_chi_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE;
                            wrrd_chi_seq.chi_rsvdc          == 'h0;
                        })
                    end
                    begin
                        `ifdef MEM_ATTACHED_ddr5sdram
                        `uvm_do_on_with(wrrd_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1], {
                            wrrd_chi_seq.cnt                == 50;
                            wrrd_chi_seq.chi_addr           == `DMU_BASE0_ADDR;
                            wrrd_chi_seq.chi_ns             == 'b0;
                            wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                            wrrd_chi_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE;
                            wrrd_chi_seq.chi_rsvdc          == 'h0;
                        })
                        `endif
                    end
                join
                `uvm_info(get_full_name(), "Normal requests done, CQ idle again...", UVM_LOW);

                // Delay to let scrubber continue and complete
                repeat(2000) @(posedge tb.clk_noc);
            end
        join

        `uvm_info(get_full_name(), "Test Case 1 completed", UVM_LOW);
    endtask

    //--------------------------------------------------------------------------
    // Test Case 2: Idle trigger completes before normal request arrives
    //--------------------------------------------------------------------------
    virtual task test_idle_trigger_early_complete();
        `uvm_info(get_full_name(), "Config: idle_cnt=100, normal_req_delay=5000", UVM_LOW);

        fork
            begin
                // Scrubber process with short idle_cnt
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 0;
                    ecc_scrub_seq.scrub_mode  == 0;      // Periodic RD (faster)
                    ecc_scrub_seq.start_addr  == 0;
                    ecc_scrub_seq.end_addr    == 20;     // Small range
                    ecc_scrub_seq.idle_cnt    == 16'd100; // Quick idle trigger
                });

                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 1;
                    ecc_scrub_seq.scrub_mode  == 0;
                });

                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 2;
                    ecc_scrub_seq.scrub_mode  == 0;
                });
            end
            begin
                // Normal request with long delay (scrubber completes first)
                repeat(5000) @(posedge tb.clk_noc);

                `uvm_info(get_full_name(), "Normal requests start (after scrubber done)...", UVM_LOW);
                fork
                    begin
                        `uvm_do_on_with(rd_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
                            rd_seq.cnt                == 20;
                            rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                            rd_seq.chi_ns             == 'b0;
                            rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE;
                            rd_seq.chi_rsvdc          == 'h0;
                        })
                    end
                    begin
                        `ifdef MEM_ATTACHED_ddr5sdram
                        `uvm_do_on_with(rd_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1], {
                            rd_seq.cnt                == 20;
                            rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                            rd_seq.chi_ns             == 'b0;
                            rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE;
                            rd_seq.chi_rsvdc          == 'h0;
                        })
                        `endif
                    end
                join
            end
        join

        `uvm_info(get_full_name(), "Test Case 2 completed", UVM_LOW);
    endtask

    //--------------------------------------------------------------------------
    // Test Case 3: Idle trigger disabled (idle_cnt = 0)
    //--------------------------------------------------------------------------
    virtual task test_idle_trigger_disabled();
        `uvm_info(get_full_name(), "Config: idle_cnt=0 (disabled), verifying no early trigger", UVM_LOW);

        fork
            begin
                // Scrubber process with idle_cnt = 0 (disabled)
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 0;
                    ecc_scrub_seq.scrub_mode  == 3;
                    ecc_scrub_seq.start_addr  == 0;
                    ecc_scrub_seq.end_addr    == 10;
                    ecc_scrub_seq.idle_cnt    == 16'd0;  // Disabled
                });

                // Small delay - scrubber should NOT start early
                repeat(500) @(posedge tb.clk_noc);

                // Start some traffic to make CQ busy then idle
                `uvm_do_on_with(wrrd_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
                    wrrd_chi_seq.cnt                == 10;
                    wrrd_chi_seq.chi_addr           == `DMU_BASE0_ADDR;
                    wrrd_chi_seq.chi_ns             == 'b0;
                    wrrd_chi_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE;
                    wrrd_chi_seq.chi_rsvdc          == 'h0;
                })

                // Wait for scrubber to complete via normal period
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 1;
                    ecc_scrub_seq.scrub_mode  == 3;
                });

                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 2;
                    ecc_scrub_seq.scrub_mode  == 3;
                });
            end
        join

        `uvm_info(get_full_name(), "Test Case 3 completed", UVM_LOW);
    endtask

    //--------------------------------------------------------------------------
    // Test Case 4: RndInterval between rounds - multiple rounds in one enable
    //--------------------------------------------------------------------------
    virtual task test_rnd_interval_between_rounds();
        int round_count;
        int expected_interval;
        
        // Configure: RndInterval=5, idle_cnt=10000 (larger than RndInterval)
        // This tests the interval between Round 1 and Round 2
        // idle_cnt=10000 > rnd_interval=2560, so rnd_interval will trigger first
        `uvm_info(get_full_name(), "Config: RndInterval=5, idle_cnt=10000, testing multi-round behavior", UVM_LOW);
        
        expected_interval = 5 * 512;  // 2560 cycles
        
        fork
            begin
                // Scrubber process with RndInterval configured
                // Note: scrub_mode[2]=1 enables RndInterval feature
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 0;
                    ecc_scrub_seq.scrub_mode  == 7;       // Periodic RMW + RndInterval (bit[2]=1)
                    ecc_scrub_seq.start_addr  == 0;
                    ecc_scrub_seq.end_addr    == 10;      // Small range for quick rounds
                    ecc_scrub_seq.idle_cnt    == 16'd10000; // idle_cnt > rnd_interval, so rnd_interval triggers first
                    ecc_scrub_seq.rnd_interval == 8'd5;   // 5 * 512 = 2560 cycles between rounds
                });

                `uvm_info(get_full_name(), "=== Round 1 waiting ===", UVM_LOW);
                
                // Wait for Round 1 to complete
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 1;       // Wait for round done
                    ecc_scrub_seq.scrub_mode  == 7;
                });
                
                `uvm_info(get_full_name(), "=== Round 1 done, waiting for RndInterval (2560 cycles) ===", UVM_LOW);
                `uvm_info(get_full_name(), $sformatf("Expected RndInterval delay: 5*512=%0d cycles", expected_interval), UVM_LOW);

                // Now we observe the gap between Round 1 and Round 2
                // idle_cnt=10000 > rnd_interval=2560, so rnd_interval will trigger first (if CQ idle)
                
                // Wait some time to let Round 2 complete
                repeat(20000) @(posedge tb.clk_noc);
                
                `uvm_info(get_full_name(), "=== Checking Round 2 status ===", UVM_LOW);
                
                // Check if Round 2 completed
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 1;
                    ecc_scrub_seq.scrub_mode  == 7;
                });

                // End scrubber
                `uvm_do_on_with(ecc_scrub_seq, p_sequencer.apb_sqr_[0], {
                    ecc_scrub_seq.mode        == 2;
                    ecc_scrub_seq.scrub_mode  == 7;
                });
            end
            begin
                // Normal traffic with controlled timing
                // Keep CQ busy to prevent any accidental idle trigger
                repeat(500) @(posedge tb.clk_noc);
                
                `uvm_info(get_full_name(), "Normal traffic burst 1...", UVM_LOW);
                `uvm_do_on_with(wrrd_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
                    wrrd_chi_seq.cnt                == 5;
                    wrrd_chi_seq.chi_addr           == `DMU_BASE0_ADDR + 'h1000;
                    wrrd_chi_seq.chi_ns             == 'b0;
                    wrrd_chi_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE;
                    wrrd_chi_seq.chi_rsvdc          == 'h0;
                })
                
                // Gap - CQ idle, but idle_cnt=0 so no trigger
                repeat(10000) @(posedge tb.clk_noc);
                
                `uvm_info(get_full_name(), "Normal traffic burst 2...", UVM_LOW);
                `uvm_do_on_with(wrrd_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
                    wrrd_chi_seq.cnt                == 5;
                    wrrd_chi_seq.chi_addr           == `DMU_BASE0_ADDR + 'h2000;
                    wrrd_chi_seq.chi_ns             == 'b0;
                    wrrd_chi_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE;
                    wrrd_chi_seq.chi_rsvdc          == 'h0;
                })
                
                // Final gap
                repeat(10000) @(posedge tb.clk_noc);
            end
        join

        `uvm_info(get_full_name(), "Test Case 4 completed - check waveform for RndInterval behavior", UVM_LOW);
    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq, p_sequencer.apb_sqr_[0], {ras_apb_seq.int_trig_mode==1'b1; ras_apb_seq.int_select=='h6;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass
