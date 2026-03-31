`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2026 07:43:25 PM
// Design Name: 
// Module Name: shift_register
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


module shift_register(
    input clk,
    input rst_n,
    input inc,
    input dec,
    output reg [3:0] shift_reg,
    output direction
);

    reg [2:0] data;
    reg dir; // 0 -> to the left, 1 -> to the right
    always @ (posedge clk) begin
        if (!rst_n) begin
            dir <= 0;
            data <= 0;
        end
        else begin
            if (inc && !dir && data < 4)
                data <= data + 1;
            else if (dec && !dir && data > 0)
                data <= data - 1;
            else if (dec && !dir && !data) begin
                dir <= 1'b1;
                data <= data + 1;
            end
            else if (inc && dir && !data) begin
                dir <= 1'b0;
                data <= data + 1;
            end
            else if (inc && dir && data > 0)
                data <= data - 1;
            else if (dec && dir && data < 4)
                data <= data + 1;
        end
    end

    reg [3:0] bits;
    always @ (*) begin
        case (data)
            4'b0000 : bits = 4'b0000;
            4'b0001 : bits = 4'b0001;
            4'b0010 : bits = 4'b0011;
            4'b0011 : bits = 4'b0111;
            4'b0100 : bits = 4'b1111;
            default : bits = 4'bxxxx;
        endcase
    end

    localparam CLK_FREQ = 100_000_000;
    localparam CNT_MAX = CLK_FREQ / 4;
    localparam CNT_WIDTH = $clog2(CNT_MAX + 1);
    reg [CNT_WIDTH - 1:0] cnt;
    reg [1:0] index;
    always @ (posedge clk) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            index <= 0;
            cnt <= 0;
        end
        else begin
            if (cnt >= CNT_MAX) begin
                cnt <= 0;
                if (dir)
                    shift_reg <= {bits[index], shift_reg[3:1]};
                else
                    shift_reg <= {shift_reg[2:0], bits[index]};
                index <= index + 1;
            end else
                cnt <= cnt + 1;
        end
    end

    assign direction = dir;

endmodule
