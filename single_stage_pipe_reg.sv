module single_stage_pipe_reg #(parameter N = 32)(
    input logic clk, rst_n, in_valid,
    input logic [N-1:0] in_data,
    input logic out_ready,
    output logic in_ready, out_valid,
    output logic [N-1:0] out_data
);

    logic [N-1:0] data_reg;
    logic valid_reg;
	 
    assign in_ready = ~valid_reg || (out_ready && out_valid);
    assign out_valid = valid_reg;
    assign out_data  = data_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_reg <= 1'b0;
        end
        else begin
            if (in_ready && in_valid) begin
                data_reg  <= in_data;
                valid_reg <= 1'b1;
            end
            else if (out_ready && out_valid) begin
                valid_reg <= 1'b0;
            end
        end
    end

endmodule
