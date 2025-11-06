module register_file(
    input clk, reset, WB,
    input [2:0] rs,
    input [2:0] rt,
    input [2:0] rd,
    input [15:0] rd_data,
    output [15:0] rs_data,
    output [15:0] rt_data
);
    reg [15:0] R [7:0];

    assign rs_data = (rs == 3'b0) ? 16'h0000 : R[rs];
    assign rt_data = (rt == 3'b0) ? 16'h0000 : R[rt];

    always @(posedge clk or posedge reset) begin
        if (reset) begin : reset_block
            integer ri;
            for (ri = 0; ri < 8; ri = ri + 1) R[ri] <= 16'h0000;
        end else if (WB && rd != 3'b0) begin
            R[rd] <= rd_data;
        end
    end
endmodule
