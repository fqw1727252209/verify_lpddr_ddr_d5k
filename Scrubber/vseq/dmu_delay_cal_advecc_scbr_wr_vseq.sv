class dmu_advecc_scbr_wr_1M_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_advecc_scbr_wr_1M_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_advecc_scbr_wr_1M_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    advecc_scrub_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;

    int filew;
    realtime s_time,e_time;

    virtual task body();
        filew = $fopen("advecc_scbr_wr_1M_delay.log","w");

        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "Start advecc_scrub wr set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==3;advecc_scrub_seq.scrub_mode==1;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr=='h3FFF;advecc_scrub_seq.wdata==32'hf0f0_f0f0;advecc_scrub_seq.trig_mode==2'b01;});
        // $timeformat(-9,3,"ns",10);

        //s_time = $realtime;
        //$fdisplay(filew,"advecc scrub read s_time %t",s_time);

        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==3;advecc_scrub_seq.trig_mode==2'b11;});
        //e_time = $realtime;
        //$fdisplay(filew,"advecc scrub read e_time %t",e_time);
        //$fdisplay(filew,"advecc scrub read delay %t",(e_time-s_time));

        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;});
        `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
        repeat(100) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish advecc scrub wr 1M test...", UVM_LOW);
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

class dmu_advecc_scbr_wr_2M_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_advecc_scbr_wr_2M_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_advecc_scbr_wr_2M_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    advecc_scrub_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;

    int filew;
    realtime s_time,e_time;

    virtual task body();
        filew = $fopen("advecc_scbr_wr_2M_delay.log","w");

        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "Start advecc_scrub wr set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==3;advecc_scrub_seq.scrub_mode==1;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr=='h7FFF;advecc_scrub_seq.wdata==32'hf0f0_f0f0;advecc_scrub_seq.trig_mode==2'b01;});
        // $timeformat(-9,3,"ns",10);

        // s_time = $realtime;
        // $fdisplay(filew,"advecc scrub read s_time %t",s_time);

        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==3;advecc_scrub_seq.trig_mode==2'b11;});
        // e_time = $realtime;
        // $fdisplay(filew,"advecc scrub read e_time %t",e_time);
        // $fdisplay(filew,"advecc scrub read delay %t",(e_time-s_time));

        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;});
        `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
        repeat(1000) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish advecc scrub wr 2M test...", UVM_LOW);
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

class dmu_advecc_scbr_wr_4M_vseq extends dmu_base_vseq;

    `uvm_object_utils(dmu_advecc_scbr_wr_4M_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name="dmu_advecc_scbr_wr_4M_vseq");
        super.new(name);
    endfunction

    `ifdef SIMU_DMU_APB_FTVIP
    apb_swerror_ecc_scrubber_seq    advecc_scrub_seq;
    apb_ras_seq                     ras_apb_seq;
    `endif

    chi_full_wrard_seq            full_wrard_chi_seq;
    //chi_ptl_wrrd_seq              ptl_wrrd_chi_seq;
    chi_wrrd_seq                  wrrd_chi_seq;
    chi_readAfterWrite_seq        readAfterWrite_chi_seq;
    chi_base_rand_seq             base_rand_chi_seq;

    int filew;
    realtime s_time,e_time;

    virtual task body();
        filew = $fopen("advecc_scbr_wr_4M_delay.log","w");

        if(starting_phase) starting_phase.raise_objection(this);
        `uvm_info(get_full_name(), "Start advecc_scrub wr set...", UVM_LOW);
        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==3;advecc_scrub_seq.scrub_mode==1;advecc_scrub_seq.start_addr==0;advecc_scrub_seq.end_addr=='hFFFF;advecc_scrub_seq.wdata==32'hf0f0_f0f0;advecc_scrub_seq.trig_mode==2'b01;});
        // $timeformat(-9,3,"ns",10);

        // s_time = $realtime;
        // $fdisplay(filew,"advecc scrub read s_time %t",s_time);

        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==3;advecc_scrub_seq.trig_mode==2'b11;});
        // e_time = $realtime;
        // $fdisplay(filew,"advecc scrub read e_time %t",e_time);
        // $fdisplay(filew,"advecc scrub read delay %t",(e_time-s_time));

        `uvm_do_on_with(advecc_scrub_seq,p_sequencer.apb_sqr_[0],{advecc_scrub_seq.mode==2;});
        `uvm_info(get_full_name(), "end advecc scrub ", UVM_LOW)
        repeat(1000) @(posedge tb.clk_noc);
        `uvm_info(get_full_name(), "Finish advecc scrub wr 4M test...", UVM_LOW);
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