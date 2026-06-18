`include "ddr_ctl_define.vh"

/*
 * /

module scbr_addr_rev_map (
    input      [`CTL_LRANK_NUM_W-1:0]    rdp_scbr_ecc_c_cid          ,
    input      [`CTL_RANK_NUM_W-1:0]     rdp_scbr_ecc_c_cs           ,
    input      [`CTL_CMD_ADDR_W-1:0]     csrUifAddrMask              ,
    input      [`CTL_ROW_W-1:0]          rdp_scbr_ecc_c_row          ,
    input      [`CTL_BA_W-1:0]           rdp_scbr_ecc_c_ba           ,
    input      [`CTL_COL_W-1:0]          rdp_scbr_ecc_c_col          ,

    input      [`CTL_ADDR_POS_W-1:0]     csr_row_0_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_1_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_2_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_3_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_4_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_5_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_6_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_7_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_8_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_9_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_10_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_11_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_12_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_13_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_14_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_15_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_16_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_17_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_row_18_pos              ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_col_0_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_col_1_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_col_2_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_col_3_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_col_4_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_col_5_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_col_6_pos               ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_ba_0_pos                ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_ba_1_pos                ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_ba_2_pos                ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_ba_3_pos                ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_ba_4_pos                ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_cs_0_pos                ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_cs_1_pos                ,
    input      [`CTL_ADDR_POS_W-1:0]     csr_cid_0_pos               ,

    output     [`CTL_CMD_ADDR_W-1:0]     uif_cmd_addr                
);

