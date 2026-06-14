`include "ddr_ctl_define.vh"

module wr_lkecc_error_inject(

    input  wire [127:0] raw_lane_0_data      ,
    input  wire [15:0]  raw_lane_0_data_mask ,
    input  wire [15:0]  raw_lane_0_ecc       ,
    input  wire [127:0] raw_lane_1_data      ,
    input  wire [15:0]  raw_lane_1_data_mask ,
    input  wire [15:0]  raw_lane_1_ecc       ,
    input  wire [127:0] raw_lane_2_data      ,
    input  wire [15:0]  raw_lane_2_data_mask ,
    input  wire [15:0]  raw_lane_2_ecc       ,
    input  wire [127:0] raw_lane_3_data      ,
    input  wire [15:0]  raw_lane_3_data_mask ,
    input  wire [15:0]  raw_lane_3_ecc       ,

    output wire [127:0] lane_0_data          ,
    output wire [15:0]  lane_0_data_mask     ,
    output wire [15:0]  lane_0_ecc           ,
    output wire [127:0] lane_1_data          ,
    output wire [15:0]  lane_1_data_mask     ,
    output wire [15:0]  lane_1_ecc           ,
    output wire [127:0] lane_2_data          ,
    output wire [15:0]  lane_2_data_mask     ,
    output wire [15:0]  lane_2_ecc           ,
    output wire [127:0] lane_3_data          ,
    output wire [15:0]  lane_3_data_mask     ,
    output wire [15:0]  lane_3_ecc           ,

    input  wire         wrlkecc_data_inject_1,
    input  wire         wrlkecc_mask_inject_1,
    input  wire         wrlkecc_data_inject_2,
    input  wire         wrlkecc_mask_inject_2,

    input  wire [2:0]   csrWrLkeccDataLaneInject1,
    input  wire [2:0]   csrWrLkeccMaskLaneInject1,
    input  wire [2:0]   csrWrLkeccDataLaneInject2,
    input  wire [2:0]   csrWrLkeccMaskLaneInject2,

    input  wire [6:0]   csrWrLkeccDataLocaInject1,
    input  wire [3:0]   csrWrLkeccMaskLocaInject1,
    input  wire [6:0]   csrWrLkeccDataLocaInject2,
    input  wire [3:0]   csrWrLkeccMaskLocaInject2
);

wire [127:0] inj_lane_0_data      ;
wire [15:0]  inj_lane_0_data_mask ;
wire [15:0]  inj_lane_0_ecc       ;

wire [127:0] inj_lane_1_data      ;
wire [15:0]  inj_lane_1_data_mask ;
wire [15:0]  inj_lane_1_ecc       ;

wire [127:0] inj_lane_2_data      ;
wire [15:0]  inj_lane_2_data_mask ;
wire [15:0]  inj_lane_2_ecc       ;

wire [127:0] inj_lane_3_data      ;
wire [15:0]  inj_lane_3_data_mask ;
wire [15:0]  inj_lane_3_ecc       ;

wire [127:0] wr_lkecc_data_loca_inject_1;
wire [127:0] wr_lkecc_data_loca_inject_2;
wire [15:0]  wr_lkecc_mask_loca_inject_1;
wire [15:0]  wr_lkecc_mask_loca_inject_2;

assign wr_lkecc_data_loca_inject_1 = 128'b1<<csrWrLkeccDataLocaInject1;
assign wr_lkecc_data_loca_inject_2 = 128'b1<<csrWrLkeccDataLocaInject2;
assign wr_lkecc_mask_loca_inject_1 = 16'b1<<csrWrLkeccMaskLocaInject1;
assign wr_lkecc_mask_loca_inject_2 = 16'b1<<csrWrLkeccMaskLocaInject2;

assign inj_lane_0_data = {128{wrlkecc_data_inject_1 & csrWrLkeccDataLaneInject1==3'h0}} & wr_lkecc_data_loca_inject_1 | 
                         {128{wrlkecc_data_inject_2 & csrWrLkeccDataLaneInject2==3'h0}} & wr_lkecc_data_loca_inject_2 ;

assign inj_lane_1_data = {128{wrlkecc_data_inject_1 & csrWrLkeccDataLaneInject1==3'h1}} & wr_lkecc_data_loca_inject_1 | 
                         {128{wrlkecc_data_inject_2 & csrWrLkeccDataLaneInject2==3'h1}} & wr_lkecc_data_loca_inject_2 ;

assign inj_lane_2_data = {128{wrlkecc_data_inject_1 & csrWrLkeccDataLaneInject1==3'h2}} & wr_lkecc_data_loca_inject_1 | 
                         {128{wrlkecc_data_inject_2 & csrWrLkeccDataLaneInject2==3'h2}} & wr_lkecc_data_loca_inject_2 ;

assign inj_lane_3_data = {128{wrlkecc_data_inject_1 & csrWrLkeccDataLaneInject1==3'h3}} & wr_lkecc_data_loca_inject_1 | 
                         {128{wrlkecc_data_inject_2 & csrWrLkeccDataLaneInject2==3'h3}} & wr_lkecc_data_loca_inject_2 ;

assign inj_lane_0_data_mask = {16{wrlkecc_mask_inject_1 & csrWrLkeccMaskLaneInject1==3'h0}} & wr_lkecc_mask_loca_inject_1 | 
                              {16{wrlkecc_mask_inject_2 & csrWrLkeccMaskLaneInject2==3'h0}} & wr_lkecc_mask_loca_inject_2 ;

assign inj_lane_1_data_mask = {16{wrlkecc_mask_inject_1 & csrWrLkeccMaskLaneInject1==3'h1}} & wr_lkecc_mask_loca_inject_1 | 
                              {16{wrlkecc_mask_inject_2 & csrWrLkeccMaskLaneInject2==3'h1}} & wr_lkecc_mask_loca_inject_2 ;

assign inj_lane_2_data_mask = {16{wrlkecc_mask_inject_1 & csrWrLkeccMaskLaneInject1==3'h2}} & wr_lkecc_mask_loca_inject_1 | 
                              {16{wrlkecc_mask_inject_2 & csrWrLkeccMaskLaneInject2==3'h2}} & wr_lkecc_mask_loca_inject_2 ;

assign inj_lane_3_data_mask = {16{wrlkecc_mask_inject_1 & csrWrLkeccMaskLaneInject1==3'h3}} & wr_lkecc_mask_loca_inject_1 | 
                              {16{wrlkecc_mask_inject_2 & csrWrLkeccMaskLaneInject2==3'h3}} & wr_lkecc_mask_loca_inject_2 ;


assign lane_0_data      = raw_lane_0_data      ^ inj_lane_0_data      ;
assign lane_0_data_mask = raw_lane_0_data_mask ^ inj_lane_0_data_mask ;
assign lane_0_ecc       = raw_lane_0_ecc       ;

assign lane_1_data      = raw_lane_1_data      ^ inj_lane_1_data      ;
assign lane_1_data_mask = raw_lane_1_data_mask ^ inj_lane_1_data_mask ;
assign lane_1_ecc       = raw_lane_1_ecc       ;

assign lane_2_data      = raw_lane_2_data      ^ inj_lane_2_data      ;
assign lane_2_data_mask = raw_lane_2_data_mask ^ inj_lane_2_data_mask ;
assign lane_2_ecc       = raw_lane_2_ecc       ;

assign lane_3_data      = raw_lane_3_data      ^ inj_lane_3_data      ;
assign lane_3_data_mask = raw_lane_3_data_mask ^ inj_lane_3_data_mask ;
assign lane_3_ecc       = raw_lane_3_ecc       ;

endmodule