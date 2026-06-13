/*
 * @Project Name:
 * @Team: verify.simu
 * @Author: huangyinjian
 * @Email: huangyinjian2356@phytium.com.cn
 * @Date: 2025-03-12 10:47:56
 * @LastEditTime: 2026-05-29 11:54:20
 * @Description:
 * Copyright(c)2025 Phytium.co.Ltd
 */

`ifdef SIMU_DMU_APB_FTVIP

class apb_base_uvddr_seq extends apb_base_seq;

    `uvm_object_utils(apb_base_uvddr_seq)

    `include "init_config_task.sv"
    freq_q fsp_queue;

    function new(string name = "apb_base_uvddr_seq");
        super.new(name);
        `ifndef SIMU_CHI_PORT_ENV
        fsp_queue = get_freq();
        `endif
    endfunction

    task sw_mpc_flow(input bit [31:0] base_addr=`DDR_PHY_BASE_ADDR, input int mpc_dat, input int mpc_rk);
        bit mpc_trig, mpc_busy;
        get_field_by_apb("CTL_MPCTRIG", mpc_trig, base_addr);
        get_field_by_apb("CTL_MPCBUSY", mpc_busy, base_addr);

        if(mpc_trig || mpc_busy) begin
            `uvm_info(get_full_name(), $sformatf("%0t, sw_mpc_flow, curr mpc_trig is %0d, mpc_busy is %0d, so do nothing",$time, mpc_trig, mpc_busy),UVM_LOW);
        end else begin
            set_field_by_apb("CTL_MPCDAT", mpc_dat, base_addr);
            set_field_by_apb("CTL_MPCRANK", mpc_rk, base_addr);
            set_field_by_apb("CTL_MPCTRIG", 1, base_addr);
            wait_field_2ch("CTL_MPCTRIG", 0, base_addr);
            wait_field_2ch("CTL_MPCBUSY", 0, base_addr);
            `uvm_info(get_full_name(), $sformatf("%0t, sw_mpc_flow done, base_addr is %0d, mpc_dat is %0h, mpc_rk is %0h",$time, base_addr, mpc_dat, mpc_rk),UVM_LOW);
        end
    endtask : sw_mpc_flow

    task mr4_en_flow(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, input int mr4_rd_inter, input bit[3:0] cs);
        set_field_by_apb("CTL_MRR4EN", 0, base_addr);
        set_field_by_apb("CTL_MR4RDINTER", mr4_rd_inter, base_addr);
        set_field_by_apb("CTL_MRR4RANK", cs, base_addr);
        set_field_by_apb("CTL_MRR4EN", 1, base_addr);
    endtask : mr4_en_flow

    task fgr_flow( input bit[1:0] ref_mode, int freq_point);//ref_mode:0,normal;1,fgr
        bit pdnen, sren, dfilpensr, sdramcgen;
        int rfm_en;
        bit master_ch=0;
        bit[31:0] rdata;
        bit[7:0] mr4_value_ch0;
        bit[7:0] mr4_value_ch1;
        get_field_by_apb("CTL_MCMASTEREN", rdata, `DDR_CTL0_BASE_ADDR);
        if(rdata==1) begin
            master_ch = 0;
        end else begin
            master_ch = 1;
        end

        $display($psprintf("%0t, fgr_flow step 1",$time));
        set_field_by_apb("CTL_XMUHOLD", 1'b1,`DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_XMUHOLD", 1'b1,`DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_SWDRAINQUEUEEN", 1'b1,`DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_SWDRAINQUEUEEN", 1'b1,`DDR_CTL1_BASE_ADDR);

        $display($psprintf("%0t, fgr_flow step 2",$time));
        wait_field_2ch("CTL_MCIDLE", 1'b1, `DDR_CTL0_BASE_ADDR);
        wait_field_2ch("CTL_MCIDLE", 1'b1, `DDR_CTL1_BASE_ADDR);

        $display($psprintf("%0t, fgr_flow step 3",$time));
        set_field_by_apb("CTL_DRAINREFBEFORESRE", 1'b1,`DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_DRAINREFBEFORESRE", 1'b1,`DDR_CTL1_BASE_ADDR);

        if(master_ch==0) begin
            $display($psprintf("%0t, fgr_flow step 4",$time));
            set_field_by_apb("CTL_FGRSTART", 1'b1, `DDR_CTL0_BASE_ADDR);

            $display($psprintf("%0t, fgr_flow step 5",$time));
            wait_field_2ch("CTL_ARBSTATE", 'h200, `DDR_CTL0_BASE_ADDR);
        end else begin
            $display($psprintf("%0t, fgr_flow step 4",$time));
            set_field_by_apb("CTL_FGRSTART", 1'b1, `DDR_CTL1_BASE_ADDR);

            $display($psprintf("%0t, fgr_flow step 5",$time));
            wait_field_2ch("CTL_ARBSTATE", 'h200, `DDR_CTL1_BASE_ADDR);
        end

        set_field_by_apb("CTL_FREQACCEPOINT", freq_point);
        get_field_by_apb("CTL_MR4VALUE", mr4_value_ch0, `DDR_CTL0_BASE_ADDR);
        get_field_by_apb("CTL_MR4VALUE", mr4_value_ch1, `DDR_CTL1_BASE_ADDR);

        $display($psprintf("%0t, fgr_flow step 6",$time));
        if(master_ch==0) begin
            set_field_by_apb("CTL_SRTYPE", 1'b1, `DDR_CTL0_BASE_ADDR);
            set_field_by_apb("CTL_SRTRIG", 1'b1, `DDR_CTL0_BASE_ADDR);
            wait_field_2ch("CTL_SRTRIG", 1'b0, `DDR_CTL1_BASE_ADDR);
            wait_field_2ch("CTL_SRBUSY", 1'b0, `DDR_CTL1_BASE_ADDR);
        end else begin
            set_field_by_apb("CTL_SRTYPE", 1'b1, `DDR_CTL1_BASE_ADDR);
            set_field_by_apb("CTL_SRTRIG", 1'b1, `DDR_CTL1_BASE_ADDR);
            wait_field_2ch("CTL_SRTRIG", 1'b0, `DDR_CTL1_BASE_ADDR);
            wait_field_2ch("CTL_SRBUSY", 1'b0, `DDR_CTL1_BASE_ADDR);
        end

        $display($psprintf("%0t, fgr_flow step 7",$time));
        if(master_ch==0) begin
            wait_field_2ch("CTL_DDRLPSTATE", 2, `DDR_CTL0_BASE_ADDR);
        end else begin
            wait_field_2ch("CTL_DDRLPSTATE", 2, `DDR_CTL1_BASE_ADDR);
        end

        $display($psprintf("%0t, fgr_flow step 8",$time));
        mr4_value_ch0[4] = ref_mode;
        mr4_value_ch1[4] = ref_mode;
        set_field_by_apb("CTL_REFMODE", ref_mode, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_REFMODE", ref_mode, `DDR_CTL1_BASE_ADDR);
        for(int i=0; i<`CLK_DMU_FREQ_NUM; i++) begin
            set_field_by_apb("CTL_FREQACCEPOINT", i);
            set_field_by_apb("CTL_MR4VALUE", mr4_value_ch0, `DDR_CTL0_BASE_ADDR);
            set_field_by_apb("CTL_MR4VALUE", mr4_value_ch1, `DDR_CTL1_BASE_ADDR);
        end
        set_field_by_apb("CTL_FREQACCEPOINT", freq_point);

        $display($psprintf("%0t, fgr_flow step 9",$time));
        if(master_ch==0) begin
            set_field_by_apb("CTL_SRTYPE", 1'b0, `DDR_CTL0_BASE_ADDR);
            set_field_by_apb("CTL_SRTRIG", 1'b1, `DDR_CTL0_BASE_ADDR);
            wait_field_2ch("CTL_SRTRIG", 1'b0, `DDR_CTL0_BASE_ADDR);
            wait_field_2ch("CTL_SRBUSY", 1'b0, `DDR_CTL0_BASE_ADDR);

            $display($psprintf("%0t, fgr_flow step 10",$time));
            set_field_by_apb("CTL_FGRSTART", 1'b0, `DDR_CTL0_BASE_ADDR);
        end else begin
            set_field_by_apb("CTL_SRTYPE", 1'b0, `DDR_CTL1_BASE_ADDR);
            set_field_by_apb("CTL_SRTRIG", 1'b1, `DDR_CTL1_BASE_ADDR);
            wait_field_2ch("CTL_SRTRIG", 1'b0, `DDR_CTL1_BASE_ADDR);
            wait_field_2ch("CTL_SRBUSY", 1'b0, `DDR_CTL1_BASE_ADDR);

            $display($psprintf("%0t, fgr_flow step 10",$time));
            set_field_by_apb("CTL_FGRSTART", 1'b0, `DDR_CTL1_BASE_ADDR);
        end

        $display($psprintf("%0t, fgr_flow step 11",$time));
        set_field_by_apb("CTL_XMUHOLD", 1'b0,`DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_XMUHOLD", 1'b0,`DDR_CTL1_BASE_ADDR);
        set_field_by_apb("PUM_TOP_DFIREQSTATE", ref_mode,`DDR_CTL0_BASE_ADDR);
        set_field_by_apb("PUM_TOP_DFIREQSTATE", ref_mode,`DDR_CTL1_BASE_ADDR);
        set_field_by_apb("PUM_TOP_REFMODE", ref_mode,`DDR_CTL0_BASE_ADDR);
        set_field_by_apb("PUM_TOP_REFMODE", ref_mode,`DDR_CTL1_BASE_ADDR);

    endtask : fgr_flow

    task fgr_flow_all(input bit ref_ab1_sb0, input bit[1:0] ref_mode);//ref_mode:0,normal;1,fgr
        bit pdnen0, sren0, dfilpensr0, sdramcgen0;
        bit pdnen1, sren1, dfilpensr1, sdramcgen1;
        int rfm_en0;
        int rfm_en1;

        hold_xmu_uif(`DDR_CTL0_BASE_ADDR);
        hold_xmu_uif(`DDR_CTL1_BASE_ADDR);

        exit_low_power_state_all(pdnen0,pdnen1,sren0,sren1);

        polling_periodic_sw_event(`DDR_CTL0_BASE_ADDR);
        polling_periodic_sw_event(`DDR_CTL1_BASE_ADDR);

        set_field_by_apb("CTL_FGRSTART", 1, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_FGRSTART", 1, `DDR_CTL1_BASE_ADDR);
        wait_field_2ch("CTL_ARBSTATE", 1, `DDR_CTL0_BASE_ADDR);
        wait_field_2ch("CTL_ARBSTATE", 1, `DDR_CTL1_BASE_ADDR);
        wait_field_2ch("CTL_ARBSTATE", 1, `DDR_CTL0_BASE_ADDR);
        wait_field_2ch("CTL_ARBSTATE", 1, `DDR_CTL1_BASE_ADDR);

        get_field_by_apb("CTL_DFILPENSR", dfilpensr0, `DDR_CTL0_BASE_ADDR);
        get_field_by_apb("CTL_DFILPENSR", dfilpensr1, `DDR_CTL1_BASE_ADDR);
        get_field_by_apb("CTL_SDRAMCGENSRDEEP", sdramcgen0, `DDR_CTL0_BASE_ADDR);
        get_field_by_apb("CTL_SDRAMCGENSRDEEP", sdramcgen1, `DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_DFILPENSR", 0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_DFILPENSR", 0, `DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_SDRAMCGENSRDEEP", 0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_SDRAMCGENSRDEEP", 0, `DDR_CTL1_BASE_ADDR);
        sr_entry_all();
        set_field_by_apb("CTL_REFMODE", ref_mode, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_REFMODE", ref_mode, `DDR_CTL1_BASE_ADDR);

        begin
            bit refswen0;
            bit refswen1;
            int mr4_0;
            int mr4_1;
            get_field_by_apb("CTL_REFSWEN", refswen0, `DDR_CTL0_BASE_ADDR);
            get_field_by_apb("CTL_REFSWEN", refswen1, `DDR_CTL1_BASE_ADDR);
            if(refswen0 == 1 || refswen1 == 1) begin
                `uvm_info(get_full_name(), $sformatf("%0t, refswen is not 0, mode only can be refab",$time),UVM_LOW);
            end else begin
                set_field_by_apb("CTL_REFABREQEN", ref_ab1_sb0, `DDR_CTL0_BASE_ADDR);
                set_field_by_apb("CTL_REFABREQEN", ref_ab1_sb0, `DDR_CTL1_BASE_ADDR);
                get_field_by_apb("CTL_RFMEN", rfm_en0, `DDR_CTL0_BASE_ADDR);
                get_field_by_apb("CTL_RFMEN", rfm_en1, `DDR_CTL1_BASE_ADDR);
                if(rfm_en0 == 1 && rfm_en1 == 1)begin
                    set_field_by_apb("CTL_RFMABEN", ref_ab1_sb0, `DDR_CTL0_BASE_ADDR);
                    set_field_by_apb("CTL_RFMABEN", ref_ab1_sb0, `DDR_CTL1_BASE_ADDR);
                end
                else begin
                    `uvm_info(get_full_name(),"channel0/1 RFM function has not enable",UVM_LOW);
                end
            end
            get_field_by_apb("CTL_MR4VALUE", mr4_0, `DDR_CTL0_BASE_ADDR);
            get_field_by_apb("CTL_MR4VALUE", mr4_1, `DDR_CTL1_BASE_ADDR);
            mr4_0[4] = ref_mode;
            mr4_1[4] = ref_mode;
            set_field_by_apb("CTL_MR4VALUE", mr4_0, `DDR_CTL0_BASE_ADDR);
            set_field_by_apb("CTL_MR4VALUE", mr4_1, `DDR_CTL1_BASE_ADDR);
        end

        sr_exit_all();
        wait_field_2ch("CTL_SWOPBUSY", 0, `DDR_CTL0_BASE_ADDR);
        wait_field_2ch("CTL_SWOPBUSY", 0, `DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_PDNEN", pdnen0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_PDNEN", pdnen1, `DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_SREN", sren0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_SREN", sren1, `DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_DFILPENSR", dfilpensr0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_DFILPENSR", dfilpensr1, `DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_SDRAMCGENSRDEEP", sdramcgen0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_SDRAMCGENSRDEEP", sdramcgen1, `DDR_CTL1_BASE_ADDR);
        unhold_xmu_uif(`DDR_CTL0_BASE_ADDR);
        unhold_xmu_uif(`DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_FGRSTART", 0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_FGRSTART", 0, `DDR_CTL1_BASE_ADDR);

    endtask : fgr_flow_all

    task hold_xmu_uif(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR);
        bit[31:0] rd_data;

        set_field_by_apb("CTL_XMUHOLD", 1, base_addr);
        while(1) begin
            get_field_by_apb("CTL_XMUIDLE", rd_data, base_addr);
            if(rd_data == 1) begin
                break;
            end
        end

        set_field_by_apb("CTL_UIFHOLD", 1, base_addr);

        while(1) begin
            get_field_by_apb("CTL_MCIDLE", rd_data, base_addr);
            if(rd_data == 1) begin
                break;
            end
        end
    endtask : hold_xmu_uif

    task exit_low_power_state(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, output bit pdnen, output bit sren);
        bit swmpsm;
        get_field_by_apb("CTL_PDNEN", pdnen, base_addr);
        get_field_by_apb("CTL_SREN", sren, base_addr);
        set_field_by_apb("CTL_PDNEN", 0, base_addr);
        set_field_by_apb("CTL_SREN", 0, base_addr);

        sr_exit(base_addr);

        get_field_by_apb("CTL_SWMPSM", swmpsm, base_addr);
        if(swmpsm == 1) begin
            mpsmx_flow(base_addr);
            set_field_by_apb("CTL_SWCMDSTART", 0, base_addr);
        end

        wait_field_2ch("CTL_DDRLPSTATE", 0, base_addr);
    endtask : exit_low_power_state

    task exit_low_power_state_all(output bit pdnen0, output bit pdnen1, output bit sren0, output bit sren1);
        bit swmpsm0;
        bit swmpsm1;

        get_field_by_apb("CTL_PDNEN", pdnen0, `DDR_CTL0_BASE_ADDR);
        get_field_by_apb("CTL_PDNEN", pdnen1, `DDR_CTL1_BASE_ADDR);
        get_field_by_apb("CTL_SREN", sren0, `DDR_CTL0_BASE_ADDR);
        get_field_by_apb("CTL_SREN", sren1, `DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_PDNEN", 0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_PDNEN", 0, `DDR_CTL1_BASE_ADDR);
        set_field_by_apb("CTL_SREN", 0, `DDR_CTL0_BASE_ADDR);
        set_field_by_apb("CTL_SREN", 0, `DDR_CTL1_BASE_ADDR);

        sr_exit_all();

        get_field_by_apb("CTL_SWMPSM", swmpsm0, `DDR_CTL0_BASE_ADDR);
        get_field_by_apb("CTL_SWMPSM", swmpsm1, `DDR_CTL1_BASE_ADDR);
        if(swmpsm0 == 1 && swmpsm1 == 1) begin
            mpsmx_flow(`DDR_CTL0_BASE_ADDR);
            mpsmx_flow(`DDR_CTL1_BASE_ADDR);
            set_field_by_apb("CTL_SWCMDSTART", 0, `DDR_CTL0_BASE_ADDR);
            set_field_by_apb("CTL_SWCMDSTART", 0, `DDR_CTL1_BASE_ADDR);
        end

        wait_field_2ch("CTL_DDRLPSTATE", 0, `DDR_CTL0_BASE_ADDR);
        wait_field_2ch("CTL_DDRLPSTATE", 0, `DDR_CTL1_BASE_ADDR);
    endtask : exit_low_power_state_all

    task mpsmx_flow(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR);
        int mr2_value;
        get_field_by_apb("CTL_MR2VALUE", mr2_value, base_addr);
        mr2_value[3] = 0;
        set_field_by_apb("CTL_MR2VALUE", mr2_value, base_addr);

        set_field_by_apb("CTL_MPSMTYPE", 0, base_addr);
        set_field_by_apb("CTL_MPSMTRIG", 1, base_addr);
        wait_field_2ch("CTL_MPSMTRIG", 0, base_addr);
        wait_field_2ch("CTL_MPSMBUSY", 0, base_addr);
    endtask : mpsmx_flow

    task sr_exit(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR);
        bit swsr;

        wait_field_2ch("CTL_SRTRIG", 0, base_addr);
        wait_field_2ch("CTL_SRBUSY", 0, base_addr);

        get_field_by_apb("CTL_SWSR", swsr, base_addr);
        if(swsr == 1) begin
            set_field_by_apb("CTL_SRTYPE", 0, base_addr);
            set_field_by_apb("CTL_SRTRIG", 1, base_addr);

            wait_field_2ch("CTL_SRTRIG", 0, base_addr);
            wait_field_2ch("CTL_SRBUSY", 0, base_addr);
        end else begin
            `uvm_info(get_full_name(), $sformatf("%0t, sr_exit, curr state is not sr state, do nothing",$time),UVM_LOW);
        end
    endtask : sr_exit

    task sr_exit_all();
        bit swsr;
        bit swsr_ch1;

        wait_field_2ch("CTL_SRTRIG", 0, `DDR_CTL0_BASE_ADDR);
        wait_field_2ch("CTL_SRBUSY", 0, `DDR_CTL0_BASE_ADDR);
        //wait_field_2ch("CTL_SRTRIG", 0, `DDR_CTL1_BASE_ADDR);
        //wait_field_2ch("CTL_SRBUSY", 0, `DDR_CTL1_BASE_ADDR);

        get_field_by_apb("CTL_SWSR", swsr, `DDR_CTL0_BASE_ADDR);
        //get_field_by_apb("CTL_SWSR", swsr_ch1, `DDR_CTL1_BASE_ADDR);

        if(swsr == 1) begin
        //if(swsr == 1 && swsr_ch1 == 1) begin
            set_field_by_apb("CTL_SRTYPE", 0, `DDR_CTL0_BASE_ADDR);
            set_field_by_apb("CTL_SRTRIG", 1, `DDR_CTL0_BASE_ADDR);
            //set_field_by_apb("CTL_SRTYPE", 0, `DDR_CTL1_BASE_ADDR);
            //set_field_by_apb("CTL_SRTRIG", 1, `DDR_CTL1_BASE_ADDR);

            wait_field_2ch("CTL_SRTRIG", 0, `DDR_CTL0_BASE_ADDR);
            wait_field_2ch("CTL_SRBUSY", 0, `DDR_CTL0_BASE_ADDR);
            //wait_field_2ch("CTL_SRTRIG", 0, `DDR_CTL1_BASE_ADDR);
            //wait_field_2ch("CTL_SRBUSY", 0, `DDR_CTL1_BASE_ADDR);
        end else begin
            `uvm_info(get_full_name(), $sformatf("%0t, sr_exit, curr state is not sr state, do nothing",$time),UVM_LOW);
        end
    endtask : sr_exit_all

    task polling_periodic_sw_event(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR);
        wait_field_2ch("CTL_MPCTRIG", 0, base_addr);
        wait_field_2ch("CTL_MPCBUSY", 0, base_addr);
        wait_field_2ch("CTL_CTRLUPDTRIG", 0, base_addr);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, base_addr);
    endtask : polling_periodic_sw_event

    task sr_entry(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR);
        bit swsr;
        wait_field_2ch("CTL_SRTRIG", 0, base_addr);
        wait_field_2ch("CTL_SRBUSY", 0, base_addr);

        get_field_by_apb("CTL_SWSR", swsr, base_addr);
        if(swsr == 0) begin
            set_field_by_apb("CTL_SRTYPE", 1, base_addr);
            set_field_by_apb("CTL_SRTRIG", 1, base_addr);

            wait_field_2ch("CTL_SRTRIG", 0, base_addr);
            wait_field_2ch("CTL_SRBUSY", 0, base_addr);
        end else begin
            `uvm_info(get_full_name(), $sformatf("%0t, sr_entry, curr state is sr state, do nothing",$time),UVM_LOW);
        end
    endtask : sr_entry

    task sr_entry_all();
        bit swsr;
        bit swsr_ch1;
        wait_field_2ch("CTL_SRTRIG", 0, `DDR_CTL0_BASE_ADDR);
        wait_field_2ch("CTL_SRBUSY", 0, `DDR_CTL0_BASE_ADDR);
        //wait_field_2ch("CTL_SRTRIG", 0, `DDR_CTL1_BASE_ADDR);
        //wait_field_2ch("CTL_SRBUSY", 0, `DDR_CTL1_BASE_ADDR);

        get_field_by_apb("CTL_SWSR", swsr, `DDR_CTL0_BASE_ADDR);
        //get_field_by_apb("CTL_SWSR", swsr_ch1, `DDR_CTL1_BASE_ADDR);

        if(swsr == 0 ) begin
        //  if(swsr == 0 && swsr_ch1 == 0) begin
            set_field_by_apb("CTL_SRTYPE", 1, `DDR_CTL0_BASE_ADDR);
            set_field_by_apb("CTL_SRTRIG", 1, `DDR_CTL0_BASE_ADDR);
            //set_field_by_apb("CTL_SRTYPE", 1, `DDR_CTL1_BASE_ADDR);
            //set_field_by_apb("CTL_SRTRIG", 1, `DDR_CTL1_BASE_ADDR);

            wait_field_2ch("CTL_SRTRIG", 0, `DDR_CTL0_BASE_ADDR);
            wait_field_2ch("CTL_SRBUSY", 0, `DDR_CTL0_BASE_ADDR);
            //wait_field_2ch("CTL_SRTRIG", 0, `DDR_CTL1_BASE_ADDR);
            //wait_field_2ch("CTL_SRBUSY", 0, `DDR_CTL1_BASE_ADDR);
        end else begin
            `uvm_info(get_full_name(), $sformatf("%0t, sr_entry, curr state is sr state, do nothing",$time),UVM_LOW);
        end
    endtask : sr_entry_all

    task wait_field_2ch(input string field_name, input int need_state, input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR);
        int state;
        while(1) begin
            get_field_by_apb(field_name, state, base_addr);
            if(state == need_state) begin
                break;
            end
        end
    endtask : wait_field_2ch

    task unhold_xmu_uif(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR);
        set_field_by_apb("CTL_UIFHOLD", 0, base_addr);
        set_field_by_apb("CTL_XMUHOLD", 0, base_addr);
    endtask : unhold_xmu_uif

    task mrr_handle(input bit[31:0] base_addr, input bit[3:0] mrrank, input bit[8:0] mraddr, output bit[63:0] mrdat, output bit[15:0] mrdatecc);
        set_field_by_apb("CTL_MRRANK", mrrank, base_addr);
        set_field_by_apb("CTL_MRADDR", mraddr, base_addr);
        set_field_by_apb("CTL_MRTYPE", 1, base_addr);
        set_field_by_apb("CTL_MRTRIG", 1, base_addr);
        wait_field_2ch("CTL_MRTRIG", 0, base_addr);
        wait_field_2ch("CTL_MRBUSY", 0, base_addr);
        //wait_field_2ch("CTL_MRRDATVLD", 1,base_addr); //0822 version add

        get_field_by_apb("CTL_MRRDAT0", mrdat[31:0], base_addr);
        get_field_by_apb("CTL_MRRDAT1", mrdat[63:32], base_addr);
        get_field_by_apb("CTL_MRRDATECC", mrdatecc, base_addr);
        $display($psprintf("%0t, mrr_handle done, base_addr is %0h, mrrank is %0h, mraddr is %0h, mrdat is %0h, mrdatecc is %0h",$time, base_addr, mrrank, mraddr, mrdat, mrdatecc));
    endtask : mrr_handle

    task mrw_handle(input bit[31:0] base_addr, input bit[3:0] mrrank, input bit[8:0] mraddr, input bit[15:0] mrdat);
        set_field_by_apb("CTL_MRRANK", mrrank, base_addr);
        set_field_by_apb("CTL_MRADDR", mraddr, base_addr);
        set_field_by_apb("CTL_MRWDAT", mrdat, base_addr);
        set_field_by_apb("CTL_MRTYPE", 0, base_addr);
        set_field_by_apb("CTL_MRTRIG", 1, base_addr);
        wait_field_2ch("CTL_MRTRIG", 0, base_addr);
        wait_field_2ch("CTL_MRBUSY", 0, base_addr);

        $display($psprintf("%0t, mrw_handle done, base_addr is %0h, mrrank is %0h, mraddr is %0h, mrdat is %0h",$time, base_addr, mrrank, mraddr, mrdat));
    endtask : mrw_handle

    task mrr_flow(input bit[8:0] mraddr, input bit[3:0] mrrank, output bit[63:0] mrdat, input bit[31:0] base_addr, output bit[15:0] mrdatecc);
        bit pdnen, sren;
        hold_xmu_uif(base_addr);
        exit_low_power_state(base_addr, pdnen, sren);
        set_field_by_apb("CTL_SWCMDSTART", 1, base_addr);
        mrr_handle(base_addr, mrrank, mraddr, mrdat, mrdatecc);
        set_field_by_apb("CTL_PDNEN", pdnen, base_addr);
        set_field_by_apb("CTL_SREN", sren, base_addr);
        unhold_xmu_uif(base_addr);
        set_field_by_apb("CTL_SWCMDSTART", 0, base_addr);

        $display($psprintf("%0t, mrr_flow done, base_addr is %0h, mrrank is %0h, mraddr is %0h, mrdat is %0h",$time, base_addr, mrrank, mraddr, mrdat));
    endtask : mrr_flow

    task mrw_flow(input bit[8:0] mraddr, input bit[3:0] mrrank, input bit[15:0] mrdat, input bit[31:0] base_addr);
        bit pdnen, sren;
        hold_xmu_uif(base_addr);
        exit_low_power_state(base_addr, pdnen, sren);
        set_field_by_apb("CTL_SWCMDSTART", 1, base_addr);
        mrw_handle(base_addr, mrrank, mraddr, mrdat);
        set_field_by_apb("CTL_PDNEN", pdnen, base_addr);
        set_field_by_apb("CTL_SREN", sren, base_addr);
        unhold_xmu_uif(base_addr);
        set_field_by_apb("CTL_SWCMDSTART", 0, base_addr);

        $display($psprintf("%0t, mrw_flow done, base_addr is %0h, mrrank is %0h, mraddr is %0h, mrdat is %0h",$time, base_addr, mrrank, mraddr, mrdat));
    endtask : mrw_flow

    task disable_auto_cmd(input bit[31:0] base_addr=`DDR_PHY_BASE_ADDR, output bit zq, output bit ctrlupd, output bit mrr4);
        get_field_by_apb("CTL_ZQCALSWEN", zq, base_addr);
        get_field_by_apb("CTL_MRR4EN", mrr4, base_addr);
        get_field_by_apb("CTL_CTRLUPDEN", ctrlupd, base_addr);

        set_field_by_apb("CTL_ZQCALSWEN", 1, base_addr);
        set_field_by_apb("CTL_MRR4EN", 0, base_addr);
        set_field_by_apb("CTL_CTRLUPDEN", 0, base_addr);
    endtask : disable_auto_cmd

    task sw_mpsm_flow(input bit[31:0] base_addr=`DDR_PHY_BASE_ADDR, input bit[1:0] mpsm_state);
        bit pdnen, sren, zq, ctrlupd, mrr4;
        bit[7:0] mr2;
        hold_xmu_uif(base_addr);
        exit_low_power_state(base_addr, pdnen, sren);
        disable_auto_cmd(base_addr, zq, ctrlupd, mrr4);
        polling_periodic_sw_event(base_addr);
        set_field_by_apb("CTL_SWCMDSTART", 1, base_addr);
        get_field_by_apb("CTL_MR2VALUE", mr2, base_addr);
        mr2[3] = 1;
        set_field_by_apb("CTL_MR2VALUE", mr2, base_addr);

        set_field_by_apb("CTL_MPSMTYPE", 1, base_addr);
        set_field_by_apb("CTL_MPSMSTATESEL", mpsm_state, base_addr);
        set_field_by_apb("CTL_MPSMTRIG", 1, base_addr);
        wait_field_2ch("CTL_MPSMTRIG", 0, base_addr);
        wait_field_2ch("CTL_MPSMBUSY", 0, base_addr);
        `uvm_info(get_full_name(), $sformatf("%0t,  sw_mpsm enter",$time),UVM_LOW);

        #5000ns;
        `uvm_info(get_full_name(), $sformatf("%0t,  sw_mpsm will exit",$time),UVM_LOW);
        mr2[3] = 0;
        set_field_by_apb("CTL_MR2VALUE", mr2, base_addr);
        set_field_by_apb("CTL_MPSMTYPE", 0, base_addr);
        set_field_by_apb("CTL_MPSMTRIG", 1, base_addr);
        wait_field_2ch("CTL_MPSMTRIG", 0, base_addr);
        wait_field_2ch("CTL_MPSMBUSY", 0, base_addr);

        sw_mpc_flow(base_addr, 5, 1);
        sw_mpc_flow(base_addr, 4, 1);

        set_field_by_apb("CTL_ZQCALSWEN", zq, base_addr);
        set_field_by_apb("CTL_MRR4EN", mrr4, base_addr);
        set_field_by_apb("CTL_PDNEN", pdnen, base_addr);
        set_field_by_apb("CTL_SREN", sren, base_addr);
        set_field_by_apb("CTL_SWCMDSTART", 0, base_addr);

        wait_field_2ch("CTL_DDRLPSTATE", 0, base_addr);
        wait_field_2ch("CTL_CTRLUPDTRIG", 0, base_addr);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, base_addr);
        set_field_by_apb("CTL_CTRLUPDTRIG", 1, base_addr);
        wait_field_2ch("CTL_CTRLUPDBUSY", 0, base_addr);
        set_field_by_apb("CTL_CTRLUPDEN", ctrlupd, base_addr);
        unhold_xmu_uif(base_addr);
        `uvm_info(get_full_name(), $sformatf("%0t, sw_mpsm exit",$time),UVM_LOW);
    endtask : sw_mpsm_flow

    task ppr_source_check(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, bit[3:0] cs, bit[3:0] cid, bit[2:0] bg, output [79:0] ppr_src);
        bit [7:0] mr14;
        bit [63:0] mrr_data;
        bit [15:0] mrr_ecc;
        mrr_handle(base_addr, cs, 14, mrr_data, mrr_ecc);
        mr14 = mrr_data[7:0];
        mr14[3:0] = cid;
        mrw_handle(base_addr, cs, 14, mr14);

        case(bg)
            3'b000,3'b001: mrr_handle(base_addr, cs, 'd54, ppr_src[63:0], ppr_src[79:64]);
            3'b010,3'b011: mrr_handle(base_addr, cs, 'd55, ppr_src[63:0], ppr_src[79:64]);
            3'b100,3'b101: mrr_handle(base_addr, cs, 'd56, ppr_src[63:0], ppr_src[79:64]);
            3'b110,3'b111: mrr_handle(base_addr, cs, 'd57, ppr_src[63:0], ppr_src[79:64]);
        endcase

        get_field_by_apb("CTL_MRRDAT0",    ppr_src[31:0], base_addr);
        get_field_by_apb("CTL_MRRDAT1",    ppr_src[63:32], base_addr);
        get_field_by_apb("CTL_MRRDATECC",  ppr_src[79:64], base_addr);
        $display($psprintf("%0t, ppr_source_check done, base_addr is %0h, cs is %0h, cid is %0h, bg is %0h, ppr_src is %0h",$time, base_addr, cs, cid, bg, ppr_src));
    endtask : ppr_source_check

    task ppr_guard_key(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, bit[3:0] cs);
        mrw_handle(base_addr, cs, 'd24, 8'b1100_1111);
        mrw_handle(base_addr, cs, 'd24, 8'b0111_0011);
        mrw_handle(base_addr, cs, 'd24, 8'b1011_1011);
        mrw_handle(base_addr, cs, 'd24, 8'b0011_1011);
    endtask : ppr_guard_key

    task ppr_wrdata_gen(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, int device_id, int mem_width);
        bit[31:0] wr_data_dq;
        bit[7:0]  wr_data_dq_mask;
        bit[15:0] wr_data_ecc_dq;
        bit[1:0]  wr_data_ecc_dq_mask;
        bit wr_data_type = 1;

        set_field_by_apb("CTL_WRDATATYPE", wr_data_type, base_addr);
        wr_data_dq = '1;
        wr_data_ecc_dq = '1;

        if(device_id < (32/mem_width)) begin
            if(mem_width=='d4) begin
                wr_data_dq[device_id*4 +: 4] = '0;
            end else if(mem_width=='d8) begin
                wr_data_dq[device_id*8 +: 8] = '0;
            end else if(mem_width=='d16) begin
                wr_data_dq[device_id*16 +: 16] = '0;
            end else begin
                assert(0);
            end
        end else begin
            if(mem_width=='d4) begin
                if(device_id=='d8) begin
                    wr_data_ecc_dq = 16'hf0f0;
                end else if(device_id=='d9) begin
                    wr_data_ecc_dq = 16'h0f0f;
                end
            end else if( (mem_width=='d8 && device_id=='d4) || (mem_width=='d16 && device_id=='d2) ) begin
                wr_data_ecc_dq = 16'h0000;
            end else begin
                assert(0);
            end
        end

        wr_data_dq_mask = '1;
        wr_data_ecc_dq_mask = '1;

        set_field_by_apb("CTL_WRDATADQ0", wr_data_dq, base_addr);
        set_field_by_apb("CTL_WRDATADQ1", wr_data_dq, base_addr);
        set_field_by_apb("CTL_WRDATADQMASK", wr_data_dq_mask, base_addr);
        set_field_by_apb("CTL_WRDATAECCCODE", wr_data_ecc_dq, base_addr);
        set_field_by_apb("CTL_WRDATAECCCODEMASK", wr_data_ecc_dq_mask, base_addr);

        $display($psprintf("%0t, ppr_wrdata_gen done, base_addr is %0h, device_id is %0h, mem_width is %0h, wr_data_dq is %0h, wr_data_dq_mask is %0h, wr_data_ecc_dq is %0h, wr_data_ecc_dq_mask is %0h",$time, base_addr, device_id, mem_width, wr_data_dq, wr_data_dq_mask, wr_data_ecc_dq, wr_data_ecc_dq_mask));
    endtask : ppr_wrdata_gen

    task ppr_recovery_procedure(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, bit sren, bit pdnen, bit zq, bit ctrlupd, bit mrr4);
        sce_resume_ref(base_addr, 4'b1111, 1, 1);

        set_field_by_apb("CTL_ZQCALSWEN", zq, base_addr);
        set_field_by_apb("CTL_MRR4EN", mrr4, base_addr);
        set_field_by_apb("CTL_CTRLUPDEN", ctrlupd, base_addr);

        set_field_by_apb("CTL_PDNEN", pdnen, base_addr);
        set_field_by_apb("CTL_SREN", sren, base_addr);
    endtask : ppr_recovery_procedure

    task sce_send_cmd(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, bit cmd_code, bit[7:0] cmd_type, bit[31:0] cmd_body, bit seq_last, bit ongoing);
        bit cmd_err;

        set_field_by_apb("CTL_CMDCODE"    , cmd_code , base_addr);
        set_field_by_apb("CTL_CMDTYPE"    , cmd_type , base_addr);
        set_field_by_apb("CTL_CMDBODY"    , cmd_body , base_addr);
        set_field_by_apb("CTL_CMDSEQLAST" , seq_last , base_addr);
        set_field_by_apb("CTL_CMDSEQONGOING", ongoing  , base_addr);
        set_field_by_apb("CTL_CMDTRIG"    , 1        , base_addr);

        wait_field_2ch("CTL_CMDTRIG"      , 0        , base_addr);
        wait_field_2ch("CTL_CMDCOMPLETE"  , 1        , base_addr);

        get_field_by_apb("CTL_CMDERR"     , cmd_err  , base_addr);

        if(cmd_err==1) begin
            $display($psprintf("%0t, sce send cmd fail, cmd_code is %0h, cmd_type is %0h, cmd_body is %0h, seq_last is %0h, ongoing is %0h, base_addr is %0h",$time, cmd_code, cmd_type, cmd_body, seq_last, ongoing, base_addr));
        end else begin
            $display($psprintf("%0t, sce send cmd success, cmd_code is %0h, cmd_type is %0h, cmd_body is %0h, seq_last is %0h, ongoing is %0h, base_addr is %0h",$time, cmd_code, cmd_type, cmd_body, seq_last, ongoing, base_addr));
        end
    endtask : sce_send_cmd

    task sce_pause_ref(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, bit[3:0] cs, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[0] = 1;
        cmd_body[1] = 0;
        cmd_body[26:23] = cs;

        sce_send_cmd(base_addr, 1, 2, cmd_body, seq_last, ongoing);
    endtask : sce_pause_ref

    task sce_preab_all_lk(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, bit[3:0] cs);
        bit[31:0] cmd_body;
        cmd_body[10] = 0;
        cmd_body[26:23] = cs;
        // for(int i=0; i<`CTL_LRANK_NUM; i++) begin
        for(int i=0; i<2; i++) begin
            cmd_body[29:27] = i;
            sce_send_cmd(base_addr, 0, 'h11, cmd_body, 1, 1);
        end

        $display($psprintf("%0t, sce_preab_all_lk done, base_addr is %0h, cs is %0h",$time, base_addr, cs));
    endtask : sce_preab_all_lk

    task sce_resume_ref(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR, bit[3:0] cs, bit seq_last, bit ongoing);
        bit[31:0] cmd_body;
        cmd_body[0] = 0;
        cmd_body[26:23] = cs;

        sce_send_cmd(base_addr, 1, 2, cmd_body, seq_last, ongoing);
    endtask : sce_resume_ref

    task pll_ctrl_setting(input int freq);
        bit [31:0] pll_ctrl;
        bit [2:0] pll_postdiv;
        bit [1:0] pll_vcosel;
        bit [1:0] pll_fbdiv;
        bit [1:0] pll_refdiv;
        bit       pll_bypass;
        bit       pll_pdcal;

        `ifdef USE_UV_PLL
        int pll_base_freq = 10000;
        `else
        int pll_base_freq = 6400;
        `endif
        int pll_mult_freq;

        pll_mult_freq = 2 * freq;

        if (pll_mult_freq <= (pll_base_freq/128)) begin
            pll_postdiv = 3'd7;
        end else if (pll_mult_freq <= (pll_base_freq/64)) begin
            pll_postdiv = 3'd6;
        end else if (pll_mult_freq <= (pll_base_freq/32)) begin
            pll_postdiv = 3'd5;
        end else if (pll_mult_freq <= (pll_base_freq/16)) begin
            pll_postdiv = 3'd4;
        end else if (pll_mult_freq <= (pll_base_freq/8)) begin
            pll_postdiv = 3'd3;
        end else if (pll_mult_freq <= (pll_base_freq/4)) begin
            pll_postdiv = 3'd2;
        end else if (pll_mult_freq <= (pll_base_freq/2)) begin
            pll_postdiv = 3'd1;
        end else begin
            pll_postdiv = 3'b0;
        end

        pll_vcosel = 2'd3;
        pll_fbdiv  = 2'b10;
        pll_refdiv = 2'b10;
        pll_bypass = 1'b0;
        pll_pdcal  = 1'b0;

        pll_ctrl = {pll_vcosel,pll_postdiv,pll_fbdiv,pll_refdiv,pll_bypass,pll_pdcal,1'b1};
        set_field_by_apb("PUM_TOP_PLLCTRL", pll_ctrl, `DDR_PHY_BASE_ADDR);
    endtask: pll_ctrl_setting

    task pll_bypass_setting;
        bit [31:0] pll_ctrl;
        bit [2:0] pll_postdiv;
        bit [1:0] pll_vcosel;
        bit [1:0] pll_fbdiv;
        bit [1:0] pll_refdiv;
        bit       pll_bypass;
        bit       pll_pdcal;

        // get_field_by_apb("PUM_TOP_PLLCTRL", pll_ctrl, `DDR_PHY_BASE_ADDR);
        // // pll_ctrl = {pll_vcosel,pll_postdiv,pll_fbdiv,pll_refdiv,pll_bypass,pll_pdcal,1'b1};
        // pll_ctrl[2]=1'b1;
        // set_field_by_apb("PUM_TOP_PLLCTRL", pll_ctrl, `DDR_PHY_BASE_ADDR);
        set_field_by_apb("PUM_TOP_PLLBYPMODE", 1'b1, `DDR_PHY_BASE_ADDR);
    endtask: pll_bypass_setting

    task ctrlupd_flow(input bit[31:0] base_addr = `DDR_PHY_BASE_ADDR,input bit hw0_sw1,input int sw_cnt);
        bit ctrlupd_en;
        bit pdnen, sren;
        get_field_by_apb("CTL_CTRLUPDEN", ctrlupd_en, base_addr);

        if( (hw0_sw1==0 && ctrlupd_en==0) || (hw0_sw1==1 && ctrlupd_en==1) ) begin
            hold_xmu_uif(base_addr);
            exit_low_power_state(base_addr, pdnen, sren);
            polling_periodic_sw_event(base_addr);
            set_field_by_apb("CTL_SWCMDSTART",1, base_addr);
            wait_field_2ch("CTL_ARBSTATE", 'h200, base_addr);
            wait_field_2ch("CTL_ARBSTATE", 'h200, base_addr);
            set_field_by_apb("CTL_CTRLUPDEN", ~hw0_sw1, base_addr);
            set_field_by_apb("CTL_PDNEN", pdnen, base_addr);
            set_field_by_apb("CTL_SREN", sren, base_addr);
            set_field_by_apb("CTL_SWCMDSTART",0, base_addr);
            unhold_xmu_uif(base_addr);
        end

        if(hw0_sw1) begin
            for(int i=0; i<sw_cnt; i++) begin
                wait_field_2ch("CTL_DDRLPSTATE", 0, base_addr);
                wait_field_2ch("CTL_CTRLUPDTRIG", 0, base_addr);
                wait_field_2ch("CTL_CTRLUPDBUSY", 0, base_addr);

                set_field_by_apb("CTL_CTRLUPDTRIG", 1, base_addr);
                wait_field_2ch("CTL_CTRLUPDBUSY", 0, base_addr);
                `uvm_info(get_type_name(),$sformatf("%0t,  sw_ctrlupd_flow done, base_addr is %0d, sw_cnt is %0d",$time, base_addr, sw_cnt),UVM_LOW);
            end
        end else begin
            `uvm_info(get_type_name(),$sformatf("%0t,  hw_ctrlupd_flow done, base_addr is %0d",$time, base_addr),UVM_LOW);
        end
    endtask : ctrlupd_flow

    task change_to_hwref_flow_2ch;
        bit sw_ref_en_ch0;
        bit sw_ref_en_ch1;
        bit dfilpensr_ch0, sdramcgen_ch0;
        bit dfilpensr_ch1, sdramcgen_ch1;
    endtask

    task change_to_normal_ref_flow_2ch;
        bit[1:0] ref_mode;
        get_field_by_apb("CTL_REFMODE", ref_mode, `DDR_CTL0_BASE_ADDR);
        if(ref_mode != 0) begin
            fgr_flow(0,0);
        end
        get_field_by_apb("CTL_REFMODE", ref_mode, `DDR_CTL1_BASE_ADDR);
        if(ref_mode != 0) begin
            fgr_flow(0,0);
        end
    endtask

    task ctrl_cww_test(input bit[8:0]RCD_BIT,input bit[3:0]MR_RANK,input bit[15:0] CWW_DAT,input bit[31:0] base_addr);

        bit[31:0] rdata;
        bit[63:0] mrr_data;
        bit pdnen,sren;

        `uvm_info(get_type_name(),$sformatf("start cww rank%h_rcd%d",MR_RANK,RCD_BIT),UVM_LOW);

        hold_xmu_uif(base_addr);
        exit_low_power_state(base_addr, pdnen, sren);
        set_field_by_apb("CTL_SWCMDSTART", 1, base_addr);

        RCD_BIT[8]='b1;
        set_field_by_apb("CTL_MRADDR", RCD_BIT, base_addr);
        set_field_by_apb("CTL_MRRANK", MR_RANK, base_addr);
        set_field_by_apb("CTL_MRWDAT", CWW_DAT, base_addr);

        set_field_by_apb("CTL_MRTYPE", 0, base_addr);
        set_field_by_apb("CTL_MRTRIG", 1, base_addr);

        wait_field_2ch("CTL_MRTRIG", 0, base_addr);
        wait_field_2ch("CTL_MRBUSY", 0, base_addr);

        repeat(100) @(tb.clk_noc);
        unhold_xmu_uif(base_addr);
        set_field_by_apb("CTL_SWCMDSTART", 0, base_addr);

        `uvm_info(get_type_name(),$sformatf("finish cww rank%h_rcd%d",MR_RANK,RCD_BIT),UVM_LOW);

    endtask

    task ctrl_cwr_test(input bit[8:0]RCD_BIT,input bit[3:0]MR_RANK,input bit[31:0] base_addr,input bit[7:0]MR_OP);

        bit[31:0] rdata;
        bit[63:0] cwr_data;
        bit pdnen,sren;

        hold_xmu_uif(base_addr);
        exit_low_power_state(base_addr, pdnen, sren);
        set_field_by_apb("CTL_SWCMDSTART", 1, base_addr);

        wait_field_2ch("CTL_MRTRIG", 0, base_addr);
        wait_field_2ch("CTL_MRBUSY", 0, base_addr);

        set_field_by_apb("CTL_MRRANK", MR_RANK, base_addr);

        set_field_by_apb("CTL_MRTYPE", 0, base_addr);
        set_field_by_apb("CTL_MRADDR", 'h15E, base_addr);
        set_field_by_apb("CTL_MRWDAT", RCD_BIT, base_addr);
        set_field_by_apb("CTL_MRTRIG", 1, base_addr);

        wait_field_2ch("CTL_MRTRIG", 0, base_addr);
        wait_field_2ch("CTL_MRBUSY", 0, base_addr);

        repeat(100) @(tb.clk_noc);
        set_field_by_apb("CTL_MRRANK", MR_RANK, base_addr);
        set_field_by_apb("CTL_MRTYPE", 0, base_addr);
        set_field_by_apb("CTL_MRADDR", 'h3F, base_addr);
        set_field_by_apb("CTL_MRTRIG", 1, base_addr);

        wait_field_2ch("CTL_MRTRIG", 0, base_addr);
        wait_field_2ch("CTL_MRBUSY", 0, base_addr);

        set_field_by_apb("CTL_MRRANK", MR_RANK, base_addr);
        set_field_by_apb("CTL_MRTYPE", 1, base_addr);
        set_field_by_apb("CTL_MRADDR", 'h3F, base_addr);
        set_field_by_apb("CTL_MRTRIG", 1, base_addr);

        wait_field_2ch("CTL_MRTRIG", 0, base_addr);
        wait_field_2ch("CTL_MRBUSY", 0, base_addr);
        get_field_by_apb("CTL_MRRDAT0", cwr_data[31:0], base_addr);

        unhold_xmu_uif(base_addr);
        set_field_by_apb("CTL_SWCMDSTART", 0, base_addr);
        `uvm_info(get_type_name(),$sformatf("rank%h_cwr_data=%0h",MR_RANK,cwr_data),UVM_LOW);

        if(cwr_data[7:0]!=MR_OP)
        `uvm_error(get_type_name(),$sformatf("cwr_data_dev0:%0h",cwr_data[7:0]))
        if(cwr_data[15:8]!=MR_OP)
        `uvm_error(get_type_name(),$sformatf("cwr_data_dev1:%0h",cwr_data[15:8]))

    endtask

    task actbyp_config();
        reg [31:0] rdata;

        set_field_by_apb("param_active_bypass_en_ch0" , 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("param_rd_active_bypass_en_ch0", 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("param_wr_active_bypass_en_ch0", 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("param_active_bypass_en_ch1" , 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("param_rd_active_bypass_en_ch1", 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("param_wr_active_bypass_en_ch1", 1, `DMU_USR_BASE_ADDR>>2);

        //xk opt schd
        set_field_by_apb("wr_open_bank_page_hit_thr_ch0", 2, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("wr_open_bank_page_hit_thr_ch1", 2, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("rd_open_bank_page_hit_thr_ch0", 2, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("rd_open_bank_page_hit_thr_ch1", 2, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("wr_opp_bank_page_hit_thr_ch0", 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("wr_opp_bank_page_hit_thr_ch1", 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("rd_opp_bank_page_hit_thr_ch0", 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("rd_opp_bank_page_hit_thr_ch1", 1, `DMU_USR_BASE_ADDR>>2);

        set_field_by_apb("switch_fast_wr_number_ch0", 2, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("switch_fast_wr_number_ch1", 2, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("switch_fast_rd_number_ch0", 1, `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("switch_fast_rd_number_ch1", 1, `DMU_USR_BASE_ADDR>>2);

        set_field_by_apb("open_bank_multiple_en_ch0"     , 1 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("open_bank_multiple_en_ch1"     , 1 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("switch_mode_early_one_cycle_ch0", 0 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("switch_mode_early_one_cycle_ch1", 0 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("schedul_policy_ch0"            , 1 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("schedul_policy_ch1"            , 1 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("wr_open_multiple_ch0"          , 1 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("wr_open_multiple_ch1"          , 1 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("rd_open_multiple_ch0"          , 1 , `DMU_USR_BASE_ADDR>>2);
        set_field_by_apb("rd_open_multiple_ch1"          , 1 , `DMU_USR_BASE_ADDR>>2);

        get_field_by_apb("schedul_policy_ch0", rdata, `DMU_USR_BASE_ADDR>>2);
        if (rdata==1) begin
            set_field_by_apb("CTL_RDOPPOSITEACTEN", 1, `DDR_CTL0_BASE_ADDR);
            set_field_by_apb("CTL_WROPPOSITEACTEN", 1, `DDR_CTL0_BASE_ADDR);
        end

        get_field_by_apb("schedul_policy_ch1", rdata, `DMU_USR_BASE_ADDR>>2);
        if (rdata==1) begin
            set_field_by_apb("CTL_RDOPPOSITEACTEN", 1, `DDR_CTL1_BASE_ADDR);
            set_field_by_apb("CTL_WROPPOSITEACTEN", 1, `DDR_CTL1_BASE_ADDR);
        end

        param_chi_qos_rd_region0_field_set (2'b00); //lpr
        param_chi_qos_rd_region1_field_set ($urandom_range(2, 0)); //random: lpr/gpr/hpr
        param_chi_qos_rd_region2_field_set ($urandom_range(2, 0)); //random: lpr/gpr/hpr

        param_chi_qos_wr_region0_field_set (0); //tpw
        param_chi_qos_wr_region1_field_set ($urandom_range(1, 0)); //random: tpw/gpw

        param_chi_port_expired_check_en_set(1'b1);
        param_chi_gpw_expired_time_set     (32'he);
        param_chi_gpr_expired_time_set     (32'he);
    endtask

    task param_chi_qos_rd_region0_thre_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION0_THREH_ADDR, rdata);
        rdata[3:0] = value; // param_chi_qos_rd_region0_thre_ch0
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION0_THREH_ADDR, rdata);
        USR_REGRD(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION0_THREH_ADDR, rdata);
        rdata[3:0] = value; // param_chi_qos_rd_region0_thre_ch1
        USR_REGWR(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION0_THREH_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_qos_rd_region0_thre]set value %h",value), UVM_LOW)
    endtask : param_chi_qos_rd_region0_thre_set

    task param_chi_qos_rd_region1_thre_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION1_THREH_ADDR, rdata);
        rdata[3:0] = value; // param_chi_qos_rd_region1_thre_ch1
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION1_THREH_ADDR, rdata);
        USR_REGRD(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION1_THREH_ADDR, rdata);
        rdata[3:0] = value; // param_chi_qos_rd_region1_thre_ch0
        USR_REGWR(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION1_THREH_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_qos_rd_region1_thre]set value %h",value), UVM_LOW)
    endtask : param_chi_qos_rd_region1_thre_set

    task param_chi_qos_rd_region0_field_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION0_FIELD_ADDR, rdata);
        rdata[1:0] = value; // param_chi_qos_rd_region0_field_ch0
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION0_FIELD_ADDR, rdata);
        USR_REGRD(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION0_FIELD_ADDR, rdata);
        rdata[1:0] = value; // param_chi_qos_rd_region0_field_ch1
        USR_REGWR(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION0_FIELD_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_qos_rd_region0_field]set value %h",value), UVM_LOW)
    endtask : param_chi_qos_rd_region0_field_set

    task param_chi_qos_rd_region1_field_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION1_FIELD_ADDR, rdata);
        rdata[1:0] = value; // param_chi_qos_rd_region1_field_ch0
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION1_FIELD_ADDR, rdata);
        USR_REGRD(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION1_FIELD_ADDR, rdata);
        rdata[1:0] = value; // param_chi_qos_rd_region1_field_ch1
        USR_REGWR(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION1_FIELD_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_qos_rd_region1_field]set value %h",value), UVM_LOW)
    endtask : param_chi_qos_rd_region1_field_set

    task param_chi_qos_rd_region2_field_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION2_FIELD_ADDR, rdata);
        rdata[1:0] = value; // param_chi_qos_rd_region2_field_ch1
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_QOS_RD_REGION2_FIELD_ADDR, rdata);
        USR_REGRD(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION2_FIELD_ADDR, rdata);
        rdata[1:0] = value; // param_chi_qos_rd_region2_field_ch0
        USR_REGWR(`CHIP1_BASE_ADDR + `CHI_QOS_RD_REGION2_FIELD_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_qos_rd_region2_field]set value %h",value), UVM_LOW)
    endtask : param_chi_qos_rd_region2_field_set

    task param_chi_qos_wr_region0_thre_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_QOS_WR_REGION_THREH_ADDR, rdata);
        rdata[3:0] = value; // param_chi_qos_wr_region0_thre_ch0
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_QOS_WR_REGION_THREH_ADDR, rdata);
        USR_REGRD(`CHIP1_BASE_ADDR + `CHI_QOS_WR_REGION_THREH_ADDR, rdata);
        rdata[3:0] = value; // param_chi_qos_wr_region0_thre_ch1
        USR_REGWR(`CHIP1_BASE_ADDR + `CHI_QOS_WR_REGION_THREH_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_qos_wr_region0_thre]set value %h",value), UVM_LOW)
    endtask : param_chi_qos_wr_region0_thre_set

    task param_chi_qos_wr_region0_field_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_QOS_WR_REGION0_FIELD_ADDR, rdata);
        rdata[0] = value; // param_chi_qos_wr_region0_field_ch0
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_QOS_WR_REGION0_FIELD_ADDR, rdata);
        USR_REGRD(`CHIP1_BASE_ADDR + `CHI_QOS_WR_REGION0_FIELD_ADDR, rdata);
        rdata[0] = value; // param_chi_qos_wr_region0_field_ch1
        USR_REGWR(`CHIP1_BASE_ADDR + `CHI_QOS_WR_REGION0_FIELD_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_qos_wr_region0_field]set value %h",value), UVM_LOW)
    endtask : param_chi_qos_wr_region0_field_set

    task param_chi_qos_wr_region1_field_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_QOS_WR_REGION1_FIELD_ADDR, rdata);
        rdata[0] = value; // param_chi_qos_wr_region1_field_ch0
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_QOS_WR_REGION1_FIELD_ADDR, rdata);
        USR_REGRD(`CHIP1_BASE_ADDR + `CHI_QOS_WR_REGION1_FIELD_ADDR, rdata);
        rdata[0] = value; // param_chi_qos_wr_region1_field_ch1
        USR_REGWR(`CHIP1_BASE_ADDR + `CHI_QOS_WR_REGION1_FIELD_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_qos_wr_region1_field]set value %h",value), UVM_LOW)
    endtask : param_chi_qos_wr_region1_field_set

    task param_chi_port_expired_check_en_set(int value);
        reg [31:0] rdata;
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_EXPIR_AGE_EN_ADDR, rdata);
        rdata[1] = value; // param_protq_hpr_min_ch0
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_EXPIR_AGE_EN_ADDR, rdata);
        USR_REGRD(`CHIP0_BASE_ADDR + `CHI_EXPIR_AGE_EN_ADDR, rdata);
        rdata[1] = value; // param_protq_hpr_min_ch1
        USR_REGWR(`CHIP0_BASE_ADDR + `CHI_EXPIR_AGE_EN_ADDR, rdata);
        `uvm_info(get_type_name(), $sformatf("[param_chi_port_expired_check_en]set value %h",value), UVM_LOW)
    endtask : param_chi_port_expired_check_en_set

    task param_chi_gpw_expired_time_set(int value);
        reg [31:0] rdata;
        USR_REGWR(`CHIP0_BASE_ADDR+`CHI_GPW_EXPIR_TIME_ADDR,value);
        USR_REGWR(`CHIP1_BASE_ADDR+`CHI_GPW_EXPIR_TIME_ADDR,value);
        `uvm_info(get_type_name(), $sformatf("[param_chi_gpw_expired_time]set value %h",value), UVM_LOW)
    endtask : param_chi_gpw_expired_time_set

    task param_chi_gpr_expired_time_set(int value);
        USR_REGWR(`CHIP0_BASE_ADDR+`CHI_GPR_EXPIR_TIME_ADDR,value);
        USR_REGWR(`CHIP1_BASE_ADDR+`CHI_GPR_EXPIR_TIME_ADDR,value);
        `uvm_info(get_type_name(), $sformatf("[param_chi_gpr_expired_time]set value %h",value), UVM_LOW)
    endtask : param_chi_gpr_expired_time_set

endclass : apb_base_uvddr_seq

`endif
