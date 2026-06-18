`include "ddr_ctl_define.vh"

module lkecc_rdp_pipe_out#(
    parameter DFI_CMD_INFO_W = `CTL_BA_W+`CTL_ROW_W+`CTL_COL_W+`CTL_BI_W+`CTL_RBI_W+5
    ,parameter DFI_CMD_ID_W = (`CTL_CMD_ID_W+`CTL_CQ_CAM_ADDR_W)
    )
(
    input                               pack_rdp_data_en   ,
    input       [`CTL_DFI_RDP_DATA_W-1:0] pack_rdp_data      ,
    input       [`CTL_DFI_RDP_DATA_DBI_W-1:0] pack_rdp_data_ecc  ,
    input       [(DFI_CMD_ID_W)-1:0]      pack_rdp_cmd_id    ,
    input       [(DFI_CMD_INFO_W)-1:0]    pack_rdp_cmd_info  ,
    output wire                         rdp_wr_en          ,
    output wire [(DFI_CMD_ID_W)-1:0]      rdp_cmd_id         ,
    output wire [`CTL_DFI_RDP_DATA_W-1:0] rdp_data           ,
    output wire [`CTL_DFI_RDP_DATA_DBI_W-1:0] rdp_data_dbi       ,
    output wire [(DFI_CMD_INFO_W)-1:0]    rdp_cmd_info
);
assign rdp_wr_en    = pack_rdp_data_en   ;
assign rdp_cmd_id   = pack_rdp_cmd_id    ;
assign rdp_data     = pack_rdp_data      ;
assign rdp_data_dbi = pack_rdp_data_ecc  ;
assign rdp_cmd_info = pack_rdp_cmd_info  ;

endmodule