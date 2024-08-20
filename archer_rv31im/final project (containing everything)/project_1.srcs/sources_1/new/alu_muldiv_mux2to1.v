`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2024 09:26:30 AM
// Design Name: 
// Module Name: alu_muldiv_mux2to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_muldiv_mux2to1(
        input sel,                //this selecter will be mapped to Mext in the control block
        input [31:0] alu_out,     //this is connected to the output of the alu that is always computed
        input [31:0] muldiv_out,  //this is connected to the output of the muldiv that is always computed
        output [31:0] mux_out      //this should be connected to a mux that will write back into memory by chosing the output computed, or something from the data memory
    );
        assign mux_out= (sel==1'b1) ? (muldiv_out) : (alu_out); 
        //if the Mext is 1, then we will take the output of the block that we created. else we will take the output of the ALU.
endmodule