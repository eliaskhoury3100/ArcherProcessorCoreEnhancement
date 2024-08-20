
Enhancement of Single-Cycle RV32I Processor Core - Archer

Project Overview

This project expands the design of a single-cycle RV32I processor core, named Archer, to support the “M” standard ISA extension for integer multiplication and division. The project is a part of the EECE 321 Computer Organization course at the American University of Beirut.

Features

• Processor Core: Implements most instructions of the RV32I base integer instruction set.
• Expanded Datapath: Supports the “M” standard ISA extension, enabling the following instructions:
• Multiplication: MUL, MULH, MULHU, MULHSU
• Division: DIV, DIVU
• Remainder: REM, REMU
• Simulation and Validation: Utilizes the Xilinx Vivado simulator to validate both the hardware unit supporting the “M” ISA extensions and the complete datapath.


Directory Structure

• mul_div_unit/
Contains the Verilog source files for the multiply/divide unit and the testbench used for validation.
• archer_rv32im/
Includes the Verilog source files implementing the expanded datapath, the new top-level wrapper (archer_rv32im.v), and the corresponding testbench (archer_rv32im_tb.v).
• RV32IMtest/
Contains the test program files to validate the signed/unsigned multiply/divide/remainder instructions:
	• RISC-V assembly code: RV32IMtest.s
	• RISC-V machine code: RV32IMtest.o
	• Verilog ROM model: RV32IM_test_rom.vhd
• report/
A comprehensive report detailing:
	• The block diagram of the multiply/divide unit.
	• Vivado simulator waveforms for validation.
	• Detailed datapath block diagram.
	• Descriptions of input/output ports and functionalities for new/modified datapath blocks.
	• Test assembly code description and corresponding simulator waveforms.
	• A summary of each team member’s contributions.

How to Use

1. Simulation: Use the Xilinx Vivado simulator to run the provided Verilog testbenches. The functionality of the processor is confirmed by viewing the waveform results, particularly focusing on multiplication, division, and remainder operations.
2. Testing: Run the provided test programs in the RV32IMtest folder to validate the extended datapath. The RISC-V machine code can be used with the Venus simulator to verify individual instructions.