`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 02:21:57 PM
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
    input [3:0] in1,  // input type is always wire
    input [3:0] in2,
    output [7:0] out  // output type can be wire or reg (default is wire)
    );
    
    // simple multiplication behaviour model with wire
//    assign out = in1 * in2;
    
    // simple multiplication behaviour model with reg
    // reg doesn't mean DFF usage if there is no posedge/negedge in sensitive list
    // conclusion: sensitive list (*) means comb logic
    // the reason of this trick is because wire type cannot be used in process block
    // if+else, for, switch+case can be used only in process blocks with reg types 
//    reg [7:0] mul;
//    always @ (*)
//        mul = in1 * in2;
//    assign out = mul;
    
    // alternate "shift and add" multiplication model
//    reg [7:0] mul;
//    integer i;
//    always @ (*) begin
//        mul = 8'b0;
//        for (i = 0; i < 4; i = i + 1) begin
//            if (in2[i])
//                mul = mul + (in1 << i);
//        end
//    end
//    assign out = mul;
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    // 8 bits in result (quotient) for 4 bit divident and divider will never be fully used
    // so we leave 4 bits for output and 1 upper bit for zero-divider error flag =)
    // because zero-devide will give undefined result
    // yep this is devision behaviour model
//    wire [3:0] quotient;
//    wire zero_divider;
//    assign quotient = (in2 != 0) ? (in1 / in2) : (4'h0);
//    assign zero_divider = (in2 != 0) ? (1'b0) : (1'b1);
//    assign out[3:0] = quotient;
//    assign out[6:4] = 3'b0;
//    assign out[7] = zero_divider;

    // just to check what will happen  in HW if x/0 =)
//    assign out = in1 / in2; // FYI: happened 0xf

    // same stuff with modulus behaviour model
    wire [3:0] remainder;
    wire zero_divider;
    assign remainder = (in2 != 0) ? (in1 % in2) : (4'h0);
    assign zero_divider = (in2 != 0) ? (1'b0) : (1'b1);
    assign out[3:0] = remainder;
    assign out[6:4] = 3'b0;
    assign out[7] = zero_divider;

    // just to check what will happen  in HW if x%0 =)
//    assign out = in1 % in2; // FYI: happened 0x0

    // alternate "shift and subtract" division and modulus model (united)
//    reg [3:0] quotient;   // div result
//    reg [3:0] remainder;  // mod result
//    reg zero_divider;
//    wire [3:0] dummy; // for unused result (quotient or remainder)
//    integer i;
//    always @ (*) begin
//        quotient = 4'b0;
//        remainder = 4'b0;
//        zero_divider = 1'b0;
//
//        if (in2 == 4'b0) begin
//            quotient = 4'h0;
//            remainder = 4'h0;
//            zero_divider = 1'b1;
//        end else begin
//            for (i = 3; i >= 0; i = i - 1) begin
//                remainder = (remainder << 1);
//                remainder[0] = in1[i];
//
//                if (remainder >= in2) begin
//                    remainder = remainder - in2;
//                    quotient[i] = 1'b1;
//                end else begin
//                    quotient[i] = 1'b0;
//                end
//            end
//        end
//    end
//    assign out[7] = zero_divider;
//    assign out[6:4] = 3'b0;
//    assign out[3:0] = remainder;
//    assign dummy = quotient; // unused result

endmodule
