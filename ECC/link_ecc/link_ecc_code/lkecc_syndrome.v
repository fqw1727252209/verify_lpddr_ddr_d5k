`include "ddr_ctl_define.vh"

module lkecc_syndrome(
    input  wire [127:0]             dec_datain         ,
    input  wire [8:0]               dec_data_ecc       ,
    output wire [8:0]               dec_data_syndrome
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

assign dec_data_syndrome[0] = dec_data_ecc[0] ^ cb0;
assign dec_data_syndrome[1] = dec_data_ecc[1] ^ cb1;
assign dec_data_syndrome[2] = dec_data_ecc[2] ^ cb2;
assign dec_data_syndrome[3] = dec_data_ecc[3] ^ cb3;
assign dec_data_syndrome[4] = dec_data_ecc[4] ^ cb4;
assign dec_data_syndrome[5] = dec_data_ecc[5] ^ cb5;
assign dec_data_syndrome[6] = dec_data_ecc[6] ^ cb6;
assign dec_data_syndrome[7] = dec_data_ecc[7] ^ cb7;
assign dec_data_syndrome[8] = dec_data_ecc[8] ^ cb8;

assign cb0 = dec_datain[1+8*0]  ^ dec_datain[3+8*0]  ^ dec_datain[5+8*0]  ^ dec_datain[7+8*0]  ^
             dec_datain[1+8*1]  ^ dec_datain[3+8*1]  ^ dec_datain[5+8*1]  ^ dec_datain[7+8*1]  ^
             dec_datain[1+8*2]  ^ dec_datain[3+8*2]  ^ dec_datain[5+8*2]  ^ dec_datain[7+8*2]  ^
             dec_datain[1+8*3]  ^ dec_datain[3+8*3]  ^ dec_datain[5+8*3]  ^ dec_datain[7+8*3]  ^
             dec_datain[1+8*4]  ^ dec_datain[3+8*4]  ^ dec_datain[5+8*4]  ^ dec_datain[7+8*4]  ^
             dec_datain[1+8*5]  ^ dec_datain[3+8*5]  ^ dec_datain[5+8*5]  ^ dec_datain[7+8*5]  ^
             dec_datain[1+8*6]  ^ dec_datain[3+8*6]  ^ dec_datain[5+8*6]  ^ dec_datain[7+8*6]  ^
             dec_datain[1+8*7]  ^ dec_datain[3+8*7]  ^ dec_datain[5+8*7]  ^ dec_datain[7+8*7]  ^
             dec_datain[1+8*8]  ^ dec_datain[3+8*8]  ^ dec_datain[5+8*8]  ^ dec_datain[7+8*8]  ^
             dec_datain[1+8*9]  ^ dec_datain[3+8*9]  ^ dec_datain[5+8*9]  ^ dec_datain[7+8*9]  ^
             dec_datain[1+8*10] ^ dec_datain[3+8*10] ^ dec_datain[5+8*10] ^ dec_datain[7+8*10] ^
             dec_datain[1+8*11] ^ dec_datain[3+8*11] ^ dec_datain[5+8*11] ^ dec_datain[7+8*11] ^
             dec_datain[1+8*12] ^ dec_datain[3+8*12] ^ dec_datain[5+8*12] ^ dec_datain[7+8*12] ^
             dec_datain[1+8*13] ^ dec_datain[3+8*13] ^ dec_datain[5+8*13] ^ dec_datain[7+8*13] ^
             dec_datain[1+8*14] ^ dec_datain[3+8*14] ^ dec_datain[5+8*14] ^ dec_datain[7+8*14] ^
             dec_datain[1+8*15] ^ dec_datain[3+8*15] ^ dec_datain[5+8*15] ^ dec_datain[7+8*15] ;

assign cb1 = dec_datain[2+8*0]  ^ dec_datain[3+8*0]  ^ dec_datain[6+8*0]  ^ dec_datain[7+8*0]  ^
             dec_datain[2+8*1]  ^ dec_datain[3+8*1]  ^ dec_datain[6+8*1]  ^ dec_datain[7+8*1]  ^
             dec_datain[2+8*2]  ^ dec_datain[3+8*2]  ^ dec_datain[6+8*2]  ^ dec_datain[7+8*2]  ^
             dec_datain[2+8*3]  ^ dec_datain[3+8*3]  ^ dec_datain[6+8*3]  ^ dec_datain[7+8*3]  ^
             dec_datain[2+8*4]  ^ dec_datain[3+8*4]  ^ dec_datain[6+8*4]  ^ dec_datain[7+8*4]  ^
             dec_datain[2+8*5]  ^ dec_datain[3+8*5]  ^ dec_datain[6+8*5]  ^ dec_datain[7+8*5]  ^
             dec_datain[2+8*6]  ^ dec_datain[3+8*6]  ^ dec_datain[6+8*6]  ^ dec_datain[7+8*6]  ^
             dec_datain[2+8*7]  ^ dec_datain[3+8*7]  ^ dec_datain[6+8*7]  ^ dec_datain[7+8*7]  ^
             dec_datain[2+8*8]  ^ dec_datain[3+8*8]  ^ dec_datain[6+8*8]  ^ dec_datain[7+8*8]  ^
             dec_datain[2+8*9]  ^ dec_datain[3+8*9]  ^ dec_datain[6+8*9]  ^ dec_datain[7+8*9]  ^
             dec_datain[2+8*10] ^ dec_datain[3+8*10] ^ dec_datain[6+8*10] ^ dec_datain[7+8*10] ^
             dec_datain[2+8*11] ^ dec_datain[3+8*11] ^ dec_datain[6+8*11] ^ dec_datain[7+8*11] ^
             dec_datain[2+8*12] ^ dec_datain[3+8*12] ^ dec_datain[6+8*12] ^ dec_datain[7+8*12] ^
             dec_datain[2+8*13] ^ dec_datain[3+8*13] ^ dec_datain[6+8*13] ^ dec_datain[7+8*13] ^
             dec_datain[2+8*14] ^ dec_datain[3+8*14] ^ dec_datain[6+8*14] ^ dec_datain[7+8*14] ^
             dec_datain[2+8*15] ^ dec_datain[3+8*15] ^ dec_datain[6+8*15] ^ dec_datain[7+8*15] ;

assign cb2 = dec_datain[4+8*0]  ^ dec_datain[5+8*0]  ^ dec_datain[6+8*0]  ^ dec_datain[7+8*0]  ^
             dec_datain[4+8*1]  ^ dec_datain[5+8*1]  ^ dec_datain[6+8*1]  ^ dec_datain[7+8*1]  ^
             dec_datain[4+8*2]  ^ dec_datain[5+8*2]  ^ dec_datain[6+8*2]  ^ dec_datain[7+8*2]  ^
             dec_datain[4+8*3]  ^ dec_datain[5+8*3]  ^ dec_datain[6+8*3]  ^ dec_datain[7+8*3]  ^
             dec_datain[4+8*4]  ^ dec_datain[5+8*4]  ^ dec_datain[6+8*4]  ^ dec_datain[7+8*4]  ^
             dec_datain[4+8*5]  ^ dec_datain[5+8*5]  ^ dec_datain[6+8*5]  ^ dec_datain[7+8*5]  ^
             dec_datain[4+8*6]  ^ dec_datain[5+8*6]  ^ dec_datain[6+8*6]  ^ dec_datain[7+8*6]  ^
             dec_datain[4+8*7]  ^ dec_datain[5+8*7]  ^ dec_datain[6+8*7]  ^ dec_datain[7+8*7]  ^
             dec_datain[4+8*8]  ^ dec_datain[5+8*8]  ^ dec_datain[6+8*8]  ^ dec_datain[7+8*8]  ^
             dec_datain[4+8*9]  ^ dec_datain[5+8*9]  ^ dec_datain[6+8*9]  ^ dec_datain[7+8*9]  ^
             dec_datain[4+8*10] ^ dec_datain[5+8*10] ^ dec_datain[6+8*10] ^ dec_datain[7+8*10] ^
             dec_datain[4+8*11] ^ dec_datain[5+8*11] ^ dec_datain[6+8*11] ^ dec_datain[7+8*11] ^
             dec_datain[4+8*12] ^ dec_datain[5+8*12] ^ dec_datain[6+8*12] ^ dec_datain[7+8*12] ^
             dec_datain[4+8*13] ^ dec_datain[5+8*13] ^ dec_datain[6+8*13] ^ dec_datain[7+8*13] ^
             dec_datain[4+8*14] ^ dec_datain[5+8*14] ^ dec_datain[6+8*14] ^ dec_datain[7+8*14] ^
             dec_datain[4+8*15] ^ dec_datain[5+8*15] ^ dec_datain[6+8*15] ^ dec_datain[7+8*15] ;

assign cb3 = dec_datain[0+8*0]  ^ dec_datain[1+8*0]  ^ dec_datain[2+8*0]  ^ dec_datain[3+8*0]  ^ dec_datain[4+8*0]  ^ dec_datain[5+8*0]  ^ dec_datain[6+8*0]  ^ dec_datain[7+8*0]  ^
             dec_datain[0+8*2]  ^ dec_datain[1+8*2]  ^ dec_datain[2+8*2]  ^ dec_datain[3+8*2]  ^ dec_datain[4+8*2]  ^ dec_datain[5+8*2]  ^ dec_datain[6+8*2]  ^ dec_datain[7+8*2]  ^
             dec_datain[0+8*5]  ^ dec_datain[1+8*5]  ^ dec_datain[2+8*5]  ^ dec_datain[3+8*5]  ^ dec_datain[4+8*5]  ^ dec_datain[5+8*5]  ^ dec_datain[6+8*5]  ^ dec_datain[7+8*5]  ^
             dec_datain[0+8*6]  ^ dec_datain[1+8*6]  ^ dec_datain[2+8*6]  ^ dec_datain[3+8*6]  ^ dec_datain[4+8*6]  ^ dec_datain[5+8*6]  ^ dec_datain[6+8*6]  ^ dec_datain[7+8*6]  ^
             dec_datain[0+8*8]  ^ dec_datain[1+8*8]  ^ dec_datain[2+8*8]  ^ dec_datain[3+8*8]  ^ dec_datain[4+8*8]  ^ dec_datain[5+8*8]  ^ dec_datain[6+8*8]  ^ dec_datain[7+8*8]  ^
             dec_datain[0+8*11] ^ dec_datain[1+8*11] ^ dec_datain[2+8*11] ^ dec_datain[3+8*11] ^ dec_datain[4+8*11] ^ dec_datain[5+8*11] ^ dec_datain[6+8*11] ^ dec_datain[7+8*11] ^
             dec_datain[0+8*12] ^ dec_datain[1+8*12] ^ dec_datain[2+8*12] ^ dec_datain[3+8*12] ^ dec_datain[4+8*12] ^ dec_datain[5+8*12] ^ dec_datain[6+8*12] ^ dec_datain[7+8*12] ^
             dec_datain[0+8*15] ^ dec_datain[1+8*15] ^ dec_datain[2+8*15] ^ dec_datain[3+8*15] ^ dec_datain[4+8*15] ^ dec_datain[5+8*15] ^ dec_datain[6+8*15] ^ dec_datain[7+8*15] ;

assign cb4 = dec_datain[0+8*0]  ^ dec_datain[1+8*0]  ^ dec_datain[2+8*0]  ^ dec_datain[3+8*0]  ^ dec_datain[4+8*0]  ^ dec_datain[5+8*0]  ^ dec_datain[6+8*0]  ^ dec_datain[7+8*0]  ^
             dec_datain[0+8*1]  ^ dec_datain[1+8*1]  ^ dec_datain[2+8*1]  ^ dec_datain[3+8*1]  ^ dec_datain[4+8*1]  ^ dec_datain[5+8*1]  ^ dec_datain[6+8*1]  ^ dec_datain[7+8*1]  ^
             dec_datain[0+8*3]  ^ dec_datain[1+8*3]  ^ dec_datain[2+8*3]  ^ dec_datain[3+8*3]  ^ dec_datain[4+8*3]  ^ dec_datain[5+8*3]  ^ dec_datain[6+8*3]  ^ dec_datain[7+8*3]  ^
             dec_datain[0+8*4]  ^ dec_datain[1+8*4]  ^ dec_datain[2+8*4]  ^ dec_datain[3+8*4]  ^ dec_datain[4+8*4]  ^ dec_datain[5+8*4]  ^ dec_datain[6+8*4]  ^ dec_datain[7+8*4]
             ^
             dec_datain[0+8*6]  ^ dec_datain[1+8*6]  ^ dec_datain[2+8*6]  ^ dec_datain[3+8*6]  ^ dec_datain[4+8*6]  ^ dec_datain[5+8*6]  ^ dec_datain[6+8*6]  ^ dec_datain[7+8*6]  ^
             dec_datain[0+8*9]  ^ dec_datain[1+8*9]  ^ dec_datain[2+8*9]  ^ dec_datain[3+8*9]  ^ dec_datain[4+8*9]  ^ dec_datain[5+8*9]  ^ dec_datain[6+8*9]  ^ dec_datain[7+8*9]  ^
             dec_datain[0+8*10] ^ dec_datain[1+8*10] ^ dec_datain[2+8*10] ^ dec_datain[3+8*10] ^ dec_datain[4+8*10] ^ dec_datain[5+8*10] ^ dec_datain[6+8*10] ^ dec_datain[7+8*10] ^
             dec_datain[0+8*12] ^ dec_datain[1+8*12] ^ dec_datain[2+8*12] ^ dec_datain[3+8*12] ^ dec_datain[4+8*12] ^ dec_datain[5+8*12] ^ dec_datain[6+8*12] ^ dec_datain[7+8*12] ^
             dec_datain[0+8*15] ^ dec_datain[1+8*15] ^ dec_datain[2+8*15] ^ dec_datain[3+8*15] ^ dec_datain[4+8*15] ^ dec_datain[5+8*15] ^ dec_datain[6+8*15] ^ dec_datain[7+8*15] ;

assign cb5 = dec_datain[0+8*1]  ^ dec_datain[1+8*1]  ^ dec_datain[2+8*1]  ^ dec_datain[3+8*1]  ^ dec_datain[4+8*1]  ^ dec_datain[5+8*1]  ^ dec_datain[6+8*1]  ^ dec_datain[7+8*1]  ^
             dec_datain[0+8*2]  ^ dec_datain[1+8*2]  ^ dec_datain[2+8*2]  ^ dec_datain[3+8*2]  ^ dec_datain[4+8*2]  ^ dec_datain[5+8*2]  ^ dec_datain[6+8*2]  ^ dec_datain[7+8*2]  ^
             dec_datain[0+8*4]  ^ dec_datain[1+8*4]  ^ dec_datain[2+8*4]  ^ dec_datain[3+8*4]  ^ dec_datain[4+8*4]  ^ dec_datain[5+8*4]  ^ dec_datain[6+8*4]  ^ dec_datain[7+8*4]  ^
             dec_datain[0+8*6]  ^ dec_datain[1+8*6]  ^ dec_datain[2+8*6]  ^ dec_datain[3+8*6]  ^ dec_datain[4+8*6]  ^ dec_datain[5+8*6]  ^ dec_datain[6+8*6]  ^ dec_datain[7+8*6]  ^
             dec_datain[0+8*9]  ^ dec_datain[1+8*9]  ^ dec_datain[2+8*9]  ^ dec_datain[3+8*9]  ^ dec_datain[4+8*9]  ^ dec_datain[5+8*9]  ^ dec_datain[6+8*9]  ^ dec_datain[7+8*9]  ^
             dec_datain[0+8*11] ^ dec_datain[1+8*11] ^ dec_datain[2+8*11] ^ dec_datain[3+8*11] ^ dec_datain[4+8*11] ^ dec_datain[5+8*11] ^ dec_datain[6+8*11] ^ dec_datain[7+8*11] ^
             dec_datain[0+8*13] ^ dec_datain[1+8*13] ^ dec_datain[2+8*13] ^ dec_datain[3+8*13] ^ dec_datain[4+8*13] ^ dec_datain[5+8*13] ^ dec_datain[6+8*13] ^ dec_datain[7+8*13] ^
             dec_datain[0+8*14] ^ dec_datain[1+8*14] ^ dec_datain[2+8*14] ^ dec_datain[3+8*14] ^ dec_datain[4+8*14] ^ dec_datain[5+8*14] ^ dec_datain[6+8*14] ^ dec_datain[7+8*14] ;

assign cb6 = dec_datain[0+8*1]  ^ dec_datain[1+8*1]  ^ dec_datain[2+8*1]  ^ dec_datain[3+8*1]  ^ dec_datain[4+8*1]  ^ dec_datain[5+8*1]  ^ dec_datain[6+8*1]  ^ dec_datain[7+8*1]  ^
             dec_datain[0+8*3]  ^ dec_datain[1+8*3]  ^ dec_datain[2+8*3]  ^ dec_datain[3+8*3]  ^ dec_datain[4+8*3]  ^ dec_datain[5+8*3]  ^ dec_datain[6+8*3]  ^ dec_datain[7+8*3]  ^
             dec_datain[0+8*5]  ^ dec_datain[1+8*5]  ^ dec_datain[2+8*5]  ^ dec_datain[3+8*5]  ^ dec_datain[4+8*5]  ^ dec_datain[5+8*5]  ^ dec_datain[6+8*5]  ^ dec_datain[7+8*5]  ^
             dec_datain[0+8*7]  ^ dec_datain[1+8*7]  ^ dec_datain[2+8*7]  ^ dec_datain[3+8*7]  ^ dec_datain[4+8*7]  ^ dec_datain[5+8*7]  ^ dec_datain[6+8*7]  ^ dec_datain[7+8*7]  ^
             dec_datain[0+8*8]  ^ dec_datain[1+8*8]  ^ dec_datain[2+8*8]  ^ dec_datain[3+8*8]  ^ dec_datain[4+8*8]  ^ dec_datain[5+8*8]  ^ dec_datain[6+8*8]  ^ dec_datain[7+8*8]  ^
             dec_datain[0+8*10] ^ dec_datain[1+8*10] ^ dec_datain[2+8*10] ^ dec_datain[3+8*10] ^ dec_datain[4+8*10] ^ dec_datain[5+8*10] ^ dec_datain[6+8*10] ^ dec_datain[7+8*10] ^
             dec_datain[0+8*12] ^ dec_datain[1+8*12] ^ dec_datain[2+8*12] ^ dec_datain[3+8*12] ^ dec_datain[4+8*12] ^ dec_datain[5+8*12] ^ dec_datain[6+8*12] ^ dec_datain[7+8*12] ^
             dec_datain[0+8*14] ^ dec_datain[1+8*14] ^ dec_datain[2+8*14] ^ dec_datain[3+8*14] ^ dec_datain[4+8*14] ^ dec_datain[5+8*14] ^ dec_datain[6+8*14] ^ dec_datain[7+8*14] ;

assign cb7 = dec_datain[0+8*1]  ^ dec_datain[1+8*1]  ^ dec_datain[2+8*1]  ^ dec_datain[3+8*1]  ^ dec_datain[4+8*1]  ^ dec_datain[5+8*1]  ^ dec_datain[6+8*1]  ^ dec_datain[7+8*1]  ^
             dec_datain[0+8*3]  ^ dec_datain[1+8*3]  ^ dec_datain[2+8*3]  ^ dec_datain[3+8*3]  ^ dec_datain[4+8*3]  ^ dec_datain[5+8*3]  ^ dec_datain[6+8*3]  ^ dec_datain[7+8*3]  ^
             dec_datain[0+8*5]  ^ dec_datain[1+8*5]  ^ dec_datain[2+8*5]  ^ dec_datain[3+8*5]  ^ dec_datain[4+8*5]  ^ dec_datain[5+8*5]  ^ dec_datain[6+8*5]  ^ dec_datain[7+8*5]  ^
             dec_datain[0+8*7]  ^ dec_datain[1+8*7]  ^ dec_datain[2+8*7]  ^ dec_datain[3+8*7]  ^ dec_datain[4+8*7]  ^ dec_datain[5+8*7]  ^ dec_datain[6+8*7]  ^ dec_datain[7+8*7]  ^
             dec_datain[0+8*9]  ^ dec_datain[1+8*9]  ^ dec_datain[2+8*9]  ^ dec_datain[3+8*9]  ^ dec_datain[4+8*9]  ^ dec_datain[5+8*9]  ^ dec_datain[6+8*9]  ^ dec_datain[7+8*9]  ^
             dec_datain[0+8*11] ^ dec_datain[1+8*11] ^ dec_datain[2+8*11] ^ dec_datain[3+8*11] ^ dec_datain[4+8*11] ^ dec_datain[5+8*11] ^ dec_datain[6+8*11] ^ dec_datain[7+8*11] ^
             dec_datain[0+8*13] ^ dec_datain[1+8*13] ^ dec_datain[2+8*13] ^ dec_datain[3+8*13] ^ dec_datain[4+8*13] ^ dec_datain[5+8*13] ^ dec_datain[6+8*13] ^ dec_datain[7+8*13] ^
             dec_datain[0+8*15] ^ dec_datain[1+8*15] ^ dec_datain[2+8*15] ^ dec_datain[3+8*15] ^ dec_datain[4+8*15] ^ dec_datain[5+8*15] ^ dec_datain[6+8*15] ^ dec_datain[7+8*15] ;

/*
assign cb8 = dec_datain[0+8*0]  ^ dec_datain[3+8*0]  ^ dec_datain[5+8*0]  ^ dec_datain[6+8*0]  ^
             dec_datain[0+8*2]  ^ dec_datain[3+8*2]  ^ dec_datain[5+8*2]  ^ dec_datain[6+8*2]  ^
             dec_datain[0+8*4]  ^ dec_datain[3+8*4]  ^ dec_datain[5+8*4]  ^ dec_datain[6+8*4]  ^
             dec_datain[0+8*7]  ^ dec_datain[3+8*7]  ^ dec_datain[5+8*7]  ^ dec_datain[6+8*7]  ^
             dec_datain[0+8*8]  ^ dec_datain[3+8*8]  ^ dec_datain[5+8*8]  ^ dec_datain[6+8*8]  ^
             dec_datain[0+8*10] ^ dec_datain[3+8*10] ^ dec_datain[5+8*10] ^ dec_datain[6+8*10] ^
             dec_datain[0+8*13] ^ dec_datain[3+8*13] ^ dec_datain[5+8*13] ^ dec_datain[6+8*13] ^
             dec_datain[0+8*14] ^ dec_datain[3+8*14] ^ dec_datain[5+8*14] ^ dec_datain[6+8*14] ^
             
             dec_datain[1+8*1]  ^ dec_datain[2+8*1]  ^ dec_datain[4+8*1]  ^ dec_datain[7+8*1]  ^
             dec_datain[1+8*3]  ^ dec_datain[2+8*3]  ^ dec_datain[4+8*3]  ^ dec_datain[7+8*3]  ^
             dec_datain[1+8*5]  ^ dec_datain[2+8*5]  ^ dec_datain[4+8*5]  ^ dec_datain[7+8*5]  ^
             dec_datain[1+8*6]  ^ dec_datain[2+8*6]  ^ dec_datain[4+8*6]  ^ dec_datain[7+8*6]  ^
             dec_datain[1+8*9]  ^ dec_datain[2+8*9]  ^ dec_datain[4+8*9]  ^ dec_datain[7+8*9]  ^
             dec_datain[1+8*11] ^ dec_datain[2+8*11] ^ dec_datain[4+8*11] ^ dec_datain[7+8*11] ^
             dec_datain[1+8*12] ^ dec_datain[2+8*12] ^ dec_datain[4+8*12] ^ dec_datain[7+8*12] ^
             dec_datain[1+8*15] ^ dec_datain[2+8*15] ^ dec_datain[4+8*15] ^ dec_datain[7+8*15] ;
*/

assign cb8 = ^(dec_datain) ^
             dec_data_ecc[0] ^
             dec_data_ecc[1] ^
             dec_data_ecc[2] ^
             dec_data_ecc[3] ^
             dec_data_ecc[4] ^
             dec_data_ecc[5] ^
             dec_data_ecc[6] ^
             dec_data_ecc[7] ;

endmodule