`timescale 1ns / 1ps


module counter #(size = 8) (clk, rst, ld, ld_val, en, up, val);
    input clk, rst, ld, en, up;
    input [size-1:0] ld_val;
    output reg [size-1:0] val;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            val <= 0;
        end else if (ld) begin
            val <= ld_val;
        end else if (en) begin
            val <= (up) ? val+1 : val-1;
        end
    end
endmodule

module slow_clk (clk, rst, n, clk_out);
    input clk, rst;
    input [31:0] n;
    output reg clk_out;
    
    wire [31:0] counter_slow_clk_val;
    wire counter_slow_clk_load;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            clk_out <= 0;
        end else if (counter_slow_clk_val == n) begin
            clk_out <= ~clk_out;
        end
    end
    
    counter #(32) counter_slow_clk(clk, rst, counter_slow_clk_load, 0, 1, 1, counter_slow_clk_val);
    assign counter_slow_clk_load = (counter_slow_clk_val == n);
endmodule

module pos_edge_det (clk, rst, sig, pos_edge);
    input clk, rst, sig;
    output pos_edge;
    
    reg sig_dly;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            sig_dly <= 0;
        end else begin
            sig_dly <= sig;
        end
    end
    
    assign pos_edge = ~sig_dly & sig;
endmodule

module async_to_sync (clk, rst, slow_clk, async, sync);
    input clk, rst, slow_clk, async;
    output reg sync;
    
    reg intermediate;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            intermediate <= 0;
            sync <= 0;
        end else if (slow_clk) begin
            intermediate <= async;
            sync <= intermediate;
        end
    end
endmodule

module button_handle (clk, rst, slow_clk, bt_in, bt_out);
    input clk, rst, slow_clk, bt_in;
    output bt_out;
    
    wire bt_out_intermediate;
    
    async_to_sync async_to_sync_0 (clk, rst, slow_clk, bt_in, bt_out_intermediate);
    pos_edge_det pos_edge_det_0 (clk, rst, bt_out_intermediate, bt_out);
endmodule

module pwm #(duty_size = 8, cycl_size = 8) (clk, rst, duty_in, cycl_in, pwm_out);
    input clk, rst;
    input [duty_size-1:0] duty_in;
    input [cycl_size-1:0] cycl_in;
    output pwm_out;
    
    wire [duty_size-1:0] counter_duty_val;
    wire counter_duty_ld, counter_duty_en, slow_clk_cycl;
    
    counter #(duty_size) counter_duty (clk, rst, counter_duty_ld, 0, counter_duty_en, 1, counter_duty_val);
    assign counter_duty_ld = (counter_duty_val == 254);
    slow_clk slow_clk_freq (clk, rst, {24'b0, cycl_in}, slow_clk_cycl);
    pos_edge_det pos_edge_det_counter_duty_en (clk, rst, slow_clk_cycl, counter_duty_en);
    
    assign pwm_out = (counter_duty_val < duty_in);
endmodule

module pwm_in_sync #(duty_size = 8, cycl_size = 8) (clk, rst, increase_duty, decrease_duty, increase_freq, decrease_freq, pwm_out);
    input clk, rst, increase_duty, decrease_duty, increase_freq, decrease_freq;
    output pwm_out;
    
    reg [duty_size-1:0] duty_in, duty_in_n;
    reg [cycl_size-1:0] cycl_in, cycl_in_n;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            duty_in <= 0;
            cycl_in <= 0;
        end else begin
            duty_in <= duty_in_n;
            cycl_in <= cycl_in_n;
        end
    end
    
    always @(duty_in, increase_duty, decrease_duty) begin
        if (increase_duty & duty_in < 255) begin
            duty_in_n <= duty_in + 1;
        end else if (decrease_duty & duty_in > 0) begin
            duty_in_n <= duty_in - 1;
        end else begin
            duty_in_n <= duty_in;
        end
    end
    
    always @(cycl_in, increase_freq, decrease_freq) begin
        if (decrease_freq & cycl_in < 255) begin
            cycl_in_n <= cycl_in + 1;
        end else if (increase_freq & cycl_in > 0) begin
            cycl_in_n <= cycl_in - 1;
        end else begin
            cycl_in_n <= cycl_in;
        end
    end
    
    pwm #(duty_size, cycl_size) pwm_0 (clk, rst, duty_in, cycl_in, pwm_out);
endmodule

module pwm_in_button #(n = 624999, duty_size = 8, cycl_size = 8) (clk, rst, increase_duty_bt, decrease_duty_bt, increase_freq_bt, decrease_freq_bt, pwm_out);
    input clk, rst, increase_duty_bt, decrease_duty_bt, increase_freq_bt, decrease_freq_bt;
    output pwm_out;
    
    wire increase_duty, decrease_duty, increase_freq, decrease_freq, clk100Hz;
    
    button_handle button_handle_inc_duty (clk, rst, clk100Hz, increase_duty_bt, increase_duty);
    button_handle button_handle_dec_duty( clk, rst, clk100Hz, decrease_duty_bt, decrease_duty);
    button_handle button_handle_inc_freq (clk, rst, clk100Hz, increase_freq_bt, increase_freq);
    button_handle button_handle_dec_freq (clk, rst, clk100Hz, decrease_freq_bt, decrease_freq);
    
    pwm_in_sync #(duty_size, cycl_size) pwm_in_sync_0 (clk, rst, increase_duty, decrease_duty, increase_freq, decrease_freq, pwm_out);
    slow_clk slow_clk_0(clk, rst, n, clk100Hz);
endmodule
