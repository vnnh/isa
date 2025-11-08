<h3 align="center">
    <img width="2285" height="1420" alt="datapath" src="https://github.com/user-attachments/assets/7d2c6f80-f9b9-48a3-8028-dee5d31b6c8b" />
    <br />
    ISA Processor Design
</h3>

# Test Bench

- the `instruction_memory` module reads in `program.mem`
- the provided `program.mem` tests all instructions by storing results in the `data_memory` module
- `isa_tb.v` inspects the memory in `data_memory` to ensure that stored values match expected values from the logic in `program.mem`
