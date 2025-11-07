module pc(input clk, reset, pc_write,
        input [9:0] pc_in, output reg [9:0] pc_out);
    always @(posedge clk or posedge reset) begin
        if (reset) pc_out <= 10'h000;
        else if (pc_write == 0) pc_out <= pc_in; // pc_write is inverted
    end
endmodule
