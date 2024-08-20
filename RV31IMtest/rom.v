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
// Instruction Memory (program initialized ROM)

`include "archerdefs.v"

module rom (
	input [`ADDRLEN-1:0] addr,
	output [`XLEN-1:0] dataout
	);
	
  integer i;
  reg [7:0] rom_array [0:(2**(`ADDRLEN))-1];
  wire [(`ADDRLEN-1):0] word_addr;
  
  assign word_addr = {addr[(`ADDRLEN-1):2], 2'b00};
  assign dataout = {rom_array[word_addr+3], rom_array[word_addr+2], rom_array[word_addr+1], rom_array[word_addr]};
  
  initial 
  begin
  //test1:
    rom_array[0] = 8'h13;
    rom_array[1] = 8'h05;
    rom_array[2] = 8'h70;
    rom_array[3] = 8'h01;//addi x10, x0, 23
    
    rom_array[4] = 8'h93;
    rom_array[5] = 8'h05;
    rom_array[6] = 8'h30;
    rom_array[7] = 8'h00;//addi x11, x0, 3
    
    rom_array[8] = 8'h13;
    rom_array[9] = 8'h06;
    rom_array[10] = 8'h60;
    rom_array[11] = 8'h06;//addi x12, x0, 102
    
    rom_array[12] = 8'hB3;
    rom_array[13] = 8'h07;
    rom_array[14] = 8'hB5;
    rom_array[15] = 8'h02;//mul x15, x10, x11
    
    rom_array[16] = 8'h33;
    rom_array[17] = 8'h18;
    rom_array[18] = 8'hB5;
    rom_array[19] = 8'h02;//mulh x16, x10, x11
    
    rom_array[20] = 8'hB3;
    rom_array[21] = 8'h28;
    rom_array[22] = 8'h25;
    rom_array[23] = 8'h02;//mulhsu x17, x10, x11
    
    rom_array[24] = 8'h33;
    rom_array[25] = 8'h39;
    rom_array[26] = 8'hB5;
    rom_array[27] = 8'h02;//mulhu x18, x10, x11
    
    rom_array[28] = 8'hB3;
    rom_array[29] = 8'h49;
    rom_array[30] = 8'hB5;
    rom_array[31] = 8'h02;//div x19, x10, x11
    
    rom_array[32] = 8'h33;
    rom_array[33] = 8'h5A;
    rom_array[34] = 8'hB5;
    rom_array[35] = 8'h02;//divu x20, x10, x11
    
        
    rom_array[36] = 8'hB3;
    rom_array[37] = 8'h6A;
    rom_array[38] = 8'hB5;
    rom_array[39] = 8'h02;//rem x21, x10, x11
    
    rom_array[40] = 8'h33;
    rom_array[41] = 8'h7B;
    rom_array[42] = 8'hB5;
    rom_array[43] = 8'h02;//remu x22, x10, x11
    
    //test2:
    
    rom_array[44] = 8'h13;
    rom_array[45] = 8'h05;
    rom_array[46] = 8'hD0;
    rom_array[47] = 8'h0A;//addi x10, x0, 173
    
    rom_array[48] = 8'h33;
    rom_array[49] = 8'h05;
    rom_array[50] = 8'hA5;
    rom_array[51] = 8'h02;//mul x10, x10, x10
    
    rom_array[52] = 8'h13;
    rom_array[53] = 8'h05;
    rom_array[54] = 8'h75;
    rom_array[55] = 8'h04;//addi x10, x10, 71
    
    rom_array[56] = 8'h93;
    rom_array[57] = 8'h05;
    rom_array[58] = 8'hF0;
    rom_array[59] = 8'hFF;//addi x11, x0, -1
    
    rom_array[60] = 8'hB3;
    rom_array[61] = 8'h06;
    rom_array[62] = 8'hB5;
    rom_array[63] = 8'h02;//mul x13, x10, x11
    
    rom_array[64] = 8'h33;
    rom_array[65] = 8'h17;
    rom_array[66] = 8'hB5;
    rom_array[67] = 8'h02;//mulh x14, x10, x11
    
    rom_array[68] = 8'hB3;
    rom_array[69] = 8'h37;
    rom_array[70] = 8'hB5;
    rom_array[71] = 8'h02;//mulhu x15, x10, x11
    
    rom_array[72] = 8'h33;
    rom_array[73] = 8'h28;
    rom_array[74] = 8'hB5;
    rom_array[75] = 8'h02;//mulhsu x16, x10, x11
    
    //test3:
    
    rom_array[76] = 8'h13;
    rom_array[77] = 8'h06;
    rom_array[78] = 8'h80;
    rom_array[79] = 8'h00;//addi x12, x0, 8
    
    rom_array[80] = 8'h13;
    rom_array[81] = 8'h16;
    rom_array[82] = 8'hC6;
    rom_array[83] = 8'h01;//slli x12, x12, 28
    
    rom_array[84] = 8'hB3;
    rom_array[85] = 8'h48;
    rom_array[86] = 8'h05;
    rom_array[87] = 8'h02;//div x17, x10, x0
    
    rom_array[88] = 8'h33;
    rom_array[89] = 8'h49;
    rom_array[90] = 8'hB6;
    rom_array[91] = 8'h02;//div x18, x12, x11
    
    rom_array[92] = 8'hB3;
    rom_array[93] = 8'h59;
    rom_array[94] = 8'hB5;
    rom_array[95] = 8'h02;//divu x19, x10, x11
    
    rom_array[96] = 8'h33;
    rom_array[97] = 8'h6A;
    rom_array[98] = 8'hB5;
    rom_array[99] = 8'h02;//rem x20, x10, x11
    
    rom_array[100] = 8'hB3;
    rom_array[101] = 8'h7A;
    rom_array[102] = 8'hB5;
    rom_array[103] = 8'h02;//remu x21, x10, x11
    
   
    for (i = 104; i < 2**(`ADDRLEN); i = i + 1) 
    begin
      rom_array[i] = 8'h00;
    end
    
  end
endmodule
