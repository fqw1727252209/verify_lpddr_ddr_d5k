`include "ddr_ctl_define.vh"
module lkecc_correct(
    input wire [136:0]          dec_datain      ,
    input wire [136:0]          error_locator_poly,
    input wire                  corr_error      ,
    output wire [136:0]         dec_dataout     
);

assign dec_dataout = corr_error ? (dec_datain ^ error_locator_poly) : dec_datain;

endmodule