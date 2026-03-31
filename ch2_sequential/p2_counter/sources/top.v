`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 03:57:11 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module debounce_btn #(
    parameter CLK_FREQ_HZ = 100000000,
    parameter DELAY_MS = 20
    )
    (
    input clk,
    input btn,
    output stabled
    );

    localparam DELAY_TICKS = (CLK_FREQ_HZ / 1000) * DELAY_MS;
    localparam CNT_WIDTH = $clog2(DELAY_TICKS + 1);
    reg [CNT_WIDTH - 1:0] count;
    reg [0:1] btn_sync;
    reg btn_stabled;

    // 1. sync btn by 2 DFFs
    always @(posedge clk) begin
        btn_sync[0] <= btn;
        btn_sync[1] <= btn_sync[0];
    end

    // 2. debounce counter logic
    always @(posedge clk) begin
        if (btn_sync[1] != btn_stabled) begin
            if (count < DELAY_TICKS)
                count <= count + 1'b1;
            else begin
                btn_stabled <= btn_sync[1];
                count <= 0;
            end
        end else begin
            count <= 0; // reset counter if signal matches current stable state
        end
    end
    assign stabled = btn_stabled;
endmodule

module edge_detector(
    input clk,
    input in_current,
    output rising_edge
//   , output falling_edge
    );

    reg in_prev;
    always @(posedge clk)
        in_prev <= in_current;

    assign rising_edge = in_current & ~in_prev;
//    assign falling_edge = ~in_current & in_prev;
endmodule

module top(
    input clk,  // 100 MHz
    input en_sw, // sw[0] is enable input
    input rst_n,
    input [1:0] btn,
    output [3:0] led
    );

    wire [1:0] debounce_res;
    wire [1:0] detector_res;
    generate
        genvar i;
        for (i = 0; i < 2; i = i + 1) begin : common_part
            debounce_btn dbnc (clk, btn[i], debounce_res[i]);
            edge_detector dtcr (clk, debounce_res[i], detector_res[i]);
        end
    endgenerate
    wire dec_flag = detector_res[0];
    wire inc_flag = detector_res[1];

    // increment or decrement counter by buttons
    /*
    reg [3:0] cnt;
    always @ (posedge clk) begin
        if (!rst_n) // rst_n doesn't need debouncing
            cnt <= 4'b0;
        else if (en_sw) begin
            if (inc_flag)
                cnt <= cnt + 1'b1;
            else if (dec_flag)
                cnt <= cnt - 1'b1;
        end
    end
    assign led = cnt;
    */

    // autoincr/autodect counter, buttons change speed/direction
    localparam CLK_FREQ = 100_000_000;
    localparam CNT_WIDTH = $clog2(CLK_FREQ + 1);

    reg [CNT_WIDTH - 1:0] cnt;
    reg [2:0] speed; // 0 = no changes, 1 = x1, 2 = x2, 3 = x4
    reg dir; // 0 -> inc, 1 -> dec
    reg [3:0] led_ff;

    // speed/dir change logic
    always @ (posedge clk) begin
        if (!rst_n) begin
            speed <= 0;
            dir <= 0;
        end
        else if (en_sw) begin
            if (inc_flag && !dir && speed < 3)
                speed <= speed + 1;
            else if (dec_flag && !dir && speed > 0)
                speed <= speed - 1;
            else if (dec_flag && !dir && !speed) begin
                dir <= 1'b1;
                speed <= speed + 1;
            end
            else if (inc_flag && dir && !speed) begin
                dir <= 1'b0;
                speed <= speed + 1;
            end
            else if (inc_flag && dir && speed > 0)
                speed <= speed - 1;
            else if (dec_flag && dir && speed < 3)
                speed <= speed + 1;            
        end
    end

    // cnt/led_ff change logic
    always @ (posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            led_ff <= 0;
        end
        else if (en_sw) begin        
            if (speed == 1) begin
                if (cnt >= CLK_FREQ) begin
                    cnt <= 0;
                    led_ff <= dir ? (led_ff - 1) : (led_ff + 1);
                end
                else 
                    cnt <= cnt + 1;
            end
            else if (speed == 2) begin
                if (cnt >= CLK_FREQ / 2) begin
                    cnt <= 0;
                    led_ff <= dir ? (led_ff - 1) : (led_ff + 1);
                end
                else 
                    cnt <= cnt + 1;
            end
            else if (speed == 3) begin
                if (cnt >= CLK_FREQ / 4) begin
                    cnt <= 0;
                    led_ff <= dir ? (led_ff - 1) : (led_ff + 1);
                end
                else 
                    cnt <= cnt + 1;
            end
            else
                cnt <= 0;     
        end
    end

    assign led = led_ff;
endmodule
