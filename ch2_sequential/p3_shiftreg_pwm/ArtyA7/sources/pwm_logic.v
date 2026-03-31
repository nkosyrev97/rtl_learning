`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2026 07:43:25 PM
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
    parameter DUTY_LVL = 64 // 0 -> off, 255 -> max
)
(
    input clk,
    input rst_n,
    input in,
//    input [7:0] duty_lvl,
    output out
);

    reg [7:0] cnt;
    wire [7:0] duty_lvl = DUTY_LVL;

    always @ (posedge clk) begin
        if (!rst_n) begin
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
    input rst_n,
    input [3:0] in,
    output [3:0] out
);

    wire [3:0] pwm_out;
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : pwms
            pwm1 #(.DUTY_LVL(2**(i+4))) pwm_l (clk, rst_n, in[i], pwm_out[i]);
        end
    endgenerate

    assign out = pwm_out;

endmodule

module pwm_right
(
    input clk, // 100 MHz
    input rst_n,
    input [3:0] in,
    output [3:0] out
);

    wire [3:0] pwm_out;
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : pwms
            pwm1 #(.DUTY_LVL(2**(7-i))) pwm_r (clk, rst_n, in[i], pwm_out[i]);
        end
    endgenerate

    assign out = pwm_out;

endmodule
