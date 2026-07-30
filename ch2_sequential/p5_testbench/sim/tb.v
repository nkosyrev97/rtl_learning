`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2026 05:10:23 PM
// Design Name: 
// Module Name: up_down_4bit_counter_tb
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

module up_down_4bit_counter_tb();

    // DUT inputs
    reg        clk;
    reg        rst_n;
    reg        sync_load;
    reg        up_down; // 1 = up, 0 = down
    reg  [3:0] load_data;

    // DUT outputs
    wire [3:0] count;

    // Verif and stat variables
    integer    errors;
    integer    success_tests;
    integer    i; // loop cycles counter
    reg [8*40:1] dynamic_test_name; // to keep a string

    // DUT connection
    up_down_4bit_counter DUT (
        .clk(clk),
        .rst_n(rst_n),
        .sync_load(sync_load),
        .up_down(up_down),
        .load_data(load_data),
        .count(count)
    );

    // 10 MHz clock generation
    always begin
        #50 clk = ~clk;
    end

    // helper task
    // 'test_name' param is 40 char string (Verilog-2001 doesn't support string types)
    task check_output(input [3:0] expected_value, input [8*40:1] test_name);
    begin
        if (count !== expected_value) begin
            $display("[FAIL] %s | Error! Received: %d, Expected: %d at time %0t ps", 
                     test_name, count, expected_value, $time);
            errors = errors + 1;
        end else begin
            $display("[PASS] %s | Matched: %d at time %0t ps", test_name, count, $time);
            success_tests = success_tests + 1;
        end
    end
    endtask

    // The main test script
    initial begin
        // init signals and vars (blocking assignment!)
        clk = 0;
        rst_n = 1;
        sync_load = 0;
        up_down = 1;
        load_data = 4'b0000;
        errors = 0;
        success_tests = 0;
        i = 0;
 
        // FPGA's GSR delay (post-synthesis/implementation)
        #105;

        $display("=== START TESTBENCH ===");

        // 1st test: sync rst_n
        @(posedge clk);  // wait for the next 'posedge clk'
        #10;             // delay to match post-synth/impl timing simulation (setup/hold deltas)
        rst_n <= 0;      // NBA for synced signals!
        @(posedge clk);  // rst_n 1 -> 0, count X -> 0
        #10;
        rst_n <= 1;
        @(negedge clk); // always check signals after @(negedge clk)!
        check_output(4'd0, "Test 1: Active sync reset");

        // 2nd test: sync input data load
        @(posedge clk);
        #10;
        load_data <= 4'd12; // sync signals should be set after 'posedge clk' (post-synthesis)
        sync_load <= 1;
        @(posedge clk);
        #10;
        sync_load <= 0;
        @(negedge clk);
        check_output(4'd12, "Test 2: Sync input data load");

        // 3rd test: increment counter (up_down = 1 at this moment)
        @(posedge clk); @(negedge clk); check_output(4'd13, "Test 3: Count up (+1)");
        @(posedge clk); @(negedge clk); check_output(4'd14, "Test 3: Count up (+2)");
        @(posedge clk); @(negedge clk); check_output(4'd15, "Test 3: Count up (+3)");
        // Overflow check (15 -> 0)
        @(posedge clk); @(negedge clk); check_output(4'd0,  "Test 3: Overflow up (15->0)");

        // 4th test: decrement counter
        @(posedge clk); // count 0 -> 1
        #10;
        up_down <= 0;
        // Inverse overfow check (0 -> 15)
        @(posedge clk); // count 1 -> 0
        @(posedge clk); // count 0 -> 15
        @(negedge clk);
        check_output(4'd15, "Test 4: Overflow down (0->15)");
        for (i = 14; i >= 0; i = i - 1) begin
            $sformat(dynamic_test_name, "Test 4: Count down (-%0d)", (14 - i + 1));
            @(posedge clk); @(negedge clk);
            check_output(i[3:0], dynamic_test_name);
        end
        $display("Test 4: From 15 to 0 counts are tested");

        // 5th test: test 'rst_n' priority over 'sync_load'
        @(posedge clk);
        #10;  // once again - this delay may be omitted for functional simulation but is needed for timing simulation
        load_data <= 4'd7;
        sync_load <= 1;
        rst_n <= 0;
        @(posedge clk);
        #10;
        rst_n <= 1;
        sync_load <= 0;
        @(negedge clk);
        check_output(4'd0, "Test 5: rst_n/sync_load priority test");

        // Results:
        #100;
        $display("\n=== RESULTS ===");
        $display("Successful tests: %0d", success_tests);
        $display("Errors total: %0d", errors);

        if (errors == 0) begin
            $display(">>> TEST SUCCEED! <<<");
        end else begin
            $display(">>> TEST FAILED! <<<");
        end

        $finish; // Finish simulation
    end

    // Additional time and signal monitoring
    initial begin
        $monitor("Time: %0t | rst_n = %b | sync_load = %b | up_down = %b | count = %d", 
                 $time, rst_n, sync_load, up_down, count);
    end

endmodule
