`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 02:39:19 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb();
    // Inputs
    reg [3:0] a, b;
    // Outputs
    wire [3:0] sum;
    wire cout;

    top DUT (a, b, sum, cout);

    task apply_test;
        input [3:0] i_a, i_b;
        begin
            a = i_a; b = i_b;
            #1; // tasks can wait time
        end
    endtask

    initial begin
        $display("--- Start Simulation ---");

        apply_test(4'd2, 4'd3); // test 1
        apply_test(4'd10, 4'd5); // test 2
        apply_test(4'd15, 4'd1); // test 3 (Overflow)

        $display("--- End Simulation ---");
        $finish;
    end

endmodule
