# single-stage-pipeline-register

- Implement a single-stage pipeline register in SystemVerilog using a standard valid/ready handshake. 
- The module sits between an input and output interface, accepts data when in_valid and in_ready are asserted, presents stored data on the output with out_valid, and correctly handles backpressure without data loss or duplication. The design should be fully synthesizable and reset to a clean, empty state. 
