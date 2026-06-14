`include "ddr_ctl_define.vh"

module lkecc_encoder(
    input                                     core_clk                  ,
    input                                     core_rstn                 ,
    input                                     raw_wdp_rd_en             ,
    input      [`CTL_DFI_WDP_DATA_W-1:0]      raw_wdp_data              ,
    input      [`CTL_DFI_WDP_DATA_MASK_W-1:0] raw_wdp_data_mask         ,

    output wire [`CTL_DFI_WDP_DATA_W-1:0]     wdp_data                  ,
    output wire [`CTL_DFI_WDP_DATA_MASK_W-1:0] wdp_data_mask            ,
    output wire [`CTL_DFI_WDP_DATA_ECC_W-1:0] wdp_data_ecc              ,

    input                                     csrWrLkeccEnable          ,

    input                                     csrWrLkeccDataInject1     ,
    input                                     csrWrLkeccDataInject2     ,
    input                                     csrWrLkeccMaskInject1     ,
    input                                     csrWrLkeccMaskInject2     ,

    output wire                               csrWrLkeccDataInjectClr1  ,
    output wire                               csrWrLkeccDataInjectClr2  ,
    output wire                               csrWrLkeccMaskInjectClr1  ,
    output wire                               csrWrLkeccMaskInjectClr2  ,

    input      [2:0]                          csrWrLkeccDataLaneInject1 ,
    input      [2:0]                          csrWrLkeccDataLaneInject2 ,
    input      [2:0]                          csrWrLkeccMaskLaneInject1 ,
    input      [2:0]                          csrWrLkeccMaskLaneInject2 ,

    input      [6:0]                          csrWrLkeccDataLocaInject1 ,
    input      [6:0]                          csrWrLkeccDataLocaInject2 ,
    input      [3:0]                          csrWrLkeccMaskLocaInject1 ,
    input      [3:0]                          csrWrLkeccMaskLocaInject2
);

wire [127:0] lane_0_data          ;
wire [15:0]  lane_0_data_mask     ;
wire [8:0]   lane_0_data_ecc      ;
wire [5:0]   lane_0_data_mask_ecc ;
wire [15:0]  lane_0_ecc           ;
wire [127:0] mdy_lane_0_data      ;
wire [15:0]  mdy_lane_0_data_mask ;
wire [15:0]  mdy_lane_0_ecc       ;

wire [127:0] lane_1_data          ;
wire [15:0]  lane_1_data_mask     ;
wire [8:0]   lane_1_data_ecc      ;
wire [5:0]   lane_1_data_mask_ecc ;
wire [15:0]  lane_1_ecc           ;
wire [127:0] mdy_lane_1_data      ;
wire [15:0]  mdy_lane_1_data_mask ;
wire [15:0]  mdy_lane_1_ecc       ;

wire [127:0] lane_2_data          ;
wire [15:0]  lane_2_data_mask     ;
wire [8:0]   lane_2_data_ecc      ;
wire [5:0]   lane_2_data_mask_ecc ;
wire [15:0]  lane_2_ecc           ;
wire [127:0] mdy_lane_2_data      ;
wire [15:0]  mdy_lane_2_data_mask ;
wire [15:0]  mdy_lane_2_ecc       ;

wire [127:0] lane_3_data          ;
wire [15:0]  lane_3_data_mask     ;
wire [8:0]   lane_3_data_ecc      ;
wire [5:0]   lane_3_data_mask_ecc ;
wire [15:0]  lane_3_ecc           ;
wire [127:0] mdy_lane_3_data      ;
wire [15:0]  mdy_lane_3_data_mask ;
wire [15:0]  mdy_lane_3_ecc       ;

wire                                    pack_wdp_data_en   ;
wire [`CTL_DFI_WDP_DATA_W-1:0]          pack_wdp_data      ;
wire [`CTL_DFI_WDP_DATA_MASK_W-1:0]     pack_wdp_data_mask ;

