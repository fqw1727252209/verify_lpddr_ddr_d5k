`include "ddr_ctl_define.vh"

module scbr_ctrl (

    input                                   core_clk                    ,
    input                                   core_rstn                   ,

    input                                   csr_ecc_en                  ,
    input                                   csr_scbr_en                 ,
    input      [1:0]                        csr_scbr_mode               ,

    input      [7:0]                        csr_scbr_period             ,
    input      [7:0]                        csrScbrRndInterval          ,
    input                                   scbr_need_send_in_idle      ,

    output     [7:0]                        csr_scbr_state              ,
    output                                  csr_scbr_error              ,
    output reg                              csr_scbr_round_done         ,

    input                                   scbr_hold                   ,
    output                                  scbr_idle                   ,
    output                                  scbr_cfg_itr                ,

    input                                   fix_rmw_fifo_empty          ,
    input      [`CTL_CMD_ADDR_W-1:0]        fix_rmw_cmd_addr_out        ,
    output                                  fix_rmw_fifo_rd_en          ,

    output                                  csr_scbr_en_re              ,
    output                                  csr_scbr_en_fe              ,
    output                                  next_round_begin            ,
    output                                  not_fix_rmw_mode            ,

    output                                  scbr_in_init_state          ,
    output                                  peri_scbr_send              ,

    input      [`CTL_CMD_ADDR_W-1:0]        peri_scbr_addr              ,
    input                                   scbr_last                   ,
    input                                   scbr_error                  ,
    input                                   scbr_init_ok                ,

    output     [`CTL_CMD_ADDR_W-1:0]        scbr_pa_cmd_addr            ,
    output     [1:0]                        scbr_pa_cmd_type            ,
    output                                  scbr_pa_cmd_vld             ,
    input                                   pa_scbr_ready
);

localparam IDLE          = 8'b00000001;
localparam INIT          = 8'b00000010;
localparam SEND_PERIODIC = 8'b00000100;
localparam SEND_FIX      = 8'b00001000;
localparam WAIT_PERIODIC = 8'b00010000;
localparam ERROR         = 8'b00100000;
localparam WR_END        = 8'b01000000;
localparam HOLD          = 8'b10000000;

reg     [7:0] curr_state                ;

reg     [7:0] next_state                ;
wire          peri_scbr_send_flag       ;

wire    in_idle_state                   ;
wire    in_init_state                   ;
wire    in_send_periodic_state          ;
wire    in_send_fix_state               ;
wire    in_wait_periodic_state          ;
wire    in_error_state                  ;
wire    in_wr_end_state                 ;
wire    in_hold_state                   ;

assign  in_idle_state          = curr_state[0];
assign  in_init_state          = curr_state[1];
assign  in_send_periodic_state = curr_state[2];
assign  in_send_fix_state      = curr_state[3];
assign  in_wait_periodic_state = curr_state[4];
assign  in_error_state         = curr_state[5];
assign  in_wr_end_state        = curr_state[6];
assign  in_hold_state          = curr_state[7];

assign  scbr_in_init_state     = in_init_state;
assign  scbr_idle              = in_idle_state | in_hold_state | in_error_state | in_wr_end_state;

assign  csr_scbr_error         = in_error_state;

assign  csr_scbr_state         = curr_state;

reg [1:0]   scbr_mode;

wire        scbr_round_done         ;
wire        csr_scbr_round_done_re  ;
wire        scbr_round_done_itr     ;

