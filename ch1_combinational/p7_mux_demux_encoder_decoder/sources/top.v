`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2026 03:33:16 PM
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
    output reg [7:0] out
    );

//    reg [1:0] sel;

    // mux 4:1
//    always @(*) begin
//        sel = in2[1:0];
//        out = 8'h0;

//        case (sel)
//            2'b00: out[7] = in1[0];
//            2'b01: out[7] = in1[1];
//            2'b10: out[7] = in1[2];
//            2'b11: out[7] = in1[3];
//            default: out[7] = 1'bx;
//        endcase

        // alternate description
//        if (sel == 2'b00)
//            out[7] = in1[0];
//        else if (sel == 2'b01)
//            out[7] = in1[1];
//        else if (sel == 2'b10)
//            out[7] = in1[2];
//        else if (sel == 2'b11)
//            out[7] = in1[3];
//        else
//            out[7] = 1'bx;

//    end

    // demux 1:4
//    always @(*) begin
//        sel = in2[1:0];
//        out = 8'h0;
//
//        case (in2[1:0]) // in2 is wire!!!
//            2'b00: out[4] = in1[0];
//            2'b01: out[5] = in1[0];
//            2'b10: out[6] = in1[0];
//            2'b11: out[7] = in1[0];
//            default: out[0] = 1'b1;
//        endcase

        // alternate description
//        if (sel == 2'b00)
//            out[4] = in1[0];
//        else if (sel == 2'b01)
//            out[5] = in1[0];
//        else if (sel == 2'b10)
//            out[6] = in1[0];
//        else if (sel == 2'b11)
//            out[7] = in1[0];
//        else
//            out[0] = 1'b1;
//    end

///////////////////////////////////////////////////////////////////////////////////////////////////////

    // 2:4 decoder with enabling
//    always @(*) begin
//        out = 8'h0;
//
//        if (!in1[3]) // in1[3] is enable signal
//            out[7:4] = 4'b0000;
//        else begin
//            case (in1[1:0])
//                2'b00: out[7:4] = 4'b0001;
//                2'b01: out[7:4] = 4'b0010;
//                2'b10: out[7:4] = 4'b0100;
//                2'b11: out[7:4] = 4'b1000;
//                default: out[7:4] = 4'b0000;
//            endcase
//        end
//    end

    // 4:2 encoder with valid flag
    // such encoders are usually done with explicit priority
    // to get rid of undefined output due the same input signals
    reg valid;
    always @(*) begin
        valid = 1'b1;
        out = 8'b0;

        if (in1[3]) 
            out[5:4] = 2'b11;
        else if (in1[2]) 
            out[5:4] = 2'b10;
        else if (in1[1]) 
            out[5:4] = 2'b01;
        else if (in1[0]) 
            out[5:4] = 2'b00;
        else begin
            out[5:4] = 2'b00;
            valid = 1'b0;
        end

        out[7] = valid;
    end

endmodule
