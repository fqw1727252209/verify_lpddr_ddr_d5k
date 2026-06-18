`include "ddr_ctl_define.vh"

module lkecc_wdp_pipe_in(
    input                               raw_wdp_rd_en      ,
    input       [`CTL_DFI_WDP_DATA_W-1:0] raw_wdp_data       ,
    input       [`CTL_DFI_WDP_DATA_MASK_W-1:0] raw_wdp_data_mask  ,
    output wire                         pack_wdp_data_en   ,
    output wire [`CTL_DFI_WDP_DATA_W-1:0] pack_wdp_data      ,
    output wire [`CTL_DFI_WDP_DATA_MASK_W-1:0] pack_wdp_data_mask
);
assign pack_wdp_data_en   = raw_wdp_rd_en      ;
assign pack_wdp_data      = raw_wdp_data       ;
assign pack_wdp_data_mask = raw_wdp_data_mask  ;

endmodule