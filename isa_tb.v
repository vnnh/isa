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
