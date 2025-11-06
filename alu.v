module alu(input [15:0] a, [15:0] b, [3:0] alu_op, output reg [15:0] result, output zero, neg);
	localparam ALU_ADD = 4'b0000;
	localparam ALU_SUB = 4'b0001;
	localparam ALU_AND = 4'b0010;
	localparam ALU_OR  = 4'b0011;
	localparam ALU_SLL = 4'b0100;
	localparam ALU_LUI = 4'b0101;

    always @(*) begin
        case (alu_op)
            ALU_ADD: result = a + b;
            ALU_SUB: result = a - b;
            ALU_AND: result = a & b;
            ALU_OR: result = a | b;
            ALU_SLL: result = a << b;
            ALU_LUI: result = b; // lui passes B to output
            default: result = 16'hXXXX;
        endcase
    end

    assign zero = result == 16'h0000;
    assign neg = result[15] == 1'b1;
endmodule
