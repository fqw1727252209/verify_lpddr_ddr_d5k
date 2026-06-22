class dmu_swerror_advecc_scbr_1symbol_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_swerror_advecc_scbr_1symbol_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_swerror_advecc_scbr_1symbol_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq advecc_scrub_seq;
    apb_swerror_advecc_loop_seq  advecc_reg_test_seq;
    apb_ras_seq                  ras_apb_seq;
    apb_ras_err_inject_seq       ras_err_limit_seq;
    `endif

    chi_full_wrard_seq       full_wrard_chi_seq;
    //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
    chi_wrrd_seq             wrrd_chi_seq;
    chi_readAfterWrite_seq   readAfterWrite_chi_seq;
    chi_base_rand_seq        base_rand_chi_seq;

    bit [255:0]              in_data;
    int                      in_cnt=1000;
    bit [`TB_ADDR_WIDTH-1:0] gen_addr;
    bit [6:0]                gen_err_col;
    bit [17:0]               gen_err_row;
    bit [4:0]                gen_err_ba;
    bit [1:0]                gen_err_cs;
    bit [2:0]                gen_err_cid;
    bit [1:0]                gen_err_lane;
    bit [5:0]                gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        //set ras err limit
        `uvm_do_on_with(ras_err_limit_seq,p_sequencer.apb_sqr_[0],{ras_err_limit_seq.mode==3;});
        //1symbol wr err inject
        //rd mode
        for(int j=5;j<6;j++)begin
            for(int i = 15;i < 20 ;i++)begin
                gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;

                `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                                                           advecc_reg_test_seq.rsecc_mode==3;
                                                                           advecc_reg_test_seq.err_mode==3'b000;
                                                                           advecc_reg_test_seq.grp_type==j;
                                                                           advecc_reg_test_seq.addr_gen==gen_addr;
                                                                          });

                fork
                    begin
                        `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                        {wr_seq.cnt                == 1;
                                         wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                         wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                         wr_seq.chi_ns             == 'b0;
                                         wr_seq.chi_cancelOnRetryAck == 'b0;
                                         wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                         wr_seq.chi_rsvdc          == 'h0;})
                    end

                    begin
                        `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                        {wr_seq.cnt                == 1;
                                         wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                         wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                         wr_seq.chi_ns             == 'b0;
                                         wr_seq.chi_cancelOnRetryAck == 'b0;
                                         wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                         wr_seq.chi_rsvdc          == 'h0;})
                    end
                join
                `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode=='h2;advecc_reg_test_seq.err_mode==3'b010;});
            end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==0;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr==50;advecc_scrub_seq.grp_type==j;});
        fork
            begin
                `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {base_rand_chi_seq.cnt     == 50;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {base_rand_chi_seq.cnt     == 50;})
                `endif
            end
        join
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==0;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==5;advecc_scrub_seq.err_mode==2'b10;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==6;advecc_scrub_seq.err_mode==2'b10;});
        #10us;
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==0;});

        `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR+15*(`TB_ADDR_WIDTH'h40);
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR+15*(`TB_ADDR_WIDTH'h40);
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join
        vsqr_chireq_finish(2);

        //rmw mode
        for(int i = 0; i < 10 ;i++)begin
            gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;
            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                                                       advecc_reg_test_seq.rsecc_mode==3;
                                                                       advecc_reg_test_seq.err_mode==3'b000;
                                                                       advecc_reg_test_seq.grp_type==j;
                                                                       advecc_reg_test_seq.addr_gen==gen_addr;
                                                                      });

            fork
                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end

                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end
            join
            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode=='h2;advecc_reg_test_seq.err_mode==3'b010;});
        end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==3;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr==50;advecc_scrub_seq.grp_type==j;});
        fork
            begin
                `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {base_rand_chi_seq.cnt     == 50;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {base_rand_chi_seq.cnt     == 50;})
                `endif
            end
        join
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==3;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==5;advecc_scrub_seq.err_mode==2'b10;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==6;advecc_scrub_seq.err_mode==2'b10;});
        #10us;
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==3;});

        `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join
        vsqr_chireq_finish(2);
    end

    `uvm_info(get_full_name(), "Finish advecc scrubber test...", UVM_LOW);
    if(starting_phase) starting_phase.drop_objection(this);

