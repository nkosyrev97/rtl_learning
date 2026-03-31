`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2026 10:23:35 PM
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


module top(
    input clk,
    input rst,
    input [1:0] btn,
    output [15:0] led
    );
    
    wire [1:0] btn_pressed;
    generate
        genvar i;
        for (i = 0; i < 2; i = i + 1) begin : btns
            btn_routine rtn (clk, btn[i], btn_pressed[i]);
        end
    endgenerate

    wire [15:0] shiftreg;
    wire dir;
    shift_register shft_rg (clk, rst, btn_pressed[1], btn_pressed[0], shiftreg, dir);

    wire [15:0] lshift_leds, rshift_leds;
    pwm_left l_pwm (clk, rst, shiftreg, lshift_leds);
    pwm_right r_pwm (clk, rst, shiftreg, rshift_leds);

    assign led = (!dir) ? lshift_leds : rshift_leds;
    
endmodule
