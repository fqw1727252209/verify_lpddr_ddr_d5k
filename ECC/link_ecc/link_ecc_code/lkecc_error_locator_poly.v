`include "ddr_ctl_define.vh"

module lkecc_error_locator_poly(
    input wire  [8:0]               syndrome           ,

    output wire                     corr_error         ,
    output wire                     uncorr_error       ,
    output wire [136:0]             error_locator_poly
);

assign corr_error   = syndrome!=9'h00 && syndrome[8]==1'b1;
assign uncorr_error = syndrome!=9'h00 && syndrome[8]==1'b0;

assign error_locator_poly[0+8*0] = !syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*0] =  syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*0] = !syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*0] =  syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*0] = !syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*0] =  syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*0] = !syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*0] =  syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*1] = !syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] & !syndrome[4] & syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*1] =  syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] & !syndrome[4] & syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*1] = !syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] & !syndrome[4] & syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*1] =  syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] & !syndrome[4] & syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*1] = !syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] & !syndrome[4] & syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*1] =  syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] & !syndrome[4] & syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*1] = !syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] & !syndrome[4] & syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*1] =  syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] & !syndrome[4] & syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*2] = !syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] &  !syndrome[4] & syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*2] =  syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] &  !syndrome[4] & syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*2] = !syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] &  !syndrome[4] & syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*2] =  syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] &  !syndrome[4] & syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*2] = !syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] &  !syndrome[4] & syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*2] =  syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] &  !syndrome[4] & syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*2] = !syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] &  !syndrome[4] & syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*2] =  syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] &  !syndrome[4] & syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*3] = !syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] &  syndrome[4] & !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*3] =  syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] &  syndrome[4] & !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*3] = !syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] &  syndrome[4] & !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*3] =  syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] &  syndrome[4] & !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*3] = !syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] &  syndrome[4] & !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*3] =  syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] &  syndrome[4] & !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*3] = !syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] &  syndrome[4] & !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*3] =  syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] &  syndrome[4] & !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*4] = !syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] & syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*4] =  syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] & syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*4] = !syndrome[0] &  syndrome[1] & !syndrome[2] & !syndrome[3] & syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*4] =  syndrome[0] &  syndrome[1] & !syndrome[2] & !syndrome[3] & syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*4] = !syndrome[0] & !syndrome[1] &  syndrome[2] & !syndrome[3] & syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*4] =  syndrome[0] & !syndrome[1] &  syndrome[2] & !syndrome[3] & syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*4] = !syndrome[0] &  syndrome[1] &  syndrome[2] & !syndrome[3] & syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*4] =  syndrome[0] &  syndrome[1] &  syndrome[2] & !syndrome[3] & syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*5] = !syndrome[0] & !syndrome[1] & !syndrome[2] &  syndrome[3] & !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*5] =  syndrome[0] & !syndrome[1] & !syndrome[2] &  syndrome[3] & !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*5] = !syndrome[0] &  syndrome[1] & !syndrome[2] &  syndrome[3] & !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*5] =  syndrome[0] &  syndrome[1] & !syndrome[2] &  syndrome[3] & !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*5] = !syndrome[0] & !syndrome[1] &  syndrome[2] &  syndrome[3] & !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*5] =  syndrome[0] & !syndrome[1] &  syndrome[2] &  syndrome[3] & !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*5] = !syndrome[0] &  syndrome[1] &  syndrome[2] &  syndrome[3] & !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*5] =  syndrome[0] &  syndrome[1] &  syndrome[2] &  syndrome[3] & !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*6] = !syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] &  syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*6] =  syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] &  syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*6] = !syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] &  syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*6] =  syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] &  syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*6] = !syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] &  syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*6] =  syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] &  syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*6] = !syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] &  syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*6] =  syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] &  syndrome[4] &  syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*7] = !syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] &  !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*7] =  syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] &  !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*7] = !syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] &  !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*7] =  syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] &  !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*7] = !syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] &  !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*7] =  syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] &  !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*7] = !syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] &  !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*7] =  syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] &  !syndrome[4] &  !syndrome[5] & syndrome[6] & syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*8] = !syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*8] =  syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*8] = !syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*8] =  syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*8] = !syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*8] =  syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*8] = !syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*8] =  syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*9] = !syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] & syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*9] =  syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] & syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*9] = !syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] & syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*9] =  syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] & syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*9] = !syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] & syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*9] =  syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] & syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*9] = !syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] & syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*9] =  syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] & syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*10] = !syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] &  syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*10] =  syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] &  syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*10] = !syndrome[0] &  syndrome[1] & !syndrome[2] & !syndrome[3] &  syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*10] =  syndrome[0] &  syndrome[1] & !syndrome[2] & !syndrome[3] &  syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*10] = !syndrome[0] & !syndrome[1] &  syndrome[2] & !syndrome[3] &  syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*10] =  syndrome[0] & !syndrome[1] &  syndrome[2] & !syndrome[3] &  syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*10] = !syndrome[0] &  syndrome[1] &  syndrome[2] & !syndrome[3] &  syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*10] =  syndrome[0] &  syndrome[1] &  syndrome[2] & !syndrome[3] &  syndrome[4] & !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*11] = !syndrome[0] & !syndrome[1] & !syndrome[2] &  syndrome[3] &  !syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*11] =  syndrome[0] & !syndrome[1] & !syndrome[2] &  syndrome[3] &  !syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*11] = !syndrome[0] &  syndrome[1] & !syndrome[2] &  syndrome[3] &  !syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*11] =  syndrome[0] &  syndrome[1] & !syndrome[2] &  syndrome[3] &  !syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*11] = !syndrome[0] & !syndrome[1] &  syndrome[2] &  syndrome[3] &  !syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*11] =  syndrome[0] & !syndrome[1] &  syndrome[2] &  syndrome[3] &  !syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*11] = !syndrome[0] &  syndrome[1] &  syndrome[2] &  syndrome[3] &  !syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*11] =  syndrome[0] &  syndrome[1] &  syndrome[2] &  syndrome[3] &  !syndrome[4] & syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*12] = !syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] & syndrome[4] &  !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*12] =  syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] & syndrome[4] &  !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*12] = !syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] & syndrome[4] &  !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*12] =  syndrome[0] &  syndrome[1] & !syndrome[2] & syndrome[3] & syndrome[4] &  !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*12] = !syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] & syndrome[4] &  !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*12] =  syndrome[0] & !syndrome[1] &  syndrome[2] & syndrome[3] & syndrome[4] &  !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*12] = !syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] & syndrome[4] &  !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*12] =  syndrome[0] &  syndrome[1] &  syndrome[2] & syndrome[3] & syndrome[4] &  !syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*13] = !syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] & !syndrome[4] &  syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*13] =  syndrome[0] & !syndrome[1] & !syndrome[2] &  !syndrome[3] & !syndrome[4] &  syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*13] = !syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] & !syndrome[4] &  syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*13] =  syndrome[0] &  syndrome[1] & !syndrome[2] &  !syndrome[3] & !syndrome[4] &  syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*13] = !syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] & !syndrome[4] &  syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*13] =  syndrome[0] & !syndrome[1] &  syndrome[2] &  !syndrome[3] & !syndrome[4] &  syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*13] = !syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] & !syndrome[4] &  syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*13] =  syndrome[0] &  syndrome[1] &  syndrome[2] &  !syndrome[3] & !syndrome[4] &  syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*14] = !syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] &  !syndrome[4] &  syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*14] =  syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] &  !syndrome[4] &  syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*14] = !syndrome[0] &  syndrome[1] & !syndrome[2] & !syndrome[3] &  !syndrome[4] &  syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*14] =  syndrome[0] &  syndrome[1] & !syndrome[2] & !syndrome[3] &  !syndrome[4] &  syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*14] = !syndrome[0] & !syndrome[1] &  syndrome[2] & !syndrome[3] &  !syndrome[4] &  syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*14] =  syndrome[0] & !syndrome[1] &  syndrome[2] & !syndrome[3] &  !syndrome[4] &  syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*14] = !syndrome[0] &  syndrome[1] &  syndrome[2] & !syndrome[3] &  !syndrome[4] &  syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*14] =  syndrome[0] &  syndrome[1] &  syndrome[2] & !syndrome[3] &  !syndrome[4] &  syndrome[5] &  syndrome[6] & !syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*15] = !syndrome[0] & !syndrome[1] & !syndrome[2] &  syndrome[3] &  syndrome[4] &  !syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*15] =  syndrome[0] & !syndrome[1] & !syndrome[2] &  syndrome[3] &  syndrome[4] &  !syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*15] = !syndrome[0] &  syndrome[1] & !syndrome[2] &  syndrome[3] &  syndrome[4] &  !syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*15] =  syndrome[0] &  syndrome[1] & !syndrome[2] &  syndrome[3] &  syndrome[4] &  !syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*15] = !syndrome[0] & !syndrome[1] &  syndrome[2] &  syndrome[3] &  syndrome[4] &  !syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*15] =  syndrome[0] & !syndrome[1] &  syndrome[2] &  syndrome[3] &  syndrome[4] &  !syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*15] = !syndrome[0] &  syndrome[1] &  syndrome[2] &  syndrome[3] &  syndrome[4] &  !syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*15] =  syndrome[0] &  syndrome[1] &  syndrome[2] &  syndrome[3] &  syndrome[4] &  !syndrome[5] &  !syndrome[6] & syndrome[7] & syndrome[8];

assign error_locator_poly[0+8*16] = syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] & !syndrome[4] & !syndrome[5] & !syndrome[6] &  !syndrome[7] & syndrome[8];
assign error_locator_poly[1+8*16] = !syndrome[0] & syndrome[1] & !syndrome[2] & !syndrome[3] & !syndrome[4] & !syndrome[5] & !syndrome[6] &  !syndrome[7] & syndrome[8];
assign error_locator_poly[2+8*16] = !syndrome[0] & !syndrome[1] & syndrome[2] & !syndrome[3] & !syndrome[4] & !syndrome[5] & !syndrome[6] &  !syndrome[7] & syndrome[8];
assign error_locator_poly[3+8*16] = !syndrome[0] & !syndrome[1] & !syndrome[2] & syndrome[3] & !syndrome[4] & !syndrome[5] & !syndrome[6] &  !syndrome[7] & syndrome[8];
assign error_locator_poly[4+8*16] = !syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] & syndrome[4] & !syndrome[5] & !syndrome[6] &  !syndrome[7] & syndrome[8];
assign error_locator_poly[5+8*16] = !syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] & !syndrome[4] & syndrome[5] & !syndrome[6] &  !syndrome[7] & syndrome[8];
assign error_locator_poly[6+8*16] = !syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] & !syndrome[4] & !syndrome[5] & syndrome[6] & !syndrome[7] & syndrome[8];
assign error_locator_poly[7+8*16] = !syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] & !syndrome[4] & !syndrome[5] & !syndrome[6] &  syndrome[7] & syndrome[8];
assign error_locator_poly[8+8*16] = !syndrome[0] & !syndrome[1] & !syndrome[2] & !syndrome[3] & !syndrome[4] & !syndrome[5] & !syndrome[6] & !syndrome[7] & syndrome[8];

endmodule