assign  scbr_round_done         = in_send_periodic_state & pa_scbr_ready & scbr_last;
assign  scbr_round_done_itr     = (scbr_mode==`CTL_CMD_TYPE_WR) ? csr_scbr_round_done: csr_scbr_round_done_re;

assign  scbr_cfg_itr            = csr_scbr_error | scbr_round_done_itr;

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        csr_scbr_round_done <= 1'b0;
    end else if(csr_scbr_en_fe)begin
        csr_scbr_round_done <= 1'b0;
    end else if(scbr_round_done)begin
        csr_scbr_round_done <= 1'b1;
    end
end

ctl_edge_detect csr_scbr_round_done_re_detect (
    .clk        (core_clk               ),
    .rst_n      (core_rstn              ),
    .in         (csr_scbr_round_done    ),
    .edge_sel   (1'b0                   ),
    .out        (csr_scbr_round_done_re )
);

wire detect_en;
assign detect_en = csr_scbr_en & csr_ecc_en;

ctl_edge_detect csr_scbr_en_re_detect (
    .clk        (core_clk               ),
    .rst_n      (core_rstn              ),
    .in         (detect_en              ),
    .edge_sel   (1'b0                   ),
    .out        (csr_scbr_en_re         )
);

ctl_edge_detect csr_scbr_en_fe_detect (
    .clk        (core_clk               ),
    .rst_n      (core_rstn              ),
    .in         (detect_en              ),
    .edge_sel   (1'b1                   ),
    .out        (csr_scbr_en_fe         )
);


reg [7:0]   scbr_period;
reg [7:0]   scbr_rnd_interval;

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        scbr_mode           <= 2'b0;
        scbr_period         <= 8'b0;
        scbr_rnd_interval   <= 8'b0;
    end else if(csr_scbr_en_re) begin
        scbr_mode           <= csr_scbr_mode        ;
        scbr_period         <= csr_scbr_period      ;
        scbr_rnd_interval   <= csrScbrRndInterval   ;
    end
end

assign scbr_pa_cmd_vld      = (peri_scbr_send_flag == 1'b1) | (in_send_fix_state & (!fix_rmw_fifo_empty));
assign scbr_pa_cmd_addr     = (peri_scbr_send_flag == 1'b1) ? peri_scbr_addr : fix_rmw_cmd_addr_out;
assign scbr_pa_cmd_type     = (peri_scbr_send_flag == 1'b1) ? scbr_mode : `CTL_CMD_TYPE_RMW;

assign peri_scbr_send       = pa_scbr_ready & peri_scbr_send_flag;

assign fix_rmw_fifo_rd_en   = in_send_fix_state & pa_scbr_ready;


wire   fix_rmw_mode         = csr_scbr_en_re ? csr_scbr_mode == `CTL_CMD_TYPE_MWR : scbr_mode == `CTL_CMD_TYPE_MWR;
assign not_fix_rmw_mode     = ~fix_rmw_mode;


wire            wait_timeout    ;
reg     [16:0]  wait_cnt        ;

wire            rnd_interval_timeout;
reg     [16:0]  rnd_interval_cnt    ;
reg             curr_round_done     ;

assign wait_timeout         = wait_cnt == ({scbr_period, 9'b0});
assign rnd_interval_timeout = (scbr_rnd_interval != 8'd0) & (rnd_interval_cnt == {scbr_rnd_interval, 9'b0});

wire    wait_cnt_inc;
wire    wait_cnt_clr;

wire    rnd_interval_cnt_inc;
wire    rnd_interval_cnt_clr;

assign wait_cnt_inc = (scbr_period != 8'd0) & (~curr_round_done) & ((in_wait_periodic_state & (~wait_timeout)) | 
                                                                    (in_send_fix_state & (~wait_timeout))      );
assign wait_cnt_clr = csr_scbr_en_fe | ((wait_timeout | scbr_need_send_in_idle) & (next_state == SEND_PERIODIC));

assign rnd_interval_cnt_inc = (scbr_rnd_interval != 8'd0) & curr_round_done & ((in_wait_periodic_state & (~rnd_interval_timeout)) | 
                                                                               (in_send_fix_state & (~rnd_interval_timeout))     );
assign rnd_interval_cnt_clr = csr_scbr_en_fe | ((rnd_interval_timeout | scbr_need_send_in_idle) & (next_state == INIT));

wire    curr_round_done_set;
wire    curr_round_done_clr;

assign curr_round_done_clr = rnd_interval_cnt_clr;
assign curr_round_done_set = scbr_round_done && (scbr_rnd_interval != 8'd0);

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        curr_round_done <= 1'b0;
    end else if(curr_round_done_clr)begin
        curr_round_done <= 1'b0;
    end else if(curr_round_done_set)begin
        curr_round_done <= 1'b1;
    end
end

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        wait_cnt <= 17'b0;
    end else if(wait_cnt_clr)begin
        wait_cnt <= 17'b0;
    end else if(wait_cnt_inc)begin
        wait_cnt <= wait_cnt + 17'b1;
    end
end

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        rnd_interval_cnt <= 17'b0;
    end else if(rnd_interval_cnt_clr)begin
        rnd_interval_cnt <= 17'b0;
    end else if(rnd_interval_cnt_inc)begin
        rnd_interval_cnt <= rnd_interval_cnt + 17'b1;
    end
end

reg     [2:0]   seq_cmd_send_cnt    ;
wire            seq_send_ok         ;
wire            seq_cmd_send_cnt_clr;
wire            seq_cmd_send_cnt_inc;

assign seq_send_ok = (in_send_periodic_state & (seq_cmd_send_cnt == 3'd7) & peri_scbr_send);

assign seq_cmd_send_cnt_inc = in_send_periodic_state & peri_scbr_send;
assign seq_cmd_send_cnt_clr = seq_send_ok | scbr_last | csr_scbr_en_fe;

always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        seq_cmd_send_cnt <= 3'b0;
    end else if(seq_cmd_send_cnt_clr)begin
        seq_cmd_send_cnt <= 3'b0;
    end else if(seq_cmd_send_cnt_inc)begin
        seq_cmd_send_cnt <= seq_cmd_send_cnt + 3'b1;
    end
end


always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        curr_state <= IDLE;
    end else if(csr_scbr_en_fe)begin
        curr_state <= IDLE;
    end else begin
        curr_state <= next_state;
    end
end

assign peri_scbr_send_flag = (scbr_hold == 1'b1) ? 1'b0 : ((curr_state == SEND_PERIODIC) ? 1'b1 : 1'b0);

reg     [7:0] pre_state         ;
always @(posedge core_clk or negedge core_rstn) begin
    if (!core_rstn) begin
        pre_state   <= IDLE;
    end else if(curr_state != next_state) begin
        pre_state   <= curr_state;
    end
end

reg [7:0] exp_state_af_hold;
always @(posedge core_clk or negedge core_rstn) begin
    if(!core_rstn) 
        exp_state_af_hold <= IDLE;
    else if(curr_state == INIT) begin
        if(scbr_error)
            exp_state_af_hold <= ERROR;
        else if(scbr_init_ok)
            exp_state_af_hold <= SEND_PERIODIC;
        else
            exp_state_af_hold <= INIT;
        end else if(curr_state == SEND_PERIODIC) begin
        if(seq_send_ok && (~scbr_last) && (scbr_period != 8'd0))
            exp_state_af_hold <= WAIT_PERIODIC;
        else if(scbr_last && scbr_mode!=`CTL_CMD_TYPE_WR) begin
            if (scbr_rnd_interval != 8'd0) begin
                exp_state_af_hold <= WAIT_PERIODIC;
            end else begin
                exp_state_af_hold <= INIT;
            end
        end
        else if(scbr_last && scbr_mode==`CTL_CMD_TYPE_WR)
            exp_state_af_hold <= WR_END;
        else
            exp_state_af_hold <= SEND_PERIODIC;
    end
    else if(curr_state == WAIT_PERIODIC) begin
        if(curr_round_done) begin
            if(rnd_interval_timeout | scbr_need_send_in_idle)
                exp_state_af_hold <= INIT;
            else if(!fix_rmw_fifo_empty)
                exp_state_af_hold <= SEND_FIX;
            else
                exp_state_af_hold <= WAIT_PERIODIC;
        end
        else if(wait_timeout | scbr_need_send_in_idle)
            exp_state_af_hold <= SEND_PERIODIC;
        else if(!fix_rmw_fifo_empty)
            exp_state_af_hold <= SEND_FIX;
        else
            exp_state_af_hold <= WAIT_PERIODIC;
    end
    else if(curr_state == SEND_FIX) begin
        if(fix_rmw_mode)
            exp_state_af_hold <= SEND_FIX;
        else if(fix_rmw_fifo_empty && rnd_interval_timeout && curr_round_done)
            exp_state_af_hold <= INIT;
        else if(fix_rmw_fifo_empty && wait_timeout && !curr_round_done)
            exp_state_af_hold <= SEND_PERIODIC;
        else if(fix_rmw_fifo_empty && (!wait_timeout))
            exp_state_af_hold <= WAIT_PERIODIC;
        else
            exp_state_af_hold <= SEND_FIX;
    end
    else if(curr_state == ERROR) begin
        exp_state_af_hold <= ERROR;
    end
    else if(curr_state == WR_END) begin
        exp_state_af_hold <= WR_END;
    end
    else if(curr_state == HOLD) begin
        exp_state_af_hold <= exp_state_af_hold;
    end
    else
        exp_state_af_hold <= IDLE;
end

always @(*) begin
    next_state = curr_state;
    case(curr_state)
        IDLE: begin
            if(csr_scbr_en_re) begin
                if(fix_rmw_mode) begin
                    next_state = SEND_FIX;
                end else begin
                    next_state = INIT;
                end
            end else begin
                next_state = IDLE;
            end
        end
        INIT: begin
            if(scbr_hold)
                next_state = HOLD;
            else if(scbr_error)
                next_state = ERROR;
            else if(scbr_init_ok)
                next_state = SEND_PERIODIC;
            else
                next_state = INIT;
        end
        SEND_PERIODIC: begin
            if(scbr_hold)
                next_state = HOLD;
            else if(seq_send_ok && (~scbr_last) && (scbr_period != 8'd0))
                next_state = WAIT_PERIODIC;
            else if(scbr_last && scbr_mode!=`CTL_CMD_TYPE_WR) begin
                if (scbr_rnd_interval != 8'd0) begin
                    next_state = WAIT_PERIODIC;
                end else begin
                    next_state = INIT;
                end
            end
            else if(scbr_last && scbr_mode==`CTL_CMD_TYPE_WR)
                next_state = WR_END;
            else
                next_state = SEND_PERIODIC;
        end
        WAIT_PERIODIC: begin
            if(scbr_hold)
                next_state = HOLD;
            else if(curr_round_done) begin
                if(rnd_interval_timeout | scbr_need_send_in_idle)
                    next_state = INIT;
                else if(!fix_rmw_fifo_empty)
                    next_state = SEND_FIX;
                else
                    next_state = WAIT_PERIODIC;
            end
            else if(wait_timeout | scbr_need_send_in_idle)
                next_state = SEND_PERIODIC;
            else if(!fix_rmw_fifo_empty)
                next_state = SEND_FIX;
            else
                next_state = WAIT_PERIODIC;
        end
        SEND_FIX: begin
            if(scbr_hold)
                next_state = HOLD;
            else if(fix_rmw_mode)
                next_state = SEND_FIX;
            else if(fix_rmw_fifo_empty && rnd_interval_timeout && curr_round_done)
                next_state = INIT;
            else if(fix_rmw_fifo_empty && wait_timeout && !curr_round_done)
                next_state = SEND_PERIODIC;
            else if(fix_rmw_fifo_empty && (!wait_timeout))
                next_state = WAIT_PERIODIC;
            else
                next_state = SEND_FIX;
        end
        ERROR: begin
            next_state = ERROR;
        end
        WR_END: begin
            next_state = WR_END;
        end
        HOLD: begin
            if(!scbr_hold)
                next_state = exp_state_af_hold;
            else
                next_state = HOLD;
        end
    endcase
end

assign next_round_begin = (~csr_scbr_en_fe) & (next_state == INIT && exp_state_af_hold != INIT) & (curr_state != INIT);

endmodule