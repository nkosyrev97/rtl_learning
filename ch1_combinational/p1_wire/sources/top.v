`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2026 11:44:36 PM
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
    input [0:0] btn,
    output [0:0] led
    );

    // positive
    assign #1 led[0] = btn[0];

    // negative
    //wire a;
    //assign a = btn[0];
    //assign led[0] = ~a;

endmodule
