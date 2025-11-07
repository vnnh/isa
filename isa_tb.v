`timescale 1ns / 1ps
module isa_tb();
    reg clk;
    reg reset;
    wire halted;

    isa uut (
        .clk(clk),
        .reset(reset),
        .halted(halted)
    );

    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
        // 10ns period = 100MHz
    end

    initial begin
        reset = 1'b1;
        #20;
        reset = 1'b0;
        $display("Starting test at %t", $time);
        $display("PC | Instruction | Time Started");
        $monitor("%h | %h | %t", uut.pc_out, uut.instr, $time);

        wait (halted == 1'b1);
        $display("Halted at %t", $time);
        #20;

        validate(10'h100, 16'h00FF); // add
        validate(10'h101, 16'h00E1); // sub
        validate(10'h102, 16'h0000); // and
        validate(10'h103, 16'h00FF); // or
        validate(10'h104, 16'h00FF); // addi
        validate(10'h105, 16'hFF01); // subi
        validate(10'h106, 16'hF100); // lui
        validate(10'h107, 16'h0F00); // slli
        validate(10'h0FF, 16'h0F00); // store
        validate(10'h0FE, 16'h0F00); // load
        validate(10'h108, 16'h0001); // beq (false)
        validate(10'h109, 16'h0001); // beq (true)
        validate(10'h10A, 16'h0002); // blt (false)
        validate(10'h10B, 16'h0002); // blt (true)
        validate(10'h10C, 16'h0002); // j
        validate(10'h10D, 16'h0004); // jr + jl test

        $display("PASSED ALL TESTS");

        $finish;
    end

	task validate(input [9:0] addr, input [15:0] expected_data);
		begin : check_task
			reg [15:0] observed_data;
	        observed_data = uut.dmem.mem[addr];
	        if (observed_data !== expected_data) begin
	            $display("FAIL: M[0x%h]", addr);
	            $display("	Expected: 0x%h", expected_data);
				$display("	Found: 0x%h", observed_data);
	            $finish;
	        end else begin
	            $display("PASS: M[0x%h] == 0x%h", addr, observed_data);
	        end
		end
    endtask
endmodule
