`include "ddr_ctl_define.vh"
module dmi_lkecc_code_gen(

    input  wire [15:0]              enc_datain  ,
    output wire [5:0]               enc_dataout
);

wire cb0;
wire cb1;
wire cb2;
wire cb3;
wire cb4;
wire cb5;

assign enc_dataout = {cb5,cb4,cb3,cb2,cb1,cb0};

assign cb0 = enc_datain[1] ^
             enc_datain[3] ^
             enc_datain[5] ^
             enc_datain[7] ^
             enc_datain[9] ^
             enc_datain[11] ^
             enc_datain[13] ^
             enc_datain[15] ;

assign cb1 = enc_datain[2] ^
             enc_datain[3] ^
             enc_datain[6] ^
             enc_datain[7] ^
             enc_datain[10] ^
             enc_datain[11] ^
             enc_datain[14] ^
             enc_datain[15] ;

assign cb2 = enc_datain[0] ^
             enc_datain[1] ^
             enc_datain[2] ^
             enc_datain[3] ^
             enc_datain[8] ^
             enc_datain[9] ^
             enc_datain[10] ^
             enc_datain[11] ^
             enc_datain[12] ^
             enc_datain[13] ^
             enc_datain[14] ^
             enc_datain[15] ;

assign cb3 = enc_datain[0] ^
             enc_datain[1] ^
             enc_datain[2] ^
             enc_datain[3] ^
             enc_datain[4] ^
             enc_datain[5] ^
             enc_datain[6] ^
             enc_datain[7] ^
             enc_datain[12] ^
             enc_datain[13] ^
             enc_datain[14] ^
             enc_datain[15] ;

assign cb4 = enc_datain[4] ^
             enc_datain[5] ^
             enc_datain[6] ^
             enc_datain[7] ^
             enc_datain[8] ^
             enc_datain[9] ^
             enc_datain[10] ^
             enc_datain[11] ^
             enc_datain[12] ^
             enc_datain[13] ^
             enc_datain[14] ^
             enc_datain[15] ;

assign cb5 = enc_datain[0] ^
             enc_datain[3] ^
             enc_datain[4] ^
             enc_datain[7] ^
             enc_datain[8] ^
             enc_datain[11] ^
             enc_datain[13] ^
             enc_datain[14] ;

endmodule