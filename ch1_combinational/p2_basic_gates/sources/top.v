`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2026 10:58:03 PM
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
    input [1:0] sw,
    output led0_r
    );

    // AND
    wire a, b, c;
    assign a = sw[0];
    assign b = sw[1];
    assign c = a & b;
    assign led0_r = c;

    // OR
    //assign led0_r = sw[0] | sw[1];

    // XOR
    //assign #3 led0_r = sw[0] ^ sw[1];

    // NAND
    //assign led0_r = ~(sw[0] & sw[1]);

    // NOR
    //assign #1 led0_r = ~(sw[0] | sw[1]);

    // NXOR =)
    //assign #1 led0_r = ~(sw[0] ^ sw[1]);

endmodule
