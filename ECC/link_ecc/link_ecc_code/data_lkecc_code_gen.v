`include "ddr_ctl_define.vh"
module data_lkecc_code_gen(
    input wire  [127:0]          enc_datain  ,
    output wire [8:0]            enc_dataout 
);

wire cb0;
wire cb1;
wire cb2;
wire cb3;
wire cb4;
wire cb5;
wire cb6;
wire cb7;
wire cb8;

assign enc_dataout = {cb8,cb7,cb6,cb5,cb4,cb3,cb2,cb1,cb0};

assign cb0 = enc_datain[1+8*0]  ^ enc_datain[3+8*0]  ^ enc_datain[5+8*0]  ^ enc_datain[7+8*0]  ^
             enc_datain[1+8*1]  ^ enc_datain[3+8*1]  ^ enc_datain[5+8*1]  ^ enc_datain[7+8*1]  ^
             enc_datain[1+8*2]  ^ enc_datain[3+8*2]  ^ enc_datain[5+8*2]  ^ enc_datain[7+8*2]  ^
             enc_datain[1+8*3]  ^ enc_datain[3+8*3]  ^ enc_datain[5+8*3]  ^ enc_datain[7+8*3]  ^
             enc_datain[1+8*4]  ^ enc_datain[3+8*4]  ^ enc_datain[5+8*4]  ^ enc_datain[7+8*4]  ^
             enc_datain[1+8*5]  ^ enc_datain[3+8*5]  ^ enc_datain[5+8*5]  ^ enc_datain[7+8*5]  ^
             enc_datain[1+8*6]  ^ enc_datain[3+8*6]  ^ enc_datain[5+8*6]  ^ enc_datain[7+8*6]  ^
             enc_datain[1+8*7]  ^ enc_datain[3+8*7]  ^ enc_datain[5+8*7]  ^ enc_datain[7+8*7]  ^
             enc_datain[1+8*8]  ^ enc_datain[3+8*8]  ^ enc_datain[5+8*8]  ^ enc_datain[7+8*8]  ^
             enc_datain[1+8*9]  ^ enc_datain[3+8*9]  ^ enc_datain[5+8*9]  ^ enc_datain[7+8*9]  ^
             enc_datain[1+8*10] ^ enc_datain[3+8*10] ^ enc_datain[5+8*10] ^ enc_datain[7+8*10] ^
             enc_datain[1+8*11] ^ enc_datain[3+8*11] ^ enc_datain[5+8*11] ^ enc_datain[7+8*11] ^
             enc_datain[1+8*12] ^ enc_datain[3+8*12] ^ enc_datain[5+8*12] ^ enc_datain[7+8*12] ^
             enc_datain[1+8*13] ^ enc_datain[3+8*13] ^ enc_datain[5+8*13] ^ enc_datain[7+8*13] ^
             enc_datain[1+8*14] ^ enc_datain[3+8*14] ^ enc_datain[5+8*14] ^ enc_datain[7+8*14] ^
             enc_datain[1+8*15] ^ enc_datain[3+8*15] ^ enc_datain[5+8*15] ^ enc_datain[7+8*15] ;

assign cb1 = enc_datain[2+8*0]  ^ enc_datain[3+8*0]  ^ enc_datain[6+8*0]  ^ enc_datain[7+8*0]  ^
             enc_datain[2+8*1]  ^ enc_datain[3+8*1]  ^ enc_datain[6+8*1]  ^ enc_datain[7+8*1]  ^
             enc_datain[2+8*2]  ^ enc_datain[3+8*2]  ^ enc_datain[6+8*2]  ^ enc_datain[7+8*2]  ^
             enc_datain[2+8*3]  ^ enc_datain[3+8*3]  ^ enc_datain[6+8*3]  ^ enc_datain[7+8*3]  ^
             enc_datain[2+8*4]  ^ enc_datain[3+8*4]  ^ enc_datain[6+8*4]  ^ enc_datain[7+8*4]  ^
             enc_datain[2+8*5]  ^ enc_datain[3+8*5]  ^ enc_datain[6+8*5]  ^ enc_datain[7+8*5]  ^
             enc_datain[2+8*6]  ^ enc_datain[3+8*6]  ^ enc_datain[6+8*6]  ^ enc_datain[7+8*6]  ^
             enc_datain[2+8*7]  ^ enc_datain[3+8*7]  ^ enc_datain[6+8*7]  ^ enc_datain[7+8*7]  ^
             enc_datain[2+8*8]  ^ enc_datain[3+8*8]  ^ enc_datain[6+8*8]  ^ enc_datain[7+8*8]  ^
             enc_datain[2+8*9]  ^ enc_datain[3+8*9]  ^ enc_datain[6+8*9]  ^ enc_datain[7+8*9]  ^
             enc_datain[2+8*10] ^ enc_datain[3+8*10] ^ enc_datain[6+8*10] ^ enc_datain[7+8*10] ^
             enc_datain[2+8*11] ^ enc_datain[3+8*11] ^ enc_datain[6+8*11] ^ enc_datain[7+8*11] ^
             enc_datain[2+8*12] ^ enc_datain[3+8*12] ^ enc_datain[6+8*12] ^ enc_datain[7+8*12] ^
             enc_datain[2+8*13] ^ enc_datain[3+8*13] ^ enc_datain[6+8*13] ^ enc_datain[7+8*13] ^
             enc_datain[2+8*14] ^ enc_datain[3+8*14] ^ enc_datain[6+8*14] ^ enc_datain[7+8*14] ^
             enc_datain[2+8*15] ^ enc_datain[3+8*15] ^ enc_datain[6+8*15] ^ enc_datain[7+8*15] ;

assign cb2 = enc_datain[4+8*0]  ^ enc_datain[5+8*0]  ^ enc_datain[6+8*0]  ^ enc_datain[7+8*0]  ^
             enc_datain[4+8*1]  ^ enc_datain[5+8*1]  ^ enc_datain[6+8*1]  ^ enc_datain[7+8*1]  ^
             enc_datain[4+8*2]  ^ enc_datain[5+8*2]  ^ enc_datain[6+8*2]  ^ enc_datain[7+8*2]  ^
             enc_datain[4+8*3]  ^ enc_datain[5+8*3]  ^ enc_datain[6+8*3]  ^ enc_datain[7+8*3]  ^
             enc_datain[4+8*4]  ^ enc_datain[5+8*4]  ^ enc_datain[6+8*4]  ^ enc_datain[7+8*4]  ^
             enc_datain[4+8*5]  ^ enc_datain[5+8*5]  ^ enc_datain[6+8*5]  ^ enc_datain[7+8*5]  ^
             enc_datain[4+8*6]  ^ enc_datain[5+8*6]  ^ enc_datain[6+8*6]  ^ enc_datain[7+8*6]  ^
             enc_datain[4+8*7]  ^ enc_datain[5+8*7]  ^ enc_datain[6+8*7]  ^ enc_datain[7+8*7]  ^
             enc_datain[4+8*8]  ^ enc_datain[5+8*8]  ^ enc_datain[6+8*8]  ^ enc_datain[7+8*8]  ^
             enc_datain[4+8*9]  ^ enc_datain[5+8*9]  ^ enc_datain[6+8*9]  ^ enc_datain[7+8*9]  ^
             enc_datain[4+8*10] ^ enc_datain[5+8*10] ^ enc_datain[6+8*10] ^ enc_datain[7+8*10] ^
             enc_datain[4+8*11] ^ enc_datain[5+8*11] ^ enc_datain[6+8*11] ^ enc_datain[7+8*11] ^
             enc_datain[4+8*12] ^ enc_datain[5+8*12] ^ enc_datain[6+8*12] ^ enc_datain[7+8*12] ^
             enc_datain[4+8*13] ^ enc_datain[5+8*13] ^ enc_datain[6+8*13] ^ enc_datain[7+8*13] ^
             enc_datain[4+8*14] ^ enc_datain[5+8*14] ^ enc_datain[6+8*14] ^ enc_datain[7+8*14] ^
             enc_datain[4+8*15] ^ enc_datain[5+8*15] ^ enc_datain[6+8*15] ^ enc_datain[7+8*15] ;

assign cb3 = enc_datain[0+8*0]  ^ enc_datain[1+8*0]  ^ enc_datain[2+8*0]  ^ enc_datain[3+8*0]  ^ enc_datain[4+8*0]  ^ enc_datain[5+8*0]  ^ enc_datain[6+8*0]  ^ enc_datain[7+8*0]  ^
             enc_datain[0+8*2]  ^ enc_datain[1+8*2]  ^ enc_datain[2+8*2]  ^ enc_datain[3+8*2]  ^ enc_datain[4+8*2]  ^ enc_datain[5+8*2]  ^ enc_datain[6+8*2]  ^ enc_datain[7+8*2]  ^
             enc_datain[0+8*5]  ^ enc_datain[1+8*5]  ^ enc_datain[2+8*5]  ^ enc_datain[3+8*5]  ^ enc_datain[4+8*5]  ^ enc_datain[5+8*5]  ^ enc_datain[6+8*5]  ^ enc_datain[7+8*5]  ^
             enc_datain[0+8*6]  ^ enc_datain[1+8*6]  ^ enc_datain[2+8*6]  ^ enc_datain[3+8*6]  ^ enc_datain[4+8*6]  ^ enc_datain[5+8*6]  ^ enc_datain[6+8*6]  ^ enc_datain[7+8*6]  ^
             enc_datain[0+8*8]  ^ enc_datain[1+8*8]  ^ enc_datain[2+8*8]  ^ enc_datain[3+8*8]  ^ enc_datain[4+8*8]  ^ enc_datain[5+8*8]  ^ enc_datain[6+8*8]  ^ enc_datain[7+8*8]  ^
             enc_datain[0+8*11] ^ enc_datain[1+8*11] ^ enc_datain[2+8*11] ^ enc_datain[3+8*11] ^ enc_datain[4+8*11] ^ enc_datain[5+8*11] ^ enc_datain[6+8*11] ^ enc_datain[7+8*11] ^
             enc_datain[0+8*12] ^ enc_datain[1+8*12] ^ enc_datain[2+8*12] ^ enc_datain[3+8*12] ^ enc_datain[4+8*12] ^ enc_datain[5+8*12] ^ enc_datain[6+8*12] ^ enc_datain[7+8*12] ^
             enc_datain[0+8*15] ^ enc_datain[1+8*15] ^ enc_datain[2+8*15] ^ enc_datain[3+8*15] ^ enc_datain[4+8*15] ^ enc_datain[5+8*15] ^ enc_datain[6+8*15] ^ enc_datain[7+8*15] ;

assign cb4 = enc_datain[0+8*0]  ^ enc_datain[1+8*0]  ^ enc_datain[2+8*0]  ^ enc_datain[3+8*0]  ^ enc_datain[4+8*0]  ^ enc_datain[5+8*0]  ^ enc_datain[6+8*0]  ^ enc_datain[7+8*0]  ^
             enc_datain[0+8*3]  ^ enc_datain[1+8*3]  ^ enc_datain[2+8*3]  ^ enc_datain[3+8*3]  ^ enc_datain[4+8*3]  ^ enc_datain[5+8*3]  ^ enc_datain[6+8*3]  ^ enc_datain[7+8*3]  ^
             enc_datain[0+8*4]  ^ enc_datain[1+8*4]  ^ enc_datain[2+8*4]  ^ enc_datain[3+8*4]  ^ enc_datain[4+8*4]  ^ enc_datain[5+8*4]  ^ enc_datain[6+8*4]  ^ enc_datain[7+8*4]  ^
             enc_datain[0+8*6]  ^ enc_datain[1+8*6]  ^ enc_datain[2+8*6]  ^ enc_datain[3+8*6]  ^ enc_datain[4+8*6]  ^ enc_datain[5+8*6]  ^ enc_datain[6+8*6]  ^ enc_datain[7+8*6]  ^
             enc_datain[0+8*9]  ^ enc_datain[1+8*9]  ^ enc_datain[2+8*9]  ^ enc_datain[3+8*9]  ^ enc_datain[4+8*9]  ^ enc_datain[5+8*9]  ^ enc_datain[6+8*9]  ^ enc_datain[7+8*9]  ^
             enc_datain[0+8*10] ^ enc_datain[1+8*10] ^ enc_datain[2+8*10] ^ enc_datain[3+8*10] ^ enc_datain[4+8*10] ^ enc_datain[5+8*10] ^ enc_datain[6+8*10] ^ enc_datain[7+8*10] ^
             enc_datain[0+8*12] ^ enc_datain[1+8*12] ^ enc_datain[2+8*12] ^ enc_datain[3+8*12] ^ enc_datain[4+8*12] ^ enc_datain[5+8*12] ^ enc_datain[6+8*12] ^ enc_datain[7+8*12] ^
             enc_datain[0+8*15] ^ enc_datain[1+8*15] ^ enc_datain[2+8*15] ^ enc_datain[3+8*15] ^ enc_datain[4+8*15] ^ enc_datain[5+8*15] ^ enc_datain[6+8*15] ^ enc_datain[7+8*15] ;

assign cb5 = enc_datain[0+8*1]  ^ enc_datain[1+8*1]  ^ enc_datain[2+8*1]  ^ enc_datain[3+8*1]  ^ enc_datain[4+8*1]  ^ enc_datain[5+8*1]  ^ enc_datain[6+8*1]  ^ enc_datain[7+8*1]  ^
             enc_datain[0+8*2]  ^ enc_datain[1+8*2]  ^ enc_datain[2+8*2]  ^ enc_datain[3+8*2]  ^ enc_datain[4+8*2]  ^ enc_datain[5+8*2]  ^ enc_datain[6+8*2]  ^ enc_datain[7+8*2]  ^
             enc_datain[0+8*4]  ^ enc_datain[1+8*4]  ^ enc_datain[2+8*4]  ^ enc_datain[3+8*4]  ^ enc_datain[4+8*4]  ^ enc_datain[5+8*4]  ^ enc_datain[6+8*4]  ^ enc_datain[7+8*4]  ^
             enc_datain[0+8*6]  ^ enc_datain[1+8*6]  ^ enc_datain[2+8*6]  ^ enc_datain[3+8*6]  ^ enc_datain[4+8*6]  ^ enc_datain[5+8*6]  ^ enc_datain[6+8*6]  ^ enc_datain[7+8*6]  ^
             enc_datain[0+8*9]  ^ enc_datain[1+8*9]  ^ enc_datain[2+8*9]  ^ enc_datain[3+8*9]  ^ enc_datain[4+8*9]  ^ enc_datain[5+8*9]  ^ enc_datain[6+8*9]  ^ enc_datain[7+8*9]  ^
             enc_datain[0+8*11] ^ enc_datain[1+8*11] ^ enc_datain[2+8*11] ^ enc_datain[3+8*11] ^ enc_datain[4+8*11] ^ enc_datain[5+8*11] ^ enc_datain[6+8*11] ^ enc_datain[7+8*11] ^
             enc_datain[0+8*13] ^ enc_datain[1+8*13] ^ enc_datain[2+8*13] ^ enc_datain[3+8*13] ^ enc_datain[4+8*13] ^ enc_datain[5+8*13] ^ enc_datain[6+8*13] ^ enc_datain[7+8*13] ^
             enc_datain[0+8*14] ^ enc_datain[1+8*14] ^ enc_datain[2+8*14] ^ enc_datain[3+8*14] ^ enc_datain[4+8*14] ^ enc_datain[5+8*14] ^ enc_datain[6+8*14] ^ enc_datain[7+8*14] ;

assign cb6 = enc_datain[0+8*1]  ^ enc_datain[1+8*1]  ^ enc_datain[2+8*1]  ^ enc_datain[3+8*1]  ^ enc_datain[4+8*1]  ^ enc_datain[5+8*1]  ^ enc_datain[6+8*1]  ^ enc_datain[7+8*1]  ^
             enc_datain[0+8*3]  ^ enc_datain[1+8*3]  ^ enc_datain[2+8*3]  ^ enc_datain[3+8*3]  ^ enc_datain[4+8*3]  ^ enc_datain[5+8*3]  ^ enc_datain[6+8*3]  ^ enc_datain[7+8*3]  ^
             enc_datain[0+8*5]  ^ enc_datain[1+8*5]  ^ enc_datain[2+8*5]  ^ enc_datain[3+8*5]  ^ enc_datain[4+8*5]  ^ enc_datain[5+8*5]  ^ enc_datain[6+8*5]  ^ enc_datain[7+8*5]  ^
             enc_datain[0+8*7]  ^ enc_datain[1+8*7]  ^ enc_datain[2+8*7]  ^ enc_datain[3+8*7]  ^ enc_datain[4+8*7]  ^ enc_datain[5+8*7]  ^ enc_datain[6+8*7]  ^ enc_datain[7+8*7]  ^
             enc_datain[0+8*8]  ^ enc_datain[1+8*8]  ^ enc_datain[2+8*8]  ^ enc_datain[3+8*8]  ^ enc_datain[4+8*8]  ^ enc_datain[5+8*8]  ^ enc_datain[6+8*8]  ^ enc_datain[7+8*8]  ^
             enc_datain[0+8*10] ^ enc_datain[1+8*10] ^ enc_datain[2+8*10] ^ enc_datain[3+8*10] ^ enc_datain[4+8*10] ^ enc_datain[5+8*10] ^ enc_datain[6+8*10] ^ enc_datain[7+8*10] ^
             enc_datain[0+8*12] ^ enc_datain[1+8*12] ^ enc_datain[2+8*12] ^ enc_datain[3+8*12] ^ enc_datain[4+8*12] ^ enc_datain[5+8*12] ^ enc_datain[6+8*12] ^ enc_datain[7+8*12] ^
             enc_datain[0+8*14] ^ enc_datain[1+8*14] ^ enc_datain[2+8*14] ^ enc_datain[3+8*14] ^ enc_datain[4+8*14] ^ enc_datain[5+8*14] ^ enc_datain[6+8*14] ^ enc_datain[7+8*14] ;

assign cb7 = enc_datain[0+8*1]  ^ enc_datain[1+8*1]  ^ enc_datain[2+8*1]  ^ enc_datain[3+8*1]  ^ enc_datain[4+8*1]  ^ enc_datain[5+8*1]  ^ enc_datain[6+8*1]  ^ enc_datain[7+8*1]  ^
             enc_datain[0+8*3]  ^ enc_datain[1+8*3]  ^ enc_datain[2+8*3]  ^ enc_datain[3+8*3]  ^ enc_datain[4+8*3]  ^ enc_datain[5+8*3]  ^ enc_datain[6+8*3]  ^ enc_datain[7+8*3]  ^
             enc_datain[0+8*5]  ^ enc_datain[1+8*5]  ^ enc_datain[2+8*5]  ^ enc_datain[3+8*5]  ^ enc_datain[4+8*5]  ^ enc_datain[5+8*5]  ^ enc_datain[6+8*5]  ^ enc_datain[7+8*5]  ^
             enc_datain[0+8*7]  ^ enc_datain[1+8*7]  ^ enc_datain[2+8*7]  ^ enc_datain[3+8*7]  ^ enc_datain[4+8*7]  ^ enc_datain[5+8*7]  ^ enc_datain[6+8*7]  ^ enc_datain[7+8*7]  ^
             enc_datain[0+8*9]  ^ enc_datain[1+8*9]  ^ enc_datain[2+8*9]  ^ enc_datain[3+8*9]  ^ enc_datain[4+8*9]  ^ enc_datain[5+8*9]  ^ enc_datain[6+8*9]  ^ enc_datain[7+8*9]  ^
             enc_datain[0+8*11] ^ enc_datain[1+8*11] ^ enc_datain[2+8*11] ^ enc_datain[3+8*11] ^ enc_datain[4+8*11] ^ enc_datain[5+8*11] ^ enc_datain[6+8*11] ^ enc_datain[7+8*11] ^
             enc_datain[0+8*13] ^ enc_datain[1+8*13] ^ enc_datain[2+8*13] ^ enc_datain[3+8*13] ^ enc_datain[4+8*13] ^ enc_datain[5+8*13] ^ enc_datain[6+8*13] ^ enc_datain[7+8*13] ^
             enc_datain[0+8*15] ^ enc_datain[1+8*15] ^ enc_datain[2+8*15] ^ enc_datain[3+8*15] ^ enc_datain[4+8*15] ^ enc_datain[5+8*15] ^ enc_datain[6+8*15] ^ enc_datain[7+8*15] ;

assign cb8 = ^(enc_datain) ^ cb0 ^ cb1 ^ cb2 ^ cb3 ^ cb4 ^ cb5 ^ cb6 ^ cb7;

endmodule