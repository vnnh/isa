module control_unit(
	input[3:0] opcode,
	input[2:0] fn,
	output reg Halt,
        Jump, BLT, JR, Branch, LType, ALUSrcA, ALUSrcB,
        JLink, WBSrc, Load, Store, WB, WBReg, output reg [3:0] ALUOp
);
	localparam ALU_ADD = 4'b0000;
	localparam ALU_SUB = 4'b0001;
	localparam ALU_AND = 4'b0010;
	localparam ALU_OR  = 4'b0011;
	localparam ALU_SLL = 4'b0100;
	localparam ALU_LUI = 4'b0101;

	always @(*) begin
		Jump = 1'b0;
		BLT = 1'b0;
		Branch = 1'b0;
		JR = 1'b0;
		Halt = 1'b0;
		LType = 1'b0; //0: rt or sign-extended,
			      //1: upper/lower 8-bit immediate
		ALUSrcA = 1'b0; // 0: rs, 1: rt
		ALUSrcB = 1'b0; // 1: use shifted/sign-extended
		JLink = 1'b0; // 1: use pc value
		WBSrc = 1'b1; // 0: mem, 1: alu
		Load = 1'b0;
		Store = 1'b0;
		ALUOp = 4'hX;
		WB = 1'b0;
		WBReg = 1'b0; // 0: rt, 1: rd

		case (opcode)
			4'b0000: begin // r-type
				WB = 1'b1;
				WBSrc = 1'b1;
				WBReg = 1'b1;
				case (fn)
					3'b000: ALUOp = ALU_ADD; // add
					3'b001: ALUOp = ALU_SUB; // sub
					3'b010: ALUOp = ALU_AND; // and
					3'b011: ALUOp = ALU_OR; // or
					3'b100: begin // jr
						Jump = 1'b1;
						WB = 1'b0;
						JR = 1'b1;
					end
					3'b111: begin // halt
						WB = 1'b0;
						Halt = 1'b1;
					end
					default: WB = 1'b0; // noop
				endcase
			end

			4'b0001: begin // addi
				WB = 1'b1;
				WBReg = 1'b0;
				WBSrc = 1'b1;
				ALUSrcA = 1'b1;
				LType = 1'b1;
				ALUSrcB = 1'b0;
				ALUOp = ALU_ADD;
			end

			4'b0010: begin // subi
				WB = 1'b1;
				WBReg = 1'b0;
				WBSrc = 1'b1;
				ALUSrcA = 1'b1;
				LType = 1'b1;
				ALUSrcB = 1'b0;
				ALUOp = ALU_SUB;
			end

			4'b0011: begin // lui
				WB = 1'b1;
				WBReg = 1'b0;
				WBSrc = 1'b1;
				ALUSrcA = 1'b1;
				LType = 1'b1;
				ALUSrcB = 1'b1;
				ALUOp = ALU_LUI;
			end

			4'b0100: begin // slli
				WB = 1'b1;
				WBReg = 1'b0;
				WBSrc = 1'b1;
				ALUSrcA = 1'b0;
				LType = 1'b0;
				ALUSrcB = 1'b1;
				ALUOp = ALU_SLL;
			end

			4'b0101: begin // load
				WB = 1'b1;
				WBReg = 1'b0;
				WBSrc = 1'b0;
				ALUSrcA = 1'b0;
				LType = 1'b0;
				ALUSrcB = 1'b1;
				ALUOp = ALU_ADD;
				Load = 1'b1;
			end

			4'b0110: begin // store
				WB = 1'b0;
				ALUSrcA = 1'b0;
				LType = 1'b0;
				ALUSrcB = 1'b1;
				ALUOp = ALU_ADD;
				Store = 1'b1;
			end

			4'b0111: begin // j
				Jump = 1'b1;
			end

			4'b1000: begin // jl
				Jump = 1'b1;
				JLink = 1'b1;
				WB = 1'b1;
				WBReg = 1'b0;
				WBSrc = 1'b0;
			end

			4'b1001: begin // beq
				Branch = 1'b1;
				ALUSrcA = 1'b0;
				LType = 1'b0;
				ALUSrcB = 1'b0;
				ALUOp = ALU_SUB;
			end

			4'b1010: begin // blt
				BLT = 1'b1;
				Branch = 1'b1;
				ALUSrcA = 1'b0;
				LType = 1'b0;
				ALUSrcB = 1'b0;
				ALUOp = ALU_SUB;
			end
		endcase
	end
endmodule
