`include "ddr_ctl_define.vh"

module lkecc_decoder #(
    parameter DFI_CMD_INFO_W = `CTL_RANK_NUM_W+`CTL_BA_W+`CTL_ROW_W+`CTL_COL_W+`CTL_BI_W+`CTL_RBI_W+4
   ,parameter DFI_CMD_ID_W   = (`CTL_CMD_ID_W+`CTL_CQ_CAM_ADDR_W)
)
(
    input                                        core_clk                 ,
    input                                        core_rstn                ,

    input      [1:0]                             csrFreqRatio             ,

    input                                        raw_rdp_sce_flag         ,
    input                                        raw_rdp_wr_en            ,
    input      [DFI_CMD_ID_W-1:0]                raw_rdp_cmd_id           ,
    input      [`CTL_DFI_RDP_DATA_W-1:0]         raw_rdp_data             ,
    input      [`CTL_DFI_RDP_DATA_DBI_W-1:0]     raw_rdp_data_ecc         ,

    input      [`CTL_RANK_NUM_W-1:0]             raw_rdp_rd_cs            ,
    input      [`CTL_BA_W-1:0]                   raw_rdp_rd_ba            ,
    input      [`CTL_ROW_W-1:0]                  raw_rdp_rd_row           ,
    input      [`CTL_COL_W-1:0]                  raw_rdp_rd_col           ,
    input                                        raw_rdp_rd_gen_for_rmw   ,
    input                                        raw_rdp_rd_gen_for_iecc  ,
    input      [`CTL_BI_W-1 :0]                  raw_rdp_cmd_bi           ,
    input      [`CTL_RBI_W-1 :0]                 raw_rdp_cmd_rbi          ,
    input                                        raw_rdp_cmd_prot         ,

    output wire                                  rdp_sce_flag             ,
    output wire                                  rdp_wr_en                ,
    output wire [DFI_CMD_ID_W-1:0]               rdp_cmd_id               ,
    output wire [`CTL_DFI_RDP_DATA_W-1:0]        rdp_data                 ,
    output wire [`CTL_DFI_RDP_DATA_DBI_W-1:0]    rdp_data_dbi             ,

    output wire [`CTL_RANK_NUM_W-1:0]            rdp_rd_cs                ,
    output wire [`CTL_BA_W-1:0]                  rdp_rd_ba                ,
    output wire [`CTL_ROW_W-1:0]                 rdp_rd_row               ,
    output wire [`CTL_COL_W-1:0]                 rdp_rd_col               ,
    output wire                                  rdp_rd_gen_for_rmw       ,
    output wire                                  rdp_rd_gen_for_iecc      ,
    output wire [`CTL_BI_W-1 :0]                 rdp_cmd_bi               ,
    output wire [`CTL_RBI_W-1 :0]                rdp_cmd_rbi              ,
    output wire                                  rdp_cmd_prot             ,

    output wire                                  rd_data_lkecc_uc_error   ,
    output wire                                  rd_data_lkecc_c_error    ,

    input                                        csrRdLkeccDataInject1    ,
    input                                        csrRdLkeccDataInject2    ,
    input                                        csrRdLkeccDbiInject1     ,
    input                                        csrRdLkeccDbiInject2     ,

    output wire                                  csrRdLkeccDataInjectClr1 ,
    output wire                                  csrRdLkeccDbiInjectClr1  ,
    output wire                                  csrRdLkeccDataInjectClr2 ,
    output wire                                  csrRdLkeccDbiInjectClr2  ,

    input      [2:0]                             csrRdLkeccDataLaneInject1,
    input      [2:0]                             csrRdLkeccDataLaneInject2,
    input      [6:0]                             csrRdLkeccDataLocaInject1,
    input      [6:0]                             csrRdLkeccDataLocaInject2,
    input      [2:0]                             csrRdLkeccDbiLaneInject1 ,
    input      [2:0]                             csrRdLkeccDbiLaneInject2 ,
    input      [3:0]                             csrRdLkeccDbiLocaInject1 ,
    input      [3:0]                             csrRdLkeccDbiLocaInject2 ,

    input                                        csrRdLkeccEnable         ,
    input                                        csrRdLkeccCorrIntEn      ,
    input                                        csrRdLkeccCorrCntEn      ,
    input                                        csrRdLkeccCorrIntClr     ,
    input                                        csrRdLkeccCorrCntClr     ,
    output reg                                   csrRdLkeccCorrInt        ,
    output reg [31:0]                            csrRdLkeccCorrCnt        ,
    input                                        csrRdLkeccUncorrIntEn    ,
    input                                        csrRdLkeccUncorrCntEn    ,
    input                                        csrRdLkeccUncorrIntClr   ,
    input                                        csrRdLkeccUncorrCntClr   ,
    output reg                                   csrRdLkeccUncorrInt      ,
    output reg [31:0]                            csrRdLkeccUncorrCnt      
);

reg csrRdLkeccEnable_d1;
always@(posedge core_clk, negedge core_rstn) begin
    if(~core_rstn) begin
        csrRdLkeccEnable_d1 <= 1'b0;
    end
    else begin
        csrRdLkeccEnable_d1 <= csrRdLkeccEnable;
    end
end

reg freq_ratio_2;
reg freq_ratio_4;
always@(posedge core_clk, negedge core_rstn) begin
    if(~core_rstn) begin
        freq_ratio_2 <= 1'b1;
        freq_ratio_4 <= 1'b0;
    end
    else begin
        freq_ratio_2 <= (csrFreqRatio==2'b01);
        freq_ratio_4 <= (csrFreqRatio==2'b10);
    end
end

wire                                  pack_rdp_data_en ;
wire [`CTL_DFI_RDP_DATA_W-1:0]        pack_rdp_data    ;
wire [`CTL_DFI_RDP_DATA_DBI_W-1:0]    pack_rdp_data_ecc;

wire [`CTL_DFI_RDP_DATA_W-1:0]        mdy_rdp_data     ;
wire [`CTL_DFI_RDP_DATA_DBI_W-1:0]    mdy_rdp_data_dbi ;

wire [127:0]                          lane_0_data      ;
wire  [15:0]                          lane_0_data_dbi  ;
wire [127:0]                          mdy_lane_0_data  ;
wire  [15:0]                          mdy_lane_0_data_dbi;
wire   [8:0]                          lane_0_data_syndrome;
wire                                  lane_0_corr_error;
wire                                  lane_0_uncorr_error;
wire [136:0]                          lane_0_error_locator_poly;
wire [127:0]                          lane_0_dec_data  ;
wire   [8:0]                          lane_0_dec_dbi   ;
wire [127:0]                          lane_1_data      ;
wire  [15:0]                          lane_1_data_dbi  ;
wire [127:0]                          mdy_lane_1_data  ;
wire  [15:0]                          mdy_lane_1_data_dbi;
wire   [8:0]                          lane_1_data_syndrome;
wire                                  lane_1_corr_error;
wire                                  lane_1_uncorr_error;
wire [136:0]                          lane_1_error_locator_poly;
wire [127:0]                          lane_1_dec_data  ;
wire   [8:0]                          lane_1_dec_dbi   ;
wire [127:0]                          lane_2_data      ;
wire  [15:0]                          lane_2_data_dbi  ;
wire [127:0]                          mdy_lane_2_data  ;
wire  [15:0]                          mdy_lane_2_data_dbi;
wire   [8:0]                          lane_2_data_syndrome;
wire                                  lane_2_corr_error;
wire                                  lane_2_uncorr_error;
wire [136:0]                          lane_2_error_locator_poly;
wire [127:0]                          lane_2_dec_data  ;
wire   [8:0]                          lane_2_dec_dbi   ;
wire [127:0]                          lane_3_data      ;
wire  [15:0]                          lane_3_data_dbi  ;
wire [127:0]                          mdy_lane_3_data  ;
wire  [15:0]                          mdy_lane_3_data_dbi;
wire   [8:0]                          lane_3_data_syndrome;
wire                                  lane_3_corr_error;
wire                                  lane_3_uncorr_error;
wire [136:0]                          lane_3_error_locator_poly;
wire [127:0]                          lane_3_dec_data  ;
wire   [8:0]                          lane_3_dec_dbi   ;

wire [DFI_CMD_INFO_W-1:0] raw_rdp_cmd_info;
assign raw_rdp_cmd_info = {raw_rdp_sce_flag,raw_rdp_cmd_bi,raw_rdp_cmd_rbi,raw_rdp_cmd_prot,raw_rdp_rd_gen_for_rmw,raw_rdp_rd_gen_for_iecc,raw_rdp_rd_cs,raw_rdp_rd_ba,raw_rdp_rd_row,raw_rdp_rd_col};

wire [(DFI_CMD_INFO_W)-1:0] pack_rdp_cmd_info;
wire [(DFI_CMD_ID_W)-1:0] pack_rdp_cmd_id;

lkecc_rdp_pipe_in #(
    .DFI_CMD_INFO_W  (DFI_CMD_INFO_W  ),
    .DFI_CMD_ID_W    (DFI_CMD_ID_W    )
) inst_lkecc_rdp_pipe_in(
    .raw_rdp_wr_en      (raw_rdp_wr_en      ),
    .raw_rdp_cmd_id     (raw_rdp_cmd_id     ),
    .raw_rdp_data       (raw_rdp_data       ),
    .raw_rdp_data_ecc   (raw_rdp_data_ecc   ),
    .raw_rdp_cmd_info   (raw_rdp_cmd_info   ),
    .pack_rdp_data_en   (pack_rdp_data_en   ),
    .pack_rdp_cmd_id    (pack_rdp_cmd_id    ),
    .pack_rdp_data      (pack_rdp_data      ),
    .pack_rdp_data_ecc  (pack_rdp_data_ecc  ),
    .pack_rdp_cmd_info  (pack_rdp_cmd_info  )
);

rdp_lane_data_map inst_rdp_lane_data_map(
    .lane_0_data      (lane_0_data      ),
    .lane_0_data_dbi  (lane_0_data_dbi  ),
    .lane_1_data      (lane_1_data      ),
    .lane_1_data_dbi  (lane_1_data_dbi  ),
    .lane_2_data      (lane_2_data      ),
    .lane_2_data_dbi  (lane_2_data_dbi  ),
    .lane_3_data      (lane_3_data      ),
    .lane_3_data_dbi  (lane_3_data_dbi  ),
    .rdp_data         (pack_rdp_data    ),
    .rdp_data_ecc     (pack_rdp_data_ecc)
);

wire rdlkecc_data_inject_1;
wire rdlkecc_data_inject_2;
wire rdlkecc_dbi_inject_1 ;
wire rdlkecc_dbi_inject_2 ;

assign rdlkecc_data_inject_1   = csrRdLkeccDataInject1 & pack_rdp_data_en;
assign rdlkecc_data_inject_2   = csrRdLkeccDataInject2 & pack_rdp_data_en;
assign rdlkecc_dbi_inject_1    = csrRdLkeccDbiInject1  & pack_rdp_data_en;
assign rdlkecc_dbi_inject_2    = csrRdLkeccDbiInject2  & pack_rdp_data_en;

assign csrRdLkeccDataInjectClr1 = csrRdLkeccDataInject1 & pack_rdp_data_en;
assign csrRdLkeccDataInjectClr2 = csrRdLkeccDataInject2 & pack_rdp_data_en;
assign csrRdLkeccDbiInjectClr1  = csrRdLkeccDbiInject1  & pack_rdp_data_en;
assign csrRdLkeccDbiInjectClr2  = csrRdLkeccDbiInject2  & pack_rdp_data_en;

rd_lkecc_error_inject inst_rd_lkecc_error_inject(
    .core_clk                  (core_clk                  ),
    .core_rstn                 (core_rstn                 ),
    .raw_lane_0_data           (lane_0_data               ),
    .raw_lane_0_dbi            (lane_0_data_dbi           ),
    .raw_lane_1_data           (lane_1_data               ),
    .raw_lane_1_dbi            (lane_1_data_dbi           ),
    .raw_lane_2_data           (lane_2_data               ),
    .raw_lane_2_dbi            (lane_2_data_dbi           ),
    .raw_lane_3_data           (lane_3_data               ),
    .raw_lane_3_dbi            (lane_3_data_dbi           ),
    .lane_0_data               (mdy_lane_0_data           ),
    .lane_0_dbi                (mdy_lane_0_data_dbi       ),
    .lane_1_data               (mdy_lane_1_data           ),
    .lane_1_dbi                (mdy_lane_1_data_dbi       ),
    .lane_2_data               (mdy_lane_2_data           ),
    .lane_2_dbi                (mdy_lane_2_data_dbi       ),
    .lane_3_data               (mdy_lane_3_data           ),
    .lane_3_dbi                (mdy_lane_3_data_dbi       ),
    .rdlkecc_data_inject_1     (rdlkecc_data_inject_1     ),
    .rdlkecc_data_inject_2     (rdlkecc_data_inject_2     ),
    .csrRdLkeccDataLaneInject1 (csrRdLkeccDataLaneInject1 ),
    .csrRdLkeccDataLaneInject2 (csrRdLkeccDataLaneInject2 ),
    .csrRdLkeccDataLocaInject1 (csrRdLkeccDataLocaInject1 ),
    .csrRdLkeccDataLocaInject2 (csrRdLkeccDataLocaInject2 ),
    .rdlkecc_dbi_inject_1      (rdlkecc_dbi_inject_1      ),
    .rdlkecc_dbi_inject_2      (rdlkecc_dbi_inject_2      ),
    .csrRdLkeccDbiLaneInject1  (csrRdLkeccDbiLaneInject1  ),
    .csrRdLkeccDbiLaneInject2  (csrRdLkeccDbiLaneInject2  ),
    .csrRdLkeccDbiLocaInject1  (csrRdLkeccDbiLocaInject1  ),
    .csrRdLkeccDbiLocaInject2  (csrRdLkeccDbiLocaInject2  )
);

lkecc_syndrome inst_lkecc_syndrome_0(
    .dec_datain      (mdy_lane_0_data             ),
    .dec_data_ecc    (mdy_lane_0_data_dbi[15:7]   ),
    .dec_data_syndrome(lane_0_data_syndrome       )
);
lkecc_syndrome inst_lkecc_syndrome_1(
    .dec_datain      (mdy_lane_1_data             ),
    .dec_data_ecc    (mdy_lane_1_data_dbi[15:7]   ),
    .dec_data_syndrome(lane_1_data_syndrome       )
);
lkecc_syndrome inst_lkecc_syndrome_2(
    .dec_datain      (mdy_lane_2_data             ),
    .dec_data_ecc    (mdy_lane_2_data_dbi[15:7]   ),
    .dec_data_syndrome(lane_2_data_syndrome       )
);
lkecc_syndrome inst_lkecc_syndrome_3(
    .dec_datain      (mdy_lane_3_data             ),
    .dec_data_ecc    (mdy_lane_3_data_dbi[15:7]   ),
    .dec_data_syndrome(lane_3_data_syndrome       )
);

lkecc_error_locator_poly inst_lkecc_error_locator_poly_0(
    .syndrome        (lane_0_data_syndrome        ),
    .corr_error      (lane_0_corr_error           ),
    .uncorr_error    (lane_0_uncorr_error         ),
    .error_locator_poly(lane_0_error_locator_poly )
);
lkecc_error_locator_poly inst_lkecc_error_locator_poly_1(
    .syndrome        (lane_1_data_syndrome        ),
    .corr_error      (lane_1_corr_error           ),
    .uncorr_error    (lane_1_uncorr_error         ),
    .error_locator_poly(lane_1_error_locator_poly )
);
lkecc_error_locator_poly inst_lkecc_error_locator_poly_2(
    .syndrome        (lane_2_data_syndrome        ),
    .corr_error      (lane_2_corr_error           ),
    .uncorr_error    (lane_2_uncorr_error         ),
    .error_locator_poly(lane_2_error_locator_poly )
);
lkecc_error_locator_poly inst_lkecc_error_locator_poly_3(
    .syndrome        (lane_3_data_syndrome        ),
    .corr_error      (lane_3_corr_error           ),
    .uncorr_error    (lane_3_uncorr_error         ),
    .error_locator_poly(lane_3_error_locator_poly )
);

lkecc_correct inst_lkecc_correct_0(
    .dec_datain      ({mdy_lane_0_data_dbi[15:7],mdy_lane_0_data} ),
    .error_locator_poly(lane_0_error_locator_poly                 ),
    .corr_error      (lane_0_corr_error                           ),
    .dec_dataout     ({lane_0_dec_dbi,lane_0_dec_data}            )
);
lkecc_correct inst_lkecc_correct_1(
    .dec_datain      ({mdy_lane_1_data_dbi[15:7],mdy_lane_1_data} ),
    .error_locator_poly(lane_1_error_locator_poly                 ),
    .corr_error      (lane_1_corr_error                           ),
    .dec_dataout     ({lane_1_dec_dbi,lane_1_dec_data}            )
);
lkecc_correct inst_lkecc_correct_2(
    .dec_datain      ({mdy_lane_2_data_dbi[15:7],mdy_lane_2_data} ),
    .error_locator_poly(lane_2_error_locator_poly                 ),
    .corr_error      (lane_2_corr_error                           ),
    .dec_dataout     ({lane_2_dec_dbi,lane_2_dec_data}            )
);
lkecc_correct inst_lkecc_correct_3(
    .dec_datain      ({mdy_lane_3_data_dbi[15:7],mdy_lane_3_data} ),
    .error_locator_poly(lane_3_error_locator_poly                 ),
    .corr_error      (lane_3_corr_error                           ),
    .dec_dataout     ({lane_3_dec_dbi,lane_3_dec_data}            )
);

lane_data_combine inst_lane_data_combine(
    .lane_0_data (lane_0_dec_data ),
    .lane_1_data (lane_1_dec_data ),
    .lane_2_data (lane_2_dec_data ),
    .lane_3_data (lane_3_dec_data ),
    .rdp_data    (mdy_rdp_data    )
);

lane_dbi_combine inst_lane_dbi_combine(
    .lane_0_dbi  ({lane_0_dec_dbi,7'h00} ),
    .lane_1_dbi  ({lane_1_dec_dbi,7'h00} ),
    .lane_2_dbi  ({lane_2_dec_dbi,7'h00} ),
    .lane_3_dbi  ({lane_3_dec_dbi,7'h00} ),
    .dbi         (mdy_rdp_data_dbi       )
);

reg                                  pack_rdp_data_en_d1 ;
reg  [(DFI_CMD_INFO_W)-1:0]          pack_rdp_cmd_info_d1;
reg  [(DFI_CMD_ID_W)-1:0]            pack_rdp_cmd_id_d1  ;

always @ (posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        pack_rdp_data_en_d1  <= 1'b0;
        pack_rdp_cmd_info_d1 <= {(DFI_CMD_INFO_W){1'b0}};
        pack_rdp_cmd_id_d1   <= {(DFI_CMD_ID_W){1'b0}};
    end else begin
        pack_rdp_data_en_d1  <= pack_rdp_data_en;
        pack_rdp_cmd_info_d1 <= pack_rdp_cmd_info;
        pack_rdp_cmd_id_d1   <= pack_rdp_cmd_id;
    end
end

wire                                  lkecc_rdp_sce_flag       ;
wire                                  lkecc_rdp_wr_en          ;
wire [(DFI_CMD_ID_W)-1:0]               lkecc_rdp_cmd_id         ;
wire [`CTL_DFI_RDP_DATA_W-1:0]        lkecc_rdp_data           ;
wire [`CTL_DFI_RDP_DATA_DBI_W-1:0]    lkecc_rdp_data_dbi       ;
wire [DFI_CMD_INFO_W-1:0]             lkecc_rdp_cmd_info       ;

lkecc_rdp_pipe_out #(
    .DFI_CMD_INFO_W  (DFI_CMD_INFO_W  ),
    .DFI_CMD_ID_W    (DFI_CMD_ID_W    )
) inst_lkecc_rdp_pipe_out(
    .pack_rdp_data_en   (pack_rdp_data_en_d1    ),
    .pack_rdp_data      (mdy_rdp_data           ),
    .pack_rdp_data_ecc  (mdy_rdp_data_dbi       ),
    .pack_rdp_cmd_id    (pack_rdp_cmd_id_d1     ),
    .pack_rdp_cmd_info  (pack_rdp_cmd_info_d1   ),
    .rdp_wr_en          (lkecc_rdp_wr_en        ),
    .rdp_cmd_id         (lkecc_rdp_cmd_id       ),
    .rdp_data           (lkecc_rdp_data         ),
    .rdp_data_dbi       (lkecc_rdp_data_dbi     ),
    .rdp_cmd_info       (lkecc_rdp_cmd_info     )
);

wire                                  i_rdp_sce_flag           ;
wire                                  i_rdp_wr_en              ;
wire [(`CTL_CMD_ID_W+`CTL_CQ_CAM_ADDR_W)-1:0] i_rdp_cmd_id       ;
wire [`CTL_DFI_RDP_DATA_W-1:0]        i_rdp_data               ;
wire [`CTL_DFI_RDP_DATA_DBI_W-1:0]    i_rdp_data_dbi           ;
wire [`CTL_RANK_NUM_W-1:0]            i_rdp_rd_cs              ;
wire [`CTL_BA_W-1:0]                  i_rdp_rd_ba              ;
wire [`CTL_ROW_W-1:0]                 i_rdp_rd_row             ;
wire [`CTL_COL_W-1:0]                 i_rdp_rd_col             ;
wire                                  i_rdp_rd_gen_for_rmw     ;
wire                                  i_rdp_rd_gen_for_iecc    ;
wire [`CTL_BI_W-1 :0]                 i_rdp_cmd_bi             ;
wire [`CTL_RBI_W-1 :0]                i_rdp_cmd_rbi            ;
wire                                  i_rdp_cmd_prot           ;
wire                                  i_rd_data_lkecc_c_error  ;
wire                                  i_rd_data_lkecc_uc_error ;

assign rdp_sce_flag             = i_rdp_sce_flag           ;
assign rdp_wr_en                = i_rdp_wr_en              ;
assign rdp_cmd_id               = i_rdp_cmd_id             ;
assign rdp_data                 = i_rdp_data               ;
assign rdp_data_dbi             = i_rdp_data_dbi           ;
assign rdp_rd_cs                = i_rdp_rd_cs              ;
assign rdp_rd_ba                = i_rdp_rd_ba              ;
assign rdp_rd_row               = i_rdp_rd_row             ;
assign rdp_rd_col               = i_rdp_rd_col             ;
assign rdp_rd_gen_for_rmw       = i_rdp_rd_gen_for_rmw     ;
assign rdp_rd_gen_for_iecc      = i_rdp_rd_gen_for_iecc    ;
assign rdp_cmd_bi               = i_rdp_cmd_bi             ;
assign rdp_cmd_rbi              = i_rdp_cmd_rbi            ;
assign rdp_cmd_prot             = i_rdp_cmd_prot           ;
assign rd_data_lkecc_c_error    = i_rd_data_lkecc_c_error  ;
assign rd_data_lkecc_uc_error   = i_rd_data_lkecc_uc_error ;

assign i_rdp_sce_flag           = csrRdLkeccEnable_d1 ? lkecc_rdp_sce_flag       : raw_rdp_sce_flag       ;
assign i_rdp_wr_en              = csrRdLkeccEnable_d1 ? lkecc_rdp_wr_en          : raw_rdp_wr_en          ;
assign i_rdp_cmd_id             = csrRdLkeccEnable_d1 ? lkecc_rdp_cmd_id         : raw_rdp_cmd_id         ;
assign i_rdp_data               = csrRdLkeccEnable_d1 ? lkecc_rdp_data           : raw_rdp_data           ;
assign i_rdp_data_dbi           = csrRdLkeccEnable_d1 ? lkecc_rdp_data_dbi       : raw_rdp_data_ecc       ;

wire [`CTL_RANK_NUM_W-1:0] lkecc_rdp_rd_cs;
wire [`CTL_BA_W-1:0]       lkecc_rdp_rd_ba;
wire [`CTL_ROW_W-1:0]      lkecc_rdp_rd_row;
wire [`CTL_COL_W-1:0]      lkecc_rdp_rd_col;
wire                       lkecc_rdp_rd_gen_for_rmw;
wire                       lkecc_rdp_rd_gen_for_iecc;
wire [`CTL_BI_W-1 :0]      lkecc_rdp_cmd_bi;
wire [`CTL_RBI_W-1 :0]     lkecc_rdp_cmd_rbi;
wire                       lkecc_rdp_cmd_prot;

assign {lkecc_rdp_sce_flag,lkecc_rdp_cmd_bi,lkecc_rdp_cmd_rbi,lkecc_rdp_cmd_prot,lkecc_rdp_rd_gen_for_rmw,lkecc_rdp_rd_gen_for_iecc,lkecc_rdp_rd_cs,lkecc_rdp_rd_ba,lkecc_rdp_rd_row,lkecc_rdp_rd_col} = lkecc_rdp_cmd_info;

assign i_rdp_rd_cs              = csrRdLkeccEnable_d1 ? lkecc_rdp_rd_cs          : raw_rdp_rd_cs          ;
assign i_rdp_rd_ba              = csrRdLkeccEnable_d1 ? lkecc_rdp_rd_ba          : raw_rdp_rd_ba          ;
assign i_rdp_rd_row             = csrRdLkeccEnable_d1 ? lkecc_rdp_rd_row         : raw_rdp_rd_row         ;
assign i_rdp_rd_col             = csrRdLkeccEnable_d1 ? lkecc_rdp_rd_col         : raw_rdp_rd_col         ;
assign i_rdp_rd_gen_for_rmw     = csrRdLkeccEnable_d1 ? lkecc_rdp_rd_gen_for_rmw : raw_rdp_rd_gen_for_rmw ;
assign i_rdp_rd_gen_for_iecc    = csrRdLkeccEnable_d1 ? lkecc_rdp_rd_gen_for_iecc: raw_rdp_rd_gen_for_iecc;
assign i_rdp_cmd_bi             = csrRdLkeccEnable_d1 ? lkecc_rdp_cmd_bi         : raw_rdp_cmd_bi         ;
assign i_rdp_cmd_rbi            = csrRdLkeccEnable_d1 ? lkecc_rdp_cmd_rbi        : raw_rdp_cmd_rbi        ;
assign i_rdp_cmd_prot           = csrRdLkeccEnable_d1 ? lkecc_rdp_cmd_prot       : raw_rdp_cmd_prot       ;

wire rd_lkecc_corr_int_p;
wire rd_lkecc_uncorr_int_p;

assign rd_lkecc_corr_int_p = 
                         lane_0_corr_error |
                         lane_1_corr_error |
                         lane_2_corr_error |
                         lane_3_corr_error ;
                         
assign rd_lkecc_uncorr_int_p = 
                         lane_0_uncorr_error |
                         lane_1_uncorr_error |
                         lane_2_uncorr_error |
                         lane_3_uncorr_error ;

always @ (posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        csrRdLkeccCorrInt <= 1'b0;
    end else if(csrRdLkeccEnable_d1 & csrRdLkeccCorrIntEn & rd_lkecc_corr_int_p) begin
        csrRdLkeccCorrInt <= 1'b1;
    end else if(csrRdLkeccCorrIntClr) begin
        csrRdLkeccCorrInt <= 1'b0;
    end
end

always @ (posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        csrRdLkeccUncorrInt <= 1'b0;
    end else if(csrRdLkeccEnable_d1 & csrRdLkeccUncorrIntEn & rd_lkecc_uncorr_int_p) begin
        csrRdLkeccUncorrInt <= 1'b1;
    end else if(csrRdLkeccUncorrIntClr) begin
        csrRdLkeccUncorrInt <= 1'b0;
    end
end

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        csrRdLkeccCorrCnt <= 32'h00;
    end else if(csrRdLkeccCorrCntClr) begin
        csrRdLkeccCorrCnt <= 32'h00;
    end else if(csrRdLkeccEnable_d1 & csrRdLkeccCorrCntEn & rd_lkecc_corr_int_p & (&csrRdLkeccCorrCnt==1'b0)) begin
        csrRdLkeccCorrCnt <= csrRdLkeccCorrCnt + 1'b1;
    end
end

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        csrRdLkeccUncorrCnt <= 32'h00;
    end else if(csrRdLkeccUncorrCntClr) begin
        csrRdLkeccUncorrCnt <= 32'h00;
    end else if(csrRdLkeccEnable_d1 & csrRdLkeccUncorrCntEn & rd_lkecc_uncorr_int_p & (&csrRdLkeccUncorrCnt==1'b0)) begin
        csrRdLkeccUncorrCnt <= csrRdLkeccUncorrCnt + 1'b1;
    end
end

assign i_rd_data_lkecc_uc_error = csrRdLkeccEnable_d1 & rd_lkecc_uncorr_int_p;
assign i_rd_data_lkecc_c_error  = csrRdLkeccEnable_d1 & rd_lkecc_corr_int_p;

endmodule