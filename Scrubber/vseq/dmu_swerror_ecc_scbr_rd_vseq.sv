class dmu_swerror_ecc_scbr_rd_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_swerror_ecc_scbr_rd_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_swerror_ecc_scbr_rd_vseq");
        super.new(name);
    endfunction

    virtual function void configSeq();
    endfunction:configSeq

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq ecc_scrub_seq;
    apb_swerror_ecc_loop_seq     ecc_reg_loop_seq;
    apb_ras_seq                  ras_apb_seq;
    apb_ras_err_inject_seq       ras_err_limit_seq;
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
        //set ras err limit
        `uvm_do_on_with(ras_err_limit_seq,p_sequencer.apb_sqr_[0],{ras_err_limit_seq.mode==3;});
        //1bit wr err inject
        for(int i = 3;i < 10 ;i++)begin
            gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;
            gen_err_col={gen_addr[31],gen_addr[30],gen_addr[28],gen_addr[16],gen_addr[8],gen_addr[13],gen_addr[23]};
            gen_err_row={gen_addr[31],gen_addr[31],gen_addr[26],gen_addr[3],gen_addr[5],gen_addr[12],gen_addr[11],gen_addr[0],gen_addr[17],gen_addr[22],gen_addr[4],gen_addr[20],gen_addr[6],gen_addr[19],gen_addr[21],gen_addr[15],gen_addr[1],gen_addr[14]};
            gen_err_ba={gen_addr[29],gen_addr[9],gen_addr[2],gen_addr[27],gen_addr[7]};
            gen_err_cs={gen_addr[31],gen_addr[18]};
            gen_err_cid={gen_addr[24],gen_addr[25],gen_addr[10]};
            gen_err_lane=$urandom_range(0,3);
            gen_err_local=$urandom_range(0,63);

            `uvm_do_on_with(ecc_reg_loop_seq,p_sequencer.apb_sqr_[0],{ecc_reg_loop_seq.mode==0;
                                                                       ecc_reg_loop_seq.ecc_mode==3;
                                                                       ecc_reg_loop_seq.err_mode==2'b00;
                                                                       ecc_reg_loop_seq.wrback==0;
                                                                       ecc_reg_loop_seq.addr_gen==gen_addr;
                                                                       // ecc_reg_loop_seq.err_col==gen_err_col;
                                                                       // ecc_reg_loop_seq.err_row==gen_err_row;
                                                                       // ecc_reg_loop_seq.err_ba==gen_err_ba;
                                                                       // ecc_reg_loop_seq.err_cs==gen_err_cs;
                                                                       // ecc_reg_loop_seq.err_cid==gen_err_cid;
                                                                       ecc_reg_loop_seq.err_lane==gen_err_lane;
                                                                       ecc_reg_loop_seq.err_local==gen_err_local;});

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
            repeat(2000) @(posedge tb.clk_noc);
            `uvm_do_on_with(ecc_reg_loop_seq,p_sequencer.apb_sqr_[0],{ecc_reg_loop_seq.mode=='h2;ecc_reg_loop_seq.err_mode==2'b00;});
        end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==0;ecc_scrub_seq.scrub_mode==0;start_addr==0;end_addr==20;});
        fork
            begin
                `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {base_rand_chi_seq.cnt     == 1000;})
            end
            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {base_rand_chi_seq.cnt     == 1000;})
                `endif
            end
        join
        vsqr_chireq_finish(2);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==0;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==5;ecc_scrub_seq.err_mode==2'b00;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==6;ecc_scrub_seq.err_mode==2'b00;});

        repeat(2000) @(posedge tb.clk_noc);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.scrub_mode==0;});

        `uvm_info(get_full_name(), "end ecc scrub ", UVM_LOW)
        repeat(1000) @(posedge tb.clk_noc);
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
            vsqr_chireq_finish(2);
        join

        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h202180;});

        //2bit error
        for(int i = 30;i < 40 ;i++)begin
            gen_addr=(i*(`TB_ADDR_WIDTH'h40))>>6;
            gen_err_col={gen_addr[31],gen_addr[30],gen_addr[28],gen_addr[16],gen_addr[8],gen_addr[13],gen_addr[23]};
            gen_err_row={gen_addr[31],gen_addr[31],gen_addr[26],gen_addr[3],gen_addr[5],gen_addr[12],gen_addr[11],gen_addr[0],gen_addr[17],gen_addr[22],gen_addr[4],gen_addr[20],gen_addr[6],gen_addr[19],gen_addr[21],gen_addr[15],gen_addr[1],gen_addr[14]};
            gen_err_ba={gen_addr[29],gen_addr[9],gen_addr[2],gen_addr[27],gen_addr[7]};
            gen_err_cs={gen_addr[31],gen_addr[18]};
            gen_err_cid={gen_addr[24],gen_addr[25],gen_addr[10]};
            gen_err_lane=$urandom_range(0,3);
            gen_err_local=$urandom_range(0,63);

            `uvm_do_on_with(ecc_reg_loop_seq,p_sequencer.apb_sqr_[0],{ecc_reg_loop_seq.mode==0;
                                                                       ecc_reg_loop_seq.ecc_mode==3;
                                                                       ecc_reg_loop_seq.err_mode==2'b01;
                                                                       ecc_reg_loop_seq.wrback==0;
                                                                       ecc_reg_loop_seq.addr_gen==gen_addr;
                                                                       // ecc_reg_loop_seq.err_col==gen_err_col;
                                                                       // ecc_reg_loop_seq.err_row==gen_err_row;
                                                                       // ecc_reg_loop_seq.err_ba==gen_err_ba;
                                                                       // ecc_reg_loop_seq.err_cs==gen_err_cs;
                                                                       // ecc_reg_loop_seq.err_cid==gen_err_cid;
                                                                       ecc_reg_loop_seq.err_lane==gen_err_lane;
                                                                       ecc_reg_loop_seq.err_local==gen_err_local;});

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
            repeat(2000) @(posedge tb.clk_noc);
            `uvm_do_on_with(ecc_reg_loop_seq,p_sequencer.apb_sqr_[0],{ecc_reg_loop_seq.mode=='h2;ecc_reg_loop_seq.err_mode==2'b00;});
        end

        repeat(100) @(posedge tb.clk_noc);

        `uvm_info(get_full_name(), "Start ecc_scrub set...", UVM_LOW);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==0;ecc_scrub_seq.scrub_mode==0;start_addr==30;end_addr==100;});
        fork
            begin
                `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[0],
                                {base_rand_chi_seq.cnt     == 1000;})
            end
            begin
                `ifdef MEM_ATTACHED_ddr5sdram
                `uvm_do_on_with(base_rand_chi_seq,p_sequencer.chi_vsqr.Down_seqr_ch_[1],
                                {base_rand_chi_seq.cnt     == 1000;})
                `endif
            end
        join
        vsqr_chireq_finish(2);
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==1;ecc_scrub_seq.scrub_mode==0;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==5;ecc_scrub_seq.err_mode==2'b01;});
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==6;ecc_scrub_seq.err_mode==2'b01;});
        //end scrub
        `uvm_do_on_with(ecc_scrub_seq,p_sequencer.apb_sqr_[0],{ecc_scrub_seq.mode==2;ecc_scrub_seq.err_mode==2'b01;});

        repeat(100) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish ecc scrub test...", UVM_LOW);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task post_body();
        bit sys_result;
        if(starting_phase) starting_phase.raise_objection(this);
        repeat(500) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Start post_body", UVM_LOW)
        `uvm_info(get_full_name(), "ras ctl_int clear", UVM_LOW)
        `uvm_do_on_with(ras_apb_seq,p_sequencer.apb_sqr_[0],{ras_apb_seq.int_trig_mode==1'b1;ras_apb_seq.int_select=='h121180;});
        if(starting_phase) starting_phase.drop_objection(this);
    endtask
endclass