wire     [`CTL_CMD_ADDR_W-1:0]     cmd_addr;

assign uif_cmd_addr = cmd_addr & csrUifAddrMask;

assign  cmd_addr[0] = 
        (csr_row_0_pos == 6'd0) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd0) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd0) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd0) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd0) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd0) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd0) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd0) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd0) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd0) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd0) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd0) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd0) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd0) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd0) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd0) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd0) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd0) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd0) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd0) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd0) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd0) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd0) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd0) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd0) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd0) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd0) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd0) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd0) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd0) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd0) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd0) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd0) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd0) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[1] = 
        (csr_row_0_pos == 6'd1) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd1) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd1) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd1) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd1) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd1) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd1) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd1) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd1) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd1) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd1) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd1) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd1) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd1) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd1) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd1) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd1) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd1) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd1) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd1) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd1) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd1) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd1) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd1) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd1) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd1) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd1) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd1) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd1) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd1) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd1) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd1) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd1) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd1) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[2] = 
        (csr_row_0_pos == 6'd2) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd2) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd2) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd2) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd2) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd2) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd2) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd2) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd2) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd2) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd2) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd2) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd2) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd2) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd2) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd2) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd2) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd2) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd2) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd2) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd2) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd2) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd2) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd2) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd2) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd2) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd2) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd2) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd2) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd2) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd2) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd2) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd2) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd2) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[3] = 
        (csr_row_0_pos == 6'd3) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd3) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd3) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd3) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd3) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd3) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd3) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd3) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd3) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd3) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd3) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd3) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd3) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd3) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd3) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd3) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd3) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd3) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd3) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd3) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd3) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd3) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd3) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd3) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd3) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd3) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd3) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd3) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd3) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd3) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd3) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd3) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd3) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd3) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[4] = 
        (csr_row_0_pos == 6'd4) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd4) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd4) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd4) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd4) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd4) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd4) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd4) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd4) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd4) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd4) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd4) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd4) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd4) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd4) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd4) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd4) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd4) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd4) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd4) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd4) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd4) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd4) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd4) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd4) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd4) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd4) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd4) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd4) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd4) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd4) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd4) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd4) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd4) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[5] = 
        (csr_row_0_pos == 6'd5) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd5) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd5) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd5) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd5) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd5) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd5) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd5) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd5) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd5) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd5) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd5) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd5) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd5) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd5) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd5) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd5) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd5) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd5) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd5) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd5) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd5) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd5) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd5) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd5) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd5) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd5) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd5) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd5) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd5) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd5) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd5) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd5) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd5) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[6] = 
        (csr_row_0_pos == 6'd6) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd6) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd6) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd6) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd6) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd6) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd6) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd6) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd6) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd6) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd6) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd6) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd6) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd6) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd6) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd6) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd6) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd6) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd6) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd6) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd6) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd6) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd6) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd6) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd6) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd6) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd6) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd6) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd6) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd6) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd6) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd6) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd6) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd6) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[7] = 
        (csr_row_0_pos == 6'd7) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd7) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd7) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd7) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd7) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd7) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd7) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd7) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd7) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd7) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd7) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd7) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd7) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd7) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd7) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd7) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd7) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd7) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd7) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd7) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd7) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd7) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd7) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd7) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd7) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd7) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd7) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd7) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd7) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd7) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd7) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd7) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd7) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd7) & rdp_scbr_ecc_c_cs[1] ;
assign  cmd_addr[8] = 
        (csr_row_0_pos == 6'd8) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd8) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd8) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd8) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd8) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd8) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd8) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd8) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd8) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd8) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd8) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd8) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd8) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd8) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd8) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd8) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd8) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd8) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd8) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd8) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd8) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd8) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd8) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd8) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd8) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd8) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd8) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd8) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd8) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd8) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd8) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd8) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd8) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd8) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[9] = 
        (csr_row_0_pos == 6'd9) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd9) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd9) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd9) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd9) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd9) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd9) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd9) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd9) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd9) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd9) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd9) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd9) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd9) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd9) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd9) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd9) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd9) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd9) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd9) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd9) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd9) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd9) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd9) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd9) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd9) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd9) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd9) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd9) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd9) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd9) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd9) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd9) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd9) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[10] = 
        (csr_row_0_pos == 6'd10) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd10) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd10) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd10) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd10) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd10) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd10) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd10) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd10) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd10) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd10) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd10) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd10) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd10) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd10) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd10) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd10) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd10) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd10) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd10) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd10) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd10) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd10) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd10) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd10) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd10) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd10) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd10) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd10) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd10) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd10) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd10) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd10) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd10) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[11] = 
        (csr_row_0_pos == 6'd11) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd11) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd11) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd11) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd11) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd11) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd11) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd11) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd11) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd11) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd11) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd11) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd11) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd11) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd11) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd11) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd11) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd11) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd11) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd11) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd11) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd11) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd11) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd11) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd11) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd11) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd11) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd11) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd11) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd11) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd11) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd11) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd11) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd11) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[12] = 
        (csr_row_0_pos == 6'd12) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd12) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd12) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd12) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd12) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd12) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd12) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd12) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd12) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd12) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd12) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd12) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd12) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd12) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd12) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd12) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd12) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd12) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd12) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd12) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd12) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd12) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd12) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd12) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd12) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd12) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd12) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd12) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd12) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd12) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd12) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd12) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd12) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd12) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[13] = 
        (csr_row_0_pos == 6'd13) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd13) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd13) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd13) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd13) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd13) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd13) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd13) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd13) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd13) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd13) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd13) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd13) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd13) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd13) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd13) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd13) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd13) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd13) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd13) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd13) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd13) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd13) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd13) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd13) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd13) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd13) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd13) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd13) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd13) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd13) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd13) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd13) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd13) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[14] = 
        (csr_row_0_pos == 6'd14) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd14) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd14) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd14) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd14) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd14) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd14) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd14) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd14) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd14) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd14) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd14) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd14) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd14) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd14) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd14) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd14) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd14) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd14) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd14) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd14) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd14) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd14) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd14) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd14) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd14) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd14) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd14) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd14) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd14) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd14) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd14) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd14) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd14) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[15] = 
        (csr_row_0_pos == 6'd15) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd15) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd15) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd15) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd15) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd15) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd15) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd15) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd15) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd15) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd15) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd15) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd15) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd15) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd15) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd15) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd15) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd15) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd15) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd15) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd15) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd15) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd15) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd15) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd15) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd15) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd15) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd15) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd15) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd15) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd15) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd15) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd15) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd15) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[16] = 
        (csr_row_0_pos == 6'd16) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd16) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd16) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd16) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd16) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd16) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd16) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd16) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd16) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd16) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd16) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd16) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd16) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd16) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd16) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd16) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd16) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd16) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd16) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd16) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd16) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd16) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd16) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd16) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd16) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd16) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd16) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd16) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd16) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd16) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd16) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd16) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd16) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd16) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[17] = 
        (csr_row_0_pos == 6'd17) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd17) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd17) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd17) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd17) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd17) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd17) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd17) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd17) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd17) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd17) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd17) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd17) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd17) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd17) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd17) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd17) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd17) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd17) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd17) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd17) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd17) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd17) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd17) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd17) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd17) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd17) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd17) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd17) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd17) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd17) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd17) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd17) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd17) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[18] = 
        (csr_row_0_pos == 6'd18) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd18) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd18) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd18) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd18) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd18) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd18) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd18) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd18) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd18) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd18) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd18) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd18) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd18) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd18) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd18) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd18) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd18) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd18) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd18) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd18) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd18) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd18) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd18) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd18) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd18) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd18) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd18) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd18) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd18) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd18) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd18) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd18) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd18) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[19] = 
        (csr_row_0_pos == 6'd19) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd19) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd19) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd19) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd19) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd19) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd19) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd19) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd19) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd19) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd19) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd19) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd19) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd19) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd19) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd19) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd19) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd19) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd19) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd19) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd19) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd19) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd19) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd19) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd19) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd19) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd19) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd19) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd19) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd19) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd19) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd19) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd19) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd19) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[20] = 
        (csr_row_0_pos == 6'd20) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd20) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd20) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd20) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd20) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd20) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd20) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd20) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd20) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd20) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd20) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd20) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd20) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd20) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd20) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd20) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd20) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd20) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd20) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd20) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd20) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd20) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd20) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd20) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd20) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd20) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd20) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd20) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd20) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd20) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd20) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd20) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd20) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd20) & rdp_scbr_ecc_c_cs[1] ;
assign  cmd_addr[21] = 
        (csr_row_0_pos == 6'd21) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd21) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd21) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd21) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd21) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd21) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd21) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd21) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd21) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd21) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd21) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd21) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd21) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd21) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd21) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd21) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd21) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd21) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd21) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd21) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd21) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd21) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd21) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd21) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd21) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd21) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd21) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd21) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd21) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd21) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd21) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd21) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd21) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd21) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[22] = 
        (csr_row_0_pos == 6'd22) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd22) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd22) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd22) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd22) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd22) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd22) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd22) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd22) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd22) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd22) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd22) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd22) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd22) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd22) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd22) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd22) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd22) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd22) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd22) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd22) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd22) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd22) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd22) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd22) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd22) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd22) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd22) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd22) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd22) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd22) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd22) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd22) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd22) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[23] = 
        (csr_row_0_pos == 6'd23) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd23) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd23) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd23) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd23) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd23) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd23) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd23) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd23) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd23) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd23) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd23) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd23) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd23) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd23) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd23) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd23) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd23) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd23) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd23) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd23) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd23) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd23) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd23) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd23) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd23) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd23) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd23) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd23) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd23) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd23) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd23) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd23) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd23) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[24] = 
        (csr_row_0_pos == 6'd24) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd24) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd24) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd24) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd24) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd24) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd24) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd24) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd24) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd24) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd24) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd24) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd24) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd24) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd24) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd24) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd24) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd24) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd24) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd24) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd24) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd24) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd24) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd24) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd24) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd24) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd24) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd24) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd24) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd24) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd24) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd24) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd24) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd24) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[25] = 
        (csr_row_0_pos == 6'd25) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd25) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd25) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd25) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd25) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd25) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd25) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd25) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd25) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd25) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd25) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd25) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd25) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd25) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd25) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd25) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd25) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd25) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd25) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd25) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd25) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd25) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd25) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd25) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd25) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd25) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd25) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd25) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd25) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd25) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd25) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd25) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd25) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd25) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[26] = 
        (csr_row_0_pos == 6'd26) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd26) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd26) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd26) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd26) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd26) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd26) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd26) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd26) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd26) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd26) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd26) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd26) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd26) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd26) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd26) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd26) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd26) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd26) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd26) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd26) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd26) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd26) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd26) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd26) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd26) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd26) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd26) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd26) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd26) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd26) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd26) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd26) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd26) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[27] = 
        (csr_row_0_pos == 6'd27) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd27) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd27) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd27) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd27) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd27) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd27) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd27) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd27) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd27) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd27) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd27) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd27) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd27) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd27) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd27) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd27) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd27) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd27) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd27) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd27) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd27) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd27) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd27) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd27) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd27) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd27) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd27) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd27) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd27) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd27) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd27) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd27) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd27) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[28] = 
        (csr_row_0_pos == 6'd28) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd28) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd28) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd28) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd28) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd28) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd28) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd28) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd28) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd28) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd28) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd28) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd28) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd28) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd28) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd28) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd28) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd28) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd28) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd28) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd28) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd28) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd28) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd28) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd28) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd28) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd28) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd28) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd28) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd28) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd28) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd28) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd28) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd28) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[29] = 
        (csr_row_0_pos == 6'd29) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd29) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd29) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd29) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd29) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd29) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd29) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd29) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd29) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd29) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd29) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd29) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd29) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd29) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd29) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd29) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd29) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd29) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd29) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd29) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd29) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd29) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd29) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd29) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd29) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd29) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd29) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd29) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd29) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd29) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd29) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd29) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd29) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd29) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[30] = 
        (csr_row_0_pos == 6'd30) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd30) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd30) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd30) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd30) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd30) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd30) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd30) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd30) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd30) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd30) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd30) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd30) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd30) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd30) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd30) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd30) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd30) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd30) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd30) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd30) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd30) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd30) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd30) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd30) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd30) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd30) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd30) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd30) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd30) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd30) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd30) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd30) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd30) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[31] = 
        (csr_row_0_pos == 6'd31) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd31) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd31) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd31) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd31) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd31) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd31) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd31) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd31) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd31) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd31) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd31) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd31) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd31) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd31) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd31) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd31) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd31) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd31) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd31) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd31) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd31) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd31) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd31) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd31) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd31) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd31) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd31) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd31) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd31) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd31) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd31) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd31) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd31) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[32] = 
        (csr_row_0_pos == 6'd32) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd32) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd32) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd32) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd32) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd32) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd32) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd32) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd32) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd32) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd32) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd32) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd32) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd32) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd32) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd32) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd32) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd32) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd32) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd32) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd32) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd32) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd32) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd32) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd32) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd32) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd32) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd32) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd32) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd32) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd32) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd32) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd32) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd32) & rdp_scbr_ecc_c_cs[1] ;

assign  cmd_addr[33] = 
        (csr_row_0_pos == 6'd33) & rdp_scbr_ecc_c_row[0] |
        (csr_row_1_pos == 6'd33) & rdp_scbr_ecc_c_row[1] |
        (csr_row_2_pos == 6'd33) & rdp_scbr_ecc_c_row[2] |
        (csr_row_3_pos == 6'd33) & rdp_scbr_ecc_c_row[3] |
        (csr_row_4_pos == 6'd33) & rdp_scbr_ecc_c_row[4] |
        (csr_row_5_pos == 6'd33) & rdp_scbr_ecc_c_row[5] |
        (csr_row_6_pos == 6'd33) & rdp_scbr_ecc_c_row[6] |
        (csr_row_7_pos == 6'd33) & rdp_scbr_ecc_c_row[7] |
        (csr_row_8_pos == 6'd33) & rdp_scbr_ecc_c_row[8] |
        (csr_row_9_pos == 6'd33) & rdp_scbr_ecc_c_row[9] |
        (csr_row_10_pos == 6'd33) & rdp_scbr_ecc_c_row[10] |
        (csr_row_11_pos == 6'd33) & rdp_scbr_ecc_c_row[11] |
        (csr_row_12_pos == 6'd33) & rdp_scbr_ecc_c_row[12] |
        (csr_row_13_pos == 6'd33) & rdp_scbr_ecc_c_row[13] |
        (csr_row_14_pos == 6'd33) & rdp_scbr_ecc_c_row[14] |
        (csr_row_15_pos == 6'd33) & rdp_scbr_ecc_c_row[15] |
        (csr_row_16_pos == 6'd33) & rdp_scbr_ecc_c_row[16] |
        (csr_row_17_pos == 6'd33) & rdp_scbr_ecc_c_row[17] |
        (csr_row_18_pos == 6'd33) & rdp_scbr_ecc_c_row[18] |
        (csr_col_0_pos == 6'd33) & rdp_scbr_ecc_c_col[0] |
        (csr_col_1_pos == 6'd33) & rdp_scbr_ecc_c_col[1] |
        (csr_col_2_pos == 6'd33) & rdp_scbr_ecc_c_col[2] |
        (csr_col_3_pos == 6'd33) & rdp_scbr_ecc_c_col[3] |
        (csr_col_4_pos == 6'd33) & rdp_scbr_ecc_c_col[4] |
        (csr_col_5_pos == 6'd33) & rdp_scbr_ecc_c_col[5] |
        (csr_col_6_pos == 6'd33) & rdp_scbr_ecc_c_col[6] |

        (csr_ba_0_pos == 6'd33) & rdp_scbr_ecc_c_ba[0] |
        (csr_ba_1_pos == 6'd33) & rdp_scbr_ecc_c_ba[1] |
        (csr_ba_2_pos == 6'd33) & rdp_scbr_ecc_c_ba[2] |
        (csr_ba_3_pos == 6'd33) & rdp_scbr_ecc_c_ba[3] |
        (csr_ba_4_pos == 6'd33) & rdp_scbr_ecc_c_ba[4] |

        (csr_cid_0_pos == 6'd33) & rdp_scbr_ecc_c_cid[0] |

        (csr_cs_0_pos == 6'd33) & rdp_scbr_ecc_c_cs[0] |
        (csr_cs_1_pos == 6'd33) & rdp_scbr_ecc_c_cs[1] ;

endmodule