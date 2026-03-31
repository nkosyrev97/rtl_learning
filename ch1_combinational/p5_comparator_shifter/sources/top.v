`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2026 12:57:13 PM
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
    output [7:0] out
    );

    reg [3:0] a, b;
    reg [7:0] c;
    always @ (*) begin
        a = in1;
        b = in2;
        c = 8'h0;

        if (a == b)
            c[7] = 1'b1;
        else if (a > b)
            c[6] = 1'b1;
        else if (a < b)
            c[5] = 1'b1;
        else
            c[4] = 1'b1;

//        c = a << b;   // logical left shift
//        c = a <<< b;  // arithmetical left shift
//        c = a >> b;   // logical right shift
//        c = a >>> b;  // arithmetical right shift
    end
    assign out = c;

endmodule
