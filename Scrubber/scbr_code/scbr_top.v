`include "ddr_ctl_define.vh"

module scbr_top (

    input                               core_clk                ,
    input                               core_rstn               ,

    input                               csrSbEccEn              ,
    input                               csrIEccEn               ,
    input      [6:0]                    csrEccRegionMap         ,
    input                               csrEccRegionMapOther    ,
    input      [1:0]                    csrEccRegionMapGranu    ,

    input      [31:0]                   csrScbrStartAddr0       ,
    input      [`CTL_CMD_ADDR_W-32-1:0] csrScbrStartAddr1       ,
    input      [31:0]                   csrScbrEndAddr0         ,
    input      [`CTL_CMD_ADDR_W-32-1:0] csrScbrEndAddr1         ,

    input                               csrScbrEn               ,
    input      [1:0]                    csrScbrMode             ,
    input      [7:0]                    csrScbrPeriod           ,
    input      [7:0]                    csrScbrRndInterval      ,
    output     [31:0]                   csrScbrCurrAddr0        ,
    output     [`CTL_CMD_ADDR_W-32-1:0] csrScbrCurrAddr1        ,
    output     [2:0]                    csrScbrAddrRangeStatus  ,
    output     [7:0]                    csrScbrState            ,
    output                              csrScbrError            ,
    output                              csrScbrRoundDone        ,
    output reg                          csrScbrFixRmwFifoFull   ,

    input      [9:0]                    csrPortAgingInitRd      ,
    input      [9:0]                    csrPortAgingInitWr      ,
    input      [`CTL_CMD_ADDR_W-1:0]    csrUifAddrMask          ,

    input      [`CTL_ADDR_POS_W-1:0]    csrRow0Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow1Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow2Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow3Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow4Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow5Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow6Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow7Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow8Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow9Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow10Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow11Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow12Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow13Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow14Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow15Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow16Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow17Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrRow18Pos             ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCol0Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCol1Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCol2Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCol3Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCol4Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCol5Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCol6Pos              ,
    input      [`CTL_ADDR_POS_W-1:0]    csrBa0Pos               ,
    input      [`CTL_ADDR_POS_W-1:0]    csrBa1Pos               ,
    input      [`CTL_ADDR_POS_W-1:0]    csrBa2Pos               ,
    input      [`CTL_ADDR_POS_W-1:0]    csrBa3Pos               ,
    input      [`CTL_ADDR_POS_W-1:0]    csrBa4Pos               ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCs0Pos               ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCs1Pos               ,
    input      [`CTL_ADDR_POS_W-1:0]    csrCid0Pos              ,
    input      [`CTL_CMD_TS_W-1:0]      global_timer            ,

    output     [`CTL_CMD_W-1:0]         hpr_q_cmd               ,
    output     [`CTL_CMD_W-1:0]         lpr_q_cmd               ,
    output     [`CTL_CMD_W-1:0]         tpw_q_cmd               ,
    output                              hpr_q_req               ,
    output                              lpr_q_req               ,
    output                              tpw_q_req               ,
    output                              tpw_q_cmd_drop          ,
    output                              hpr_page_match_next     ,
    output                              lpr_page_match_next     ,
    output                              tpw_page_match_next     ,
    output                              hpr_aging               ,
    output                              lpr_aging               ,
    output                              tpw_aging               ,
    output                              gpr_timeout             ,
    output                              gpw_timeout             ,
    output     [4:0]                    hpr_inter_priority      ,
    output     [4:0]                    lpr_inter_priority      ,
    output     [4:0]                    tpw_inter_priority      ,
    output                              hpr_q_iecc_protect      ,
    output                              lpr_q_iecc_protect      ,
    output                              tpw_q_iecc_protect      ,
    output                              hpr_q_iecc_region_acc   ,
    output                              lpr_q_iecc_region_acc   ,
    output                              tpw_q_iecc_region_acc   ,
    input                               hpr_q_grant             ,
    input                               lpr_q_grant             ,
    input                               tpw_q_grant             ,

    input                               rdp_scbr_req            ,
    input      [`CTL_LRANK_NUM_W-1:0]   rdp_scbr_ecc_c_cid      ,
    input      [`CTL_RANK_NUM_W-1:0]    rdp_scbr_ecc_c_cs       ,
    input      [`CTL_ROW_W-1:0]         rdp_scbr_ecc_c_row      ,
    input      [`CTL_BA_W-1:0]          rdp_scbr_ecc_c_ba       ,
    input      [`CTL_COL_W-1:0]         rdp_scbr_ecc_c_col      ,

    input                               scbr_hold               ,
    input                               csrCqIdle               ,
    input      [15:0]                   csrScbrCtrlIdleCnt      ,

    output                              scbr_fifo_full_itr      ,
    output                              scbr_cfg_itr            
);

assign hpr_q_cmd            = {(`CTL_CMD_W){1'b0}};
assign hpr_q_req            = 1'b0;
assign hpr_aging            = 1'b0;
assign hpr_inter_priority   = 5'b0;
assign hpr_page_match_next  = 1'b0;
assign lpr_page_match_next  = 1'b0;
assign tpw_page_match_next  = 1'b0;
assign tpw_q_cmd_drop       = 1'b0;
assign gpr_timeout          = 1'b0;
assign gpw_timeout          = 1'b0;

wire   hpr_q_grant_nc;
assign hpr_q_grant_nc = hpr_q_grant;

assign hpr_q_iecc_protect     = 1'b0;
assign hpr_q_iecc_region_acc  = 1'b0;
assign lpr_q_iecc_region_acc  = 1'b0;
assign tpw_q_iecc_region_acc  = 1'b0;

assign lpr_q_iecc_protect   = lpr_q_req & csrIEccEn;
assign tpw_q_iecc_protect   = tpw_q_req & csrIEccEn;

wire   [`CTL_CMD_ADDR_W-1:0] scbr_pa_cmd_addr;
wire   [`CTL_CMD_ID_W-1:0]   scbr_pa_cmd_id  ;
wire   [`CTL_PORT_ID_W-1:0]  scbr_port_id    ;
wire   [1:0]                 scbr_pa_cmd_type;
wire   [1:0]                 scbr_pa_cmd_pri ;
wire                         scbr_pa_cmd_vld ;
wire                         pa_scbr_ready   ;

wire                         cmd_is_wr;
wire                         cmd_is_rd;

assign cmd_is_wr        = (scbr_pa_cmd_type == `CTL_CMD_TYPE_RMW) | (scbr_pa_cmd_type == `CTL_CMD_TYPE_WR);
assign cmd_is_rd        = (scbr_pa_cmd_type == `CTL_CMD_TYPE_RD);

assign tpw_q_req        = cmd_is_wr & scbr_pa_cmd_vld;
assign lpr_q_req        = cmd_is_rd & scbr_pa_cmd_vld;

assign pa_scbr_ready    = tpw_q_req ? tpw_q_grant : lpr_q_grant;

assign scbr_pa_cmd_pri  = `CTL_PRIO_LPR_TPW               ;
assign scbr_port_id     = `CTL_SCBR_PORT                  ;

assign scbr_pa_cmd_id = {
                        scbr_port_id                      ,
                        1'b0                              ,
                        3'b110                            ,
                        13'b0                             ,
                        1'b0                              
};

assign lpr_q_cmd        = {
                        {(`CTL_CMD_TS_W+1){1'b0}}         ,
                        scbr_pa_cmd_id                    ,
                        scbr_pa_cmd_addr                  ,
                        scbr_pa_cmd_type                  ,
                        scbr_pa_cmd_pri                   ,
                        `AXI_QOS_W'b0                     
};

assign tpw_q_cmd        = {
                        {(`CTL_CMD_TS_W+1){1'b0}}         ,
                        scbr_pa_cmd_id                    ,
                        scbr_pa_cmd_addr                  ,
                        scbr_pa_cmd_type                  ,
                        scbr_pa_cmd_pri                   ,
                        `AXI_QOS_W'b0                     
};

reg    [9:0]            port_aging_cnt_lpr                ;
reg    [9:0]            port_aging_cnt_tpw                ;

wire                    port_aging_cnt_dec_lpr            ;
wire                    port_aging_cnt_dec_tpw            ;
wire                    fix_rmw_fifo_almost_full_nc       ;
wire                    fix_rmw_fifo_almost_full          ;
wire   [$clog2(`CTL_SCBR_FIFO_DEPTH):0] fix_rmw_fifo_wcnt ;

assign fix_rmw_fifo_almost_full = fix_rmw_fifo_wcnt[$clog2(`CTL_SCBR_FIFO_DEPTH)-1 -: 2] == 2'b11 |
                                  fix_rmw_fifo_wcnt[$clog2(`CTL_SCBR_FIFO_DEPTH)] == 1'b1          ;

assign port_aging_cnt_dec_lpr = (lpr_q_req) & (port_aging_cnt_lpr != 10'h0);
assign port_aging_cnt_dec_tpw = (tpw_q_req) & (port_aging_cnt_tpw != 10'h0);

always@(posedge core_clk, negedge core_rstn) begin
    if(~core_rstn) begin
        port_aging_cnt_lpr <= 10'h3ff;
    end else if(lpr_q_grant) begin
        port_aging_cnt_lpr <= csrPortAgingInitRd;
    end else if(port_aging_cnt_dec_lpr) begin
        port_aging_cnt_lpr <= port_aging_cnt_lpr - 1'b1;
    end
end

always@(posedge core_clk, negedge core_rstn) begin
    if(~core_rstn) begin
        port_aging_cnt_tpw <= 10'h3ff;
    end else if(tpw_q_grant) begin
        port_aging_cnt_tpw <= csrPortAgingInitWr;
    end else if(port_aging_cnt_dec_tpw) begin
        port_aging_cnt_tpw <= port_aging_cnt_tpw - 1'b1;
    end
end

assign lpr_inter_priority   = port_aging_cnt_lpr[9:5]                 ;
assign tpw_inter_priority   = port_aging_cnt_tpw[9:5]                 ;
assign lpr_aging            = lpr_q_req & ((port_aging_cnt_lpr == 10'h0) | fix_rmw_fifo_almost_full);
assign tpw_aging            = tpw_q_req & ((port_aging_cnt_tpw == 10'h0) | fix_rmw_fifo_almost_full);

reg  [15:0]             ctrl_idle_cnt;
wire                    scbr_need_send_in_idle;

always @(posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        ctrl_idle_cnt   <= 16'h0;
    end else if(csrScbrEn & ~csrCqIdle) begin
        ctrl_idle_cnt   <= csrScbrCtrlIdleCnt;
    end else if(csrCqIdle & (ctrl_idle_cnt > 16'h0)) begin
        ctrl_idle_cnt   <= ctrl_idle_cnt - 16'h1;
    end
end

assign scbr_need_send_in_idle = csrCqIdle & csrScbrEn & (ctrl_idle_cnt == 16'h0) & (|csrScbrCtrlIdleCnt);

wire   [`CTL_CMD_ADDR_W-1:0] fix_cmd_addr_in        ;

scbr_addr_rev_map scbr_addr_rev_map (
    .rdp_scbr_ecc_c_cid         (rdp_scbr_ecc_c_cid         ),
    .rdp_scbr_ecc_c_cs          (rdp_scbr_ecc_c_cs          ),
    .csrUifAddrMask             (csrUifAddrMask             ),
    .rdp_scbr_ecc_c_row         (rdp_scbr_ecc_c_row         ),
    .rdp_scbr_ecc_c_ba          (rdp_scbr_ecc_c_ba          ),
    .rdp_scbr_ecc_c_col         (rdp_scbr_ecc_c_col         ),

    .csr_row_0_pos              (csrRow0Pos                 ),
    .csr_row_1_pos              (csrRow1Pos                 ),
    .csr_row_2_pos              (csrRow2Pos                 ),
    .csr_row_3_pos              (csrRow3Pos                 ),
    .csr_row_4_pos              (csrRow4Pos                 ),
    .csr_row_5_pos              (csrRow5Pos                 ),
    .csr_row_6_pos              (csrRow6Pos                 ),
    .csr_row_7_pos              (csrRow7Pos                 ),
    .csr_row_8_pos              (csrRow8Pos                 ),
    .csr_row_9_pos              (csrRow9Pos                 ),
    .csr_row_10_pos             (csrRow10Pos                ),
    .csr_row_11_pos             (csrRow11Pos                ),
    .csr_row_12_pos             (csrRow12Pos                ),
    .csr_row_13_pos             (csrRow13Pos                ),
    .csr_row_14_pos             (csrRow14Pos                ),
    .csr_row_15_pos             (csrRow15Pos                ),
    .csr_row_16_pos             (csrRow16Pos                ),
    .csr_row_17_pos             (csrRow17Pos                ),
    .csr_row_18_pos             (csrRow18Pos                ),
    .csr_col_0_pos              (csrCol0Pos                 ),
    .csr_col_1_pos              (csrCol1Pos                 ),
    .csr_col_2_pos              (csrCol2Pos                 ),
    .csr_col_3_pos              (csrCol3Pos                 ),
    .csr_col_4_pos              (csrCol4Pos                 ),
    .csr_col_5_pos              (csrCol5Pos                 ),
    .csr_col_6_pos              (csrCol6Pos                 ),
    .csr_ba_0_pos               (csrBa0Pos                  ),
    .csr_ba_1_pos               (csrBa1Pos                  ),
    .csr_ba_2_pos               (csrBa2Pos                  ),
    .csr_ba_3_pos               (csrBa3Pos                  ),
    .csr_ba_4_pos               (csrBa4Pos                  ),
    .csr_cs_0_pos               (csrCs0Pos                  ),
    .csr_cs_1_pos               (csrCs1Pos                  ),
    .csr_cid_0_pos              (csrCid0Pos                 ),
    .uif_cmd_addr               (fix_cmd_addr_in            )
);

wire                            fix_rmw_fifo_full          ;
wire                            fix_rmw_fifo_almost_empty_nc;
wire                            fix_rmw_fifo_empty         ;
wire   [`CTL_CMD_ADDR_W-1:0]    fix_rmw_cmd_addr_in        ;
wire   [`CTL_CMD_ADDR_W-1:0]    fix_rmw_cmd_addr_out       ;
wire                            fix_rmw_fifo_rd_en         ;
wire                            fix_rmw_fifo_wr_en         ;

assign fix_rmw_fifo_wr_en = (~fix_rmw_fifo_full) & rdp_scbr_req;
assign fix_rmw_cmd_addr_in = fix_cmd_addr_in;

ctl_fifo_fwft_sync_np2_clr #(
    .DATA_WIDTH                 (`CTL_CMD_ADDR_W            ),
    .ADDR_WIDTH                 ($clog2(`CTL_SCBR_FIFO_DEPTH)),
    .DATA_DEPTH                 (`CTL_SCBR_FIFO_DEPTH       )
) 
fix_rmw_fifo (
    .h_rstn                     (core_rstn                  ),
    .s_rst                      (1'b0                       ),
    .clk                        (core_clk                   ),
    .wr_en                      (fix_rmw_fifo_wr_en         ),
    .din                        (fix_rmw_cmd_addr_in        ),
    .almost_full_nc             (fix_rmw_fifo_almost_full_nc),
    .full                       (fix_rmw_fifo_full          ),
    .wcnt                       (fix_rmw_fifo_wcnt          ),
    
    .rd_en                      (fix_rmw_fifo_rd_en         ),
    .dout                       (fix_rmw_cmd_addr_out       ),
    .almost_empty_nc            (fix_rmw_fifo_almost_empty_nc),
    .empty                      (fix_rmw_fifo_empty         )
);

wire                            global_timer_full          ;
reg                             scbr_fifo_full_itr_vld     ;

assign global_timer_full = global_timer == {`CTL_CMD_TS_W{1'b1}};

always @(posedge core_clk or negedge core_rstn) begin
    if(!core_rstn) begin
        scbr_fifo_full_itr_vld <= 1'b1;
    end else if(global_timer_full) begin
        scbr_fifo_full_itr_vld <= 1'b1;
    end else if(scbr_fifo_full_itr) begin
        scbr_fifo_full_itr_vld <= 1'b0;
    end
end

always @(posedge core_clk or negedge core_rstn) begin
    if(!core_rstn) begin
        csrScbrFixRmwFifoFull <= 1'b0;
    end else if(global_timer_full) begin
        csrScbrFixRmwFifoFull <= 1'b0;
    end else if(scbr_fifo_full_itr) begin
        csrScbrFixRmwFifoFull <= 1'b1;
    end
end

assign scbr_fifo_full_itr  = fix_rmw_fifo_almost_full & scbr_fifo_full_itr_vld;

wire                            csr_scbr_en_re             ;
wire                            csr_scbr_en_fe             ;
wire                            not_fix_rmw_mode           ;
wire                            next_round_begin           ;

wire                            peri_scbr_send             ;

wire   [`CTL_CMD_ADDR_W-1:0]    peri_scbr_addr             ;
wire                            scbr_last                  ;
wire                            scbr_error                 ;
wire                            scbr_init_ok               ;
wire                            scbr_in_init_state         ;

wire                            ecc_en                     ;

assign ecc_en = csrIEccEn | csrSbEccEn;
wire                            scbr_idle_nc               ;

scbr_ctrl scbr_ctrl(
    .core_clk                   (core_clk                   ),
    .core_rstn                  (core_rstn                  ),

    .csr_ecc_en                 (ecc_en                     ),
    .csr_scbr_en                (csrScbrEn                  ),
    .csr_scbr_mode              (csrScbrMode                ),
    .csr_scbr_period            (csrScbrPeriod              ),
    .csrScbrRndInterval         (csrScbrRndInterval         ),
    .scbr_need_send_in_idle     (scbr_need_send_in_idle     ),

    .csr_scbr_state             (csrScbrState               ),
    .csr_scbr_error             (csrScbrError               ),
    .csr_scbr_round_done        (csrScbrRoundDone           ),

    .scbr_hold                  (scbr_hold                  ),
    .scbr_idle                  (scbr_idle_nc               ),
    .scbr_cfg_itr               (scbr_cfg_itr               ),

    .fix_rmw_fifo_empty         (fix_rmw_fifo_empty         ),
    .fix_rmw_cmd_addr_out       (fix_rmw_cmd_addr_out       ),
    .fix_rmw_fifo_rd_en         (fix_rmw_fifo_rd_en         ),

    .csr_scbr_en_re             (csr_scbr_en_re             ),
    .csr_scbr_en_fe             (csr_scbr_en_fe             ),
    .not_fix_rmw_mode           (not_fix_rmw_mode           ),
    .next_round_begin           (next_round_begin           ),

    .scbr_in_init_state         (scbr_in_init_state         ),
    .peri_scbr_send             (peri_scbr_send             ),

    .peri_scbr_addr             (peri_scbr_addr             ),
    .scbr_last                  (scbr_last                  ),
    .scbr_error                 (scbr_error                 ),
    .scbr_init_ok               (scbr_init_ok               ),

    .scbr_pa_cmd_addr           (scbr_pa_cmd_addr           ),
    .scbr_pa_cmd_type           (scbr_pa_cmd_type           ),
    .scbr_pa_cmd_vld            (scbr_pa_cmd_vld            ),
    .pa_scbr_ready              (pa_scbr_ready              )
);

scbr_addr_gen scbr_addr_gen (
    .core_clk                   (core_clk                   ),
    .core_rstn                  (core_rstn                  ),
    .csrSbEccEn                 (csrSbEccEn                 ),
    .csrIEccEn                  (csrIEccEn                  ),
    .csr_col_5_pos              (csrCol5Pos                 ),
    .csr_ecc_region_map         (csrEccRegionMap            ),
    .csr_ecc_region_map_other   (csrEccRegionMapOther       ),
    .csr_ecc_region_map_granu   (csrEccRegionMapGranu       ),
    .csrScbrStartAddr0          (csrScbrStartAddr0          ),
    .csrScbrStartAddr1          (csrScbrStartAddr1          ),
    .csrScbrEndAddr0            (csrScbrEndAddr0            ),
    .csrScbrEndAddr1            (csrScbrEndAddr1            ),

    .csr_scbr_en_re             (csr_scbr_en_re             ),
    .csr_scbr_en_fe             (csr_scbr_en_fe             ),
    .not_fix_rmw_mode           (not_fix_rmw_mode           ),
    .next_round_begin           (next_round_begin           ),
    .csrScbrCurrAddr0           (csrScbrCurrAddr0           ),
    .csrScbrCurrAddr1           (csrScbrCurrAddr1           ),
    .csr_scbr_addr_range_status (csrScbrAddrRangeStatus     ),
    .peri_scbr_send             (peri_scbr_send             ),

    .scbr_in_init_state         (scbr_in_init_state         ),
    .scbr_init_ok               (scbr_init_ok               ),
    .scbr_error                 (scbr_error                 ),
    .peri_scbr_addr             (peri_scbr_addr             ),
    .scbr_last                  (scbr_last                  )
);

endmodule