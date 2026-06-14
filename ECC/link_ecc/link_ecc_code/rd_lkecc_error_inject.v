`include "ddr_ctl_define.vh"

module rd_lkecc_error_inject(
    input              core_clk                  ,
    input              core_rstn                 ,
    
    input  wire [127:0]     raw_lane_0_data           ,
    input  wire [15:0]      raw_lane_0_dbi            ,
    input  wire [127:0]     raw_lane_1_data           ,
    input  wire [15:0]      raw_lane_1_dbi            ,
    input  wire [127:0]     raw_lane_2_data           ,
    input  wire [15:0]      raw_lane_2_dbi            ,
    input  wire [127:0]     raw_lane_3_data           ,
    input  wire [15:0]      raw_lane_3_dbi            ,

    output reg  [127:0]     lane_0_data               ,
    output reg  [15:0]      lane_0_dbi                ,
    output reg  [127:0]     lane_1_data               ,
    output reg  [15:0]      lane_1_dbi                ,
    output reg  [127:0]     lane_2_data               ,
    output reg  [15:0]      lane_2_dbi                ,
    output reg  [127:0]     lane_3_data               ,
    output reg  [15:0]      lane_3_dbi                ,

    input  wire             rdlkecc_data_inject_1     ,
    input  wire             rdlkecc_data_inject_2     ,
    input  wire [2:0]       csrRdLkeccDataLaneInject1 ,
    input  wire [2:0]       csrRdLkeccDataLaneInject2 ,
    input  wire [6:0]       csrRdLkeccDataLocaInject1 ,
    input  wire [6:0]       csrRdLkeccDataLocaInject2 ,
    
    input  wire             rdlkecc_dbi_inject_1      ,
    input  wire             rdlkecc_dbi_inject_2      ,
    input  wire [2:0]       csrRdLkeccDbiLaneInject1  ,
    input  wire [2:0]       csrRdLkeccDbiLaneInject2  ,
    input  wire [3:0]       csrRdLkeccDbiLocaInject1  ,
    input  wire [3:0]       csrRdLkeccDbiLocaInject2
);

wire [127:0] inj_lane_0_data ;
wire [15:0]  inj_lane_0_dbi  ;

wire [127:0] inj_lane_1_data ;
wire [15:0]  inj_lane_1_dbi  ;

wire [127:0] inj_lane_2_data ;
wire [15:0]  inj_lane_2_dbi  ;

wire [127:0] inj_lane_3_data ;
wire [15:0]  inj_lane_3_dbi  ;

wire [127:0] rd_lkecc_data_loca_inject_1;
wire [127:0] rd_lkecc_data_loca_inject_2;
wire [15:0]  rd_lkecc_dbi_loca_inject_1;
wire [15:0]  rd_lkecc_dbi_loca_inject_2;

assign rd_lkecc_data_loca_inject_1 = 128'b1<<csrRdLkeccDataLocaInject1;
assign rd_lkecc_data_loca_inject_2 = 128'b1<<csrRdLkeccDataLocaInject2;
assign rd_lkecc_dbi_loca_inject_1  = 16'b1<<csrRdLkeccDbiLocaInject1;
assign rd_lkecc_dbi_loca_inject_2  = 16'b1<<csrRdLkeccDbiLocaInject2;

assign inj_lane_0_data = {128{rdlkecc_data_inject_1 & csrRdLkeccDataLaneInject1==3'h0}} & rd_lkecc_data_loca_inject_1 | 
                         {128{rdlkecc_data_inject_2 & csrRdLkeccDataLaneInject2==3'h0}} & rd_lkecc_data_loca_inject_2 ;

assign inj_lane_1_data = {128{rdlkecc_data_inject_1 & csrRdLkeccDataLaneInject1==3'h1}} & rd_lkecc_data_loca_inject_1 | 
                         {128{rdlkecc_data_inject_2 & csrRdLkeccDataLaneInject2==3'h1}} & rd_lkecc_data_loca_inject_2 ;

assign inj_lane_2_data = {128{rdlkecc_data_inject_1 & csrRdLkeccDataLaneInject1==3'h2}} & rd_lkecc_data_loca_inject_1 | 
                         {128{rdlkecc_data_inject_2 & csrRdLkeccDataLaneInject2==3'h2}} & rd_lkecc_data_loca_inject_2 ;

assign inj_lane_3_data = {128{rdlkecc_data_inject_1 & csrRdLkeccDataLaneInject1==3'h3}} & rd_lkecc_data_loca_inject_1 | 
                         {128{rdlkecc_data_inject_2 & csrRdLkeccDataLaneInject2==3'h3}} & rd_lkecc_data_loca_inject_2 ;

assign inj_lane_0_dbi  = {16{rdlkecc_dbi_inject_1 & csrRdLkeccDbiLaneInject1==3'h0}} & rd_lkecc_dbi_loca_inject_1 | 
                         {16{rdlkecc_dbi_inject_2 & csrRdLkeccDbiLaneInject2==3'h0}} & rd_lkecc_dbi_loca_inject_2 ;

assign inj_lane_1_dbi  = {16{rdlkecc_dbi_inject_1 & csrRdLkeccDbiLaneInject1==3'h1}} & rd_lkecc_dbi_loca_inject_1 | 
                         {16{rdlkecc_dbi_inject_2 & csrRdLkeccDbiLaneInject2==3'h1}} & rd_lkecc_dbi_loca_inject_2 ;

assign inj_lane_2_dbi  = {16{rdlkecc_dbi_inject_1 & csrRdLkeccDbiLaneInject1==3'h2}} & rd_lkecc_dbi_loca_inject_1 | 
                         {16{rdlkecc_dbi_inject_2 & csrRdLkeccDbiLaneInject2==3'h2}} & rd_lkecc_dbi_loca_inject_2 ;

assign inj_lane_3_dbi  = {16{rdlkecc_dbi_inject_1 & csrRdLkeccDbiLaneInject1==3'h3}} & rd_lkecc_dbi_loca_inject_1 | 
                         {16{rdlkecc_dbi_inject_2 & csrRdLkeccDbiLaneInject2==3'h3}} & rd_lkecc_dbi_loca_inject_2 ;

wire [127:0] tmp_lane_0_data;
wire [15:0]  tmp_lane_0_dbi;

wire [127:0] tmp_lane_1_data;
wire [15:0]  tmp_lane_1_dbi;

wire [127:0] tmp_lane_2_data;
wire [15:0]  tmp_lane_2_dbi;

wire [127:0] tmp_lane_3_data;
wire [15:0]  tmp_lane_3_dbi;

assign tmp_lane_0_data = raw_lane_0_data ^ inj_lane_0_data;
assign tmp_lane_0_dbi  = raw_lane_0_dbi  ^ inj_lane_0_dbi ;

assign tmp_lane_1_data = raw_lane_1_data ^ inj_lane_1_data;
assign tmp_lane_1_dbi  = raw_lane_1_dbi  ^ inj_lane_1_dbi ;

assign tmp_lane_2_data = raw_lane_2_data ^ inj_lane_2_data;
assign tmp_lane_2_dbi  = raw_lane_2_dbi  ^ inj_lane_2_dbi ;

assign tmp_lane_3_data = raw_lane_3_data ^ inj_lane_3_data;
assign tmp_lane_3_dbi  = raw_lane_3_dbi  ^ inj_lane_3_dbi ;

always @ (posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        lane_0_data <= 128'h00;
        lane_0_dbi  <= 16'h00;
    end else begin
        lane_0_data <= tmp_lane_0_data;
        lane_0_dbi  <= tmp_lane_0_dbi;
    end
end

always @ (posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        lane_1_data <= 128'h00;
        lane_1_dbi  <= 16'h00;
    end else begin
        lane_1_data <= tmp_lane_1_data;
        lane_1_dbi  <= tmp_lane_1_dbi;
    end
end

always @ (posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        lane_2_data <= 128'h00;
        lane_2_dbi  <= 16'h00;
    end else begin
        lane_2_data <= tmp_lane_2_data;
        lane_2_dbi  <= tmp_lane_2_dbi;
    end
end

always @ (posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        lane_3_data <= 128'h00;
        lane_3_dbi  <= 16'h00;
    end else begin
        lane_3_data <= tmp_lane_3_data;
        lane_3_dbi  <= tmp_lane_3_dbi;
    end
end

endmodule