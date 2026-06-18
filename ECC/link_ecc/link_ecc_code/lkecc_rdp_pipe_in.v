`include "ddr_ctl_define.vh"

module lkecc_rdp_pipe_in #(
    parameter DFI_CMD_INFO_W = `CTL_BA_W+`CTL_ROW_W+`CTL_COL_W+`CTL_BI_W+`CTL_RBI_W+5
    ,parameter DFI_CMD_ID_W = (`CTL_CMD_ID_W+`CTL_CQ_CAM_ADDR_W)
    )
(
    input                               raw_rdp_wr_en      ,
    input       [(DFI_CMD_ID_W)-1:0]      raw_rdp_cmd_id     ,
    input       [`CTL_DFI_RDP_DATA_W-1:0] raw_rdp_data       ,
    input       [`CTL_DFI_RDP_DATA_DBI_W-1:0] raw_rdp_data_ecc   ,
    input       [DFI_CMD_INFO_W-1:0]    raw_rdp_cmd_info   ,

    output wire [(DFI_CMD_ID_W)-1:0]      pack_rdp_cmd_id    ,
    output wire                         pack_rdp_data_en   ,
    output wire [`CTL_DFI_RDP_DATA_W-1:0] pack_rdp_data      ,
    output wire [`CTL_DFI_RDP_DATA_DBI_W-1:0] pack_rdp_data_ecc  ,
    output wire [(DFI_CMD_INFO_W)-1:0]    pack_rdp_cmd_info
);
assign pack_rdp_data_en   = raw_rdp_wr_en      ;
assign pack_rdp_cmd_id    = raw_rdp_cmd_id     ;
assign pack_rdp_data      = raw_rdp_data       ;
assign pack_rdp_data_ecc  = raw_rdp_data_ecc   ;
assign pack_rdp_cmd_info  = raw_rdp_cmd_info   ;

endmodule