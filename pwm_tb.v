`timescale 1ns / 1ps


module pwm_tb();
    reg clk, rst;
    reg [7:0] duty_in;
    reg [7:0] cycl_in;
    wire pwm_out;
    
    pwm #(8, 8) uut (clk, rst, duty_in, cycl_in, pwm_out); 
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0; rst = 1; duty_in = 0; cycl_in = 0;
        #10 rst = 0;
        #11 duty_in = 128;
        #20000 cycl_in = 1;
        #20000 duty_in = 64;
        #20000 cycl_in = 2;
        #20000 duty_in = 192;
        #20000 cycl_in = 3;
        #20000 rst = 1;
    end
endmodule
