`include "ddr_ctl_define.vh"

module lkecc_wdp_pipe_out(
    input                               core_clk           ,
    input                               core_rstn          ,
    input       [`CTL_DFI_WDP_DATA_W-1:0] pack_wdp_data      ,
    input       [`CTL_DFI_WDP_DATA_MASK_W-1:0] pack_wdp_data_mask ,
    input       [`CTL_DFI_WDP_DATA_ECC_W-1:0] pack_wdp_data_ecc  ,
    output reg  [`CTL_DFI_WDP_DATA_W-1:0] wdp_data           ,
    output reg  [`CTL_DFI_WDP_DATA_MASK_W-1:0] wdp_data_mask      ,
    output reg  [`CTL_DFI_WDP_DATA_ECC_W-1:0] wdp_data_ecc
);

always @(posedge core_clk or negedge core_rstn) begin
    if(~core_rstn) begin
        wdp_data      <= {`CTL_DFI_WDP_DATA_W{1'b0}};
        wdp_data_mask <= {`CTL_DFI_WDP_DATA_MASK_W{1'b0}};
        wdp_data_ecc  <= {`CTL_DFI_WDP_DATA_ECC_W{1'b0}};
    end else begin
        wdp_data      <= pack_wdp_data      ;
        wdp_data_mask <= pack_wdp_data_mask ;
        wdp_data_ecc  <= pack_wdp_data_ecc  ;
    end
end

endmodule