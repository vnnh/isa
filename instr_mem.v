module instruction_memory(input [9:0] addr, output [15:0] instruction);
    reg [15:0] mem [1023:0];
    initial begin
        $readmemh("program.mem", mem);
    end

    assign instruction = mem[addr];
endmodule
