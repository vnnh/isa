# Test Bench

- the `instruction_memory` module reads in `program.mem`
- the provided `program.mem` tests all instructions by storing results in the `data_memory` module
- `isa_tb.v` inspects the memory in `data_memory` to ensure that stored values match expected values from the logic in `program.mem`
