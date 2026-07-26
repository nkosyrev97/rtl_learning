`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 02:38:36 PM
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
    input [3:0] in1,
    input [3:0] in2,
    output [3:0] out,
    output c_out
    );

    // func definition
    function [4:0] sum4(input [3:0] a, input [3:0] b, input cin);
        begin
            sum4 = a + b + cin;
        end
    endfunction

    // module's body
    wire c_in;
    wire [4:0] full_sum;
    assign c_in = 1'b0;

    assign full_sum = sum4(in1, in2, c_in);
    assign out = full_sum[3:0];
    assign c_out = full_sum[4];

endmodule