endtask

virtual task post_body();
    bit sys_result;
    if(starting_phase) starting_phase.raise_objection(this);
    repeat(500) @(posedge tb.clk_noc);
    `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
    `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
    `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h6c0000;});
    if(starting_phase) starting_phase.drop_objection(this);
endtask
endclass

class dmu_swerror_advecc_scbr_2symbol_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_swerror_advecc_scbr_2symbol_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_swerror_advecc_scbr_2symbol_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq advecc_scrub_seq;
    apb_swerror_advecc_loop_seq  advecc_reg_test_seq;
    apb_ras_seq                  ras_apb_seq;
    `endif

    chi_full_wrard_seq       full_wrard_chi_seq;
    //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
    chi_wrrd_seq             wrrd_chi_seq;
    chi_readAfterWrite_seq   readAfterWrite_chi_seq;
    chi_base_rand_seq        base_rand_chi_seq;

    bit [255:0]              in_data;
    bit [`TB_ADDR_WIDTH-1:0] gen_addr;
    bit [6:0]                gen_err_col;
    bit [17:0]               gen_err_row;
    bit [4:0]                gen_err_ba;
    bit [1:0]                gen_err_cs;
    bit [2:0]                gen_err_cid;
    bit [1:0]                gen_err_lane;
    bit [5:0]                gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        //2symbol wr err inject
        //rd_mode
        for(int j=3;j<4;j++)begin
            for(int i = 80; i < 90 ;i++)begin
                gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;

                `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                                                           advecc_reg_test_seq.rsecc_mode==3;
                                                                           advecc_reg_test_seq.err_mode==3'b010;
                                                                           advecc_reg_test_seq.grp_type==j;
                                                                           advecc_reg_test_seq.addr_gen==gen_addr;
                                                                          });

                fork
                    begin
                        `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                        {wr_seq.cnt                == 1;
                                         wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                         wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                         wr_seq.chi_ns             == 'b0;
                                         wr_seq.chi_cancelOnRetryAck == 'b0;
                                         wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                         wr_seq.chi_rsvdc          == 'h0;})
                    end

                    begin
                        `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                        {wr_seq.cnt                == 1;
                                         wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                         wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                         wr_seq.chi_ns             == 'b0;
                                         wr_seq.chi_cancelOnRetryAck == 'b0;
                                         wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                         wr_seq.chi_rsvdc          == 'h0;})
                    end
                join
                `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode=='h2;advecc_reg_test_seq.err_mode==3'b010;});
            end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==0;advecc_scrub_seq.start_addr==50;advecc_scrub_seq.end_addr==95;advecc_scrub_seq.grp_type==j;});
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
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==0;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==5;advecc_scrub_seq.err_mode==2'b10;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==6;advecc_scrub_seq.err_mode==2'b10;});
        #10us;
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==0;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR+80*(`TB_ADDR_WIDTH'h40);
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR+80*(`TB_ADDR_WIDTH'h40);
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join
        vsqr_chireq_finish(2);

        //rmw mode
        for(int i = 0; i < 10 ;i++)begin
            gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;

            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                                                       advecc_reg_test_seq.rsecc_mode==3;
                                                                       advecc_reg_test_seq.err_mode==3'b010;
                                                                       advecc_reg_test_seq.grp_type==j;
                                                                       advecc_reg_test_seq.addr_gen==gen_addr;
                                                                      });

            fork
                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end

                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end
            join
            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode=='h2;advecc_reg_test_seq.err_mode==3'b010;});
        end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==3;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr==50;advecc_scrub_seq.grp_type==j;});
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
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==3;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==5;advecc_scrub_seq.err_mode==2'b10;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==6;advecc_scrub_seq.err_mode==2'b10;});
        #10us;
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==3;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join
        vsqr_chireq_finish(2);
        end

        `uvm_info(get_full_name(), "Finish advecc scrubber test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h6c0000;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_swerror_advecc_scbr_bf_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_swerror_advecc_scbr_bf_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_swerror_advecc_scbr_bf_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq advecc_scrub_seq;
    apb_swerror_advecc_loop_seq  advecc_reg_test_seq;
    apb_ras_seq                  ras_apb_seq;
    `endif

    chi_full_wrard_seq       full_wrard_chi_seq;
    //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
    chi_wrrd_seq             wrrd_chi_seq;
    chi_readAfterWrite_seq   readAfterWrite_chi_seq;
    chi_base_rand_seq        base_rand_chi_seq;

    bit [255:0]              in_data;
    bit [`TB_ADDR_WIDTH-1:0] gen_addr;
    bit [6:0]                gen_err_col;
    bit [17:0]               gen_err_row;
    bit [4:0]                gen_err_ba;
    bit [1:0]                gen_err_cs;
    bit [2:0]                gen_err_cid;
    bit [1:0]                gen_err_lane;
    bit [5:0]                gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        //bf wr err inject
        for(int j=4;j<5;j++)begin
            for(int i = 50;i < 60 ;i++)begin
                gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;

                `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                                                           advecc_reg_test_seq.rsecc_mode==3;
                                                                           advecc_reg_test_seq.err_mode==3'b100;
                                                                           advecc_reg_test_seq.grp_type==j;
                                                                           advecc_reg_test_seq.addr_gen==gen_addr;
                                                                          });

                fork
                    begin
                        `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                        {wr_seq.cnt                == 1;
                                         wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                         wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                         wr_seq.chi_ns             == 'b0;
                                         wr_seq.chi_cancelOnRetryAck == 'b0;
                                         wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                         wr_seq.chi_rsvdc          == 'h0;})
                    end

                    begin
                        `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                        {wr_seq.cnt                == 1;
                                         wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                         wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                         wr_seq.chi_ns             == 'b0;
                                         wr_seq.chi_cancelOnRetryAck == 'b0;
                                         wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                         wr_seq.chi_rsvdc          == 'h0;})
                    end
                join
                `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode=='h2;advecc_reg_test_seq.err_mode==3'b100;});
            end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==0;advecc_scrub_seq.start_addr==50;advecc_scrub_seq.end_addr==80;advecc_scrub_seq.grp_type==j;});
        
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
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==0;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==5;advecc_scrub_seq.err_mode==2'b10;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==6;advecc_scrub_seq.err_mode==2'b10;});
        #10us;
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==0;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR+50*(`TB_ADDR_WIDTH'h40);
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR+50*(`TB_ADDR_WIDTH'h40);
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join
        vsqr_chireq_finish(2);

        for(int i = 3;i < 10 ;i++)begin
            gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;

            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                                                       advecc_reg_test_seq.rsecc_mode==3;
                                                                       advecc_reg_test_seq.err_mode==3'b100;
                                                                       advecc_reg_test_seq.grp_type==j;
                                                                       advecc_reg_test_seq.addr_gen==gen_addr;
                                                                      });

            fork
                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end

                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end
            join
            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode=='h2;advecc_reg_test_seq.err_mode==3'b100;});
        end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==3;advecc_scrub_seq.start_addr==1;advecc_scrub_seq.end_addr==50;advecc_scrub_seq.grp_type==j;});

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
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==3;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==5;advecc_scrub_seq.err_mode==2'b10;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==6;advecc_scrub_seq.err_mode==2'b10;});

        #10us;
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==3;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end

            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join
        vsqr_chireq_finish(2);
        end

        `uvm_info(get_full_name(), "Finish advecc scrubber test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h6c0000;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_swerror_advecc_scbr_chipkill_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_swerror_advecc_scbr_chipkill_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_swerror_advecc_scbr_chipkill_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq advecc_scrub_seq;
    apb_swerror_advecc_loop_seq  advecc_reg_test_seq;
    apb_ras_seq                  ras_apb_seq;
    `endif

    chi_full_wrard_seq       full_wrard_chi_seq;
    //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
    chi_wrrd_seq             wrrd_chi_seq;
    chi_readAfterWrite_seq   readAfterWrite_chi_seq;
    chi_base_rand_seq        base_rand_chi_seq;

    bit [255:0]              in_data;
    bit [`TB_ADDR_WIDTH-1:0] gen_addr;
    bit [6:0]                gen_err_col;
    bit [17:0]               gen_err_row;
    bit [4:0]                gen_err_ba;
    bit [1:0]                gen_err_cs;
    bit [2:0]                gen_err_cid;
    bit [1:0]                gen_err_lane;
    bit [5:0]                gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        //bf wr err inject
        for(int j=5;j<6;j++)begin
        for(int i = 4;i < 10 ;i++)begin
            gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;
            gen_err_col={gen_addr[31],gen_addr[30],gen_addr[28],gen_addr[16],gen_addr[8],gen_addr[13],gen_addr[23]};
            gen_err_row={gen_addr[31],gen_addr[31],gen_addr[26],gen_addr[3],gen_addr[5],gen_addr[12],gen_addr[11],gen_addr[0],gen_addr[17],gen_addr[22],gen_addr[4],gen_addr[20],gen_addr[6],gen_addr[19],gen_addr[21],gen_addr[15],gen_addr[1],gen_addr[14]};
            gen_err_ba={gen_addr[29],gen_addr[9],gen_addr[2],gen_addr[27],gen_addr[7]};
            gen_err_cs={gen_addr[31],gen_addr[18]};
            gen_err_cid={gen_addr[24],gen_addr[25],gen_addr[10]};

            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                                                       advecc_reg_test_seq.rsecc_mode==3;
                                                                       advecc_reg_test_seq.err_mode==4'b1000;
                                                                       advecc_reg_test_seq.addr_gen==gen_addr;
                                                                       advecc_reg_test_seq.grp_type==j;
                                                                       // advecc_reg_test_seq.err_col==gen_err_col;
                                                                       // advecc_reg_test_seq.err_row==gen_err_row;
                                                                       // advecc_reg_test_seq.err_ba==gen_err_ba;
                                                                       // advecc_reg_test_seq.err_cs==gen_err_cs;
                                                                       // advecc_reg_test_seq.err_cid==gen_err_cid;
                                                                      });

            fork
                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end
                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end
            join
            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode=='h2;advecc_reg_test_seq.err_mode==4'b1000;});
        end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==0;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr==50;advecc_scrub_seq.grp_type==j;});
        // fork
        //     begin
        //         `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
        //                         {base_rand_chi_seq.cnt     == 100;})
        //     end
        //
        //     begin
        //         `ifdef MEM_ATTACHED_ddr5sdram
        //         `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
        //                         {base_rand_chi_seq.cnt     == 100;})
        //         `endif
        //     end
        // join
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
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==0;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==5;advecc_scrub_seq.err_mode==2'b10;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==6;advecc_scrub_seq.err_mode==2'b10;});

        //end scrub
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==0;});
        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        fork
            begin
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
            end
            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(rd_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {rd_seq.cnt                == 20;
                                 rd_seq.chi_addr           == `DMU_BASE0_ADDR;
                                 rd_seq.chi_ns             == 'b0;
                                 rd_seq.chi_cancelOnRetryAck == 'b0;
                                 rd_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                 rd_seq.chi_rsvdc          == 'h0;})
                `endif
            end
        join
        vsqr_chireq_finish(2);
        end

        `uvm_info(get_full_name(), "Finish advecc scrubber test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h6c0000;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass

class dmu_swerror_advecc_scbr_3symbol_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_swerror_advecc_scbr_3symbol_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_swerror_advecc_scbr_3symbol_vseq");
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
    apb_swerror_ecc_scrubber_seq advecc_scrub_seq;
    apb_swerror_advecc_loop_seq  advecc_reg_test_seq;
    apb_ras_seq                  ras_apb_seq;
    `endif

    chi_full_wrard_seq       full_wrard_chi_seq;
    //chi_ptl_wrrd_seq         ptl_wrrd_chi_seq;
    chi_wrrd_seq             wrrd_chi_seq;
    chi_readAfterWrite_seq   readAfterWrite_chi_seq;
    chi_base_rand_seq        base_rand_chi_seq;

    bit [255:0]              in_data;
    bit [`TB_ADDR_WIDTH-1:0] gen_addr;
    bit [6:0]                gen_err_col;
    bit [17:0]               gen_err_row;
    bit [4:0]                gen_err_ba;
    bit [1:0]                gen_err_cs;
    bit [2:0]                gen_err_cid;
    bit [1:0]                gen_err_lane;
    bit [5:0]                gen_err_local;

    virtual task body();
        if(starting_phase) starting_phase.raise_objection(this);
        //bf wr err inject
        for(int j=5;j<6;j++)begin
        for(int i = 8;i < 15 ;i++)begin
            gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;

            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode==0;
                                                                       advecc_reg_test_seq.rsecc_mode==3;
                                                                       advecc_reg_test_seq.err_mode==4'b0110;
                                                                       advecc_reg_test_seq.addr_gen==gen_addr;
                                                                       advecc_reg_test_seq.grp_type==j;
                                                                       // advecc_reg_test_seq.err_col==gen_err_col;
                                                                       // advecc_reg_test_seq.err_row==gen_err_row;
                                                                       // advecc_reg_test_seq.err_ba==gen_err_ba;
                                                                       // advecc_reg_test_seq.err_cs==gen_err_cs;
                                                                       // advecc_reg_test_seq.err_cid==gen_err_cid;
                                                                      });

            fork
                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end

                begin
                    `uvm_do_on_with(wr_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                    {wr_seq.cnt                == 1;
                                     wr_seq.chi_addr           == `DMU_BASE0_ADDR+i*(`TB_ADDR_WIDTH'h40);
                                     wr_seq.chi_wrdata         == chi_addr+(1'b1<<40);
                                     wr_seq.chi_ns             == 'b0;
                                     wr_seq.chi_cancelOnRetryAck == 'b0;
                                     wr_seq.chi_size           == DENALI_CHI_SIZE_FULLLINE ;
                                     wr_seq.chi_rsvdc          == 'h0;})
                end
            join
            `uvm_do_on_with(advecc_reg_test_seq,p_sequencer.apb_sqr_[0],{advecc_reg_test_seq.mode=='h2;advecc_reg_test_seq.err_mode==4'b0110;});
        end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==4;advecc_scrub_seq.scrub_mode==0;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr==50;advecc_scrub_seq.grp_type==j;});
        // fork
        //     begin
        //         `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
        //                         {base_rand_chi_seq.cnt     == 100;})
        //     end
        //
        //     begin
        //         `ifdef MEM_ATTACHED_ddr5sdram
        //         `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
        //                         {base_rand_chi_seq.cnt     == 100;})
        //         `endif
        //     end
        // join
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
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==1;advecc_scrub_seq.scrub_mode==0;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==5;advecc_scrub_seq.err_mode==2'b11;});
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==6;advecc_scrub_seq.err_mode==2'b11;});

        //end scrub
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;advecc_scrub_seq.scrub_mode==0;});
        end

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        //#10us;
        repeat(2000) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish advecc scrubber test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h630000;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass