module data_memory(input clk, Load, Store,
        input [9:0] addr, input [15:0] write_data, output [15:0] read_data);
    reg [15:0] mem [1023:0];

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    assign read_data = Load ? mem[addr] : 16'hXXXX;

    always @(posedge clk) begin
        if (Store) begin
            mem[addr] <= write_data;
        end
    end
endmodule
