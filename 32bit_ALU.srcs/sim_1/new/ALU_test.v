`timescale 1ns / 1ps

module ALU_test(

    );
    reg [31:0] a, b;
    reg CI;
    reg [3:0] F;
    reg [1:0] dir;
    reg [4:0] bite;
    wire [31:0] S;
    wire CO;
    wire overflow;
    wire zero;
    wire symbol;
    
    ALU_32bit alu(a, b, CI, F, dir, bite, S, CO, overflow, zero, symbol);
    initial
    begin
    //串行加法
        F = 4'b0000;
        CI = 1'b0;
        a = 32'h12340000;
        b = 32'h23450000;
    #20
        a = 32'hf1111111;
        b = 32'he1111111;
    #20
        a = 32'h00000000;
        b = 32'h00000000;
    //并行加法
    #20
        F = 4'b0001;
        CI = 1'b0;
        a = 32'h12340000;
        b = 32'h23450000;
    #20
        a = 32'hf1111111;
        b = 32'he1111111;
    #20
        a = 32'h00000000;
        b = 32'h00000000;
    //逻辑非
    #20
        F = 4'b0110;
        a = 32'hffffffff;
    #20
        a = 32'h00000000;
    #20
        a = 32'h11111111;
    //逻辑与
    #20
        F = 4'b0100;
        a = 32'hffffffff;
        b = 32'h00000000;
    #20
        a = 32'h00000000;
        b = 32'h11111111;
    #20
        a = 32'h11111111;
        b = 32'hffffffff;
    //逻辑或
    #20
        F = 4'b0101;
        a = 32'hffffffff;
        b = 32'h00000000;
    #20
        a = 32'h00000000;
        b = 32'h11111111;
    #20
        a = 32'h11111111;
        b = 32'hffffffff;
    //逻辑异或
    #20
        F = 4'b0111;
        a = 32'hffffffff;
        b = 32'h00000000;
    #20
        a = 32'h00000000;
        b = 32'h11111111;
    #20
        a = 32'h11111111;
        b = 32'hffffffff;
    //逻辑或非
    #20
        F = 4'b1000;
        a = 32'hffffffff;
        b = 32'h00000000;
    #20
        a = 32'h00000000;
        b = 32'h11111111;
    #20
        a = 32'h11111111;
        b = 32'hffffffff;
    end
    
endmodule
