`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2026 07:43:25 PM
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
    input rst_n,
    input [1:0] btn,
    output [3:0] led
);

    wire [1:0] btn_pressed;
    generate
        genvar i;
        for (i = 0; i < 2; i = i + 1) begin : btns
            btn_routine rtn (clk, btn[i], btn_pressed[i]);
        end
    endgenerate

    wire [3:0] shiftreg;
    wire dir;
    shift_register shft_rg (clk, rst_n, btn_pressed[1], btn_pressed[0], shiftreg, dir);

    wire [3:0] lshift_leds, rshift_leds;
    pwm_left l_pwm (clk, rst_n, shiftreg, lshift_leds);
    pwm_right r_pwm (clk, rst_n, shiftreg, rshift_leds);

    assign led = (!dir) ? lshift_leds : rshift_leds;

endmodule