wire [`CTL_DFI_WDP_DATA_W-1:0]          mdy_wdp_data       ;
wire [`CTL_DFI_WDP_DATA_MASK_W-1:0]     mdy_wdp_data_mask  ;
wire [`CTL_DFI_WDP_DATA_ECC_W-1:0]      mdy_wdp_data_ecc   ;

lkecc_wdp_pipe_in inst_lkecc_wdp_pipe_in(
    .raw_wdp_rd_en      (raw_wdp_rd_en      ),
    .raw_wdp_data       (raw_wdp_data       ),
    .raw_wdp_data_mask  (raw_wdp_data_mask  ),
    .pack_wdp_data_en   (pack_wdp_data_en   ),
    .pack_wdp_data      (pack_wdp_data      ),
    .pack_wdp_data_mask (pack_wdp_data_mask )
);

wdp_lane_data_map inst_wdp_lane_data_map(
    .lane_0_data        (lane_0_data        ),
    .lane_0_data_mask   (lane_0_data_mask   ),
    .lane_1_data        (lane_1_data        ),
    .lane_1_data_mask   (lane_1_data_mask   ),
    .lane_2_data        (lane_2_data        ),
    .lane_2_data_mask   (lane_2_data_mask   ),
    .lane_3_data        (lane_3_data        ),
    .lane_3_data_mask   (lane_3_data_mask   ),
    .wdp_data           (pack_wdp_data      ),
    .wdp_data_mask      (pack_wdp_data_mask )
);

data_lkecc_code_gen inst_data_lkecc_code_gen_0(
    .enc_datain  (lane_0_data      ),
    .enc_dataout (lane_0_data_ecc  )
);
data_lkecc_code_gen inst_data_lkecc_code_gen_1(
    .enc_datain  (lane_1_data      ),
    .enc_dataout (lane_1_data_ecc  )
);
data_lkecc_code_gen inst_data_lkecc_code_gen_2(
    .enc_datain  (lane_2_data      ),
    .enc_dataout (lane_2_data_ecc  )
);
data_lkecc_code_gen inst_data_lkecc_code_gen_3(
    .enc_datain  (lane_3_data      ),
    .enc_dataout (lane_3_data_ecc  )
);

dmi_lkecc_code_gen inst_dmi_lkecc_code_gen_0(
    .enc_datain  (lane_0_data_mask      ),
    .enc_dataout (lane_0_data_mask_ecc  )
);
dmi_lkecc_code_gen inst_dmi_lkecc_code_gen_1(
    .enc_datain  (lane_1_data_mask      ),
    .enc_dataout (lane_1_data_mask_ecc  )
);
dmi_lkecc_code_gen inst_dmi_lkecc_code_gen_2(
    .enc_datain  (lane_2_data_mask      ),
    .enc_dataout (lane_2_data_mask_ecc  )
);
dmi_lkecc_code_gen inst_dmi_lkecc_code_gen_3(
    .enc_datain  (lane_3_data_mask      ),
    .enc_dataout (lane_3_data_mask_ecc  )
);

assign lane_0_ecc = {lane_0_data_ecc, lane_0_data_mask_ecc, 1'b0};
assign lane_1_ecc = {lane_1_data_ecc, lane_1_data_mask_ecc, 1'b0};
assign lane_2_ecc = {lane_2_data_ecc, lane_2_data_mask_ecc, 1'b0};
assign lane_3_ecc = {lane_3_data_ecc, lane_3_data_mask_ecc, 1'b0};


wire wrlkecc_data_inject_1;
wire wrlkecc_mask_inject_1;
wire wrlkecc_data_inject_2;
wire wrlkecc_mask_inject_2;

reg pack_wdp_data_en_d1;
reg pack_wdp_data_en_d2;

always@(posedge core_clk, negedge core_rstn) begin
    if(~core_rstn) begin
        pack_wdp_data_en_d1 <= 1'b0;
        pack_wdp_data_en_d2 <= 1'b0;
    end else begin
        pack_wdp_data_en_d1 <= pack_wdp_data_en;
        pack_wdp_data_en_d2 <= pack_wdp_data_en_d1;
    end
end

/*
assign wrlkecc_data_inject_1     = csrWrLkeccDataInject1 & pack_wdp_data_en;
assign wrlkecc_mask_inject_1     = csrWrLkeccMaskInject1 & pack_wdp_data_en;
assign wrlkecc_data_inject_2     = csrWrLkeccDataInject2 & pack_wdp_data_en;
assign wrlkecc_mask_inject_2     = csrWrLkeccMaskInject2 & pack_wdp_data_en;

assign csrWrLkeccDataInjectClr1  = csrWrLkeccDataInject1 & pack_wdp_data_en;
assign csrWrLkeccMaskInjectClr1  = csrWrLkeccMaskInject1 & pack_wdp_data_en;
assign csrWrLkeccDataInjectClr2  = csrWrLkeccDataInject2 & pack_wdp_data_en;
assign csrWrLkeccMaskInjectClr2  = csrWrLkeccMaskInject2 & pack_wdp_data_en;
*/

assign wrlkecc_data_inject_1     = csrWrLkeccDataInject1 & pack_wdp_data_en_d2;
assign wrlkecc_mask_inject_1     = csrWrLkeccMaskInject1 & pack_wdp_data_en_d2;
assign wrlkecc_data_inject_2     = csrWrLkeccDataInject2 & pack_wdp_data_en_d2;
assign wrlkecc_mask_inject_2     = csrWrLkeccMaskInject2 & pack_wdp_data_en_d2;

assign csrWrLkeccDataInjectClr1  = csrWrLkeccDataInject1 & pack_wdp_data_en_d2;
assign csrWrLkeccMaskInjectClr1  = csrWrLkeccMaskInject1 & pack_wdp_data_en_d2;
assign csrWrLkeccDataInjectClr2  = csrWrLkeccDataInject2 & pack_wdp_data_en_d2;
assign csrWrLkeccMaskInjectClr2  = csrWrLkeccMaskInject2 & pack_wdp_data_en_d2;


wr_lkecc_error_inject inst_wr_lkecc_error_inject(
    .raw_lane_0_data          (lane_0_data              ),
    .raw_lane_0_data_mask     (lane_0_data_mask         ),
    .raw_lane_0_ecc           (lane_0_ecc               ),
    .raw_lane_1_data          (lane_1_data              ),
    .raw_lane_1_data_mask     (lane_1_data_mask         ),
    .raw_lane_1_ecc           (lane_1_ecc               ),
    .raw_lane_2_data          (lane_2_data              ),
    .raw_lane_2_data_mask     (lane_2_data_mask         ),
    .raw_lane_2_ecc           (lane_2_ecc               ),
    .raw_lane_3_data          (lane_3_data              ),
    .raw_lane_3_data_mask     (lane_3_data_mask         ),
    .raw_lane_3_ecc           (lane_3_ecc               ),
    .lane_0_data              (mdy_lane_0_data          ),
    .lane_0_data_mask         (mdy_lane_0_data_mask     ),
    .lane_0_ecc               (mdy_lane_0_ecc           ),
    .lane_1_data              (mdy_lane_1_data          ),
    .lane_1_data_mask         (mdy_lane_1_data_mask     ),
    .lane_1_ecc               (mdy_lane_1_ecc           ),
    .lane_2_data              (mdy_lane_2_data          ),
    .lane_2_data_mask         (mdy_lane_2_data_mask     ),
    .lane_2_ecc               (mdy_lane_2_ecc           ),
    .lane_3_data              (mdy_lane_3_data          ),
    .lane_3_data_mask         (mdy_lane_3_data_mask     ),
    .lane_3_ecc               (mdy_lane_3_ecc           ),
    .wrlkecc_data_inject_1    (wrlkecc_data_inject_1    ),
    .wrlkecc_mask_inject_1    (wrlkecc_mask_inject_1    ),
    .wrlkecc_data_inject_2    (wrlkecc_data_inject_2    ),
    .wrlkecc_mask_inject_2    (wrlkecc_mask_inject_2    ),
    .csrWrLkeccDataLaneInject1(csrWrLkeccDataLaneInject1),
    .csrWrLkeccMaskLaneInject1(csrWrLkeccMaskLaneInject1),
    .csrWrLkeccDataLaneInject2(csrWrLkeccDataLaneInject2),
    .csrWrLkeccMaskLaneInject2(csrWrLkeccMaskLaneInject2),
    .csrWrLkeccDataLocaInject1(csrWrLkeccDataLocaInject1),
    .csrWrLkeccMaskLocaInject1(csrWrLkeccMaskLocaInject1),
    .csrWrLkeccDataLocaInject2(csrWrLkeccDataLocaInject2),
    .csrWrLkeccMaskLocaInject2(csrWrLkeccMaskLocaInject2)
);

lane_ecc_combine inst_lane_ecc_combine(
    .lane_0_ecc  (mdy_lane_0_ecc),
    .lane_1_ecc  (mdy_lane_1_ecc),
    .lane_2_ecc  (mdy_lane_2_ecc),
    .lane_3_ecc  (mdy_lane_3_ecc),
    .wdp_data_ecc(mdy_wdp_data_ecc)
);

lane_data_combine inst_lane_data_combine(
    .lane_0_data (mdy_lane_0_data),
    .lane_1_data (mdy_lane_1_data),
    .lane_2_data (mdy_lane_2_data),
    .lane_3_data (mdy_lane_3_data),
    .rdp_data    (mdy_wdp_data)
);

lane_mask_combine inst_lane_mask_combine(
    .lane_0_mask (mdy_lane_0_data_mask),
    .lane_1_mask (mdy_lane_1_data_mask),
    .lane_2_mask (mdy_lane_2_data_mask),
    .lane_3_mask (mdy_lane_3_data_mask),
    .wdp_data_mask (mdy_wdp_data_mask)
);


wire [`CTL_DFI_WDP_DATA_W-1:0]        lkecc_wdp_data      ;
wire [`CTL_DFI_WDP_DATA_MASK_W-1:0]   lkecc_wdp_data_mask ;
wire [`CTL_DFI_WDP_DATA_ECC_W-1:0]    lkecc_wdp_data_ecc  ;

lkecc_wdp_pipe_out inst_lkecc_wdp_pipe_out(
    .core_clk           (core_clk           ),
    .core_rstn          (core_rstn          ),
    .pack_wdp_data      (mdy_wdp_data       ),
    .pack_wdp_data_mask (mdy_wdp_data_mask  ),
    .pack_wdp_data_ecc  (mdy_wdp_data_ecc   ),
    .wdp_data           (lkecc_wdp_data     ),
    .wdp_data_mask      (lkecc_wdp_data_mask),
    .wdp_data_ecc       (lkecc_wdp_data_ecc )
);

assign wdp_data      = csrWrLkeccEnable ? lkecc_wdp_data      : raw_wdp_data      ;
assign wdp_data_mask = csrWrLkeccEnable ? lkecc_wdp_data_mask : raw_wdp_data_mask ;
assign wdp_data_ecc  = csrWrLkeccEnable ? lkecc_wdp_data_ecc  : {`CTL_DFI_WDP_DATA_ECC_W{1'b0}};

endmodule