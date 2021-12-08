`timescale 1ns / 1ps

module Add_1bit(
    input A,
    input B,
    input CI, //进位输入
    output S, //输出
    output G, //进位产生
    output P //进位传递
);

xor(S,A,B,CI);
and(G,A,B);
or(P,A,B);
    
endmodule

module CLA_4bit( //4bit_CLA组件
    input[3:0] G,
    input[3:0] P,
    input CI_0,
    output[4:1] CI,
    output Gm,
    output Pm
);

wire temp[9:0];
and(temp[0],CI_0,P[0]); //P0C0
and(temp[1],temp[0],P[1]); //P1P0C0
and(temp[2],temp[1],P[2]); //P2P1P0C0
and(temp[3],temp[2],P[3]); //P3P2P1P0G0

and(temp[4],G[0],P[1]); //P1G0
and(temp[5],temp[4],P[2]); //P2P1G0
and(temp[6],temp[5],P[3]); //P3P2P1G0

and(temp[7],G[1],P[2]); //P2G1
and(temp[8],temp[7],P[3]); //P3P2G1

and(temp[9],G[2],P[3]); //P3G2

or(CI[1],G[0],temp[0]); //C1 = G0 + P0C0
or(CI[2],G[1],temp[4],temp[1]); //C2 = G1 + P1G0 + P1P0C0
or(CI[3],G[2],temp[7],temp[5],temp[2]); //C3 = G2 + P2G1 + P2P1G0 + P2P1P0C0
or(CI[4],G[3],temp[9],temp[8],temp[6],temp[3]); //C4 = G3 + P3G2 + P3P2P1G0 + P3P2P1P0C0
  
or(Gm,G[3],temp[9],temp[8],temp[6]); //Gm = G3 + P3G2 + P3P2G1 + P3P2P1G0
and(Pm,P[0],P[1],P[2],P[3]); //Pm = P3P2P1P0
    
endmodule

module CLA_Add_4bit( //4bit_CLA
    input[3:0] A,
    input[3:0] B,
    input CI_0,
    output[3:0] S,
    output Gm,
    output Pm
);

wire[3:0] G;
wire[3:0] P;
wire[4:1] CI;
    
Add_1bit u1(
    .A (A[0]),
    .B (B[0]),
    .CI (CI_0),
    .S (S[0]),
    .G (G[0]),
    .P (P[0])
);
    
Add_1bit u2(
    .A (A[1]),
    .B (B[1]),
    .CI (CI[1]),
    .S (S[1]),
    .G (G[1]),
    .P (P[1])
);
    
Add_1bit u3(
    .A (A[2]),
    .B (B[2]),
    .CI (CI[2]),
    .S (S[2]),
    .G (G[2]),
    .P (P[2])
);
    
Add_1bit u4(
    .A (A[3]),
    .B (B[3]),
    .CI (CI[3]),
    .S (S[3]),
    .G (G[3]),
    .P (P[3])
);

CLA_4bit U(
    .P (P),
    .G (G),
    .CI_0 (CI_0),
    .CI (CI),
    .Gm (Gm),
    .Pm (Pm)
);
    
endmodule

module CLA_Add_16bit( //16bit_CLA
    input[15:0] A,
    input[15:0] B,
    input CI_0,
    output[15:0] S,
    output GM,
    output PM
);

wire[3:0] G;
wire[3:0] P;
wire[4:1] CI;

CLA_Add_4bit u1(
    .A (A[3:0]),
    .B (B[3:0]),
    .CI_0 (CI_0),
    .S (S[3:0]),
    .Gm (G[0]),
    .Pm (P[0])
);
    
CLA_Add_4bit u2(
    .A (A[7:4]),
    .B (B[7:4]),
    .CI_0 (CI[1]),
    .S (S[7:4]),
    .Gm (G[1]),
    .Pm (P[1])
);
    
CLA_Add_4bit u3(
    .A (A[11:8]),
    .B (B[11:8]),
    .CI_0 (CI[2]),
    .S (S[11:8]),
    .Gm (G[2]),
    .Pm (P[2])
);
    
CLA_Add_4bit u4(
    .A (A[15:12]),
    .B (B[15:12]),
    .CI_0 (CI[3]),
    .S (S[15:12]),
    .Gm (G[3]),
    .Pm (P[3])
);

CLA_4bit U(
    .P (P),
    .G (G),
    .CI_0 (CI_0),
    .CI (CI),
    .Gm (GM),
    .Pm (PM)
);
    
endmodule

module CLA_Add_32bit( //32bit_CLA
    input[31:0] A,
    input[31:0] B,
    input CI_0,
    output[31:0] S,
    output CO
);

wire CI_16;
wire[1:0] G;
wire[1:0] P;

CLA_Add_16bit u1(
    .A (A[15:0]),
    .B (B[15:0]),
    .CI_0 (CI_0),
    .S (S[15:0]),
    .GM (G[0]),
    .PM (P[0])
);

CLA_Add_16bit u2(
    .A (A[31:16]),
    .B (B[31:16]),
    .CI_0 (CI_16),
    .S (S[31:16]),
    .GM (G[1]),
    .PM (P[1])
);

wire temp[2:0];
and(temp[0],CI_0,P[0]);
and(temp[1],temp[0],P[1]);
and(temp[2],G[0],P[1]);
or(CI_16,G[0],temp[0]);
or(CO,G[1],temp[2],temp[1]);

endmodule

module Serial_Add_1bit(
    input A,
    input B,
    input CI,
    output S,
    output CO
);

wire G, P, tmp;
xor(S, A, B, CI);
and(G, A, B);
xor(P, A, B);
and(tmp, P, CI);
or(CO, G, tmp);

endmodule

module Serial_Add_32bit(
    input[31:0] A,
    input[31:0] B,
    input CI_0,
    output[31:0] S,
    output CO
);

wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,
      c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,
      c29,c30,c31;
      
Serial_Add_1bit u1(.A (A[0]), .B (B[0]), .CI (CI_0), .S (S[0]), .CO (c1));
Serial_Add_1bit u2(.A (A[1]), .B (B[1]), .CI (c1), .S (S[1]), .CO (c2));
Serial_Add_1bit u3(.A (A[2]), .B (B[2]), .CI (c2), .S (S[2]), .CO (c3));
Serial_Add_1bit u4(.A (A[3]), .B (B[3]), .CI (c3), .S (S[3]), .CO (c4));
Serial_Add_1bit u5(.A (A[4]), .B (B[4]), .CI (c4), .S (S[4]), .CO (c5));
Serial_Add_1bit u6(.A (A[5]), .B (B[5]), .CI (c5), .S (S[5]), .CO (c6));
Serial_Add_1bit u7(.A (A[6]), .B (B[6]), .CI (c6), .S (S[6]), .CO (c7));
Serial_Add_1bit u8(.A (A[7]), .B (B[7]), .CI (c7), .S (S[7]), .CO (c8));
Serial_Add_1bit u9(.A (A[8]), .B (B[8]), .CI (c8), .S (S[8]), .CO (c9));
Serial_Add_1bit u10(.A (A[9]), .B (B[9]), .CI (c9), .S (S[9]), .CO (c10));
Serial_Add_1bit u11(.A (A[10]), .B (B[10]), .CI (c10), .S (S[10]), .CO (c11));
Serial_Add_1bit u12(.A (A[11]), .B (B[11]), .CI (c11), .S (S[11]), .CO (c12));
Serial_Add_1bit u13(.A (A[12]), .B (B[12]), .CI (c12), .S (S[12]), .CO (c13));
Serial_Add_1bit u14(.A (A[13]), .B (B[13]), .CI (c13), .S (S[13]), .CO (c14));
Serial_Add_1bit u15(.A (A[14]), .B (B[14]), .CI (c14), .S (S[14]), .CO (c15));
Serial_Add_1bit u16(.A (A[15]), .B (B[15]), .CI (c15), .S (S[15]), .CO (c16));
Serial_Add_1bit u17(.A (A[16]), .B (B[16]), .CI (c16), .S (S[16]), .CO (c17));
Serial_Add_1bit u18(.A (A[17]), .B (B[17]), .CI (c17), .S (S[17]), .CO (c18));
Serial_Add_1bit u19(.A (A[18]), .B (B[18]), .CI (c18), .S (S[18]), .CO (c19));
Serial_Add_1bit u20(.A (A[19]), .B (B[19]), .CI (c19), .S (S[19]), .CO (c20));
Serial_Add_1bit u21(.A (A[20]), .B (B[20]), .CI (c20), .S (S[20]), .CO (c21));
Serial_Add_1bit u22(.A (A[21]), .B (B[21]), .CI (c21), .S (S[21]), .CO (c22));
Serial_Add_1bit u23(.A (A[22]), .B (B[22]), .CI (c22), .S (S[22]), .CO (c23));
Serial_Add_1bit u24(.A (A[23]), .B (B[23]), .CI (c23), .S (S[23]), .CO (c24));
Serial_Add_1bit u25(.A (A[24]), .B (B[24]), .CI (c24), .S (S[24]), .CO (c25));
Serial_Add_1bit u26(.A (A[25]), .B (B[25]), .CI (c25), .S (S[25]), .CO (c26));
Serial_Add_1bit u27(.A (A[26]), .B (B[26]), .CI (c26), .S (S[26]), .CO (c27));
Serial_Add_1bit u28(.A (A[27]), .B (B[27]), .CI (c27), .S (S[27]), .CO (c28));
Serial_Add_1bit u29(.A (A[28]), .B (B[28]), .CI (c28), .S (S[28]), .CO (c29));
Serial_Add_1bit u30(.A (A[29]), .B (B[29]), .CI (c29), .S (S[29]), .CO (c30));
Serial_Add_1bit u31(.A (A[30]), .B (B[30]), .CI (c30), .S (S[30]), .CO (c31));
Serial_Add_1bit u32(.A (A[31]), .B (B[31]), .CI (c31), .S (S[31]), .CO (CO));

endmodule
