`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2026 10:23:35 PM
// Design Name: 
// Module Name: btn_routine
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


module btn_routine #(
    parameter CLK_FREQ_HZ = 100000000,
    parameter DELAY_MS = 20
)
(
    input clk,
    input btn,
    output btn_pressed
);

    // 1. sync btn by 2 DFFs
    reg [0:1] btn_sync;
    always @(posedge clk) begin
        btn_sync[0] <= btn;
        btn_sync[1] <= btn_sync[0];
    end

    // 2. debounce counter logic
    localparam DELAY_TICKS = (CLK_FREQ_HZ / 1000) * DELAY_MS;
    localparam CNT_WIDTH = $clog2(DELAY_TICKS + 1);
    reg [CNT_WIDTH - 1:0] count;
    reg btn_stabled;
    always @(posedge clk) begin
        if (btn_sync[1] != btn_stabled) begin
            if (count < DELAY_TICKS)
                count <= count + 1'b1;
            else begin
                btn_stabled <= btn_sync[1];
                count <= 0;
            end
        end else begin
            count <= 0; // reset counter if signal matches current stable state
        end
    end

    // 3. detect rising edge
    reg btn_prev;
    always @(posedge clk)
        btn_prev <= btn_stabled;
    assign btn_pressed = btn_stabled & ~btn_prev;

endmodule
