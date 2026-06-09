/*
 * @Project Name: 
 * @Team: verify.emu
 * @Author: zhonghuai
 * @Email: zhonghuai2056@phytium.com.cn
 * @Date: 2026-03-17 20:20:45
 * @LastEditors: fengqingwei
 * @LastEditTime: 2026-06-03 09:44:33
 * @Descripttion: 
 * @Version: 1.0
 * @Copyright (c) 2026 Phytium.co.Ltd
 */

`ifdef SIMU_DMU_APB_FTVIP

class apb_lkecc_seq extends apb_base_uvddr_seq;

    `uvm_object_utils(apb_lkecc_seq)

    rand bit [`APB_ADDR_WIDTH-1:0]   addr;
    rand bit [`APB_DATA_WIDTH-1:0]   data;
    rand bit [6:0]                   mode;
    rand bit [5:0]                   ch_sel;
    rand bit                         bc_mode;

    rand bit [1:0]                   mask_lane_inject2_rand;
    rand bit [3:0]                   mask_loca_inject2_rand;
    rand bit [1:0]                   mask_lane_inject1_rand;
    rand bit [3:0]                   mask_loca_inject1_rand;

    rand bit [1:0]                   data_lane_inject2_rand;
    rand bit [6:0]                   data_loca_inject2_rand;
    rand bit [1:0]                   data_lane_inject1_rand;
    rand bit [6:0]                   data_loca_inject1_rand;

    rand bit [1:0]                   dbi_lane_inject2_rand;
    rand bit [3:0]                   dbi_loca_inject2_rand;
    rand bit [1:0]                   dbi_lane_inject1_rand;
    rand bit [3:0]                   dbi_loca_inject1_rand;



    constraint mask_loca_diff_c {
        // Prevent mask_loca_inject1_rand and mask_loca_inject2_rand from being equal
        mask_loca_inject1_rand != mask_loca_inject2_rand;
    }

    constraint data_loca_diff_c {
        // Prevent data_loca_inject1_rand and data_loca_inject2_rand from being equal
        data_loca_inject1_rand != data_loca_inject2_rand;
    }

    constraint dbi_loca_diff_c {
        // Prevent dbi_loca_inject1_rand and dbi_loca_inject2_rand from being equal
        dbi_loca_inject1_rand != dbi_loca_inject2_rand;
    }

    constraint dbi_loca_inject2_range_c {
        // Constrain dbi_loca_inject2_rand to values 7-15
        dbi_loca_inject2_rand >= 7;
        dbi_loca_inject2_rand <= 15;
    }

    constraint dbi_loca_inject1_range_c {
        // Constrain dbi_loca_inject1_rand to values 7-15
        dbi_loca_inject1_rand >= 7;
        dbi_loca_inject1_rand <= 15;
    }


    function new(string name = "apb_lkecc_seq");
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
        `uvm_info(get_full_name(), "start apb_lkecc_seq...", UVM_LOW);
        repeat(5) @(posedge tb.clk_cfg);
        ctl_phy_reg_parser();
        ctl_phy_field_parser();
        // ch_sel = `SIMU_DMU_CH_SEL;
        ch_sel = 6'b111111;
        // for (int i=0; i<6; i++) begin
        //    if (ch_sel[i]==1) begin
        //        for(int j=0;j<`RANK_NUM;j++) begin
        //            for(int k=0;k<32/`DRAM_WIDTH;k++) begin
        //                $mmsomaset($sformatf("tb.lpddr5_ch%0d.rank[%1d].mdat[%0d].comp", i, j, k), "correctSingleBitError", 1);
        //                lpddr5_dram_changeSeverity($sformatf("tb.lpddr5_ch%0d.rank[%1d].mdat[%0d].comp(cfg)", i, j, k),DENALI_LPDDR5_WRITE_LINK_ECC_DATA_SBE,DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
        //                lpddr5_dram_changeSeverity($sformatf("tb.lpddr5_ch%0d.rank[%1d].mdat[%0d].comp(cfg)", i, j, k),DENALI_LPDDR5_WRITE_INVALID_DMI,DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
        //            end
        //        end
        //    end
        // end

        if(mode=='h0) begin
            lkecc_cfg();
        end else if (mode=='h1) begin

        end else if (mode=='h2) begin

        end else if (mode=='h3) begin
            // Mode 3: Enable only dbi_inject1_en
            lkecc_rd_err_inj(1'b0, 1'b0, dbi_lane_inject1_rand, data_lane_inject2_rand,
                                         dbi_loca_inject2_rand, data_loca_inject2_rand,
                             1'b1, 1'b0,
                                         dbi_lane_inject1_rand, data_lane_inject1_rand,
                                         dbi_loca_inject1_rand, data_loca_inject1_rand);

        end else if (mode=='h4) begin
            // Mode 4: Enable both dbi_inject1_en and dbi_inject2_en
            lkecc_rd_err_inj(1'b1, 1'b0, dbi_lane_inject1_rand, data_lane_inject2_rand,
                                         dbi_loca_inject2_rand, data_loca_inject2_rand,
                             1'b1, 1'b0,
                                         dbi_lane_inject1_rand, data_lane_inject1_rand,
                                         dbi_loca_inject1_rand, data_loca_inject1_rand);

        end else if (mode=='h5) begin
            // Mode 5: Enable only data_inject1_en
            lkecc_rd_err_inj(1'b0, 1'b0, dbi_lane_inject2_rand, data_lane_inject1_rand,
                                         dbi_loca_inject1_rand, data_loca_inject2_rand,
                             1'b0, 1'b1,
                                         dbi_lane_inject1_rand, data_lane_inject1_rand,
                                         dbi_loca_inject1_rand, data_loca_inject1_rand);

        end else if (mode=='h6) begin
            // Mode 6: Enable both data_inject1_en and data_inject2_en
            lkecc_rd_err_inj(1'b0, 1'b1, dbi_lane_inject2_rand, data_lane_inject1_rand,
                                         dbi_loca_inject1_rand, data_loca_inject2_rand,
                             1'b0, 1'b1,
                                         dbi_lane_inject1_rand, data_lane_inject1_rand,
                                         dbi_loca_inject1_rand, data_loca_inject1_rand);

        end else if (mode=='h7) begin
            // Mode 7: Enable mask_inject1_en only
            lkecc_wr_err_inj(1'b0, 1'b0, mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject2_rand, data_loca_inject2_rand,
                             1'b1, 1'b0,
                                         mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject1_rand, data_loca_inject1_rand);

        end else if (mode=='h8) begin
            // Mode 8: Enable both mask_inject1_en and mask_inject2_en
            lkecc_wr_err_inj(1'b1, 1'b0, mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject2_rand, data_loca_inject2_rand,
                             1'b1, 1'b0,
                                         mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject1_rand, data_loca_inject1_rand);

        end else if (mode=='h9) begin
            // Mode 9: Enable data_inject1_en only
            lkecc_wr_err_inj(1'b0, 1'b0, mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject2_rand, data_loca_inject2_rand,
                             1'b0, 1'b1,
                                         mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject1_rand, data_loca_inject1_rand);

        end else if (mode=='hA) begin
            // Mode A: Enable both data_inject1_en and data_inject2_en
            lkecc_wr_err_inj(1'b0, 1'b1, mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject2_rand, data_loca_inject2_rand,
                             1'b0, 1'b1,
                                         mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject1_rand, data_loca_inject1_rand);

        end

        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    extern virtual task lkecc_cfg();

    // Write error injection tasks
    extern virtual task lkecc_wr_err_inj(
        input bit        mask_inject2_en,  // WrLkeccMaskInject2
        input bit        data_inject2_en,  // WrLkeccDataInject2
        input bit [2:0]  mask_lane_inject2,// WrLkeccMaskLaneInject2
        input bit [2:0]  data_lane_inject2,// WrLkeccDataLaneInject2
        input bit [3:0]  mask_loca_inject2,// WrLkeccMaskLocaInject2
        input bit [6:0]  data_loca_inject2,// WrLkeccDataLocaInject2
        input bit        mask_inject1_en,  // WrLkeccMaskInject1
        input bit        data_inject1_en,  // WrLkeccDataInject1
        input bit [2:0]  mask_lane_inject1,// WrLkeccMaskLaneInject1
        input bit [2:0]  data_lane_inject1,// WrLkeccDataLaneInject1
        input bit [3:0]  mask_loca_inject1,// WrLkeccMaskLocaInject1
        input bit [6:0]  data_loca_inject1 // WrLkeccDataLocaInject1
    );

    // Read error injection tasks
    extern virtual task lkecc_rd_err_inj(
        input bit        dbi_inject2_en,   // RdLkeccDbiInject2
        input bit        data_inject2_en,  // RdLkeccDataInject2
        input bit [2:0]  dbi_lane_inject2, // RdLkeccDbiLaneInject2
        input bit [2:0]  data_lane_inject2,// RdLkeccDataLaneInject2
        input bit [3:0]  dbi_loca_inject2, // RdLkeccDbiLocaInject2
        input bit [6:0]  data_loca_inject2,// RdLkeccDataLocaInject2
        input bit        dbi_inject1_en,   // RdLkeccDbiInject1
        input bit        data_inject1_en,  // RdLkeccDataInject1
        input bit [2:0]  dbi_lane_inject1, // RdLkeccDbiLaneInject1
        input bit [2:0]  data_lane_inject1,// RdLkeccDataLaneInject1
        input bit [3:0]  dbi_loca_inject1, // RdLkeccDbiLocaInject1
        input bit [6:0]  data_loca_inject1 // RdLkeccDataLocaInject1
    );

    extern virtual task lkecc_get_status(
        output bit [31:0] rd_lkecc_corr_cnt,   // RdLkeccCorrCnt
        output bit [31:0] rd_lkecc_uncorr_cnt, // RdLkeccUncorrCnt
        output bit        rd_lkecc_corr_int,   // RdLkeccCorrInt
        output bit        rd_lkecc_uncorr_int  // RdLkeccUncorrInt
    );

    extern virtual task lkecc_clr_err(
        input bit         clr_corr_cnt,    // 1: clear correctable counter
        input bit         clr_uncorr_cnt,  // 1: clear uncorrectable counter
        input bit         clr_corr_int,    // 1: clear correctable interrupt
        input bit         clr_uncorr_int   // 1: clear uncorrectable interrupt
    );

endclass : apb_lkecc_seq

task apb_lkecc_seq::lkecc_cfg();
    `uvm_info(get_full_name(), "start lkecc_cfg...", UVM_LOW);

    for (int i=0; i<6; i++) begin
        if(ch_sel[i]==1) begin

            for (int j=0;j<`RANK_NUM;j++) begin
               for(int k=0;k<32/`DRAM_WIDTH;k++) begin
                   // $mmsomaset($sformatf("tb.lpddr5_ch%0d.rank[%1d].mdat[%0d].comp", i, j, k), "correctSingleBitError", 1);
                   // lpddr5_dram_changeSeverity($sformatf("tb.lpddr5_ch%0d.rank[%1d].mdat[%0d].comp(cfg)", i, j, k),DENALI_LPDDR5_WRITE_LINK_ECC_DATA_SBE,DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
                   // lpddr5_dram_changeSeverity($sformatf("tb.lpddr5_ch%0d.rank[%1d].mdat[%0d].comp(cfg)", i, j, k),DENALI_LPDDR5_WRITE_LINK_ECC_DATA_DBE,DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
                   // lpddr5_dram_changeSeverity($sformatf("tb.lpddr5_ch%0d.rank[%1d].mdat[%0d].comp(cfg)", i, j, k),DENALI_LPDDR5_WRITE_INVALID_DMI,DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
               end
            end

            `uvm_info(get_full_name(), $sformatf("start lkecc_cfg for channel %0d", i), UVM_LOW);

            // Step 1: Enable LK ECC for read and write
            set_field_by_apb("CTL_RDLKECCENABLE", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_WRLKECCENABLE", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            `uvm_info(get_full_name(), "LK ECC enabled for read and write", UVM_LOW);

            // Step 2: Enable error counters
            set_field_by_apb("CTL_RDLKECCUNCORRCNTEN", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_RDLKECCCORRCNTEN", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            `uvm_info(get_full_name(), "LK ECC error counters enabled", UVM_LOW);

            // Step 3: Enable interrupts
            set_field_by_apb("CTL_RDLKECCUNCORRINTEN", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_RDLKECCCORRINTEN", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            `uvm_info(get_full_name(), "LK ECC interrupts enabled", UVM_LOW);
        end
    end

    `uvm_info(get_full_name(), "lkecc_cfg configuration completed", UVM_LOW);
endtask : lkecc_cfg

task apb_lkecc_seq::lkecc_wr_err_inj(
    input bit        mask_inject2_en,  // WrLkeccMaskInject2
    input bit        data_inject2_en,  // WrLkeccDataInject2
    input bit [2:0]  mask_lane_inject2,// WrLkeccMaskLaneInject2
    input bit [2:0]  data_lane_inject2,// WrLkeccDataLaneInject2
    input bit [3:0]  mask_loca_inject2,// WrLkeccMaskLocaInject2
    input bit [6:0]  data_loca_inject2,// WrLkeccDataLocaInject2
    input bit        mask_inject1_en,  // WrLkeccMaskInject1
    input bit        data_inject1_en,  // WrLkeccDataInject1
    input bit [2:0]  mask_lane_inject1,// WrLkeccMaskLaneInject1
    input bit [2:0]  data_lane_inject1,// WrLkeccDataLaneInject1
    input bit [3:0]  mask_loca_inject1,// WrLkeccMaskLocaInject1
    input bit [6:0]  data_loca_inject1 // WrLkeccDataLocaInject1
);
    `uvm_info(get_full_name(), "start lkecc_wr_err_inj...", UVM_LOW);

    for (int i=0; i<6; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("start lkecc_wr_err_inj for channel %0d", i), UVM_LOW);

            // Set WrLkeccMaskInject2 and WrLkeccDataInject2
            set_field_by_apb("CTL_WRLKECCMASKINJECT2", mask_inject2_en, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_WRLKECCDATAINJECT2", data_inject2_en, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set WrLkeccMaskLaneInject2 and WrLkeccDataLaneInject2
            set_field_by_apb("CTL_WRLKECCMASKLANEINJECT2", mask_lane_inject2, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_WRLKECCDATALANEINJECT2", data_lane_inject2, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set WrLkeccMaskLocaInject2 and WrLkeccDataLocaInject2
            set_field_by_apb("CTL_WRLKECCMASKLOCAINJECT2", mask_loca_inject2, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_WRLKECCDATALOCAINJECT2", data_loca_inject2, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set WrLkeccMaskInject1 and WrLkeccDataInject1
            set_field_by_apb("CTL_WRLKECCMASKINJECT1", mask_inject1_en, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_WRLKECCDATAINJECT1", data_inject1_en, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set WrLkeccMaskLaneInject1 and WrLkeccDataLaneInject1
            set_field_by_apb("CTL_WRLKECCMASKLANEINJECT1", mask_lane_inject1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_WRLKECCDATALANEINJECT1", data_lane_inject1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set WrLkeccMaskLocaInject1 and WrLkeccDataLocaInject1
            set_field_by_apb("CTL_WRLKECCMASKLOCAINJECT1", mask_loca_inject1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_WRLKECCDATALOCAINJECT1", data_loca_inject1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            `uvm_info(get_full_name(), $sformatf("Write error injection configured: MaskInject2=%0b, DataInject2=%0b, MaskInject1=%0b, DataInject1=%0b",
                mask_inject2_en, data_inject2_en, mask_inject1_en, data_inject1_en), UVM_LOW);
        end
    end

    `uvm_info(get_full_name(), "lkecc_wr_err_inj configuration completed", UVM_LOW);
endtask : lkecc_wr_err_inj

task apb_lkecc_seq::lkecc_rd_err_inj(
    input bit        dbi_inject2_en,   // RdLkeccDbiInject2
    input bit        data_inject2_en,  // RdLkeccDataInject2
    input bit [2:0]  dbi_lane_inject2, // RdLkeccDbiLaneInject2
    input bit [2:0]  data_lane_inject2,// RdLkeccDataLaneInject2
    input bit [3:0]  dbi_loca_inject2, // RdLkeccDbiLocaInject2
    input bit [6:0]  data_loca_inject2,// RdLkeccDataLocaInject2
    input bit        dbi_inject1_en,   // RdLkeccDbiInject1
    input bit        data_inject1_en,  // RdLkeccDataInject1
    input bit [2:0]  dbi_lane_inject1, // RdLkeccDbiLaneInject1
    input bit [2:0]  data_lane_inject1,// RdLkeccDataLaneInject1
    input bit [3:0]  dbi_loca_inject1, // RdLkeccDbiLocaInject1
    input bit [6:0]  data_loca_inject1 // RdLkeccDataLocaInject1
);
    `uvm_info(get_full_name(), "start lkecc_rd_err_inj...", UVM_LOW);

    for (int i=0; i<6; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("start lkecc_rd_err_inj for channel %0d", i), UVM_LOW);

            // Set RdLkeccDbiInject2 and RdLkeccDataInject2
            set_field_by_apb("CTL_RDLKECCDBIINJECT2", dbi_inject2_en, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_RDLKECCDATAINJECT2", data_inject2_en, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set RdLkeccDbiLaneInject2 and RdLkeccDataLaneInject2
            set_field_by_apb("CTL_RDLKECCDBILANEINJECT2", dbi_lane_inject2, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_RDLKECCDATALANEINJECT2", data_lane_inject2, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set RdLkeccDbiLocaInject2 and RdLkeccDataLocaInject2
            set_field_by_apb("CTL_RDLKECCDBILOCAINJECT2", dbi_loca_inject2, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_RDLKECCDATALOCAINJECT2", data_loca_inject2, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set RdLkeccDbiInject1 and RdLkeccDataInject1
            set_field_by_apb("CTL_RDLKECCDBIINJECT1", dbi_inject1_en, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_RDLKECCDATAINJECT1", data_inject1_en, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set RdLkeccDbiLaneInject1 and RdLkeccDataLaneInject1
            set_field_by_apb("CTL_RDLKECCDBILANEINJECT1", dbi_lane_inject1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_RDLKECCDATALANEINJECT1", data_lane_inject1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            // Set RdLkeccDbiLocaInject1 and RdLkeccDataLocaInject1
            set_field_by_apb("CTL_RDLKECCDBILOCAINJECT1", dbi_loca_inject1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            set_field_by_apb("CTL_RDLKECCDATALOCAINJECT1", data_loca_inject1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);

            `uvm_info(get_full_name(), $sformatf("Read error injection configured: DbiInject2=%0b, DataInject2=%0b, DbiInject1=%0b, DataInject1=%0b",
                dbi_inject2_en, data_inject2_en, dbi_inject1_en, data_inject1_en), UVM_LOW);
        end
    end

    `uvm_info(get_full_name(), "lkecc_rd_err_inj configuration completed", UVM_LOW);
endtask : lkecc_rd_err_inj

task apb_lkecc_seq::lkecc_get_status(
    output bit [31:0] rd_lkecc_corr_cnt,   // RdLkeccCorrCnt
    output bit [31:0] rd_lkecc_uncorr_cnt, // RdLkeccUncorrCnt
    output bit        rd_lkecc_corr_int,   // RdLkeccCorrInt
    output bit        rd_lkecc_uncorr_int  // RdLkeccUncorrInt
);
    `uvm_info(get_full_name(), "start lkecc_get_status...", UVM_LOW);

    for (int i=0; i<6; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("read lkecc status for channel %0d", i), UVM_LOW);

            // Read correctable and uncorrectable error counters
            get_field_by_apb("CTL_RDLKECCCORRCNT", rd_lkecc_corr_cnt, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            get_field_by_apb("CTL_RDLKECCUNCORRCNT", rd_lkecc_uncorr_cnt, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            `uvm_info(get_full_name(), $sformatf("RdLkeccCorrCnt=%0d, RdLkeccUncorrCnt=%0d",
                rd_lkecc_corr_cnt, rd_lkecc_uncorr_cnt), UVM_LOW);

            // Read interrupt status
            get_field_by_apb("CTL_RDLKECCCORRINT", rd_lkecc_corr_int, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            get_field_by_apb("CTL_RDLKECCUNCORRINT", rd_lkecc_uncorr_int, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            `uvm_info(get_full_name(), $sformatf("RdLkeccCorrInt=%0b, RdLkeccUncorrInt=%0b",
                rd_lkecc_corr_int, rd_lkecc_uncorr_int), UVM_LOW);
        end
    end

    `uvm_info(get_full_name(), "lkecc_get_status completed", UVM_LOW);
endtask : lkecc_get_status

task apb_lkecc_seq::lkecc_clr_err(
    input bit         clr_corr_cnt,    // 1: clear correctable counter
    input bit         clr_uncorr_cnt,  // 1: clear uncorrectable counter
    input bit         clr_corr_int,    // 1: clear correctable interrupt
    input bit         clr_uncorr_int   // 1: clear uncorrectable interrupt
);
    `uvm_info(get_full_name(), "start lkecc_clr_err...", UVM_LOW);

    for (int i=0; i<6; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("clear lkecc error for channel %0d", i), UVM_LOW);

            // Clear correctable counter
            if (clr_corr_cnt) begin
                set_field_by_apb("CTL_RDLKECCCORRCNTCLR", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
                `uvm_info(get_full_name(), "RdLkeccCorrCntClr written to clear correctable error counter", UVM_LOW);
                set_field_by_apb("CTL_RDLKECCCORRCNTCLR", 1'b0, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            end

            // Clear uncorrectable counter
            if (clr_uncorr_cnt) begin
                set_field_by_apb("CTL_RDLKECCUNCORRCNTCLR", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
                `uvm_info(get_full_name(), "RdLkeccUncorrCntClr written to clear uncorrectable error counter", UVM_LOW);
                set_field_by_apb("CTL_RDLKECCUNCORRCNTCLR", 1'b0, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            end

            // Clear correctable interrupt
            if (clr_corr_int) begin
                set_field_by_apb("CTL_RDLKECCCORRINTCLR", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
                `uvm_info(get_full_name(), "RdLkeccCorrIntClr written to clear correctable interrupt", UVM_LOW);
                set_field_by_apb("CTL_RDLKECCCORRINTCLR", 1'b0, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            end

            // Clear uncorrectable interrupt
            if (clr_uncorr_int) begin
                set_field_by_apb("CTL_RDLKECCUNCORRINTCLR", 1'b1, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
                `uvm_info(get_full_name(), "RdLkeccUncorrIntClr written to clear uncorrectable interrupt", UVM_LOW);
                set_field_by_apb("CTL_RDLKECCUNCORRINTCLR", 1'b0, `DDR_CTL0_BASE_ADDR+i*'h0_0400);
            end
        end
    end

    `uvm_info(get_full_name(), "lkecc_clr_err completed", UVM_LOW);
endtask : lkecc_clr_err

`endif