class dmu_hwerror_advecc_scrubber_vseq extends dmu_base_vseq;//1bit
    `uvm_object_utils(dmu_hwerror_advecc_scrubber_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_hwerror_advecc_scrubber_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_DMU_APB_FTVIP
    apb_hwerror_advecc_seq       advecc_test_seq;
    apb_swerror_ecc_seq          ecc_clr_seq;
    apb_swerror_ecc_scrubber_seq ecc_scrub_seq;
    apb_ras_seq                  ras_apb_seq;
    `endif

    chi_full_wrard_seq       full_wrard_chi_seq;
    //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
    chi_wrrd_seq             wrrd_chi_seq;
    chi_readAfterWrite_seq   readAfterWrite_chi_seq;
    chi_base_rand_seq        base_rand_chi_seq;

    bit [255:0] in_data;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);

        repeat(10) @(tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc test...", UVM_LOW);

        `uvm_do_on_with(advecc_test_seq,p_sequencer.apb_sqr_[0],{advecc_test_seq.mode==0;advecc_test_seq.rsecc_mode==3;advecc_test_seq.grp_type==3;});

        $display("ecc config end begin data access");

        `uvm_info(get_full_name(), "Start wrrd_chi_seq...", UVM_LOW)
        fork
            begin
                `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {wr_seq.cnt                == 10;
                                 wr_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                 wr_seq.chi_ns             == 'b0;
                                 wr_seq.chi_cancelOnRetryAck == 'b0;
                                 wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 wr_seq.chi_rsvdc          == 'h0;})
            end
            begin
                //model inject 1bit cfg ch0
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
                repeat(750) @(tb.clk_noc);
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
                repeat(750) @(tb.clk_noc);
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

                `endif
                `endif
            end
        join

        fork
            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {wr_seq.cnt                == 10;
                                 wr_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                 wr_seq.chi_ns             == 'b0;
                                 wr_seq.chi_cancelOnRetryAck == 'b0;
                                 wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 wr_seq.chi_rsvdc          == 'h0;})
                `endif
            end
            begin
                //model inject 1bit cfg ch1
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
                repeat(750) @(tb.clk_noc);
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
                repeat(750) @(tb.clk_noc);
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

                `endif
                `endif
            end
        join

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==4;ecc_scrub_seq.scrub_mode==3;ecc_scrub_seq.start_addr==0;ecc_scrub_seq.end_addr==50;ecc_scrub_seq.grp_type==3;});

        fork
            begin
                `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[0], {
                                base_rand_chi_seq.cnt     == 100;
                               })
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[1], {
                                base_rand_chi_seq.cnt     == 100;
                               })
                `endif
            end

            begin
                `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[2], {
                                base_rand_chi_seq.cnt     == 100;
                               })
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(base_rand_chi_seq, p_sequencer.chi_vsqr.Down_seqr_ch_[3], {
                                base_rand_chi_seq.cnt     == 100;
                               })
                `endif
            end
        join
        vsqr_chireq_finish(2);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==3;});
        #10us;
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==3;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 10;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 10;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join
        vsqr_chireq_finish(2);

        `uvm_info(get_full_name(), "Finish advecc scrubber test...", UVM_LOW);

        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctrl_int_status clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h006c0000;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_hwerror_advecc_scrubber_2bit_vseq extends dmu_base_vseq;
    `uvm_object_utils(dmu_hwerror_advecc_scrubber_2bit_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_hwerror_advecc_scrubber_2bit_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_DMU_APB_FTVIP
    apb_hwerror_advecc_seq       advecc_test_seq;
    apb_swerror_ecc_seq          ecc_clr_seq;
    apb_swerror_ecc_scrubber_seq ecc_scrub_seq;
    apb_ras_seq                  ras_apb_seq;
    `endif

    chi_full_wrard_seq       full_wrard_chi_seq;
    //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
    chi_wrrd_seq             wrrd_chi_seq;
    chi_readAfterWrite_seq   readAfterWrite_chi_seq;
    chi_base_rand_seq        base_rand_chi_seq;

    bit [255:0] in_data;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);

        repeat(10) @(tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc test...", UVM_LOW);

        `uvm_do_on_with(advecc_test_seq,p_sequencer.apb_sqr_[0],{advecc_test_seq.mode==0;advecc_test_seq.rsecc_mode==3;advecc_test_seq.grp_type==4;});

        $display("ecc config end begin data access");

        `uvm_info(get_full_name(), "Start wrrd_chi_seq...", UVM_LOW)
        fork
            begin
                `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {wr_seq.cnt                == 10;
                                 wr_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                 wr_seq.chi_ns             == 'b0;
                                 wr_seq.chi_cancelOnRetryAck == 'b0;
                                 wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 wr_seq.chi_rsvdc          == 'h0;})
            end
            begin
                //model inject 1bit cfg ch0
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
                repeat(750) @(tb.clk_noc);
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
                repeat(750) @(tb.clk_noc);
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch0.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

                `endif
                `endif
            end
        join

        fork
            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {wr_seq.cnt                == 10;
                                 wr_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                 wr_seq.chi_ns             == 'b0;
                                 wr_seq.chi_cancelOnRetryAck == 'b0;
                                 wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 wr_seq.chi_rsvdc          == 'h0;})
                `endif
            end
            begin
                //model inject 1bit cfg ch1
                `ifdef SIMU_DDR_INJECT_MODEL
                `ifdef dram_ddr5_udimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch1 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0003);
                repeat(750) @(tb.clk_noc);
                $deposit(tb.u_dc.ddr5udimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

                `elsif dram_ddr5_rdimm
                //DQ Invalid Data while wr preamble, TJ2's HJ PHY is 2tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_invalid_pre, 4);
                //Read Preamble, Now is 1tCK(occupy 4data)
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.rd_preamble, 2);
                //D[0],D[8] will be inject
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wr_err_inject_position, 0);
                //Inject Ch1 Chip0 Dq0's write data
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0003);
                repeat(750) @(tb.clk_noc);
                $deposit(tb.u_dc.ddr5rdimm.ddr_inject_err_ch1.wrdata_err_inject_bit_sel[31:0], 32'h0000_0000);

                `endif
                `endif
            end
        join

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==4;ecc_scrub_seq.scrub_mode==3;ecc_scrub_seq.start_addr==0;ecc_scrub_seq.end_addr==50;ecc_scrub_seq.grp_type==4;});
        // fork
        //     begin
        //         `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
        //                         {base_rand_chi_seq.cnt     == 100;})
        //     end
        //     begin
        //         `ifdef MEM_ATTACHED_ddr5sdram
        //         `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
        //                         {base_rand_chi_seq.cnt     == 100;})
        //         `endif
        //     end
        //         `endif
        //     end
        // join
        // vsqr_chireq_finish(2);
        fork
            begin
                `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {wrrd_chi_seq.cnt                == 1000;
                                 wrrd_chi_seq.chi_addr           == `DMU_BASE0_ADDR+100*(`TB_ADDR_WIDTH'h40);
                                 //wrrd_chi_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                 wrrd_chi_seq.chi_ns             == 'b0;
                                 wrrd_chi_seq.chi_qos            == 'hf;
                                 wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                                 wrrd_chi_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 wrrd_chi_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(wrrd_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {wrrd_chi_seq.cnt                == 1000;
                                 wrrd_chi_seq.chi_addr           == `DMU_BASE1_ADDR+100*(`TB_ADDR_WIDTH'h40);
                                 //wrrd_chi_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                 wrrd_chi_seq.chi_ns             == 'b0;
                                 wrrd_chi_seq.chi_qos            == 'hf;
                                 wrrd_chi_seq.chi_cancelOnRetryAck == 'b0;
                                 wrrd_chi_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 wrrd_chi_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join

        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==3;});
        // #10us;
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==3;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 10;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 10;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end

        join

        `uvm_info(get_full_name(), "Finish advecc scrubber test...", UVM_LOW);

        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctrl_int_status clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h006c0000;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass