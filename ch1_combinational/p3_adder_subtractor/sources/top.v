`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 12:16:14 AM
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
    input carry_in,
    output [3:0] out,
    output carry_out
    );
    
    // IMPORTENT: look at the 'carry_in' pin in constrain file .xdc!
    // 'carry_in' is mapped to 1st pin (G13) in JA PMOD and pulled-down to zero!
    // this makes carry_in = 0 only while no gadget is connected to JA (pin is "in the air")!

    // 4bit Adder with carry flags
    //wire [4:0] full_sum;
    //assign full_sum = in1 + in2 + carry_in;
    //assign out = full_sum[3:0];
    //assign carry_out = full_sum[4];

    // Same adder made by concatenation
    //assign {carry_out, out} = in1 + in2 + carry_in;

    // in subtract logic carry flags are named borrow flags
    //wire borrow_in, borrow_out;
    assign borrow_in = carry_in;
    assign {borrow_out, out} = in1 - in2 - borrow_in;
    assign carry_out = borrow_out;

endmodule
