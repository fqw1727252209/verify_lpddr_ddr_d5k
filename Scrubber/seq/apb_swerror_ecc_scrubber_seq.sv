









`ifdef SIMU_DMU_APB_FTVIP
class apb_swerror_ecc_scrubber_seq extends apb_base_seq;

    `uvm_object_utils(apb_swerror_ecc_scrubber_seq)

    rand bit [2:0] mode;
    rand bit [2:0] scrub_mode;
    rand bit [34:0] start_addr;
    rand bit [34:0] end_addr;
    rand bit [1:0] trig_mode;
    rand bit [31:0] wdata;
    randc bit[2:0] grp_type;
    rand bit [2:0] err_mode;
    rand bit hold_mode;
    rand bit [7:0] rnd_interval;
    rand bit [15:0] idle_cnt;

    int filew;
    realtime s_time,e_time;

    bit [32:0] rdata;
    bit [32:0] rdata_row;

    constraint c_rnd_interval {soft rnd_interval == 1;}

    function new(string name = "apb_swerror_ecc_scrubber_seq");
        super.new(name);
    endfunction

    `include "init_config_task.sv"

    virtual task pre_body();

        if(starting_phase) starting_phase.raise_objection(this);
            `uvm_info(get_full_name(), "wait rst!", UVM_LOW);
            repeat(5) @(posedge tb.clk_cfg);
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    virtual task body();

        if(starting_phase) starting_phase.raise_objection(this);
            `uvm_info(get_full_name(), "Start ecc scrub access", UVM_LOW);
        if(mode==0)begin
            // apb_sbecc_scrub_cfg(`ECC0_BASE_ADDR);
            // apb_sbecc_scrub_cfg(`ECC1_BASE_ADDR);
            ecc_scrub_cfg(`DDR_CTL0_BASE_ADDR,scrub_mode,start_addr,end_addr);
            ecc_scrub_cfg(`DDR_CTL1_BASE_ADDR,scrub_mode,start_addr,end_addr);
        end
        else if(mode==1)begin
            ecc_scrub_status(`DDR_CTL0_BASE_ADDR);
            ecc_scrub_status(`DDR_CTL1_BASE_ADDR);
        end
        else if(mode==2)begin
            ecc_scrub_end(`DDR_CTL0_BASE_ADDR);
            ecc_scrub_end(`DDR_CTL1_BASE_ADDR);
        end
        else if(mode==3)begin
            ecc_scrub_backtoback(`DDR_CTL0_BASE_ADDR);
            ecc_scrub_backtoback(`DDR_CTL1_BASE_ADDR);
        end
        else if(mode==4)begin//advecc scrub
            // apb_rsecc_scrub_cfg(`ECC0_BASE_ADDR);
            // apb_rsecc_scrub_cfg(`ECC1_BASE_ADDR);
            advecc_scrub_cfg(`DDR_CTL0_BASE_ADDR,scrub_mode,start_addr,end_addr);
            advecc_scrub_cfg(`DDR_CTL1_BASE_ADDR,scrub_mode,start_addr,end_addr);
        end
        else if(mode==5)begin//scrub int check
            // apb_ecc_scrub_chk(`ECC0_BASE_ADDR);
            // apb_ecc_scrub_chk(`ECC1_BASE_ADDR);
        end
        else if(mode==6)begin
            // apb_ecc_scrub_clr(`ECC0_BASE_ADDR);
            // apb_ecc_scrub_clr(`ECC1_BASE_ADDR);
        end
        else if(mode==7)begin//xum_hold_state
            xmu_hold_state(`DDR_CTL0_BASE_ADDR,hold_mode);
            xmu_hold_state(`DDR_CTL1_BASE_ADDR,hold_mode);
        end
        // `uvm_info(get_full_name(), "Finish ecc scrub access", UVM_LOW);

        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    extern virtual task ecc_scrub_cfg(input bit[31:0] ctrl_addr,input [2:0] scrub_mode,input [34:0] start_addr,input [34:0] end_addr);
    extern virtual task ecc_scrub_status(input bit[31:0] ctrl_addr);
    extern virtual task ecc_scrub_end(input bit[31:0] ctrl_addr);
    extern virtual task ecc_scrub_backtoback(input bit[31:0] ctrl_addr);
    extern virtual task apb_sbecc_scrub_cfg(input bit[31:0] base_addr);
    extern virtual task apb_rsecc_scrub_cfg(input bit[31:0] base_addr);
    extern virtual task apb_ecc_scrub_chk(input bit[31:0] base_addr);
    extern virtual task apb_ecc_scrub_clr(input bit[31:0] base_addr);
    extern virtual task xmu_hold_state(input bit[31:0] base_addr,input hold_mode);
    extern virtual task advecc_scrub_cfg(input bit[31:0] ctrl_addr,input [2:0] scrub_mode,input [34:0] start_addr,input [34:0] end_addr);

