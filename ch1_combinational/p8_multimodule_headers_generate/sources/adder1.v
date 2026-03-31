`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 03:26:47 PM
// Design Name: 
// Module Name: adder1
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


module adder1(
    input c_in,
    input a,
    input b,
    output sum,
    output c_out
    );
    assign sum = a ^ b ^ c_in;
    assign c_out = (a & b) | (c_in & (a ^ b));
endmodule
