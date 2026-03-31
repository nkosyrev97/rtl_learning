`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2026 10:27:28 PM
// Design Name: 
// Module Name: pwm_logic
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


module pwm1 #(
    parameter DUTY_LVL = 2048 // 0 -> off, 65536 -> max
)
(
    input clk,
    input rst,
    input in,
//    input [7:0] duty_lvl,
    output out
);

    reg [15:0] cnt;
    wire [15:0] duty_lvl = DUTY_LVL;

    always @ (posedge clk) begin
        if (rst) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end

    assign out = (cnt < duty_lvl) ? in : 0;

endmodule

module pwm_left
(
    input clk, // 100 MHz
    input rst,
    input [15:0] in,
    output [15:0] out
);

    wire [15:0] pwm_out;
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : pwms
            pwm1 #(.DUTY_LVL((2**(i+1))-1)) pwm_l (clk, rst, in[i], pwm_out[i]);
        end
    endgenerate

    assign out = pwm_out;

endmodule

module pwm_right
(
    input clk, // 100 MHz
    input rst,
    input [15:0] in,
    output [15:0] out
);

    wire [15:0] pwm_out;
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : pwms
            pwm1 #(.DUTY_LVL((2**(16-i))-1)) pwm_r (clk, rst, in[i], pwm_out[i]);
        end
    endgenerate

    assign out = pwm_out;

endmodule
