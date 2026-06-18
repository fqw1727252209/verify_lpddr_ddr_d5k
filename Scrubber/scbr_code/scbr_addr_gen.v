`include "ddr_ctl_define.vh"

module scbr_addr_gen (

    input                                   core_clk                    ,
    input                                   core_rstn                   ,

    input                                   csrSbEccEn                  ,
    input                                   csrIEccEn                   ,
    input      [`CTL_ADDR_POS_W-1:0]        csr_col_5_pos               ,
    input      [6:0]                        csr_ecc_region_map          ,
    input                                   csr_ecc_region_map_other    ,
    input      [1:0]                        csr_ecc_region_map_granu    ,
    input      [31:0]                       csrScbrStartAddr0           ,
    input      [`CTL_CMD_ADDR_W-32-1:0]     csrScbrStartAddr1           ,
    input      [31:0]                       csrScbrEndAddr0             ,
    input      [`CTL_CMD_ADDR_W-32-1:0]     csrScbrEndAddr1             ,
    input                                   csr_scbr_en_re              ,
    input                                   csr_scbr_en_fe              ,
    output     [31:0]                       csrScbrCurrAddr0            ,
    output     [`CTL_CMD_ADDR_W-32-1:0]     csrScbrCurrAddr1            ,
    output reg [2:0]                        csr_scbr_addr_range_status  ,

    input                                   not_fix_rmw_mode            ,
    input                                   next_round_begin            ,
    input                                   peri_scbr_send              ,

    input                                   scbr_in_init_state          ,
    output                                  scbr_init_ok                ,
    output                                  scbr_error                  ,
    output reg [`CTL_CMD_ADDR_W-1:0]        peri_scbr_addr              ,
    output                                  scbr_last                   

);

