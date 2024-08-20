//
// SPDX-License-Identifier: CERN-OHL-P-2.0+
//
// Copyright (C) 2021-2024 Embedded and Reconfigurable Computing Lab, American University of Beirut
// Contributed by:
// Mazen A. R. Saghir <mazen@aub.edu.lb>
//
// This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,
// INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR
// A PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable
// conditions.
// Source location: https://github.com/ERCL-AUB/archer/rv32i_single_cycle
//
// Archer RV32I single-cycle datapath wrapper (top-level entity)

`include "archerdefs.v"
//this is just a test
module archer_rv32i_single_cycle (
	input clk,
	input rst_n,
	// local instruction memory bus interface
	output [`ADDRLEN-1:0] imem_addr,
	output [`XLEN-1:0] imem_datain,
	input [`XLEN-1:0] imem_dataout,    
	output imem_wen,
	output [3:0] imem_ben,
	// local data memory bus interface
	output [`ADDRLEN-1:0] dmem_addr,
	output [`XLEN-1:0] dmem_datain,
	input [`XLEN-1:0] dmem_dataout,
	output dmem_wen,
	output [3:0] dmem_ben,
	output [31:0] in1,
	output [31:0] in2,
	output [31:0] value_out
	);
	
	
    // pc wires
    wire [`XLEN-1:0] d_pc_in;
    wire [`XLEN-1:0] d_pc_out;

    // imem wires
    //wire [`ADDRLEN-1:0] d_imem_addr;
    wire [`XLEN-1:0] d_instr_word;

    // add4 wires
    wire [`XLEN-1:0] d_pcplus4;

    // control wires
    wire c_branch_out;
    wire c_jump;
    wire c_lui;
    wire c_PCSrc;
    wire c_reg_write;
    wire c_alu_src1;
    wire c_alu_src2;
    wire [3:0] c_alu_op;
    wire c_mem_write;
    wire c_mem_read;
    wire c_mem_to_reg;
    wire [2:0]c_muldiv_op;     //this wire will be used to connect the output og the control to the input of the muldiv block
    wire c_Mext;               // this wire will be used to connect the output of the control to the selecter of the multiplexer that chooses between the output of alu and output of muldiv block




    //alu_muldiv_mux2to1 wires
    wire [31:0] c_muldiv_to_mux;            //this wire will connect the output of muldiv to the multiplexer so that it can choose between it or the output of the alu
    wire [31:0] c_alu_muldiv_mux2to1_out;   //this wire will connect the output of the multiplexer to the other multiplexer that chooses what to store back in memory (it chooses between this output or something from the data memory)
    
    
    // register file wires

    wire [`XLEN-1:0] d_reg_file_datain;
    wire [`XLEN-1:0] d_regA;
    wire [`XLEN-1:0] d_regB;

    // immgen wires

    wire [`XLEN-1:0] d_immediate;

    // lui_mux wires

    wire [`XLEN-1:0] d_zero;
    wire [`XLEN-1:0] d_lui_mux_out;

    // alu_src1_mux wires 

    wire [`XLEN-1:0] d_alu_src1;

    // alu_src2_mux wires 

    wire [`XLEN-1:0] d_alu_src2;

    // alu wires

    wire [`XLEN-1:0] d_alu_out;

    // mem_mux wires

    wire [`XLEN-1:0] d_mem_mux_out;

    // lmb wires

    wire [1:0] d_byte_mask;
    wire d_sign_ext_n;
    wire [`XLEN-1:0] d_data_mem_out;
    
    

    // instruction word fields

    wire [4:0] d_rs1;
    wire [4:0] d_rs2;
    wire [4:0] d_rd;
    wire [2:0] d_funct3;
    wire [6:0] d_funct7;
    
    pc pc_inst (.clk(clk), 
                .rst_n(rst_n), 
                .datain(d_pc_in), 
                .dataout(d_pc_out));
    
    lmb limb_inst (.proc_addr(d_pc_out), 
                   .proc_data_send(`XLEN'd0), 
                   .proc_data_receive(d_instr_word),
    		   .proc_byte_mask(2'b10), 
    		   .proc_sign_ext_n(1'b1), 
    		   .proc_mem_write(1'b0),
    		   .proc_mem_read(1'b1), 
    		   .mem_addr(imem_addr), 
    		   .mem_datain(imem_datain), 
    		   .mem_dataout(imem_dataout), 
    		   .mem_wen(imem_wen), 
    		   .mem_ben(imem_ben));
    		   
    add4 add4_inst (.datain(d_pc_out), 
    		    .result(d_pcplus4));
    
    mux2to1 pc_mux (.sel(c_PCSrc), 
                    .input0(d_pcplus4), 
                    .input1(d_alu_out), 
                    .muxout(d_pc_in));
    
    control control_inst (.instruction(d_instr_word), 
    			  .BranchCond(c_branch_out), 
    			  .Jump(c_jump), 
    			  .Lui(c_lui),
    			  .PCSrc(c_PCSrc),
    			  .RegWrite(c_reg_write),
    			  .ALUSrc1(c_alu_src1),
    			  .ALUSrc2(c_alu_src2),
    			  .ALUOp(c_alu_op),
    			  .MemWrite(c_mem_write),
    			  .MemRead(c_mem_read),
    			  .MemToReg(c_mem_to_reg),
    			  .MulDivOp(c_muldiv_op),           //connecting the funct3 output to the corresponding wire
    			  .Mext(c_Mext)                     //connecting the funct7[0] output to the corresponding wire
    			  );
    			  
    mux2to1 write_back_mux (.sel(c_jump),
    			    .input0(d_mem_mux_out),
    			    .input1(d_pcplus4),
    			    .muxout(d_reg_file_datain));
    			    
    regfile RF_inst (.clk(clk),
    		     .rst_n(rst_n),
    		     .RegWrite(c_reg_write),
    		     .rs1(d_rs1),
    		     .rs2(d_rs2),
    		     .rd(d_rd),
    		     .datain(d_reg_file_datain),
    		     .regA(d_regA),
    		     .regB(d_regB));
    		     
    branch_cmp brcmp_inst (.inputA(d_regA),
    			   .inputB(d_regB),
    			   .cond(d_funct3),
    			   .result(c_branch_out));
    			   
    immgen immgen_inst (.instruction(d_instr_word),
    			.immediate(d_immediate));
    			
    mux2to1 lui_mux (.sel(c_lui),
    		     .input0(d_pc_out),
    		     .input1(d_zero),
    		     .muxout(d_lui_mux_out));
    		     
    mux2to1 alu_src1_mux (.sel(c_alu_src1),
    			  .input0(d_regA),
    			  .input1(d_lui_mux_out),
    			  .muxout(d_alu_src1));
    			  
    mux2to1 alu_src2_mux (.sel(c_alu_src2),
    			  .input0(d_regB),
    			  .input1(d_immediate),
    			  .muxout(d_alu_src2));
    			 
    mux2to1 mem_mux (.sel(c_mem_to_reg),
                     .input0(c_alu_muldiv_mux2to1_out),      //this should be changed from d_alu_out to c_alu_muldiv_mux2to1_out because we can store in memory any of the results of the alu or muldiv block
                     .input1(d_data_mem_out),
                     .muxout(d_mem_mux_out));
                     
    alu alu_inst (.inputA(d_alu_src1),
                  .inputB(d_alu_src2),
                  .ALUop(c_alu_op),
                  .result(d_alu_out));
    			
    lmb ldmb_inst (.proc_addr(d_alu_out),
    		   .proc_data_send(d_regB),
    		   .proc_data_receive(d_data_mem_out),
    		   .proc_byte_mask(d_byte_mask),
    		   .proc_sign_ext_n(d_sign_ext_n),
    		   .proc_mem_write(c_mem_write),
    		   .proc_mem_read(c_mem_read),
    		   .mem_addr(dmem_addr),
    		   .mem_datain(dmem_datain),
    		   .mem_dataout(dmem_dataout),
    		   .mem_wen(dmem_wen),
    		   .mem_ben(dmem_ben));
    		   
    // we created the 2 following blocks:
    		   
    mul_div muldiv(.inputA(d_regA),
                   .inputB(d_regB),
                   .operation(c_muldiv_op),
                   .result(c_muldiv_to_mux),
                   .div_zero(),
                   .div_overflow()
                   );
    
    alu_muldiv_mux2to1 mux_alu_and_muldiv (.sel(c_Mext),
                               .alu_out(d_alu_out),
                               .muldiv_out(c_muldiv_to_mux),
                               .mux_out(c_alu_muldiv_mux2to1_out)
                               );
    
    
    		   
    assign d_rs1 = d_instr_word[`LOG2_XRF_SIZE+14:15];
    assign d_rs2 = d_instr_word[`LOG2_XRF_SIZE+19:20];
    assign d_rd = d_instr_word[`LOG2_XRF_SIZE+6:7];
    assign d_funct3 = d_instr_word[14:12];
    assign d_funct7 = d_instr_word[31:25];
    assign d_zero = `XLEN'd0;
    assign d_byte_mask = d_funct3[1:0];
    assign d_sign_ext_n = d_funct3[2];
	
	assign in1=d_alu_src1;
	assign in2=d_alu_src2;
	assign value_out = c_alu_muldiv_mux2to1_out;


endmodule
