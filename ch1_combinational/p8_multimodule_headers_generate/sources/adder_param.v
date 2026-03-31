`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2026 03:53:27 PM
// Design Name: 
// Module Name: adder_param
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


module adder_param #(parameter DATA_WIDTH=4) (
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    input c_in,
    output [DATA_WIDTH-1:0] sum,
    output c_out
    );

    wire [DATA_WIDTH:0] carry;
    assign carry[0] = c_in;

    generate
        genvar i;

        for (i = 0; i < DATA_WIDTH; i = i + 1)
        begin: some_label
            //adder1 a1 (carry[i], a[i], b[i], sum[i], carry[i+1]); // parameter ordered mapping
            adder1 a1 (
                .a(a[i]),
                .b(b[i]),
                .c_in(carry[i]),
                .sum(sum[i]),
                .c_out(carry[i+1])
            ); // parameter named mapping    
        end
    endgenerate

    assign c_out = carry[DATA_WIDTH];

endmodule
