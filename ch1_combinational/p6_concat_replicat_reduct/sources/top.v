`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2026 02:50:22 PM
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
    input [1:0] in1,
    input [1:0] in2,
    output [7:0] out
    );

    wire [3:0] a;
    wire [7:0] b;
    assign a = {in2, in1};  // concatenation -> a = {in2[1], in2[0], in1[1], in1[0]}
    assign b = {2{a}};  // replication -> b = {in2[1], in2[0], in1[1], in1[0], in2[1], in2[0], in1[1], in1[0]}

//    assign out[0] = ^b; // XOR reduction -> out = (((((((b[0] ^ b[1]) ^ b[2]) ^ b[3]) ... ^ b[7])
    assign out[0] = ~&b; // NAND reduction -> out = (((((((b[0] ~& b[1]) ... ~& b[7])

    assign out[7:1] = 7'b0;

endmodule
