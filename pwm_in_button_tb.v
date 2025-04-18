`timescale 1ns / 1ps


module pwm_in_button_tb();
    reg clk, rst, increase_duty_bt, decrease_duty_bt, increase_freq_bt, decrease_freq_bt;
    wire pwm_out;
    
    pwm_in_button #(4, 8, 8) uut (clk, rst, increase_duty_bt, decrease_duty_bt, increase_freq_bt, decrease_freq_bt, pwm_out); 
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0; rst = 1; increase_duty_bt = 0; decrease_duty_bt = 0; increase_freq_bt = 0; decrease_freq_bt = 0;
        #10 rst = 0;
        #11 increase_duty_bt = 1;
        #20 increase_duty_bt = 0;
        #100 increase_duty_bt = 1;
        #20 increase_duty_bt = 0;
        #100 increase_duty_bt = 1;
        #20 increase_duty_bt = 0;
        #100 increase_duty_bt = 1;
        #20 increase_duty_bt = 0;
        #100 decrease_duty_bt = 1;
        #20 decrease_duty_bt = 0;
        #100 decrease_duty_bt = 1;
        #20 decrease_duty_bt = 0;
        #100 decrease_duty_bt = 1;
        #20 decrease_duty_bt = 0;
        #100 decrease_duty_bt = 1;
        #20 decrease_duty_bt = 0;
        #100 decrease_duty_bt = 1;
        #20 decrease_duty_bt = 0;
        #100 increase_duty_bt = 1;
        #20 increase_duty_bt = 0;
        #100 increase_duty_bt = 1;
        #20 increase_duty_bt = 0;
        #100 decrease_freq_bt = 1;
        #20 decrease_freq_bt = 0;
        #100 decrease_freq_bt = 1;
        #20 decrease_freq_bt = 0;
        #100 decrease_freq_bt = 1;
        #20 decrease_freq_bt = 0;
        #100 decrease_freq_bt = 1;
        #20 decrease_freq_bt = 0;
        #100 decrease_freq_bt = 1;
        #20 decrease_freq_bt = 0;
        #100 decrease_freq_bt = 1;
        #20 decrease_freq_bt = 0;
        #100 decrease_freq_bt = 1;
        #20 decrease_freq_bt = 0;
        #100 increase_freq_bt = 1;
        #20 increase_freq_bt = 0;
        #100 increase_freq_bt = 1;
        #20 increase_freq_bt = 0;
        #100 rst = 1;
    end
endmodule
