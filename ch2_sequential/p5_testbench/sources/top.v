`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2026 04:57:35 PM
// Design Name: 
// Module Name: up_down_4bit_counter
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

module up_down_4bit_counter(
    input clk,
    input rst_n,
    input sync_load,
    input up_down,
    input [3:0] load_data,
    output reg [3:0] count
    );

    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 4'b0000;
        end else if (sync_load) begin
            count <= load_data;
        end else if (up_down) begin
            count <= count + 1'b1;
        end else begin
            count <= count - 1'b1;
        end
    end

endmodule