endclass : apb_swerror_ecc_scrubber_seq

task apb_swerror_ecc_scrubber_seq::ecc_scrub_cfg(input bit[31:0] ctrl_addr,input [2:0] scrub_mode,input [34:0] start_addr,input [34:0] end_addr);

    //ecc_enable
    `uvm_info(get_full_name(), "set ecc_enable ", UVM_LOW);
    set_field_by_apb("CTL_SBECCEN", 1, ctrl_addr);
    set_field_by_apb("CTL_SBECCCHKEN", 1, ctrl_addr);

    //set ecc_scrub_start_addr
    `uvm_info(get_full_name(), "set ecc_scrub_start_addr ", UVM_LOW);
    set_field_by_apb("CTL_SCBRSTARTADDR0", start_addr[31:0], ctrl_addr);
    set_field_by_apb("CTL_SCBRSTARTADDR1", start_addr[34:32], ctrl_addr);

    //set ecc_scrub_end_addr
    `uvm_info(get_full_name(), "set ecc_scrub_end_addr ", UVM_LOW);
    set_field_by_apb("CTL_SCBRENDADDR0", end_addr[31:0], ctrl_addr);
    set_field_by_apb("CTL_SCBRENDADDR1", end_addr[34:32], ctrl_addr);

    //set ecc_scrub_mode:0-rd,1-wr,2-writeback 3-rmw,bit[2]=1-rnd_scrb
    set_field_by_apb("CTL_SCBRMODE", scrub_mode, ctrl_addr);
    if(scrub_mode==1)begin
        set_field_by_apb("CTL_SCBRWDATA", wdata, ctrl_addr);
    end
    if(scrub_mode[2]==1)begin
        `uvm_info(get_full_name(), "set ROUND_SCRUB_INTERVAL ", UVM_LOW);
        set_field_by_apb("CTL_SCBRRNDINTERVAL", rnd_interval, ctrl_addr);
    end
    //set CTL_SCBRCTRLIDLECNT for idle trigger
    if(idle_cnt != 16'h0)begin
        `uvm_info(get_full_name(), "set CTL_SCBRCTRLIDLECNT ", UVM_LOW);
        set_field_by_apb("CTL_SCBRCTRLIDLECNT", idle_cnt, ctrl_addr);
    end
    //set ECC_SCRUB_INTERVAL
    `uvm_info(get_full_name(), "set ECC_SCRUB_INTERVAL ", UVM_LOW);
    set_field_by_apb("CTL_SCBRPERIOD", 1, ctrl_addr);

    //set ecc_scrub_start
    `uvm_info(get_full_name(), "set ecc_scrub_start ", UVM_LOW);
    set_field_by_apb("CTL_SCBREN", 1, ctrl_addr);

endtask

task apb_swerror_ecc_scrubber_seq::ecc_scrub_status(input bit[31:0] ctrl_addr);
    //errstate1 bit[3]=1

    bit [2:0] rnd;
    `uvm_info(get_full_name(), "wait scrub_round done ", UVM_LOW);
    get_field_poll_by_apb("CTL_SCBRROUNDDONE",1,ctrl_addr);
    if(scrub_mode[2]==1)begin
        repeat(2000) @(posedge tb.clk_noc);
    end
    get_field_by_apb("CTL_SCBRERROR",rdata,ctrl_addr);
    if(rdata == 1 ) begin
        `uvm_error(get_type_name(), $sformatf("scbr error=%0h", rdata));
    end
    get_field_by_apb("CTL_SCBRSTATE",rdata,ctrl_addr);
    `uvm_info(get_type_name(), $sformatf(" scbrstatus=%0h", rdata),UVM_LOW);
    get_field_by_apb("CTL_SCBRADDRRANGESTATUS",rdata,ctrl_addr);
    `uvm_info(get_type_name(), $sformatf(" scbr addr range status=%0h", rdata),UVM_LOW);
    get_field_by_apb("CTL_SCBRFIXRMWFIFOFULL",rdata,ctrl_addr);
    `uvm_info(get_type_name(), $sformatf(" scbr rmw fifo full=%0h", rdata),UVM_LOW);

endtask

task apb_swerror_ecc_scrubber_seq::ecc_scrub_end(input bit[31:0] ctrl_addr);
    // `uvm_info(get_full_name(), "clr ecc int", UVM_LOW);
    // set_field_by_apb("CTL_RDSBECCCORRINTCLR",1,ctrl_addr);
    // set_field_by_apb("CTL_RDSBECCCORRINTCLR",0,ctrl_addr);
    `uvm_info(get_full_name(), "set ecc_scrub_en=0 ", UVM_LOW);
    set_field_by_apb("CTL_SCBREN", 0, ctrl_addr);
    // close ecc_enable

    repeat(1000) @(posedge tb.clk_noc);
    `uvm_info(get_full_name(), "close ecc_check ", UVM_LOW);
    set_field_by_apb("CTL_SBECCCHKEN", 0, ctrl_addr);
    set_field_by_apb("CTL_RSECCCHECKEN", 0, ctrl_addr);
    // `uvm_info(get_full_name(), "close ecc_enable ", UVM_LOW);
    // set_field_by_apb("CTL_RSECCEN", 0, ctrl_addr);
    // set_field_by_apb("CTL_SBECCEN", 0, ctrl_addr);

    // set_field_by_apb("PUM_TOP_LANEMULTICASTWR", 'h0, `DDR_PHY_BASE_ADDR);    //Close lane csr multicast write mode
    // set_field_by_apb("DLANE8_DLANETXBYPCTRL", 'h3f,  `DDR_PHY_BASE_ADDR);    //close dlane8's DQS&DQ OE
    // set_field_by_apb("DLANE8_DLANERXBYPCTRL", 'h17,  `DDR_PHY_BASE_ADDR);
    // set_field_by_apb("DLANE9_DLANETXBYPCTRL", 'h3f,  `DDR_PHY_BASE_ADDR);    //close dlane9's DQS&DQ OE
    // set_field_by_apb("DLANE9_DLANERXBYPCTRL", 'h17,  `DDR_PHY_BASE_ADDR);
endtask

task apb_swerror_ecc_scrubber_seq::ecc_scrub_backtoback(input bit[31:0] ctrl_addr);
    //trig_mode=2'b00 ecc scrub back to back
    //trig_mode=2'b01 advecc scrub back to back
    //trig_mode=2'b10 scbr_fifo_full check
    //trig_mode=2'b11 scbr round done check

    if(trig_mode[1]==0)begin
        if(trig_mode[0]==0)begin
            //ecc_enable
            `uvm_info(get_full_name(), "set ecc_enable ", UVM_LOW);
            set_field_by_apb("CTL_SBECCEN", 1, ctrl_addr);
            set_field_by_apb("CTL_SBECCCHKEN", 1, ctrl_addr);
        end
        else if(trig_mode[0]==1)begin
            `uvm_info(get_full_name(), "set advecc_enable ", UVM_LOW);
            set_field_by_apb("CTL_SBECCEN", 0, ctrl_addr);
            set_field_by_apb("CTL_SBECCCHKEN", 0, ctrl_addr);
            set_field_by_apb("CTL_RSECCEN", 1, ctrl_addr);
            set_field_by_apb("CTL_RSECCCHECKEN", 1, ctrl_addr);
        end

        //set ecc_scrub_start_addr
        `uvm_info(get_full_name(), "set ecc_scrub_start_addr ", UVM_LOW);
        set_field_by_apb("CTL_SCBRSTARTADDR0", start_addr[31:0], ctrl_addr);
        set_field_by_apb("CTL_SCBRSTARTADDR1", start_addr[34:32], ctrl_addr);

        //set ecc_scrub_end_addr
        `uvm_info(get_full_name(), "set ecc_scrub_end_addr ", UVM_LOW);
        set_field_by_apb("CTL_SCBRENDADDR0", end_addr[31:0], ctrl_addr);
        set_field_by_apb("CTL_SCBRENDADDR1", end_addr[34:32], ctrl_addr);

        //set ecc_scrub_mode:0-rd,1-wr,2-writeback 3-rmw,bit[2]=1-rnd_scrb
        set_field_by_apb("CTL_SCBRMODE", scrub_mode, ctrl_addr);
        if(scrub_mode==1)begin
            set_field_by_apb("CTL_SCBRWDATA", wdata, ctrl_addr);
        end
        //set ECC_SCRUB_INTERVAL
        `uvm_info(get_full_name(), "set ECC_SCRUB_INTERVAL ", UVM_LOW);
        set_field_by_apb("CTL_SCBRPERIOD", 0, ctrl_addr);

        //set ecc_scrub_start
        filew = $fopen("scbr_start.log","w");

        `uvm_info(get_full_name(), "set ecc_scrub_start ", UVM_LOW);
        set_field_by_apb("CTL_SCBREN", 1, ctrl_addr);

        $timeformat(-9,3,"ns",10);
        s_time = $realtime;
        $fdisplay(filew,"scbr s_time %t",s_time);

    end
    else if (trig_mode==2'b10)begin
        `uvm_info(get_full_name(), "wait fifofull intr ", UVM_LOW);
        get_field_poll_by_apb("CTL_SCBRFIXRMWFIFOFULL",1,ctrl_addr);

    end
    else if(trig_mode==2'b11)begin
        filew = $fopen("scbr_end.log","w");

        `uvm_info(get_full_name(), "wait scrub_round done ", UVM_LOW);
        get_field_poll_by_apb("CTL_SCBRROUNDDONE",1,ctrl_addr);
        e_time = $realtime;
        $fdisplay(filew,"scbr e_time %t",e_time);
        //$fdisplay(filew,"scbr delay %t",(e_time-s_time));
    end
endtask

task apb_swerror_ecc_scrubber_seq::advecc_scrub_cfg(input bit[31:0] ctrl_addr,input [2:0] scrub_mode,input [34:0] start_addr,input [34:0] end_addr);

    //advecc_enable
    `uvm_info(get_full_name(), "set advecc_enable ", UVM_LOW);

    set_field_by_apb("CTL_RSECCEN", 1, ctrl_addr);
    set_field_by_apb("CTL_RSECCCHECKEN", 1, ctrl_addr);
    set_field_by_apb("CTL_SBECCEN", 0, ctrl_addr);
    set_field_by_apb("CTL_SBECCCHKEN", 0, ctrl_addr);
    //advecc type
    set_field_by_apb("CTL_RSSYMGRPTYPE", grp_type, ctrl_addr);
    // set_field_by_apb("CTL_RSECCUCADJUSTEN", 1, ctrl_addr);


    //set ecc_scrub_start_addr
    `uvm_info(get_full_name(), "set ecc_scrub_start_addr ", UVM_LOW);
    set_field_by_apb("CTL_SCBRSTARTADDR0", start_addr[31:0], ctrl_addr);
    set_field_by_apb("CTL_SCBRSTARTADDR1", start_addr[34:32], ctrl_addr);

    //set ecc_scrub_end_addr
    `uvm_info(get_full_name(), "set ecc_scrub_end_addr ", UVM_LOW);
    set_field_by_apb("CTL_SCBRENDADDR0", end_addr[31:0], ctrl_addr);
    set_field_by_apb("CTL_SCBRENDADDR1", end_addr[34:32], ctrl_addr);

    //set ecc_scrub_mode:0-rd,1-wr,2-writeback 3-rmw,bit[2]=1-rnd_scrb
    set_field_by_apb("CTL_SCBRMODE", scrub_mode, ctrl_addr);
    if(scrub_mode==1)begin
        set_field_by_apb("CTL_SCBRWDATA", wdata, ctrl_addr);
    end
    if(scrub_mode[2]==1)begin
        `uvm_info(get_full_name(), "set ROUND_SCRUB_INTERVAL ", UVM_LOW);
        set_field_by_apb("CTL_SCBRRNDINTERVAL", 1, ctrl_addr);
    end
    //set ECC_SCRUB_INTERVAL
    `uvm_info(get_full_name(), "set ECC_SCRUB_INTERVAL ", UVM_LOW);
    set_field_by_apb("CTL_SCBRPERIOD", 1, ctrl_addr);

    //set ecc_scrub_start
    `uvm_info(get_full_name(), "set ecc_scrub_start ", UVM_LOW);
    set_field_by_apb("CTL_SCBREN", 1, ctrl_addr);

endtask

task apb_swerror_ecc_scrubber_seq::apb_sbecc_scrub_cfg(input bit[31:0] base_addr);
    `uvm_info(get_full_name(), "set apb_ecc scrub int enable/cnt enbale  ", UVM_LOW);
    //cor int/cnt
    USR_REGRD(base_addr+`SBECC_SCBR_CTRL_CFG_ADDR,rdata);
    rdata[0]=1;
    rdata[1]=1;
    // uncor int/cnt
    rdata[16]=1;
    rdata[17]=1;
    USR_REGWR(base_addr+`SBECC_SCBR_CTRL_CFG_ADDR,rdata);
    //scbr cmd id expand en
    USR_REGRD(base_addr+`ECC_SCBR_FUNC_ADDR,rdata);
    rdata[0]=1;
    USR_REGWR(base_addr+`ECC_SCBR_FUNC_ADDR,rdata);
    //port cor int/cnt
    USR_REGRD(base_addr+`SBECC_PORT_CTRL_CFG_ADDR,rdata);
    rdata[0]=1;
    rdata[1]=1;
    //port uncor int/cnt
    rdata[16]=1;
    rdata[17]=1;
    USR_REGWR(base_addr+`SBECC_PORT_CTRL_CFG_ADDR,rdata);

endtask

task apb_swerror_ecc_scrubber_seq::apb_rsecc_scrub_cfg(input bit[31:0] base_addr);
    `uvm_info(get_full_name(), "set apb_ecc scrub int enable/cnt enbale  ", UVM_LOW);
    //cor int/cnt
    USR_REGRD(base_addr+`RSECC_SCBR_CTRL_CFG_ADDR,rdata);
    rdata[0]=1;
    rdata[1]=1;
    // uncor int/cnt
    rdata[16]=1;
    rdata[17]=1;
    USR_REGWR(base_addr+`RSECC_SCBR_CTRL_CFG_ADDR,rdata);
    //scbr cmd id expand en
    USR_REGRD(base_addr+`ECC_SCBR_FUNC_ADDR,rdata);
    rdata[0]=1;
    USR_REGWR(base_addr+`ECC_SCBR_FUNC_ADDR,rdata);
    //port cor int/cnt
    USR_REGRD(base_addr+`RSECC_PORT_CTRL_CFG_ADDR,rdata);
    rdata[0]=1;
    rdata[1]=1;
    //port uncor int/cnt
    rdata[16]=1;
    rdata[17]=1;
    USR_REGWR(base_addr+`RSECC_PORT_CTRL_CFG_ADDR,rdata);

endtask

task apb_swerror_ecc_scrubber_seq::apb_ecc_scrub_chk(input bit[31:0] base_addr);
    `uvm_info(get_full_name(), "check apb_ecc scrub int/cnt  ", UVM_LOW);
    //err_mode:
    //-00 sbecc cor
    //-01 sbecc uncor
    //-10 advecc cor
    //-11 advecc uncor
    if(err_mode==2'b00)begin
        //cor int/cnt
        USR_REGRD(base_addr+`ECC_CTRL_INT_STATE_ADDR,rdata);
        while(rdata[16] != 1) begin
            USR_REGRD(base_addr+`ECC_CTRL_INT_STATE_ADDR,rdata);
        end
        USR_REGRD(base_addr+`SBECC_SCBR_CNT_ADDR,rdata);
        `uvm_info(get_type_name(), $sformatf("correctable apb_ecc_scbr cnt=%0h", rdata[15:0]),UVM_LOW);
        USR_REGRD(base_addr+`SBECC_SCBR_CORR_RECORD_ADDR0_ADDR,rdata);
        USR_REGRD(base_addr+`SBECC_SCBR_CORR_RECORD_ADDR1_ADDR,rdata_row);
        `uvm_info(get_type_name(), $sformatf(" the 1st correctable apb_ecc_scbr addr:cs=%0h,cid=%0h,ba=%0h,col=%0h,row=%0h", rdata[17:16],rdata[26:24],rdata[4:0],rdata[14:8],rdata_row),UVM_LOW);
    end
    // uncor int/cnt
    if(err_mode==2'b01)begin
        USR_REGRD(base_addr+`ECC_CTRL_INT_STATE_ADDR,rdata);
        while(rdata[17] != 1) begin
            USR_REGRD(base_addr+`ECC_CTRL_INT_STATE_ADDR,rdata);
        end
        USR_REGRD(base_addr+`SBECC_SCBR_CNT_ADDR,rdata);
        `uvm_info(get_type_name(), $sformatf("uncorrectable apb_ecc_scbr cnt=%0h", rdata[31:16]),UVM_LOW);
        USR_REGRD(base_addr+`SBECC_SCBR_UNCORR_RECORD_ADDR0_ADDR,rdata);
        USR_REGRD(base_addr+`SBECC_SCBR_UNCORR_RECORD_ADDR1_ADDR,rdata_row);
        `uvm_info(get_type_name(), $sformatf(" the 1st uncorrectable apb_ecc_scbr addr:cs=%0h,cid=%0h,ba=%0h,col=%0h,row=%0h", rdata[17:16],rdata[26:24],rdata[4:0],rdata[14:8],rdata_row),UVM_LOW);
    end
    if(err_mode==2'b10)begin
        //cor int/cnt
        USR_REGRD(base_addr+`ECC_CTRL_INT_STATE_ADDR,rdata);
        while(rdata[18] != 1) begin
            USR_REGRD(base_addr+`ECC_CTRL_INT_STATE_ADDR,rdata);
        end
        USR_REGRD(base_addr+`RSECC_SCBR_CNT_ADDR,rdata);
        `uvm_info(get_type_name(), $sformatf("correctable apb_advecc_scbr cnt=%0h", rdata[15:0]),UVM_LOW);
        USR_REGRD(base_addr+`RSECC_SCBR_CORR_RECORD_ADDR0_1_ADDR,rdata);
        USR_REGRD(base_addr+`RSECC_SCBR_CORR_RECORD_ADDR1_1_ADDR,rdata_row);
        `uvm_info(get_type_name(), $sformatf(" the 1st correctable apb_advecc_scbr addr:cs=%0h,cid=%0h,ba=%0h,col=%0h,row=%0h", rdata[17:16],rdata[26:24],rdata[4:0],rdata[14:8],rdata_row),UVM_LOW);
    end
    // uncor int/cnt
    if(err_mode==2'b11)begin
        USR_REGRD(base_addr+`ECC_CTRL_INT_STATE_ADDR,rdata);
        while(rdata[19] != 1) begin
            USR_REGRD(base_addr+`ECC_CTRL_INT_STATE_ADDR,rdata);
        end
        USR_REGRD(base_addr+`RSECC_SCBR_CNT_ADDR,rdata);
        `uvm_info(get_type_name(), $sformatf("uncorrectable apb_advecc_scbr cnt=%0h", rdata[31:16]),UVM_LOW);
        USR_REGRD(base_addr+`RSECC_SCBR_UNCORR_RECORD_ADDR0_ADDR,rdata);
        USR_REGRD(base_addr+`RSECC_SCBR_UNCORR_RECORD_ADDR1_ADDR,rdata_row);
        `uvm_info(get_type_name(), $sformatf(" the 1st uncorrectable apb_advecc_scbr addr:cs=%0h,cid=%0h,ba=%0h,col=%0h,row=%0h", rdata[17:16],rdata[26:24],rdata[4:0],rdata[14:8],rdata_row),UVM_LOW);
    end
endtask

task apb_swerror_ecc_scrubber_seq::apb_ecc_scrub_clr(input bit[31:0] base_addr);
    `uvm_info(get_full_name(), "clr apb_ecc int", UVM_LOW);
    if(err_mode==2'b00)begin
        //cor int clr
        USR_REGRD(base_addr+`SBECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[0]=1;
        USR_REGWR(base_addr+`SBECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[1]=1;
        USR_REGWR(base_addr+`SBECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[1:0]=0;
        USR_REGWR(base_addr+`SBECC_SCBR_CLR_CFG_ADDR,rdata);
    end
    if(err_mode==2'b01)begin
        // uncor int clr
        USR_REGRD(base_addr+`SBECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[16]=1;
        USR_REGWR(base_addr+`SBECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[17]=1;
        USR_REGWR(base_addr+`SBECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[17:16]=0;
        USR_REGWR(base_addr+`SBECC_SCBR_CLR_CFG_ADDR,rdata);
    end
    if(err_mode==2'b10)begin
        //cor int clr
        USR_REGRD(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[0]=1;
        USR_REGWR(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[1]=1;
        USR_REGWR(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[2]=1;
        USR_REGWR(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[2:0]=0;
        USR_REGWR(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
    end
    if(err_mode==2'b11)begin
        // uncor int clr
        USR_REGRD(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[16]=1;
        USR_REGWR(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[17]=1;
        USR_REGWR(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[18]=1;
        USR_REGWR(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
        rdata[18:16]=0;
        USR_REGWR(base_addr+`RSECC_SCBR_CLR_CFG_ADDR,rdata);
    end
endtask

task apb_swerror_ecc_scrubber_seq::xmu_hold_state(input bit[31:0] base_addr,input hold_mode);
    if(hold_mode==1)
        set_field_by_apb("CTL_XMUHOLD",1,base_addr);
    else
        set_field_by_apb("CTL_XMUHOLD",0,base_addr);
endtask

`endif