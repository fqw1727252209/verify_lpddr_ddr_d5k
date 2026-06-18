/*
 * @Project Name: 
 * @Team: soc/ddr
 * @Author: fengqingwei
 * @Email: fengqingwei2361@phytium.com.cn
 * @Date: 2026-06-02 09:54:41
 * @LastEditors: fengqingwei
 * @LastEditTime: 2026-06-02 14:46:19
 * @Description: 
 * @Copyright (c) 2026 Phytium.co.Ltd
 */

`ifdef SIMU_DMU_APB_FTVIP

class apb_inline_ecc_seq extends apb_base_uvddr_seq;

    `uvm_object_utils(apb_inline_ecc_seq)

    rand bit [`APB_ADDR_WIDTH-1:0]   addr;
    rand bit [`APB_DATA_WIDTH-1:0]   data;
    rand bit [5:0]                   mode;
    rand bit [5:0]                   ch_sel;
    rand bit                         bc_mode;
    rand bit [2:0] sel_blk_off;
    rand bit [5:0] sel_loc1;
    rand bit [5:0] sel_loc2;

    constraint default_ch_sel_c {
        soft ch_sel == 6'b000011;
    }
    
    function new(string name = "apb_inline_ecc_seq");
        super.new(name);
    endfunction

    function automatic bit [31:0] inline_ecc_ctl_base(input int ch_idx);
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
        `uvm_info(get_full_name(), "start apb_inline_ecc_seq...", UVM_LOW);
        repeat(5) @(posedge tb.clk_cfg);
        ctl_phy_reg_parser();
        ctl_phy_field_parser();
        // ch_sel = `SIMU_DMU_CH_SEL;
        if(mode=='h0) begin
            inline_ecc_cfg();
        end else if (mode=='h1) begin
            // blk_off: 3'b0 - first 64-bit data block
            // loc1: 8'h0 - first bit position to flip (bit 0)
            // loc2: 8'h1 - second bit position to flip (bit 1)
            // addr0: 32'h10000 - DRAM address {cs,cid,ba,row,col}
            // err_inj_en: 2'b11 - single-bit error injection enabled
            inline_ecc_wr_data_err_inj(3'b0,8'h0,8'h1,32'h60001c0,2'b11);
        end else if (mode=='h2) begin
            // Error status read, clear and verify flow
            bit        rd_ecc_c_err;
            bit        rd_ecc_uc_err;
            int        iecc_c_err_cnt;
            int        iecc_uc_err_cnt;
            int        iecc_c_cs;
            int        iecc_c_ba;
            int        iecc_c_col;
            int        iecc_c_row;
            int        iecc_c_syndrom_datah;
            int        iecc_c_syndrom_datal;
            int        iecc_c_syndrom_code;
            int        iecc_c_maskh;
            int        iecc_c_maskl;
            int        iecc_uc_cs;
            int        iecc_uc_ba;
            int        iecc_uc_col;
            int        iecc_uc_row;
            int        iecc_uc_syndrom_datah;
            int        iecc_uc_syndrom_datal;
            int        iecc_uc_syndrom_code;
            bit        rd_ecc_c_err_before;
            bit        rd_ecc_uc_err_before;
            int        iecc_c_err_cnt_before;
            int        iecc_uc_err_cnt_before;

            // Step 1: Read error status
            `uvm_info(get_full_name(), "Step 1: Reading ECC error status...", UVM_LOW);
            inline_ecc_get_status(
                rd_ecc_c_err, rd_ecc_uc_err,
                iecc_c_err_cnt, iecc_uc_err_cnt,
                iecc_c_cs, iecc_c_ba, iecc_c_col, iecc_c_row,
                iecc_c_syndrom_datah, iecc_c_syndrom_datal, iecc_c_syndrom_code,
                iecc_c_maskh, iecc_c_maskl,
                iecc_uc_cs, iecc_uc_ba, iecc_uc_col, iecc_uc_row,
                iecc_uc_syndrom_datah, iecc_uc_syndrom_datal, iecc_uc_syndrom_code
            );
            rd_ecc_c_err_before     = rd_ecc_c_err;
            rd_ecc_uc_err_before    = rd_ecc_uc_err;
            iecc_c_err_cnt_before   = iecc_c_err_cnt;
            iecc_uc_err_cnt_before  = iecc_uc_err_cnt;

            if (rd_ecc_c_err_before == 1'b0 && rd_ecc_uc_err_before == 1'b0 &&
                iecc_c_err_cnt_before == 0 && iecc_uc_err_cnt_before == 0) begin
                `uvm_error(get_full_name(), "INLINE ECC STATUS CHECK FAILED: no correctable or uncorrectable error was observed before clear");
            end

            // Step 2: Clear errors (both correctable and uncorrectable)
            `uvm_info(get_full_name(), "Step 2: Clearing ECC errors...", UVM_LOW);
            inline_ecc_clr_err(1'b1, 1'b1);

            // Step 3: Verify clear was successful by reading status again
            `uvm_info(get_full_name(), "Step 3: Verifying error clear...", UVM_LOW);
            inline_ecc_get_status(
                rd_ecc_c_err, rd_ecc_uc_err,
                iecc_c_err_cnt, iecc_uc_err_cnt,
                iecc_c_cs, iecc_c_ba, iecc_c_col, iecc_c_row,
                iecc_c_syndrom_datah, iecc_c_syndrom_datal, iecc_c_syndrom_code,
                iecc_c_maskh, iecc_c_maskl,
                iecc_uc_cs, iecc_uc_ba, iecc_uc_col, iecc_uc_row,
                iecc_uc_syndrom_datah, iecc_uc_syndrom_datal, iecc_uc_syndrom_code
            );

            // Check if errors were cleared successfully
            if (rd_ecc_c_err == 1'b0 && rd_ecc_uc_err == 1'b0 &&
                iecc_c_err_cnt == 0 && iecc_uc_err_cnt == 0) begin
                `uvm_info(get_full_name(), "ERROR CLEAR VERIFICATION PASSED: All error status cleared successfully", UVM_LOW);
            end else begin
                `uvm_error(get_full_name(), $sformatf("ERROR CLEAR VERIFICATION FAILED: rd_ecc_c_err=%0b, rd_ecc_uc_err=%0b, iecc_c_err_cnt=%0d, iecc_uc_err_cnt=%0d",
                    rd_ecc_c_err, rd_ecc_uc_err, iecc_c_err_cnt, iecc_uc_err_cnt));
            end
        end else if (mode=='h3) begin
            inline_ecc_wr_data_err_inj(sel_blk_off,sel_loc1,sel_loc2,32'h60001c0,2'b11); //wreccc
        end else if (mode=='h4) begin
            inline_ecc_wr_data_err_inj(sel_blk_off,sel_loc1,sel_loc2,32'h60001c0,2'b01); //wreccu
        end else if (mode=='h5) begin
            inline_ecc_rd_data_err_inj(sel_blk_off,sel_loc1,sel_loc2,32'h60001c0,2'b11); //rdeccc
        end else if (mode=='h6) begin
            inline_ecc_rd_data_err_inj(sel_blk_off,sel_loc1,sel_loc2,32'h60001c0,2'b01); //rdeccr
        end else if (mode=='h7) begin
            //USR_REGWR(`USR_BASE_ADDR+`DMU_TOP_APB_CTL,2'b11); // fqw 2026.06.02
        end else if (mode=='h8) begin
            integer id;
            integer success;
            string  model_path;

            for(int ch_idx = 0; ch_idx < 2; ch_idx++) begin
                for(int rank_idx = 0; rank_idx < `RANK_NUM; rank_idx++) begin
                    for(int mdat_idx = 0; mdat_idx < 32/`DRAM_WIDTH; mdat_idx++) begin
                        model_path = $sformatf("tb.u_dc.lpddr5.ch%0d.rank[%0d].mdat[%0d].comp",
                                               ch_idx, rank_idx, mdat_idx);
                        id = $mminstanceid(model_path);
                        if(id == 0) begin
                            model_path = $sformatf("tb.u_dc.lpddr5_ch%0d.rank[%0d].mdat[%0d].comp",
                                                   ch_idx, rank_idx, mdat_idx);
                            id = $mminstanceid(model_path);
                        end
                        success = $mmerrinject(id, "-seed 0 -reads 1 -bits 1 2 -percentage 80 15");
                        `uvm_info(get_full_name(),
                                  $sformatf("inline ECC model inject path=%s id=%0d result=%0d",
                                            model_path, id, success),
                                  UVM_LOW);
                    end
                end
            end
        end else if (mode=='h9) begin
            inline_ecc_clr_err(1'b1, 1'b1);
        end
        
        if(starting_phase) starting_phase.drop_objection(this);

    endtask

    extern virtual task inline_ecc_cfg();
    extern virtual task inline_ecc_wr_data_err_inj(
        input bit [2:0] blk_off,     // IEccWrDataErrInjBlkOff: which 64-bit data block
        input bit [5:0] loc1,        // IEccWrDataErrInjLoc1: first bit position to flip
        input bit [5:0] loc2,        // IEccWrDataErrInjLoc2: second bit position to flip (for double-bit error)
        input bit [31:0] addr0,      // IEccWrDataErrInjAddr0: DRAM address {cs,cid,ba,row,col}
        input bit [1:0] err_inj_en   // IEccWrDataErrInjEn: 2'b01=double-bit, 2'b11=single-bit
    );
    extern virtual task inline_ecc_rd_data_err_inj(
        input bit [2:0] blk_off,     // IEccRdDataErrInjBlkOff: which 64-bit data block
        input bit [5:0] loc1,        // IEccRdDataErrInjLoc1: first bit position to flip
        input bit [5:0] loc2,        // IEccRdDataErrInjLoc2: second bit position to flip (for double-bit error)
        input bit [31:0] addr0,      // IEccRdDataErrInjAddr: DRAM address {cs,cid,ba,row,col}
        input bit [1:0] err_inj_en   // IEccRdDataErrInjEn: 2'b00=disable, 2'b01=double-bit, 2'b10=single-bit, 2'b11=single-bit
    );
    extern virtual task inline_ecc_get_status(
        output bit        rd_ecc_c_err,    // RdEccCErr: correctable error detected
        output bit        rd_ecc_uc_err,   // RdEccUcErr: uncorrectable error detected
        output int        iecc_c_err_cnt,  // IEccCErrCnt: correctable error count
        output int        iecc_uc_err_cnt, // IEccUcErrCnt: uncorrectable error count
        output int        iecc_c_cs,       // IEccCCs: correctable error CS
        output int        iecc_c_ba,       // IEccCBa: correctable error BG and BA
        output int        iecc_c_col,      // IEccCCol: correctable error column
        output int        iecc_c_row,      // IEccCRow: correctable error row
        output int        iecc_c_syndrom_datah, // IEccCSyndromDatah: correctable error syndrome data high
        output int        iecc_c_syndrom_datal, // IEccCSyndromDatal: correctable error syndrome data low
        output int        iecc_c_syndrom_code,  // IEccCSyndromCode: correctable error syndrome code
        output int        iecc_c_maskh,    // IEccCMaskh: correctable error mask high
        output int        iecc_c_maskl,    // IEccCMaskl: correctable error mask low
        output int        iecc_uc_cs,      // IEccUcCs: uncorrectable error CS
        output int        iecc_uc_ba,      // IEccUcBa: uncorrectable error BG and BA
        output int        iecc_uc_col,     // IEccUcCol: uncorrectable error column
        output int        iecc_uc_row,     // IEccUcRow: uncorrectable error row
        output int        iecc_uc_syndrom_datah, // IEccUcSyndromDatah: uncorrectable error syndrome data high
        output int        iecc_uc_syndrom_datal, // IEccUcSyndromDatal: uncorrectable error syndrome data low
        output int        iecc_uc_syndrom_code   // IEccUcSyndromCode: uncorrectable error syndrome code
    );
    extern virtual task inline_ecc_clr_err(
        input bit         clr_c_err,       // 1: clear correctable error
        input bit         clr_uc_err       // 1: clear uncorrectable error
    );

endclass : apb_inline_ecc_seq

task apb_inline_ecc_seq::inline_ecc_cfg();
    `uvm_info(get_full_name(), "start inline_ecc_cfg...", UVM_LOW);
    
    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("start inline_ecc_cfg for channel %0d", i), UVM_LOW);

            set_field_by_apb("CTL_COL0POS",   0, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_COL1POS",   1, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_COL2POS",   2, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_COL3POS",  25, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_COL4POS",  26, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_COL5POS",  27, inline_ecc_ctl_base(i));

            set_field_by_apb("CTL_ROW0POS",   7, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW1POS",   8, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW2POS",   9, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW3POS",  10, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW4POS",  11, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW5POS",  12, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW6POS",  13, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW7POS",  14, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW8POS",  15, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW9POS",  16, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW10POS", 17, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW11POS", 18, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW12POS", 19, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW13POS", 20, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW14POS", 21, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW15POS", 22, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW16POS", 23, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_ROW17POS", 24, inline_ecc_ctl_base(i));

            set_field_by_apb("CTL_BA0POS",    5, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_BA1POS",    6, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_BA2POS",    3, inline_ecc_ctl_base(i));
            set_field_by_apb("CTL_BA3POS",    4, inline_ecc_ctl_base(i));
            // set_field_by_apb("CTL_CSPOS",    28, inline_ecc_ctl_base(i));

            // Step 1: Set WrEccCredit (range: 1 to WR ECC CAM depth)
            // User-defined value: set this according to the actual WR ECC CAM depth.
            set_field_by_apb("CTL_WRECCCREDIT",   8'b00100000, inline_ecc_ctl_base(i));

            // Step 2: Set EccRegionLock (1: ECC code in DRAM cannot be accessed by master, 0: can be accessed)
            // User-defined value: set this to 0 or 1 according to the requirement.
            set_field_by_apb("CTL_ECCREGIONLOCK", 'b1, inline_ecc_ctl_base(i));

            // Step 3: Set EccRegionMapGranu (0: 8 parts, 1: 16 parts, 2: 32 parts, 3: 64 parts)
            // User-defined value: set this to 0-3 according to the DRAM space partitioning requirement.
            set_field_by_apb("CTL_ECCREGIONMAPGRANU", 'b0, inline_ecc_ctl_base(i));

            // Step 4: Set EccRegionMap (7-bit one-hot code for regions 0-6, 1: protected, 0: non-protected)
            // User-defined value: set the 7-bit one-hot code according to the region protection requirement.
            set_field_by_apb("CTL_ECCREGIONMAP",    'h7f, inline_ecc_ctl_base(i));

            // Step 5: Set EccRegionMapOther (1: other regions protected, 0: non-protected)
            // User-defined value: set this to 0 or 1 according to the protection requirement for other regions.
            set_field_by_apb("CTL_ECCREGIONMAPOTHER", 'b1, inline_ecc_ctl_base(i));

            // Step 6: Set IEccEn to 1 to enable inline ECC
            set_field_by_apb("CTL_IECCEN", 1, inline_ecc_ctl_base(i));
        end
    end
    
    `uvm_info(get_full_name(), "inline_ecc_cfg configuration ", UVM_LOW);
endtask : inline_ecc_cfg

task apb_inline_ecc_seq::inline_ecc_wr_data_err_inj(
    input bit [2:0] blk_off,     // IEccWrDataErrInjBlkOff: which 64-bit data block
    input bit [5:0] loc1,        // IEccWrDataErrInjLoc1: first bit position to flip
    input bit [5:0] loc2,        // IEccWrDataErrInjLoc2: second bit position to flip (for double-bit error)
    input bit [31:0] addr0,      // IEccWrDataErrInjAddr0: DRAM address {cs,cid,ba,row,col}
    input bit [1:0] err_inj_en   // IEccWrDataErrInjEn: 2'b01=double-bit, 2'b11=single-bit
);
    `uvm_info(get_full_name(), "start inline_ecc_wr_data_err_inj...", UVM_LOW);
    
    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("start inline_ecc_wr_data_err_inj for channel %0d", i), UVM_LOW);

            // Step 1: Set IEccWrDataErrInjBlkOff - indicates which 64-bit data block (from lowest to highest)
            set_field_by_apb("CTL_IECCWRDATAERRINJBLKOFF", blk_off, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("Set IEccWrDataErrInjBlkOff = %0d", blk_off), UVM_LOW);

            // Step 2: Set IEccWrDataErrInjLoc1 - indicates bit position to flip in 64-bit data
            set_field_by_apb("CTL_IECCWRDATAERRINJLOC1", loc1, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("Set IEccWrDataErrInjLoc1 = %0d", loc1), UVM_LOW);

            // Step 3: Set IEccWrDataErrInjLoc2 - indicates second bit position to flip (for double-bit error)
            set_field_by_apb("CTL_IECCWRDATAERRINJLOC2", loc2, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("Set IEccWrDataErrInjLoc2 = %0d", loc2), UVM_LOW);

            // Step 4: Set IEccWrDataErrInjAddr0 - DRAM address {cs,cid,ba,row,col}
            set_field_by_apb("CTL_IECCWRDATAERRINJADDRL", addr0, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("Set IEccWrDataErrInjAddr = 0x%08h", addr0), UVM_LOW);

            // Step 5: Set IEccWrDataErrInjEn - 2'b01 for double-bit error, 2'b11 for single-bit error
            set_field_by_apb("CTL_IECCWRDATAERRINJEN", err_inj_en, inline_ecc_ctl_base(i));
            if (err_inj_en == 2'b01) begin
                `uvm_info(get_full_name(), "Set IEccWrDataErrInjEn = 2'b01 (double-bit error injection enabled)", UVM_LOW);
            end else if (err_inj_en == 2'b11) begin
                `uvm_info(get_full_name(), "Set IEccWrDataErrInjEn = 2'b11 (single-bit error injection enabled)", UVM_LOW);
            end else begin
                `uvm_info(get_full_name(), $sformatf("Set IEccWrDataErrInjEn = 2'b%02b (unexpected value)", err_inj_en), UVM_LOW);
            end
        end
    end
    
    `uvm_info(get_full_name(), "inline_ecc_wr_data_err_inj configuration completed", UVM_LOW);
endtask : inline_ecc_wr_data_err_inj

task apb_inline_ecc_seq::inline_ecc_rd_data_err_inj(
    input bit [2:0] blk_off,     // IEccRdDataErrInjBlkOff: which 64-bit data block
    input bit [5:0] loc1,        // IEccRdDataErrInjLoc1: first bit position to flip
    input bit [5:0] loc2,        // IEccRdDataErrInjLoc2: second bit position to flip (for double-bit error)
    input bit [31:0] addr0,      // IEccRdDataErrInjAddr: DRAM address {cs,cid,ba,row,col}
    input bit [1:0] err_inj_en   // IEccRdDataErrInjEn: 2'b00=disable, 2'b01=double-bit, 2'b10=single-bit, 2'b11=single-bit
);
    `uvm_info(get_full_name(), "start inline_ecc_rd_data_err_inj...", UVM_LOW);
    
    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("start inline_ecc_rd_data_err_inj for channel %0d", i), UVM_LOW);

            // Step 1: Set IEccRdDataErrInjBlkOff - indicates which 64-bit data block (from lowest to highest)
            set_field_by_apb("CTL_IECCRDDATAERRINJBLKOFF", blk_off, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("Set IEccRdDataErrInjBlkOff = %0d", blk_off), UVM_LOW);

            // Step 2: Set IEccRdDataErrInjLoc1 - indicates bit position to flip in 64-bit data
            set_field_by_apb("CTL_IECCRDDATAERRINJLOC1", loc1, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("Set IEccRdDataErrInjLoc1 = %0d", loc1), UVM_LOW);

            // Step 3: Set IEccRdDataErrInjLoc2 - indicates second bit position to flip (for double-bit error)
            set_field_by_apb("CTL_IECCRDDATAERRINJLOC2", loc2, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("Set IEccRdDataErrInjLoc2 = %0d", loc2), UVM_LOW);

            // Step 4: Set IEccRdDataErrInjAddr - DRAM address {cs,cid,ba,row,col}
            set_field_by_apb("CTL_IECCRDDATAERRINJADDRL", addr0, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("Set IEccRdDataErrInjAddr = 0x%08h", addr0), UVM_LOW);

            // Step 5: Set IEccRdDataErrInjEn - 2'b00=disable, 2'b01=double-bit, 2'b10=single-bit, 2'b11=single-bit
            set_field_by_apb("CTL_IECCRDDATAERRINJEN", err_inj_en, inline_ecc_ctl_base(i));
            if (err_inj_en == 2'b01) begin
                `uvm_info(get_full_name(), "Set CTL_IECCRDDATAERRINJEN = 2'b01 (double-bit error injection enabled)", UVM_LOW);
            end else if (err_inj_en == 2'b11) begin
                `uvm_info(get_full_name(), "Set CTL_IECCRDDATAERRINJEN = 2'b11 (single-bit error injection enabled)", UVM_LOW);
            end else begin
                `uvm_info(get_full_name(), $sformatf("Set CTL_IECCRDDATAERRINJEN = 2'b%02b (unexpected value)", err_inj_en), UVM_LOW);
            end
        end
    end
    
    `uvm_info(get_full_name(), "inline_ecc_rd_data_err_inj configuration completed", UVM_LOW);
endtask : inline_ecc_rd_data_err_inj

task apb_inline_ecc_seq::inline_ecc_get_status(
    output bit        rd_ecc_c_err,    // RdEccCErr: correctable error detected
    output bit        rd_ecc_uc_err,   // RdEccUcErr: uncorrectable error detected
    output int        iecc_c_err_cnt,  // IEccCErrCnt: correctable error count
    output int        iecc_uc_err_cnt, // IEccUcErrCnt: uncorrectable error count
    output int        iecc_c_cs,       // IEccCCs: correctable error CS
    output int        iecc_c_ba,       // IEccCBa: correctable error BG and BA
    output int        iecc_c_col,      // IEccCCol: correctable error column
    output int        iecc_c_row,      // IEccCRow: correctable error row
    output int        iecc_c_syndrom_datah, // IEccCSyndromDatah: correctable error syndrome data high
    output int        iecc_c_syndrom_datal, // IEccCSyndromDatal: correctable error syndrome data low
    output int        iecc_c_syndrom_code,  // IEccCSyndromCode: correctable error syndrome code
    output int        iecc_c_maskh,    // IEccCMaskh: correctable error mask high
    output int        iecc_c_maskl,    // IEccCMaskl: correctable error mask low
    output int        iecc_uc_cs,      // IEccUcCs: uncorrectable error CS
    output int        iecc_uc_ba,      // IEccUcBa: uncorrectable error BG and BA
    output int        iecc_uc_col,     // IEccUcCol: uncorrectable error column
    output int        iecc_uc_row,     // IEccUcRow: uncorrectable error row
    output int        iecc_uc_syndrom_datah, // IEccUcSyndromDatah: uncorrectable error syndrome data high
    output int        iecc_uc_syndrom_datal, // IEccUcSyndromDatal: uncorrectable error syndrome data low
        output int        iecc_uc_syndrom_code   // IEccUcSyndromCode: uncorrectable error syndrome code
);
    bit ch_rd_ecc_c_err;
    bit ch_rd_ecc_uc_err;
    int ch_iecc_c_err_cnt;
    int ch_iecc_uc_err_cnt;

    `uvm_info(get_full_name(), "start inline_ecc_get_status...", UVM_LOW);

    rd_ecc_c_err           = '0;
    rd_ecc_uc_err          = '0;
    iecc_c_err_cnt         = '0;
    iecc_uc_err_cnt        = '0;
    iecc_c_cs              = '0;
    iecc_c_ba              = '0;
    iecc_c_col             = '0;
    iecc_c_row             = '0;
    iecc_c_syndrom_datah   = '0;
    iecc_c_syndrom_datal   = '0;
    iecc_c_syndrom_code    = '0;
    iecc_c_maskh           = '0;
    iecc_c_maskl           = '0;
    iecc_uc_cs             = '0;
    iecc_uc_ba             = '0;
    iecc_uc_col            = '0;
    iecc_uc_row            = '0;
    iecc_uc_syndrom_datah  = '0;
    iecc_uc_syndrom_datal  = '0;
    iecc_uc_syndrom_code   = '0;

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("read inline_ecc status for channel %0d", i), UVM_LOW);

            // Read correctable/uncorrectable error flags
            get_field_by_apb("CTL_RDECCCERR", ch_rd_ecc_c_err, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_RDECCUCERR", ch_rd_ecc_uc_err, inline_ecc_ctl_base(i));
            rd_ecc_c_err  |= ch_rd_ecc_c_err;
            rd_ecc_uc_err |= ch_rd_ecc_uc_err;
            `uvm_info(get_full_name(), $sformatf("RdEccCErr=%0b, RdEccUcErr=%0b", rd_ecc_c_err, rd_ecc_uc_err), UVM_LOW);

            // Read error counts
            get_field_by_apb("CTL_HOSTIECCCERRCNT", ch_iecc_c_err_cnt, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_HOSTIECCUCERRCNT", ch_iecc_uc_err_cnt, inline_ecc_ctl_base(i));
            iecc_c_err_cnt  += ch_iecc_c_err_cnt;
            iecc_uc_err_cnt += ch_iecc_uc_err_cnt;
            `uvm_info(get_full_name(), $sformatf("IEccCErrCnt=%0d, IEccUcErrCnt=%0d", ch_iecc_c_err_cnt, ch_iecc_uc_err_cnt), UVM_LOW);

            // Read correctable error address and syndrome info
            get_field_by_apb("CTL_IECCCCS", iecc_c_cs, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCCBA", iecc_c_ba, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCCCOL", iecc_c_col, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCCROW", iecc_c_row, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("IEccCCs=0x%0h, IEccCBa=0x%0h, IEccCCol=0x%0h, IEccCRow=0x%0h",
                iecc_c_cs, iecc_c_ba, iecc_c_col, iecc_c_row), UVM_LOW);

            get_field_by_apb("CTL_IECCCSYNDROMDATAH", iecc_c_syndrom_datah, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCCSYNDROMDATAL", iecc_c_syndrom_datal, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCCSYNDROMCODE", iecc_c_syndrom_code, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("IEccCSyndromDatah=0x%0h, IEccCSyndromDatal=0x%0h, IEccCSyndromCode=0x%0h",
                iecc_c_syndrom_datah, iecc_c_syndrom_datal, iecc_c_syndrom_code), UVM_LOW);

            get_field_by_apb("CTL_IECCCMASKH", iecc_c_maskh, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCCMASKL", iecc_c_maskl, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("IEccCMaskh=0x%0h, IEccCMaskl=0x%0h", iecc_c_maskh, iecc_c_maskl), UVM_LOW);

            // Read uncorrectable error address and syndrome info
            get_field_by_apb("CTL_IECCUCCS", iecc_uc_cs, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCUCBA", iecc_uc_ba, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCUCCOL", iecc_uc_col, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCUCROW", iecc_uc_row, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("IEccUcCs=0x%0h, IEccUcBa=0x%0h, IEccUcCol=0x%0h, IEccUcRow=0x%0h",
                iecc_uc_cs, iecc_uc_ba, iecc_uc_col, iecc_uc_row), UVM_LOW);

            get_field_by_apb("CTL_IECCUCSYNDROMDATAH", iecc_uc_syndrom_datah, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCUCSYNDROMDATAL", iecc_uc_syndrom_datal, inline_ecc_ctl_base(i));
            get_field_by_apb("CTL_IECCUCSYNDROMCODE", iecc_uc_syndrom_code, inline_ecc_ctl_base(i));
            `uvm_info(get_full_name(), $sformatf("IEccUcSyndromDatah=0x%0h, IEccUcSyndromDatal=0x%0h, IEccUcSyndromCode=0x%0h",
                iecc_uc_syndrom_datah, iecc_uc_syndrom_datal, iecc_uc_syndrom_code), UVM_LOW);
        end
    end

    `uvm_info(get_full_name(), "inline_ecc_get_status completed", UVM_LOW);
endtask : inline_ecc_get_status

task apb_inline_ecc_seq::inline_ecc_clr_err(
    input bit         clr_c_err,       // 1: clear correctable error
    input bit         clr_uc_err       // 1: clear uncorrectable error
);
    `uvm_info(get_full_name(), "start inline_ecc_clr_err...", UVM_LOW);

    for (int i=0; i<2; i++) begin
        if(ch_sel[i]==1) begin
            `uvm_info(get_full_name(), $sformatf("clear inline_ecc error for channel %0d", i), UVM_LOW);

            // Step 1: Write IEccCErrClr to clear IEccCErrCnt and correctable error records
            if (clr_c_err) begin
                set_field_by_apb("CTL_IECCCERRCLR", 1, inline_ecc_ctl_base(i));
                `uvm_info(get_full_name(), "IEccCErrClr written to clear correctable error count and records", UVM_LOW);
                // Clear the clear bit (auto-clear or write 0)
                set_field_by_apb("CTL_IECCCERRCLR", 0, inline_ecc_ctl_base(i));
            end

            // Step 2: Write IEccUcErrClr to clear IEccUcErrCnt and uncorrectable error records
            if (clr_uc_err) begin
                set_field_by_apb("CTL_IECCUCERRCLR", 1, inline_ecc_ctl_base(i));
                `uvm_info(get_full_name(), "IEccUcErrClr written to clear uncorrectable error count and records", UVM_LOW);
                // Clear the clear bit (auto-clear or write 0)
                set_field_by_apb("CTL_IECCUCERRCLR", 0, inline_ecc_ctl_base(i));
            end
        end
    end

    `uvm_info(get_full_name(), "inline_ecc_clr_err completed", UVM_LOW);
endtask : inline_ecc_clr_err

`endif
