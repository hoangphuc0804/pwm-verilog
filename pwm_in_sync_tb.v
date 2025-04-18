`timescale 1ns / 1ps


module pwm_in_sync_tb();
    reg clk, rst, increase_duty, decrease_duty, increase_freq, decrease_freq;
    wire pwm_out;
    
    pwm_in_sync #(8, 8) uut (clk, rst, increase_duty, decrease_duty, increase_freq, decrease_freq, pwm_out); 
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0; rst = 1; increase_duty = 0; decrease_duty = 0; increase_freq = 0; decrease_freq = 0;
        #10 rst = 0;
        #11 increase_duty = 1;
        #2 increase_duty = 0;
        #100 increase_duty = 1;
        #2 increase_duty = 0;
        #100 increase_duty = 1;
        #2 increase_duty = 0;
        #100 decrease_duty = 1;
        #2 decrease_duty = 0;
        #100 decrease_duty = 1;
        #2 decrease_duty = 0;
        #100 decrease_duty = 1;
        #2 decrease_duty = 0;
        #100 decrease_duty = 1;
        #2 decrease_duty = 0;
        #100 increase_freq = 1;
        #2 increase_freq = 0;
        #100 increase_freq = 1;
        #2 increase_freq = 0;
        #100 increase_freq = 1;
        #2 increase_freq = 0;
        #100 decrease_freq = 1;
        #2 decrease_freq = 0;
        #100 decrease_freq = 1;
        #2 decrease_freq = 0;
        #100 decrease_freq = 1;
        #2 decrease_freq = 0;
        #100 decrease_freq = 1;
        #2 decrease_freq = 0;
        #100 rst = 1;
    end
endmodule
