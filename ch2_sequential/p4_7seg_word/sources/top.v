`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2026 03:36:37 PM
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

module top #(
    parameter CLK_FREQ_HZ = 10_000_000,
    parameter DELAY_MS = 20,
    parameter AN_INTERVAL_MS = 10 // set to 1000 to see details
)
(
    input clk_in,
    input rst,
    input en,
    output [6:0] seg,
    output [3:0] an
);

    // MMCM IP-block: input 100 MHz, output 10 MHz
    wire clk, locked;
    mmcm_7seg_wrapper my_mmcm_bd_inst (
        .clk_in1_0  (clk_in),
        .reset_0    (rst),
        .clk_out1_0 (clk),
        .locked_0   (locked)
    );

    // get synced reset signal for the rest of the logic (sys_rst)
    reg locked_sync0, locked_sync1;
    wire sys_rst;
    always @(posedge clk or negedge locked) begin
        if (!locked) begin
            locked_sync0 <= 1'b1;
            locked_sync1 <= 1'b1;
        end else begin
            locked_sync0 <= 1'b0;
            locked_sync1 <= locked_sync0;
        end
    end
    assign sys_rst = locked_sync1;

    // sync and debounce enable signal (sw0)
    reg en_sync0, en_sync1, en_stabled;
    wire sys_en;
    localparam EN_DELAY_TICKS = (CLK_FREQ_HZ / 1000) * DELAY_MS;
    localparam EN_CNT_WIDTH = $clog2(EN_DELAY_TICKS + 1);
    reg [EN_CNT_WIDTH - 1:0] en_debounce_cnt;
    always @(posedge clk) begin
        if (sys_rst) begin
            en_sync0 <= 1'b0;
            en_sync1 <= 1'b0;
            en_stabled <= 1'b0;
            en_debounce_cnt <= 'b0; // set all CNT_WIDTH bits to zero
        end else begin
            en_sync0 <= en;
            en_sync1 <= en_sync0;

            if (en_sync1 != en_stabled) begin
                if (en_debounce_cnt < EN_DELAY_TICKS)
                    en_debounce_cnt <= en_debounce_cnt + 1'b1;
                else begin
                    en_stabled <= en_sync1;
                    en_debounce_cnt <= 'b0;
                end
            end else begin
                en_debounce_cnt <= 'b0; // reset counter if signal matches current stable state
            end
        end
    end
    assign sys_en = en_stabled;

    // AN shift register logic
    localparam AN_PERIOD_TICKS = (CLK_FREQ_HZ / 1000) * AN_INTERVAL_MS;
    localparam AN_SWITCH_TICKS = AN_PERIOD_TICKS / 4; // there are 4 ANs (letters)
    localparam AN_CNT_WIDTH = $clog2(AN_SWITCH_TICKS + 1);
    reg [AN_CNT_WIDTH - 1:0] an_switch_cnt; // counter to switch to the next AN
    reg [3:0] shift_reg_figure;
    always @(posedge clk) begin
        if (sys_rst) begin
            shift_reg_figure <= 4'b0111;
            an_switch_cnt <= 'b0;
        end
        else if (sys_en) begin
            if (an_switch_cnt >= AN_SWITCH_TICKS - 1) begin
                shift_reg_figure <= {shift_reg_figure[0], shift_reg_figure[3:1]};
                an_switch_cnt <= 'b0;
            end else begin
                an_switch_cnt <= an_switch_cnt + 1'b1;
            end
        end
    end
    assign an = shift_reg_figure;

    // 7 segment letter decoder logic for each an value
    reg [6:0] letters;
    always @(*) begin
        case (shift_reg_figure)
            4'b1111 : letters = 'b1111111;
            4'b1110 : letters = 7'b0001000; // A
            4'b1101 : letters = 7'b0000010; // G
            4'b1011 : letters = 7'b0001100; // P
            4'b0111 : letters = 7'b0001110; // F
            default : letters = 7'bxxxxxxx;
        endcase
    end
    assign seg = letters;

endmodule
