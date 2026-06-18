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

    constraint default_ch_sel_c {
        soft ch_sel == 6'b000011;
    }

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

    function automatic bit [31:0] lkecc_ctl_base(input int ch_idx);
        return (ch_idx == 0) ? `DDR_CTL0_BASE_ADDR : `DDR_CTL1_BASE_ADDR;
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
        $display("%0t LKECC_DBG: apb_lkecc_seq body entered, mode=0x%0h", $time, mode);
        `uvm_info(get_full_name(), "start apb_lkecc_seq...", UVM_LOW);
        repeat(5) @(posedge tb.clk_cfg);
        ctl_phy_reg_parser();
        ctl_phy_field_parser();

        if(mode=='h0) begin
            lkecc_cfg();
        end else if (mode=='h1) begin
            // Mode 1: generic write link ECC single-bit data injection.
            lkecc_wr_err_inj(1'b0, 1'b0, mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject2_rand, data_loca_inject2_rand,
                             1'b0, 1'b1,
                                         mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject1_rand, data_loca_inject1_rand);

        end else if (mode=='h2) begin
            // Mode 2: generic write link ECC double-bit data injection.
            lkecc_wr_err_inj(1'b0, 1'b1, mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject2_rand, data_loca_inject2_rand,
                             1'b0, 1'b1,
                                         mask_lane_inject1_rand, data_lane_inject1_rand,
                                         mask_loca_inject1_rand, data_loca_inject1_rand);

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

        end else if (mode=='hB) begin
            bit [31:0] rd_lkecc_corr_cnt;
            bit [31:0] rd_lkecc_uncorr_cnt;
            bit        rd_lkecc_corr_int;
            bit        rd_lkecc_uncorr_int;

            lkecc_get_status(rd_lkecc_corr_cnt, rd_lkecc_uncorr_cnt,
                              rd_lkecc_corr_int, rd_lkecc_uncorr_int);

        end else if (mode=='hC) begin
            lkecc_clr_err(1'b1, 1'b1, 1'b1, 1'b1);
        end else if (mode=='hD) begin
            lkecc_dram_status_clear();
        end else if (mode=='hE) begin
            lkecc_check_dram_wr_status(1'b0);
        end else if (mode=='hF) begin
            lkecc_check_dram_wr_status(1'b1);
        end else if (mode=='h10) begin
            lkecc_check_ctrl_rd_status(1'b0);
        end else if (mode=='h11) begin
            lkecc_check_ctrl_rd_status(1'b1);
        end

        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    extern virtual task lkecc_cfg();
    extern virtual task lkecc_mr22_cfg(input bit [31:0] base_addr);
    extern virtual task lkecc_dram_dbi_disable(input bit [31:0] base_addr);
    extern virtual task lkecc_lpddr5_model_cfg();
    extern virtual task lkecc_dram_change_severity(input string path, input int err_id, input int severity);
    extern virtual task lkecc_dram_status_clear();
    extern virtual task lkecc_check_dram_wr_status(input bit expect_uncorr);
    extern virtual task lkecc_check_ctrl_rd_status(input bit expect_uncorr);

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

task apb_lkecc_seq::lkecc_dram_change_severity(input string path, input int err_id, input int severity);
    automatic integer regid;
    automatic integer result;
    automatic integer error_reg;

    regid = $mminstanceid(path);
    if (regid == 0) begin
        `uvm_warning(get_full_name(), $sformatf("skip Denali severity change, invalid model cfg path: %s", path));
        return;
    end

    error_reg = 0;
    error_reg = error_reg |
                (err_id   << DENALI_LPDDR5_Rpos__DEN_ERR_CTRL_ErrId) |
                (severity << DENALI_LPDDR5_Rpos__DEN_ERR_CTRL_Severity);
    result = $mmwriteword4(regid, DENALI_LPDDR5_REG_DEN_ERR_CTRL, error_reg);
    `uvm_info(get_full_name(),
              $sformatf("set Denali severity path=%s err_id=%0d severity=%0d result=%0d",
                        path, err_id, severity, result),
              UVM_LOW);
endtask : lkecc_dram_change_severity

task apb_lkecc_seq::lkecc_lpddr5_model_cfg();
    integer result;
    integer id;
    string  path0;
    string  cfg_path;
    string  soma_path;

    `uvm_info(get_full_name(), "enable LPDDR5 model correctSingleBitError for Link ECC", UVM_NONE);

    for (int ch_idx=0; ch_idx<2; ch_idx++) begin
        if (ch_sel[ch_idx]==1'b1) begin
            for (int rank_idx=0; rank_idx<`RANK_NUM; rank_idx++) begin
                for (int mdat_idx=0; mdat_idx<32/`DRAM_WIDTH; mdat_idx++) begin
                    path0 = $sformatf("tb.u_dc.lpddr5.ch%0d.rank[%0d].mat[%0d].comp",
                                      ch_idx, rank_idx, mdat_idx);

                    soma_path = path0;
                    id = $mminstanceid(path0);

                    if (id == 0) begin
                        `uvm_warning(get_full_name(),
                                     $sformatf("skip LPDDR5 model config, no valid comp path for ch=%0d rank=%0d mdat=%0d",
                                               ch_idx, rank_idx, mdat_idx));
                        continue;
                    end

                    result = $mmsomaset(soma_path, "correctSingleBitError", 1);
                    `uvm_info(get_full_name(),
                              $sformatf("mmsomaset %s correctSingleBitError=1 result=%0d",
                                        soma_path, result),
                              UVM_NONE);

                    cfg_path = {soma_path, "(cfg)"};
                    lkecc_dram_change_severity(cfg_path, DENALI_LPDDR5_WRITE_LINK_ECC_DATA_SBE,
                                               DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
                    lkecc_dram_change_severity(cfg_path, DENALI_LPDDR5_WRITE_LINK_ECC_DATA_DBE,
                                               DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
                    lkecc_dram_change_severity(cfg_path, DENALI_LPDDR5_WRITE_INVALID_DMI,
                                               DENALI_LPDDR5_ERR_CONFIG_SEVERITY_Info);
                end
            end
        end
    end
endtask : lkecc_lpddr5_model_cfg

task apb_lkecc_seq::lkecc_cfg();
    $display("%0t LKECC_DBG: lkecc_cfg entered", $time);
    `uvm_info(get_full_name(), "start lkecc_cfg...", UVM_NONE);

    lkecc_lpddr5_model_cfg();

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("start lkecc_cfg for channel %0d", i), UVM_NONE);

            // Step 1: Read Link ECC is mutually exclusive with Read DBI.
            set_field_by_apb("CTL_CTLRDDBIEN", 1'b0, lkecc_ctl_base(i));
            set_field_by_apb("CTL_CTLWRDBIEN", 2'b00, lkecc_ctl_base(i));
            lkecc_dram_dbi_disable(lkecc_ctl_base(i));

            // Step 2: Enable DRAM-side write/read link ECC through MR22.
            lkecc_mr22_cfg(lkecc_ctl_base(i));

            // Step 3: Enable error counters.
            set_field_by_apb("CTL_RDLKECCUNCORRCNTEN", 1'b1, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCCORRCNTEN", 1'b1, lkecc_ctl_base(i));
            `uvm_info(get_full_name(), "LK ECC error counters enabled", UVM_LOW);

            // Step 4: Enable interrupts.
            set_field_by_apb("CTL_RDLKECCUNCORRINTEN", 1'b1, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCCORRINTEN", 1'b1, lkecc_ctl_base(i));
            `uvm_info(get_full_name(), "LK ECC interrupts enabled", UVM_LOW);
        end
    end

    `uvm_info(get_full_name(), "lkecc_cfg configuration completed", UVM_LOW);
endtask : lkecc_cfg

task apb_lkecc_seq::lkecc_dram_dbi_disable(input bit [31:0] base_addr);
    bit [63:0] mrdat;
    bit [15:0] mrdatecc;
    bit [3:0]  mr_rank;
    bit [7:0]  mr3_value;

    for(int rank_idx = 0; rank_idx < `RANK_NUM; rank_idx++) begin
        mr_rank = 4'b0001 << rank_idx;
        mrr_flow(3, mr_rank, mrdat, base_addr, mrdatecc);
        mr3_value = mrdat[7:0] & 8'h3f;
        `uvm_info(get_full_name(),
                  $sformatf("disable DRAM DBI through MR3: base_addr=0x%0h rank=0x%0h old_mr3=0x%0h new_mr3=0x%0h",
                            base_addr, mr_rank, mrdat[7:0], mr3_value),
                  UVM_NONE);
        mrw_flow(3, mr_rank, mr3_value, base_addr);
        repeat(20) @(posedge tb.clk_cfg);
    end
endtask : lkecc_dram_dbi_disable

task apb_lkecc_seq::lkecc_mr22_cfg(input bit [31:0] base_addr);
    bit [3:0]  mr_rank;
    bit [7:0]  mr22_value;

    mr22_value = 8'h50; // MR22 OP[7:6]=01 RECC enabled, OP[5:4]=01 WECC enabled.
    for(int rank_idx = 0; rank_idx < `RANK_NUM; rank_idx++) begin
        mr_rank = 4'b0001 << rank_idx;
        `uvm_info(get_full_name(),
                  $sformatf("enable DRAM Link ECC through MR22: base_addr=0x%0h rank=0x%0h mr22=0x%0h",
                            base_addr, mr_rank, mr22_value),
                  UVM_NONE);
        mrw_flow(22, mr_rank, mr22_value, base_addr);
        repeat(20) @(posedge tb.clk_cfg);
    end
endtask : lkecc_mr22_cfg

task apb_lkecc_seq::lkecc_dram_status_clear();
    bit [63:0] mrdat;
    bit [15:0] mrdatecc;
    bit [3:0]  mr_rank;

    `uvm_info(get_full_name(), "clear DRAM-side Link ECC write status through MR43 read", UVM_LOW);

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            for(int rank_idx = 0; rank_idx < `RANK_NUM; rank_idx++) begin
                mr_rank = 4'b0001 << rank_idx;
                mrr_flow(43, mr_rank, mrdat, lkecc_ctl_base(i), mrdatecc);
                `uvm_info(get_full_name(), $sformatf("MR43 clear read: ch=%0d rank=%0d mr43=0x%0h",
                    i, rank_idx, mrdat[7:0]), UVM_LOW);
                repeat(20) @(posedge tb.clk_cfg);
            end
        end
    end
endtask : lkecc_dram_status_clear

task apb_lkecc_seq::lkecc_check_dram_wr_status(input bit expect_uncorr);
    bit [63:0] mrdat;
    bit [15:0] mrdatecc;
    bit [7:0]  mr43;
    bit [7:0]  mr44;
    bit [7:0]  mr45;
    bit [3:0]  mr_rank;
    bit [31:0] total_sbe_cnt;
    bit        any_dbe_flag;
    bit        any_corr_status;
    int        dbe_ch;
    int        dbe_rank;
    bit [7:0]  dbe_mr43;
    bit [7:0]  dbe_mr44;
    bit [7:0]  dbe_mr45;

    total_sbe_cnt = '0;
    any_dbe_flag  = 1'b0;
    any_corr_status = 1'b0;
    dbe_ch         = -1;
    dbe_rank       = -1;
    dbe_mr43       = '0;
    dbe_mr44       = '0;
    dbe_mr45       = '0;

    `uvm_info(get_full_name(),
              $sformatf("check DRAM-side Link ECC write status through MR43/MR44/MR45, ch_sel=0x%0h expect_uncorr=%0b",
                        ch_sel, expect_uncorr),
              UVM_LOW);

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            for(int rank_idx = 0; rank_idx < `RANK_NUM; rank_idx++) begin
                mr_rank = 4'b0001 << rank_idx;

                // Read syndrome registers before MR43 because MR43 has clear-on-read behavior in the DRAM model.
                mrr_flow(44, mr_rank, mrdat, lkecc_ctl_base(i), mrdatecc);
                mr44 = mrdat[7:0];
                repeat(20) @(posedge tb.clk_cfg);

                mrr_flow(45, mr_rank, mrdat, lkecc_ctl_base(i), mrdatecc);
                mr45 = mrdat[7:0];
                repeat(20) @(posedge tb.clk_cfg);

                mrr_flow(43, mr_rank, mrdat, lkecc_ctl_base(i), mrdatecc);
                mr43 = mrdat[7:0];
                repeat(20) @(posedge tb.clk_cfg);

                total_sbe_cnt += mr43[5:0];
                any_corr_status |= (mr43[5:0] != 0) || ({mr45[7], mr44} != 0) || (mr45[5:0] != 0);
                if (mr43[7] && !any_dbe_flag) begin
                    dbe_ch    = i;
                    dbe_rank  = rank_idx;
                    dbe_mr43  = mr43;
                    dbe_mr44  = mr44;
                    dbe_mr45  = mr45;
                end
                any_dbe_flag  |= mr43[7];

                `uvm_info(get_full_name(), $sformatf(
                    "DRAM Link ECC status: ch=%0d rank=%0d MR43=0x%0h MR44=0x%0h MR45=0x%0h sbe_cnt=%0d sbec_rule=%0b dbe=%0b data_syn=0x%0h err_lane=%0b dmi_syn=0x%0h",
                    i, rank_idx, mr43, mr44, mr45, mr43[5:0], mr43[6], mr43[7],
                    {mr45[7], mr44}, mr45[6], mr45[5:0]), UVM_LOW);
            end
        end
    end

    if (expect_uncorr) begin
        if (!any_dbe_flag) begin
            `uvm_error(get_full_name(), "Expected DRAM-side Link ECC DBE flag, but MR43 DBE flag was not observed");
        end
    end else begin
        if (!any_corr_status) begin
            `uvm_error(get_full_name(),
                       $sformatf("Expected DRAM-side Link ECC correctable status, but MR43 SBE count and MR44/MR45 syndrome stayed zero, ch_sel=0x%0h",
                                 ch_sel));
        end else if (total_sbe_cnt == 0) begin
            `uvm_warning(get_full_name(),
                         $sformatf("DRAM-side Link ECC syndrome was observed, but MR43 SBE count stayed zero, ch_sel=0x%0h",
                                   ch_sel));
        end
        if (any_dbe_flag) begin
            `uvm_error(get_full_name(),
                       $sformatf("Expected only correctable write Link ECC error, but MR43 DBE flag was observed at ch=%0d rank=%0d MR43=0x%0h MR44=0x%0h MR45=0x%0h",
                                 dbe_ch, dbe_rank, dbe_mr43, dbe_mr44, dbe_mr45));
        end
    end
endtask : lkecc_check_dram_wr_status

task apb_lkecc_seq::lkecc_check_ctrl_rd_status(input bit expect_uncorr);
    bit [31:0] corr_cnt;
    bit [31:0] uncorr_cnt;
    bit        corr_int;
    bit        uncorr_int;
    bit [31:0] total_corr_cnt;
    bit [31:0] total_uncorr_cnt;
    bit        any_corr_int;
    bit        any_uncorr_int;

    total_corr_cnt   = '0;
    total_uncorr_cnt = '0;
    any_corr_int     = 1'b0;
    any_uncorr_int   = 1'b0;

    `uvm_info(get_full_name(), "check controller-side read Link ECC status", UVM_LOW);

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            get_field_by_apb("CTL_RDLKECCCORRCNT", corr_cnt, lkecc_ctl_base(i));
            get_field_by_apb("CTL_RDLKECCUNCORRCNT", uncorr_cnt, lkecc_ctl_base(i));
            get_field_by_apb("CTL_RDLKECCCORRINT", corr_int, lkecc_ctl_base(i));
            get_field_by_apb("CTL_RDLKECCUNCORRINT", uncorr_int, lkecc_ctl_base(i));

            total_corr_cnt   += corr_cnt;
            total_uncorr_cnt += uncorr_cnt;
            any_corr_int     |= corr_int;
            any_uncorr_int   |= uncorr_int;

            `uvm_info(get_full_name(), $sformatf(
                "Read Link ECC status: ch=%0d corr_cnt=%0d uncorr_cnt=%0d corr_int=%0b uncorr_int=%0b",
                i, corr_cnt, uncorr_cnt, corr_int, uncorr_int), UVM_LOW);
        end
    end

    if (expect_uncorr) begin
        if ((total_uncorr_cnt == 0) && !any_uncorr_int) begin
            `uvm_error(get_full_name(), "Expected read Link ECC uncorrectable status, but no uncorrectable counter or interrupt was observed");
        end
    end else begin
        if ((total_corr_cnt == 0) && !any_corr_int) begin
            `uvm_error(get_full_name(), "Expected read Link ECC correctable status, but no correctable counter or interrupt was observed");
        end
        if ((total_uncorr_cnt != 0) || any_uncorr_int) begin
            `uvm_error(get_full_name(), "Expected only read Link ECC correctable status, but uncorrectable status was observed");
        end
    end
endtask : lkecc_check_ctrl_rd_status

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
    $display("%0t LKECC_DBG: lkecc_wr_err_inj entered", $time);

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("start lkecc_wr_err_inj for channel %0d", i), UVM_LOW);
            $display("%0t LKECC_DBG: configure write injection ch=%0d data1=%0b data2=%0b mask1=%0b mask2=%0b lane1=%0d loc1=%0d",
                     $time, i, data_inject1_en, data_inject2_en, mask_inject1_en, mask_inject2_en,
                     data_lane_inject1, data_loca_inject1);

            // Set WrLkeccMaskLaneInject2 and WrLkeccDataLaneInject2
            set_field_by_apb("CTL_WRLKECCMASKLANEINJECT2", mask_lane_inject2, lkecc_ctl_base(i));
            set_field_by_apb("CTL_WRLKECCDATALANEINJECT2", data_lane_inject2, lkecc_ctl_base(i));

            // Set WrLkeccMaskLocaInject2 and WrLkeccDataLocaInject2
            set_field_by_apb("CTL_WRLKECCMASKLOCAINJECT2", mask_loca_inject2, lkecc_ctl_base(i));
            set_field_by_apb("CTL_WRLKECCDATALOCAINJECT2", data_loca_inject2, lkecc_ctl_base(i));

            // Set WrLkeccMaskLaneInject1 and WrLkeccDataLaneInject1
            set_field_by_apb("CTL_WRLKECCMASKLANEINJECT1", mask_lane_inject1, lkecc_ctl_base(i));
            set_field_by_apb("CTL_WRLKECCDATALANEINJECT1", data_lane_inject1, lkecc_ctl_base(i));

            // Set WrLkeccMaskLocaInject1 and WrLkeccDataLocaInject1
            set_field_by_apb("CTL_WRLKECCMASKLOCAINJECT1", mask_loca_inject1, lkecc_ctl_base(i));
            set_field_by_apb("CTL_WRLKECCDATALOCAINJECT1", data_loca_inject1, lkecc_ctl_base(i));

            // Program one-shot enable bits last so the next write data beat consumes a complete injection setup.
            $display("%0t LKECC_DBG: arm write injection one-shot ch=%0d", $time, i);
            set_field_by_apb("CTL_WRLKECCMASKINJECT2", mask_inject2_en, lkecc_ctl_base(i));
            set_field_by_apb("CTL_WRLKECCDATAINJECT2", data_inject2_en, lkecc_ctl_base(i));
            set_field_by_apb("CTL_WRLKECCMASKINJECT1", mask_inject1_en, lkecc_ctl_base(i));
            set_field_by_apb("CTL_WRLKECCDATAINJECT1", data_inject1_en, lkecc_ctl_base(i));

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

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("start lkecc_rd_err_inj for channel %0d", i), UVM_LOW);

            // Set RdLkeccDbiLaneInject2 and RdLkeccDataLaneInject2
            set_field_by_apb("CTL_RDLKECCDBILANEINJECT2", dbi_lane_inject2, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCDATALANEINJECT2", data_lane_inject2, lkecc_ctl_base(i));

            // Set RdLkeccDbiLocaInject2 and RdLkeccDataLocaInject2
            set_field_by_apb("CTL_RDLKECCDBILOCAINJECT2", dbi_loca_inject2, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCDATALOCAINJECT2", data_loca_inject2, lkecc_ctl_base(i));

            // Set RdLkeccDbiLaneInject1 and RdLkeccDataLaneInject1
            set_field_by_apb("CTL_RDLKECCDBILANEINJECT1", dbi_lane_inject1, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCDATALANEINJECT1", data_lane_inject1, lkecc_ctl_base(i));

            // Set RdLkeccDbiLocaInject1 and RdLkeccDataLocaInject1
            set_field_by_apb("CTL_RDLKECCDBILOCAINJECT1", dbi_loca_inject1, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCDATALOCAINJECT1", data_loca_inject1, lkecc_ctl_base(i));

            // Program one-shot enable bits last so the next read data beat consumes a complete injection setup.
            set_field_by_apb("CTL_RDLKECCDBIINJECT2", dbi_inject2_en, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCDATAINJECT2", data_inject2_en, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCDBIINJECT1", dbi_inject1_en, lkecc_ctl_base(i));
            set_field_by_apb("CTL_RDLKECCDATAINJECT1", data_inject1_en, lkecc_ctl_base(i));

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

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("read lkecc status for channel %0d", i), UVM_LOW);

            // Read correctable and uncorrectable error counters
            get_field_by_apb("CTL_RDLKECCCORRCNT", rd_lkecc_corr_cnt, lkecc_ctl_base(i));
            get_field_by_apb("CTL_RDLKECCUNCORRCNT", rd_lkecc_uncorr_cnt, lkecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("RdLkeccCorrCnt=%0d, RdLkeccUncorrCnt=%0d",
                rd_lkecc_corr_cnt, rd_lkecc_uncorr_cnt), UVM_LOW);

            // Read interrupt status
            get_field_by_apb("CTL_RDLKECCCORRINT", rd_lkecc_corr_int, lkecc_ctl_base(i));
            get_field_by_apb("CTL_RDLKECCUNCORRINT", rd_lkecc_uncorr_int, lkecc_ctl_base(i));
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

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("clear lkecc error for channel %0d", i), UVM_LOW);

            // Clear correctable counter
            if (clr_corr_cnt) begin
                set_field_by_apb("CTL_RDLKECCCORRCNTCLR", 1'b1, lkecc_ctl_base(i));
                `uvm_info(get_full_name(), "RdLkeccCorrCntClr written to clear correctable error counter", UVM_LOW);
                set_field_by_apb("CTL_RDLKECCCORRCNTCLR", 1'b0, lkecc_ctl_base(i));
            end

            // Clear uncorrectable counter
            if (clr_uncorr_cnt) begin
                set_field_by_apb("CTL_RDLKECCUNCORRCNTCLR", 1'b1, lkecc_ctl_base(i));
                `uvm_info(get_full_name(), "RdLkeccUncorrCntClr written to clear uncorrectable error counter", UVM_LOW);
                set_field_by_apb("CTL_RDLKECCUNCORRCNTCLR", 1'b0, lkecc_ctl_base(i));
            end

            // Clear correctable interrupt
            if (clr_corr_int) begin
                set_field_by_apb("CTL_RDLKECCCORRINTCLR", 1'b1, lkecc_ctl_base(i));
                `uvm_info(get_full_name(), "RdLkeccCorrIntClr written to clear correctable interrupt", UVM_LOW);
                set_field_by_apb("CTL_RDLKECCCORRINTCLR", 1'b0, lkecc_ctl_base(i));
            end

            // Clear uncorrectable interrupt
            if (clr_uncorr_int) begin
                set_field_by_apb("CTL_RDLKECCUNCORRINTCLR", 1'b1, lkecc_ctl_base(i));
                `uvm_info(get_full_name(), "RdLkeccUncorrIntClr written to clear uncorrectable interrupt", UVM_LOW);
                set_field_by_apb("CTL_RDLKECCUNCORRINTCLR", 1'b0, lkecc_ctl_base(i));
            end
        end
    end

    `uvm_info(get_full_name(), "lkecc_clr_err completed", UVM_LOW);
endtask : lkecc_clr_err

`endif