reg     [`CTL_CMD_ADDR_W-1:0] scbr_start_addr   ;
reg     [`CTL_CMD_ADDR_W-1:0] scbr_end_addr     ;

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        scbr_start_addr     <= {(`CTL_CMD_ADDR_W){1'b0}};
        scbr_end_addr       <= {(`CTL_CMD_ADDR_W){1'b0}};
    end else if(csr_scbr_en_re) begin
        scbr_start_addr     <= {csrScbrStartAddr1, csrScbrStartAddr0} ;
        scbr_end_addr       <= {csrScbrEndAddr1, csrScbrEndAddr0}     ;
    end
end

wire    [5:0]   prot_divide_pos_utl;

assign prot_divide_pos_utl      = `CTL_CMD_ADDR_W - 1 - csr_col_5_pos + csr_ecc_region_map_granu;

wire    [`CTL_CMD_ADDR_W-1:0]   start_addr                  ;
wire    [`CTL_CMD_ADDR_W-1:0]   end_addr                    ;

wire    [5:0]                   start_addr_hv6              ;
wire    [5:0]                   end_addr_hv6                ;

wire    [5:0]                   start_addr_hv6_sft          ;
wire    [5:0]                   end_addr_hv6_sft            ;

wire    [2:0]                   start_lowest_8_region_bits  ;
wire    [2:0]                   end_lowest_8_region_bits    ;

assign  start_addr      = {csrScbrStartAddr1, csrScbrStartAddr0};
assign  end_addr        = {csrScbrEndAddr1, csrScbrEndAddr0};

assign  start_addr_hv6  = csrIEccEn ? { start_addr[csr_col_5_pos],
                                        start_addr[csr_col_5_pos - 1],
                                        start_addr[csr_col_5_pos - 2],
                                        start_addr[csr_col_5_pos - 3],
                                        start_addr[csr_col_5_pos - 4],
                                        start_addr[csr_col_5_pos - 5] 
                                      } : 6'h0;

assign  end_addr_hv6    = csrIEccEn ? { end_addr[csr_col_5_pos],
                                        end_addr[csr_col_5_pos - 1],
                                        end_addr[csr_col_5_pos - 2],
                                        end_addr[csr_col_5_pos - 3],
                                        end_addr[csr_col_5_pos - 4],
                                        end_addr[csr_col_5_pos - 5] 
                                      } : 6'h0;

assign  start_addr_hv6_sft      = start_addr_hv6 << csr_ecc_region_map_granu;
assign  end_addr_hv6_sft        = end_addr_hv6   << csr_ecc_region_map_granu;

assign  start_lowest_8_region_bits  = start_addr_hv6_sft[5:3] ;
assign  end_lowest_8_region_bits    = end_addr_hv6_sft[5:3]   ;

wire                            start_is_in_ecc_region          ;
wire                            end_is_in_ecc_region            ;

wire                            start_is_in_lowest_8_region     ;
wire                            end_is_in_lowest_8_region       ;

wire                            start_is_in_lowest_8_region_and_prot ;
wire                            end_is_in_lowest_8_region_and_prot   ;

wire                            start_is_protect                ;
wire                            end_is_protect                  ;

wire    [7:0]                   prot_bits_for_lowest_8_region   ;
wire                            start_in_other_is_prot          ;
wire                            end_in_other_is_prot            ;

assign  prot_bits_for_lowest_8_region = {csr_ecc_region_map_other, csr_ecc_region_map};

assign  start_is_in_ecc_region  = start_addr_hv6[5:3] == 3'b111;
assign  end_is_in_ecc_region    = end_addr_hv6[5:3]   == 3'b111;

assign  start_is_in_lowest_8_region = csr_ecc_region_map_granu==2'b01 ? start_addr_hv6[5]   == 1'b0     :
                                      csr_ecc_region_map_granu==2'b10 ? start_addr_hv6[5:4] == 2'b00    :
                                      csr_ecc_region_map_granu==2'b11 ? start_addr_hv6[5:3] == 3'b000   :
                                      1'b1;

assign  end_is_in_lowest_8_region   = csr_ecc_region_map_granu==2'b01 ? end_addr_hv6[5]     == 1'b0     :
                                      csr_ecc_region_map_granu==2'b10 ? end_addr_hv6[5:4]   == 2'b00    :
                                      csr_ecc_region_map_granu==2'b11 ? end_addr_hv6[5:3]   == 3'b000   :
                                      1'b1;

assign  start_is_in_lowest_8_region_and_prot = start_is_in_lowest_8_region & 
                                               prot_bits_for_lowest_8_region[start_addr_hv6_sft[5:3]];

assign  end_is_in_lowest_8_region_and_prot   = end_is_in_lowest_8_region & 
                                               prot_bits_for_lowest_8_region[end_addr_hv6_sft[5:3]];

assign  start_in_other_is_prot  = (~start_is_in_lowest_8_region & ~start_is_in_ecc_region ) & csr_ecc_region_map_other;
assign  end_in_other_is_prot    = (~end_is_in_lowest_8_region   & ~end_is_in_ecc_region   ) & csr_ecc_region_map_other;

assign  start_is_protect        = start_is_in_lowest_8_region_and_prot | start_in_other_is_prot;
assign  end_is_protect          = end_is_in_lowest_8_region_and_prot   | end_in_other_is_prot;

wire    [2:0]   start_region;
wire    [2:0]   end_region;
wire    [3:0]   end_start_region_sub;
wire    [2:0]   region_num;

assign  start_region            = start_is_in_lowest_8_region   ? start_lowest_8_region_bits : 3'b111;
assign  end_region              = end_is_in_lowest_8_region     ? end_lowest_8_region_bits   : 3'b111;
assign  end_start_region_sub    = end_region - start_region;
assign  region_num              = end_start_region_sub[2:0];

wire            cfg_has_ecc_region_error        ;

assign  cfg_has_ecc_region_error        = start_is_in_ecc_region | end_is_in_ecc_region;

wire            cfg_start_exceed_end_error      ;
assign  cfg_start_exceed_end_error      = {csrScbrStartAddr1, csrScbrStartAddr0} > {csrScbrEndAddr1, csrScbrEndAddr0};

reg     [3:0]   prot_divide_pos_utl_init        ;
reg     [2:0]   start_region_init               ;
reg             cfg_has_ecc_region_error_init   ;
reg             start_is_protect_init           ;
reg             end_is_protect_init             ;
reg     [2:0]   region_num_init                 ;
reg             cfg_start_exceed_end_error_init ;

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        prot_divide_pos_utl_init        <= 4'b0;
        start_region_init               <= 3'b0;
        cfg_has_ecc_region_error_init   <= 1'b0;
        start_is_protect_init           <= 1'b0;
        end_is_protect_init             <= 1'b0;
        region_num_init                 <= 3'b0;
        cfg_start_exceed_end_error_init <= 1'b0;
    end else if(csr_scbr_en_fe) begin
        prot_divide_pos_utl_init        <= 4'b0;
        start_region_init               <= 3'b0;
        cfg_has_ecc_region_error_init   <= 1'b0;
        start_is_protect_init           <= 1'b0;
        end_is_protect_init             <= 1'b0;
        region_num_init                 <= 3'b0;
        cfg_start_exceed_end_error_init <= 1'b0;
    end else if(csr_scbr_en_re) begin
        prot_divide_pos_utl_init        <= prot_divide_pos_utl[3:0]     ;
        start_region_init               <= start_region                 ;
        cfg_has_ecc_region_error_init   <= cfg_has_ecc_region_error     ;
        start_is_protect_init           <= start_is_protect             ;
        end_is_protect_init             <= end_is_protect               ;
        region_num_init                 <= region_num                   ;
        cfg_start_exceed_end_error_init <= cfg_start_exceed_end_error   ;
    end
end

reg             checking;
reg     [2:0]   region_cnt;
reg     [2:0]   checking_region;
reg             range_has_prot_region;

wire            last_check;
assign  last_check = (region_cnt == 3'b0) & scbr_in_init_state;

wire            checking_assert;
assign  checking_assert = not_fix_rmw_mode & (csr_scbr_en_re || next_round_begin);

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        checking            <= 1'b0;
    end else if(csr_scbr_en_fe) begin
        checking            <= 1'b0;
    end else if(checking_assert) begin
        checking            <= 1'b1;
    end else if(last_check) begin
        checking            <= 1'b0;
    end
end

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        region_cnt          <= 3'b0;
        checking_region     <= 3'b0;
    end else if(csr_scbr_en_fe) begin
        region_cnt          <= 3'b0;
        checking_region     <= 3'b0;
    end else if(csr_scbr_en_re) begin
        region_cnt          <= region_num;
        checking_region     <= start_region;
    end else if(next_round_begin) begin
        region_cnt          <= region_num_init;
        checking_region     <= start_region_init;
    end else if(checking && (!last_check)) begin
        region_cnt          <= region_cnt - 3'b1;
        checking_region     <= checking_region + 3'b1;
    end
end

wire            checking_region_is_protect;
assign  checking_region_is_protect = prot_bits_for_lowest_8_region[checking_region];

wire            range_has_prot_region_next;
assign  range_has_prot_region_next = range_has_prot_region | checking_region_is_protect;

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        range_has_prot_region       <= 1'b0;
    end else if(csr_scbr_en_fe) begin
        range_has_prot_region       <= 1'b0;
    end else if(checking) begin
        range_has_prot_region       <= range_has_prot_region_next;
    end
end

wire            scbr_round1_error               ;
wire            scbr_round2_error               ;
wire            range_has_no_prot_region        ;
wire    [2:0]   csr_scbr_addr_range_status_next ;

assign  range_has_no_prot_region = ~range_has_prot_region_next;

assign  scbr_round1_error = cfg_has_ecc_region_error_init   |
                            cfg_start_exceed_end_error_init ;

assign  scbr_round2_error = checking & range_has_no_prot_region;

assign  scbr_error  = ((scbr_round1_error | scbr_round2_error) & last_check & csrIEccEn) | (cfg_start_exceed_end_error_init & csrSbEccEn);

assign  csr_scbr_addr_range_status_next = { cfg_has_ecc_region_error_init   ,
                                            cfg_start_exceed_end_error_init ,
                                            range_has_no_prot_region
                                          };

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        csr_scbr_addr_range_status  <= 3'b0;
    end else if(csr_scbr_en_fe) begin
        csr_scbr_addr_range_status  <= 3'b0;
    end else if(scbr_error) begin
        csr_scbr_addr_range_status  <= csr_scbr_addr_range_status_next;
    end
end

wire            region_fifo_full    ;
wire            region_fifo_empty   ;
wire    [2:0]   region_fifo_in      ;
wire    [2:0]   region_fifo_out     ;
wire            region_fifo_rd_en   ;

wire            region_fifo_wr_en   ;

assign  region_fifo_wr_en   = checking & checking_region_is_protect;
assign  region_fifo_in      = checking_region;

assign  scbr_init_ok        = (scbr_in_init_state & (~scbr_error) & csrSbEccEn) | (scbr_in_init_state & last_check & (~region_fifo_empty) & (~scbr_error) & csrIEccEn);

wire    full;

ctl_fifo_fwft_sync_np2_clr #(
    .DATA_WIDTH     (3),
    .ADDR_WIDTH     (3),
    .DATA_DEPTH     (8)
)
prot_region_fifo (
    .h_rstn             (core_rstn          ),
    .s_rst              (csr_scbr_en_fe     ),
    .clk                (core_clk           ),
    .wr_en              (region_fifo_wr_en  ),
    .din                (region_fifo_in     ),
`ifdef UV_CTL_SIM
    .full               (region_fifo_full   ),
`else
    .full               (full               ),
`endif
    .wcnt               (                   ),//spyglass disable -rule "W287b"
    .almost_empty_nc    (                   ),//spyglass disable -rule "W287b"
    .almost_full_nc     (                   ),//spyglass disable -rule "W287b"
    
    .rd_en              (region_fifo_rd_en  ),
    .dout               (region_fifo_out    ),
    .empty              (region_fifo_empty  )
);

wire    fifo_full_out_nc;
assign  fifo_full_out_nc = full;

reg     [2:0] curr_region;

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        curr_region         <= 3'b0;
    end else if(csr_scbr_en_fe) begin
        curr_region         <= 3'b0;
    end else if(region_fifo_rd_en) begin
        curr_region         <= region_fifo_out;
    end
end

wire    [`CTL_CMD_ADDR_W-1:0]   region_fifo_peri_scbr_addr  ;
wire    [`CTL_CMD_ADDR_W-1:0]   peri_scbr_addr_first        ;
wire    [`CTL_CMD_ADDR_W-1:0]   peri_scbr_addr_gen          ;

wire    [`CTL_CMD_ADDR_W-1:0]   in_lowest_8_region_last_addr;
wire                            use_end_addr_as_last        ;
wire                            curr_region_last            ;
wire                            curr_region_is_other        ;

assign  region_fifo_peri_scbr_addr      = {region_fifo_out, {(`CTL_CMD_ADDR_W-3){1'b0}}} >> prot_divide_pos_utl_init[3:0];
assign  peri_scbr_addr_first            = (start_is_protect_init) ? scbr_start_addr : region_fifo_peri_scbr_addr;

assign  in_lowest_8_region_last_addr    = {curr_region, {(`CTL_CMD_ADDR_W-3){1'b1}}} >> prot_divide_pos_utl_init[3:0];

assign  curr_region_is_other            = curr_region == 3'b111;
assign  use_end_addr_as_last            = curr_region_is_other | (region_fifo_empty & end_is_protect_init);
assign  curr_region_last                = use_end_addr_as_last ? 
                                          peri_scbr_addr == scbr_end_addr : 
                                          peri_scbr_addr == in_lowest_8_region_last_addr ;

assign  region_fifo_rd_en               = (~region_fifo_empty) & ((curr_region_last & peri_scbr_send) | scbr_init_ok);

assign  peri_scbr_addr_gen              = curr_region_last ? region_fifo_peri_scbr_addr              :
                                          (peri_scbr_addr + `CTL_CMD_ADDR_W'b1) ;

wire                            peri_scbr_addr_upd_vld;
wire    [`CTL_CMD_ADDR_W-1:0]   peri_scbr_addr_next;

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        peri_scbr_addr <= `CTL_CMD_ADDR_W'b0;
    end else if(peri_scbr_addr_upd_vld) begin
        peri_scbr_addr <= peri_scbr_addr_next;
    end
end

assign peri_scbr_addr_upd_vld  = (csrIEccEn == 1'b1) ? (region_fifo_rd_en || peri_scbr_send) : ((csrSbEccEn == 1'b1) ? (scbr_init_ok | peri_scbr_send) : 1'b0);
assign scbr_last               = (csrIEccEn == 1'b1) ? (region_fifo_empty & curr_region_last & peri_scbr_send) : ((csrSbEccEn == 1'b1) ? ((peri_scbr_addr==scbr_end_addr) & peri_scbr_send) : 1'b0);
assign peri_scbr_addr_next     = (csrIEccEn == 1'b1) ? (scbr_in_init_state ? peri_scbr_addr_first : peri_scbr_addr_gen) : ((csrSbEccEn == 1'b1) ? (scbr_in_init_state ? scbr_start_addr : (peri_scbr_addr + 1)) : {`CTL_CMD_ADDR_W{1'b0}});

assign {csrScbrCurrAddr1, csrScbrCurrAddr0} = peri_scbr_addr;

`ifdef UV_CTL_SIM
    assert property (@(posedge core_clk)  (csrIEccEn == 1'b1) & (region_fifo_wr_en == 1) |-> region_fifo_full == 0  );
`endif /* UV_CTL_SIM */

endmodule