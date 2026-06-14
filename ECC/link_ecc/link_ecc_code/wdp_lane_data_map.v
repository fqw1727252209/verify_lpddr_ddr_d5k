`include "ddr_ctl_define.vh"

module wdp_lane_data_map(
    output wire [127:0]                  lane_0_data      ,
    output wire [15:0]                   lane_0_data_mask ,
    output wire [127:0]                  lane_1_data      ,
    output wire [15:0]                   lane_1_data_mask ,
    output wire [127:0]                  lane_2_data      ,
    output wire [15:0]                   lane_2_data_mask ,
    output wire [127:0]                  lane_3_data      ,
    output wire [15:0]                   lane_3_data_mask ,

    input  wire [`CTL_DFI_WDP_DATA_W-1:0]      wdp_data       ,
    input  wire [`CTL_DFI_WDP_DATA_MASK_W-1:0] wdp_data_mask  
);

assign lane_0_data      = {wdp_data[(64*7+8*0+39):(64*7+8*0+32)],wdp_data[(64*7+8*0+7):(64*7+8*0+0)],
                           wdp_data[(64*6+8*0+39):(64*6+8*0+32)],wdp_data[(64*6+8*0+7):(64*6+8*0+0)],
                           wdp_data[(64*5+8*0+39):(64*5+8*0+32)],wdp_data[(64*5+8*0+7):(64*5+8*0+0)],
                           wdp_data[(64*4+8*0+39):(64*4+8*0+32)],wdp_data[(64*4+8*0+7):(64*4+8*0+0)],
                           wdp_data[(64*3+8*0+39):(64*3+8*0+32)],wdp_data[(64*3+8*0+7):(64*3+8*0+0)],
                           wdp_data[(64*2+8*0+39):(64*2+8*0+32)],wdp_data[(64*2+8*0+7):(64*2+8*0+0)],
                           wdp_data[(64*1+8*0+39):(64*1+8*0+32)],wdp_data[(64*1+8*0+7):(64*1+8*0+0)],
                           wdp_data[(64*0+8*0+39):(64*0+8*0+32)],wdp_data[(64*0+8*0+7):(64*0+8*0+0)]
                          };

assign lane_1_data      = {wdp_data[(64*7+8*1+39):(64*7+8*1+32)],wdp_data[(64*7+8*1+7):(64*7+8*1+0)],
                           wdp_data[(64*6+8*1+39):(64*6+8*1+32)],wdp_data[(64*6+8*1+7):(64*6+8*1+0)],
                           wdp_data[(64*5+8*1+39):(64*5+8*1+32)],wdp_data[(64*5+8*1+7):(64*5+8*1+0)],
                           wdp_data[(64*4+8*1+39):(64*4+8*1+32)],wdp_data[(64*4+8*1+7):(64*4+8*1+0)],
                           wdp_data[(64*3+8*1+39):(64*3+8*1+32)],wdp_data[(64*3+8*1+7):(64*3+8*1+0)],
                           wdp_data[(64*2+8*1+39):(64*2+8*1+32)],wdp_data[(64*2+8*1+7):(64*2+8*1+0)],
                           wdp_data[(64*1+8*1+39):(64*1+8*1+32)],wdp_data[(64*1+8*1+7):(64*1+8*1+0)],
                           wdp_data[(64*0+8*1+39):(64*0+8*1+32)],wdp_data[(64*0+8*1+7):(64*0+8*1+0)]
                          };

assign lane_2_data      = {wdp_data[(64*7+8*2+39):(64*7+8*2+32)],wdp_data[(64*7+8*2+7):(64*7+8*2+0)],
                           wdp_data[(64*6+8*2+39):(64*6+8*2+32)],wdp_data[(64*6+8*2+7):(64*6+8*2+0)],
                           wdp_data[(64*5+8*2+39):(64*5+8*2+32)],wdp_data[(64*5+8*2+7):(64*5+8*2+0)],
                           wdp_data[(64*4+8*2+39):(64*4+8*2+32)],wdp_data[(64*4+8*2+7):(64*4+8*2+0)],
                           wdp_data[(64*3+8*2+39):(64*3+8*2+32)],wdp_data[(64*3+8*2+7):(64*3+8*2+0)],
                           wdp_data[(64*2+8*2+39):(64*2+8*2+32)],wdp_data[(64*2+8*2+7):(64*2+8*2+0)],
                           wdp_data[(64*1+8*2+39):(64*1+8*2+32)],wdp_data[(64*1+8*2+7):(64*1+8*2+0)],
                           wdp_data[(64*0+8*2+39):(64*0+8*2+32)],wdp_data[(64*0+8*2+7):(64*0+8*2+0)]
                          };

assign lane_3_data      = {wdp_data[(64*7+8*3+39):(64*7+8*3+32)],wdp_data[(64*7+8*3+7):(64*7+8*3+0)],
                           wdp_data[(64*6+8*3+39):(64*6+8*3+32)],wdp_data[(64*6+8*3+7):(64*6+8*3+0)],
                           wdp_data[(64*5+8*3+39):(64*5+8*3+32)],wdp_data[(64*5+8*3+7):(64*5+8*3+0)],
                           wdp_data[(64*4+8*3+39):(64*4+8*3+32)],wdp_data[(64*4+8*3+7):(64*4+8*3+0)],
                           wdp_data[(64*3+8*3+39):(64*3+8*3+32)],wdp_data[(64*3+8*3+7):(64*3+8*3+0)],
                           wdp_data[(64*2+8*3+39):(64*2+8*3+32)],wdp_data[(64*2+8*3+7):(64*2+8*3+0)],
                           wdp_data[(64*1+8*3+39):(64*1+8*3+32)],wdp_data[(64*1+8*3+7):(64*1+8*3+0)],
                           wdp_data[(64*0+8*3+39):(64*0+8*3+32)],wdp_data[(64*0+8*3+7):(64*0+8*3+0)]
                          };

assign lane_0_data_mask = {wdp_data_mask[(8*7+1*0+4)],wdp_data_mask[(8*7+1*0+0)],
                           wdp_data_mask[(8*6+1*0+4)],wdp_data_mask[(8*6+1*0+0)],
                           wdp_data_mask[(8*5+1*0+4)],wdp_data_mask[(8*5+1*0+0)],
                           wdp_data_mask[(8*4+1*0+4)],wdp_data_mask[(8*4+1*0+0)],
                           wdp_data_mask[(8*3+1*0+4)],wdp_data_mask[(8*3+1*0+0)],
                           wdp_data_mask[(8*2+1*0+4)],wdp_data_mask[(8*2+1*0+0)],
                           wdp_data_mask[(8*1+1*0+4)],wdp_data_mask[(8*1+1*0+0)],
                           wdp_data_mask[(8*0+1*0+4)],wdp_data_mask[(8*0+1*0+0)]
                          };

assign lane_1_data_mask = {wdp_data_mask[(8*7+1*1+4)],wdp_data_mask[(8*7+1*1+0)],
                           wdp_data_mask[(8*6+1*1+4)],wdp_data_mask[(8*6+1*1+0)],
                           wdp_data_mask[(8*5+1*1+4)],wdp_data_mask[(8*5+1*1+0)],
                           wdp_data_mask[(8*4+1*1+4)],wdp_data_mask[(8*4+1*1+0)],
                           wdp_data_mask[(8*3+1*1+4)],wdp_data_mask[(8*3+1*1+0)],
                           wdp_data_mask[(8*2+1*1+4)],wdp_data_mask[(8*2+1*1+0)],
                           wdp_data_mask[(8*1+1*1+4)],wdp_data_mask[(8*1+1*1+0)],
                           wdp_data_mask[(8*0+1*1+4)],wdp_data_mask[(8*0+1*1+0)]
                          };

assign lane_2_data_mask = {wdp_data_mask[(8*7+1*2+4)],wdp_data_mask[(8*7+1*2+0)],
                           wdp_data_mask[(8*6+1*2+4)],wdp_data_mask[(8*6+1*2+0)],
                           wdp_data_mask[(8*5+1*2+4)],wdp_data_mask[(8*5+1*2+0)],
                           wdp_data_mask[(8*4+1*2+4)],wdp_data_mask[(8*4+1*2+0)],
                           wdp_data_mask[(8*3+1*2+4)],wdp_data_mask[(8*3+1*2+0)],
                           wdp_data_mask[(8*2+1*2+4)],wdp_data_mask[(8*2+1*2+0)],
                           wdp_data_mask[(8*1+1*2+4)],wdp_data_mask[(8*1+1*2+0)],
                           wdp_data_mask[(8*0+1*2+4)],wdp_data_mask[(8*0+1*2+0)]
                          };

assign lane_3_data_mask = {wdp_data_mask[(8*7+1*3+4)],wdp_data_mask[(8*7+1*3+0)],
                           wdp_data_mask[(8*6+1*3+4)],wdp_data_mask[(8*6+1*3+0)],
                           wdp_data_mask[(8*5+1*3+4)],wdp_data_mask[(8*5+1*3+0)],
                           wdp_data_mask[(8*4+1*3+4)],wdp_data_mask[(8*4+1*3+0)],
                           wdp_data_mask[(8*3+1*3+4)],wdp_data_mask[(8*3+1*3+0)],
                           wdp_data_mask[(8*2+1*3+4)],wdp_data_mask[(8*2+1*3+0)],
                           wdp_data_mask[(8*1+1*3+4)],wdp_data_mask[(8*1+1*3+0)],
                           wdp_data_mask[(8*0+1*3+4)],wdp_data_mask[(8*0+1*3+0)]
                          };

endmodule