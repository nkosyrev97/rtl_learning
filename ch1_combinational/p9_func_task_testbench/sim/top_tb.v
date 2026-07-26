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

    // DUT inputs
    reg [3:0] a, b;

    // DUT outputs
    wire [3:0] sum;
    wire cout;

    // Verif vars
    reg [4:0] expected_full;
    reg [3:0] expected_sum;
    reg expected_cout;
    integer error_count = 0;

    top DUT (a, b, sum, cout);

    // task definition
    task apply_test;
        input [3:0] i_a, i_b;
        begin
            a = i_a; b = i_b;

            expected_full = i_a + i_b;
            expected_sum  = expected_full[3:0];
            expected_cout = expected_full[4];

            #45; // tasks can wait time

            if ((sum !== expected_sum) || (cout !== expected_cout)) begin
                $display("ERROR: [%0t] %d + %d -> Received: %d (C:%b) | Expected: %d (C:%b)", 
                         $time, a, b, sum, cout, expected_sum, expected_cout);
                error_count = error_count + 1;
            end else begin
                $display("OK: [%0t] %d + %d = %d (Carry: %b)", $time, a, b, sum, cout);
            end

            #5; // to match post-synth/impl timing tests
        end
    endtask

    initial begin
        // FPGA's GSR delay (should be >= 105 ns)
        #200;

        $display("--- Start Simulation ---");

        apply_test(4'd2, 4'd3);    // test 1 (Usual)
        apply_test(4'd10, 4'd5);   // test 2 (Max sum)
        apply_test(4'd15, 4'd1);   // test 3 (Overflow)
        apply_test(4'd0,  4'd0);   // test 4 (Zeroes)
        apply_test(4'd15, 4'd15);  // test 5 (Max overflow)

        $display("--- End Simulation ---");

        if (error_count == 0) begin
            $display(">>>> PASSED! <<<<");
        end else begin
            $display(">>>> FAILED! Errors found: %0d! <<<<", error_count);
        end

        $finish;
    end

endmodule
