`timescale 1ns / 1ps

module Decoder_4to16(
    input [3:0] a,
    output [15:0] y
    );
wire [3:0] Na;
not (Na[0],a[0]);
not (Na[1],a[1]);
not (Na[2],a[2]);
not (Na[3],a[3]);

and (y[0],Na[3],Na[2],Na[1],Na[0]); //0000
and (y[1],Na[3],Na[2],Na[1],a[0]); //0001
and (y[2],Na[3],Na[2],a[1],Na[0]); //0010
and (y[3],Na[3],Na[2],a[1],a[0]); //0011
and (y[4],Na[3],a[2],Na[1],Na[0]); //0100
and (y[5],Na[3],a[2],Na[1],a[0]); //0101
and (y[6],Na[3],a[2],a[1],Na[0]); //0110
and (y[7],Na[3],a[2],a[1],a[0]); //0111
and (y[8],a[3],Na[2],Na[1],Na[0]); //1000
and (y[9],a[3],Na[2],Na[1],a[0]); //1001
and (y[10],a[3],Na[2],a[1],Na[0]); //1010
and (y[11],a[3],Na[2],a[1],a[0]); //1011
and (y[12],a[3],a[2],Na[1],Na[0]); //1100
and (y[13],a[3],a[2],Na[1],a[0]); //1101
and (y[14],a[3],a[2],a[1],Na[0]); //1110
and (y[15],a[3],a[2],a[1],a[0]); //1111

endmodule

module Decoder_2To4(
    input [1:0] a,
    output [3:0] y
    );
wire [1:0] Na;

not (Na[0],a[0]);
not (Na[1],a[1]);

and (y[0],Na[1],Na[0]);
and (y[1],Na[1],a[0]);
and (y[2],a[1],Na[0]);
and (y[3],a[1],a[0]);
endmodule