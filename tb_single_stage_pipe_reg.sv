`timescale 1ns/1ps

module tb_single_stage_pipe_reg;

    parameter N = 32;
    logic clk;
    logic rst_n;
    logic in_valid;
    logic [N-1:0] in_data;
    logic out_ready;
    logic in_ready;
    logic out_valid;
    logic [N-1:0] out_data;

    single_stage_pipe_reg #(.N(N)) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .in_valid  (in_valid),
        .in_data   (in_data),
        .out_ready (out_ready),
        .in_ready  (in_ready),
        .out_valid (out_valid),
        .out_data  (out_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 0;
        rst_n     = 0;
        in_valid  = 0;
        in_data   = 0;
        out_ready = 0;

        #20;
        rst_n = 1;

        // Case 1: Normal transfer
        @(posedge clk);
        in_valid  = 1;
        in_data   = 32'hA5A4_A3A2;
        out_ready = 1;

        @(posedge clk);
        in_valid = 0;

        // Case 2: Backpressure (out_ready deasserted)
        @(posedge clk);
        in_valid  = 1;
        in_data   = 32'hA5A4_A3A1;
        out_ready = 0;

        repeat (3) @(posedge clk);

        // Release backpressure
        out_ready = 1;

        @(posedge clk);
        in_valid = 0;

        // Case 3: Bubble (no input)
        repeat (2) @(posedge clk);

        // Case 4: Back-to-back transfers
        @(posedge clk);
        in_valid  = 1;
        in_data   = 32'hABCD_DCBA;
        out_ready = 1;

        @(posedge clk);
        in_data   = 32'hABCD_ABCD;

        @(posedge clk);
        in_valid = 0;

        repeat (5) @(posedge clk);

        $finish;
    end

    always @(posedge clk) begin
        $display(
            "T=%0t | in_v=%b in_r=%b in_d=%h | out_v=%b out_r=%b out_d=%h",$time, in_valid, in_ready, in_data,
            out_valid, out_ready, out_data
        );
    end

endmodule
