`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 09:52:59 PM
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
    input clk, // 100 MHz
    input btn,
    input rst_n,
    output led
    );

    reg led_ff;

    // This is bad design due posedge on signal from button where clk is expected.
    // Since FPGA has hardware optimal routes for clocks to DFFs this will cause
    // placement error in implementetion stage.
    // However we still have the opportunity to route unoptimized signal 
    // from "btn" wire to DFF's "clk" input by writing special line
    // "set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets btn_IBUF]" in .xdc file.
    // P.S. Button bouncing still exists, but not that obvious.
//    always @ (posedge btn or negedge rst_n)
//    begin
//        if (!rst_n) // this is also a async reset example
//            led_ff <= 1'b0;
//        else
//            led_ff <= ~led_ff;
//    end

    // This is good design because we use native clk signal for DFF
    // and the FPGA has optimized routes in hardware for clock signals.
    // P.S. However there is still one big problem - bouncing button signal!
    // This problem gets OBVIOUS if DFF is clk-driven
//    always @ (posedge clk)
//    begin
//        if (!rst_n) // this is also a sync reset example
//            led_ff <= 1'b0;
//        else if (btn)
//            led_ff <= ~led_ff;
        // 'else' is unnecessary because it's DFF and it will remember previous value.
        // That's why no latches will be generated, so don't worry.
        // 'else' is necessary only in always_comb blocks!
//    end


    // The right solution in 4 steps! (with async reset)
    parameter  DEBOUNCE_DELAY_TICKS = 2000000; // clk (100 000 000 Hz) * 0,02 sec = 2 000 000 cycles
    reg [21:0] count;
    reg        btn_stable;
    reg        btn_sync_0, btn_sync_1;

    // 1. sync button signal by two DFFs (protection from metastability)
    always @(posedge clk) begin
        btn_sync_0 <= btn;
        btn_sync_1 <= btn_sync_0;
    end

    // 2. debounce counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            btn_stable <= 0;
        end else begin
            if (btn_sync_1 != btn_stable) begin
                // state changed: start counting
                if (count < DEBOUNCE_DELAY_TICKS)
                    count <= count + 1;
                else begin
                    // state remained stable for DEBOUNCE_DELAY_TICKS: confirm change
                    btn_stable <= btn_sync_1;
                    count <= 0;
                end
            end else begin
                count <= 0; // reset counter if signal matches current stable state
            end
        end
    end

    // 3. rising edge detection (to toggle LED once per press)
    reg btn_prev;
    always @(posedge clk)
        btn_prev <= btn_stable;
    wire btn_clicked = btn_stable && !btn_prev; // rising edge trigger

    // 4. LED control logic (finally)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led_ff <= 1'b0;
        else if (btn_clicked)
            led_ff <= ~led_ff;
    end

    assign led = led_ff;

endmodule
