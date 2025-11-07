module isa(input clk, input reset, output halted);
    wire Halt;
    assign halted = Halt;
    wire Jump;
    wire BLT;
    wire JR;
    wire Branch;
    wire LType;
    wire ALUSrcA;
    wire ALUSrcB;
    wire JLink;
    wire WBSrc;
    wire Load;
    wire Store;
    wire [3:0] ALUOp;
    wire WB;
    wire WBReg;

    wire [9:0]  pc_out, pc_in;
    wire [15:0] instr;

    wire [2:0]  rs, rt, rd;
    assign rd = JLink ? 3'b111 : (WBReg ? instr[5:3] : instr[11:9]);
    wire [15:0] rs_data, rt_data;
    wire [15:0] rd_data;

    wire [15:0] imm_sext;
    wire [15:0] imm_shifted;
	wire [15:0] imm_9;
    assign imm_sext = {{10{instr[5]}}, instr[5:0]};
    assign imm_shifted = {instr[7:0], 8'b0};
	assign imm_9 = {7'b0, instr[8:0]};
    wire [15:0] alu_a, alu_b;
    wire [15:0] alu_out;
    wire alu_zero;
    wire alu_neg;

    wire [15:0] mem_read_data;

    wire [9:0] pc_plus_1;
    assign pc_plus_1 = pc_out + 1;
    wire [9:0]  branch_target;
    assign branch_target = pc_plus_1 + imm_sext[9:0];

    wire [3:0] op = instr[15:12];
    wire [2:0] fn = instr[2:0];

    assign rs = instr[8:6];
    assign rt = instr[11:9];

    pc pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_write(Halt),
        .pc_out(pc_out)
    );

    instruction_memory imem (
        .addr(pc_out),
        .instruction(instr)
    );

    control_unit ctrl (
        .opcode(op),
        .fn(fn),
        .Halt(Halt),
        .Jump(Jump),
        .BLT(BLT),
        .JR(JR),
        .Branch(Branch),
        .LType(LType),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .JLink(JLink),
        .WBSrc(WBSrc),
        .Load(Load),
        .Store(Store),
        .ALUOp(ALUOp),
        .WB(WB),
        .WBReg(WBReg)
    );

    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .rd_data(rd_data),
        .WB(WB),
        .rs_data(rs_data),
        .rt_data(rt_data)
    );

    assign alu_a = ALUSrcA ? rt_data : rs_data;
    assign alu_b = {LType, ALUSrcB} == 2'b00 ? rt_data
        : {LType, ALUSrcB} == 2'b01 ? imm_sext
        : {LType, ALUSrcB} == 2'b10 ? imm_9
        : {LType, ALUSrcB} == 2'b11 ? imm_shifted
        : 16'hXXXX;

    alu alu_mod (
        .a(alu_a),
        .b(alu_b),
        .alu_op(ALUOp),
        .result(alu_out),
        .zero(alu_zero),
        .neg(alu_neg)
    );

    data_memory dmem (
        .clk(clk),
        .addr(alu_out[9:0]),
        .write_data(rt_data),
        .read_data(mem_read_data),
        .Store(Store),
        .Load(Load)
    );

    wire PCMuxB;
    assign PCMuxB = (Branch && (BLT ? alu_neg : alu_zero)) || JR;
    assign pc_in = {Jump, PCMuxB} == 2'b00 ? pc_plus_1
        : {Jump, PCMuxB} == 2'b01 ? branch_target
        : {Jump, PCMuxB} == 2'b10 ? instr[9:0]
        : {Jump, PCMuxB} == 2'b11 ? rt_data
        : pc_plus_1;

	assign rd_data = {JLink, WBSrc} == 2'b00 ? mem_read_data
        : {JLink, WBSrc} == 2'b01 ? alu_out
        : {JLink, WBSrc} == 2'b10 ? pc_plus_1
        : 16'hXXXX;
endmodule
