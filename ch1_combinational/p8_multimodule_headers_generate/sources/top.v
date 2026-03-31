`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 03:22:57 PM
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

`include "adder.vh"

module top(
    input [3:0] in1,
    input [3:0] in2,
    output [3:0] out,
    output c_out
    );

    wire c_in;
    assign c_in = 1'b0;

    adder_param #(.DATA_WIDTH(`ADD_WIDTH)) adder (
        .a(in1),
        .b(in2),
        .c_in(c_in),
        .sum(out),
        .c_out(c_out)
    );

endmodule
