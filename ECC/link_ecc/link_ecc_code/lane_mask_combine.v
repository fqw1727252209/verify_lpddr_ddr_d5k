`include "ddr_ctl_define.vh"

module lane_mask_combine(
    input wire  [15:0]                         lane_0_mask ,
    input wire  [15:0]                         lane_1_mask ,
    input wire  [15:0]                         lane_2_mask ,
    input wire  [15:0]                         lane_3_mask ,

    output wire [`CTL_DFI_WDP_DATA_ECC_W-1:0] wdp_data_mask
);

assign wdp_data_mask = {
    lane_3_mask[(7*2 + 1)],
    lane_2_mask[(7*2 + 1)],
    lane_1_mask[(7*2 + 1)],
    lane_0_mask[(7*2 + 1)],
    lane_3_mask[(7*2 + 0)],
    lane_2_mask[(7*2 + 0)],
    lane_1_mask[(7*2 + 0)],
    lane_0_mask[(7*2 + 0)],
    
    lane_3_mask[(6*2 + 1)],
    lane_2_mask[(6*2 + 1)],
    lane_1_mask[(6*2 + 1)],
    lane_0_mask[(6*2 + 1)],
    lane_3_mask[(6*2 + 0)],
    lane_2_mask[(6*2 + 0)],
    lane_1_mask[(6*2 + 0)],
    lane_0_mask[(6*2 + 0)],
    
    lane_3_mask[(5*2 + 1)],
    lane_2_mask[(5*2 + 1)],
    lane_1_mask[(5*2 + 1)],
    lane_0_mask[(5*2 + 1)],
    lane_3_mask[(5*2 + 0)],
    lane_2_mask[(5*2 + 0)],
    lane_1_mask[(5*2 + 0)],
    lane_0_mask[(5*2 + 0)],
    
    lane_3_mask[(4*2 + 1)],
    lane_2_mask[(4*2 + 1)],
    lane_1_mask[(4*2 + 1)],
    lane_0_mask[(4*2 + 1)],
    lane_3_mask[(4*2 + 0)],
    lane_2_mask[(4*2 + 0)],
    lane_1_mask[(4*2 + 0)],
    lane_0_mask[(4*2 + 0)],
    
    lane_3_mask[(3*2 + 1)],
    lane_2_mask[(3*2 + 1)],
    lane_1_mask[(3*2 + 1)],
    lane_0_mask[(3*2 + 1)],
    lane_3_mask[(3*2 + 0)],
    lane_2_mask[(3*2 + 0)],
    lane_1_mask[(3*2 + 0)],
    lane_0_mask[(3*2 + 0)],
    
    lane_3_mask[(2*2 + 1)],
    lane_2_mask[(2*2 + 1)],
    lane_1_mask[(2*2 + 1)],
    lane_0_mask[(2*2 + 1)],
    lane_3_mask[(2*2 + 0)],
    lane_2_mask[(2*2 + 0)],
    lane_1_mask[(2*2 + 0)],
    lane_0_mask[(2*2 + 0)],
    
    lane_3_mask[(1*2 + 1)],
    lane_2_mask[(1*2 + 1)],
    lane_1_mask[(1*2 + 1)],
    lane_0_mask[(1*2 + 1)],
    lane_3_mask[(1*2 + 0)],
    lane_2_mask[(1*2 + 0)],
    lane_1_mask[(1*2 + 0)],
    lane_0_mask[(1*2 + 0)],
    
    lane_3_mask[(0*2 + 1)],
    lane_2_mask[(0*2 + 1)],
    lane_1_mask[(0*2 + 1)],
    lane_0_mask[(0*2 + 1)],
    lane_3_mask[(0*2 + 0)],
    lane_2_mask[(0*2 + 0)],
    lane_1_mask[(0*2 + 0)],
    lane_0_mask[(0*2 + 0)]
};

endmodule