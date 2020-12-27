`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:23:49 07/22/2018 
// Design Name: 
// Module Name:    contrl_UNIT 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module contrl_UNIT(clk,IR,z_sig,m_op,immediate,resume,enablle,fetch_LED,pause_LED);
	
	input clk;
	input [15:0] IR;
	input z_sig;
	
	output reg [41:0] m_op;
	output reg [15:0] immediate;
	
	
	
	input resume;
	input enablle;
	
	output fetch_LED;
	output pause_LED;
	
	wire [9:0] next_add;
	wire[14:0] write_register;
	
	
	parameter RESUME_CHECK = 33;
	parameter J_IR = 32;
	parameter Z_CHECK = 31;
	
	
	parameter FETCH1 = 10'b0000000000;
	parameter FETCH2 = 10'b0000000001;
	parameter FETCH3 = 10'b0000000010;
	parameter FETCH4 = 10'b0000000011;
	parameter FETCH5 = 10'b0000000100;
	
	parameter ADDH1 = 10'b0000001000;
	parameter ADDH2 = 10'b0000001001;
	parameter ADDH3 = 10'b0000001010;
	
	parameter ADDL1 = 10'b0000010000;
	parameter ADDL2 = 10'b0000010001;
	parameter ADDL3 = 10'b0000010010;
	
	parameter ADD1 = 10'b0000011000;
	parameter ADD2 = 10'b0000011001;
	
	parameter CLEAR1 = 10'b0000100000;
	
	parameter ADDI1 = 10'b0000101000;
	parameter ADDI2 = 10'b0000101001;
	
	parameter SHIFTR1 = 10'b0000110000;
	parameter SHIFTR2 = 10'b0000110001;
	
	parameter SHIFTL1 = 10'b0000111000;
	parameter SHIFTL2 = 10'b0000111001;
	
	parameter LOAD1 = 10'b0001000000;
	parameter LOAD2 = 10'b0001000001;
	parameter LOAD3 = 10'b0001000010;
	parameter LOAD4 = 10'b0001000011;
	parameter LOAD5 = 10'b0001000100;
	
	parameter INC128 = 10'b0001001000;
	
	parameter STORE1 = 10'b0001010000;
	parameter STORE2 = 10'b0001010001;
	parameter STORE3 = 10'b0001010010;
	parameter STORE4 = 10'b0001010011;
	
	parameter SUBI1 = 10'b0001011000;
	parameter SUBI2 = 10'b0001011001;
	
	parameter JUMPNZ1 = 10'b0001100000;
	parameter JUMPNZ2 = 10'b0001100001;
	parameter JUMPNZ3 = 10'b0101100001;
	
	parameter PAUSE1 = 10'b0011111000;
	parameter PAUSE2 = 10'b1011111000;
	
	
	
	//assign next_add = {resume&&m_op[RESUME_CHECK] , z&&m_op[Z_CHECK] , (m_op[J_IR])?{IR[15:11],3'b0}:m_op[41:34]};
	
	assign next_add[9] = resume&&m_op[RESUME_CHECK];
	assign next_add[8] = z_sig&&m_op[Z_CHECK];
	assign next_add[7:0] = (m_op[J_IR])?{IR[15:11],3'b0}:m_op[41:34];
	
	
	assign write_register = (1 << (IR[10:7] - 1));
	
	assign fetch_LED = (next_add==FETCH1);
	assign pause_LED = (next_add==PAUSE1);
	
	initial begin
		m_op = {8'b11111000,34'b0};
		//immediate = 16'b0;
	end
	
	
	always@(negedge clk) begin
		
		//if(enablle) begin
			
			if(next_add==ADDH2 || next_add==ADDL2) begin
				immediate <= {13'b0,IR[2:0]};
			end else if(next_add==ADDI1 || next_add==SHIFTR1 || next_add==SHIFTL1 || next_add==SUBI1 || next_add==JUMPNZ2)begin
				immediate <= {9'b0, IR[6:0]};
			end else begin
				immediate <= 16'bz;
			end
			
			
			
			case(next_add)
				FETCH1   : m_op <= {8'b00000001 , 3'b000, 5'b11100, 15'b001000000000000, 4'd13   ,7'b0000000};
				FETCH2   : m_op <= {8'b00000010 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0100001};
				//FETCH3   : m_op <= {8'b00000011 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0100001}; // changed
				//FETCH4   : m_op <= {8'b00000100 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0100001};
				FETCH3   : m_op <= {8'b11111000 , 3'b010, 5'b00000, 15'b000000000000000, 4'd0    ,7'b1000001}; //changed
				
				ADDH1    : m_op <= {8'b00001001 , 3'b000, 5'b00100, 15'b100000000000000, IR[6:3] ,7'b0000000};
				ADDH2    : m_op <= {8'b00001010 , 3'b000, 5'b01010, 15'b100000000000000, 4'd0    ,7'b0000000};
				ADDH3    : m_op <= {8'b00000000 , 3'b000, 5'b01000, write_register     , IR[10:7],7'b0000000};
				
				ADDL1    : m_op <= {8'b00010001 , 3'b000, 5'b00011, 15'b100000000000000, IR[6:3] ,7'b0000000};
				ADDL2    : m_op <= {8'b00010010 , 3'b000, 5'b01010, 15'b100000000000000, 4'd0    ,7'b0000000};
				ADDL3    : m_op <= {8'b00000000 , 3'b000, 5'b01000, write_register     , IR[10:7],7'b0000000};
				
				ADD1	   : m_op <= {8'b00011001 , 3'b000, 5'b00010, 15'b100000000000000, IR[6:3] ,7'b0000000};
				ADD2	   : m_op <= {8'b00000000 , 3'b000, 5'b01000, write_register     , IR[10:7],7'b0000000};
				
				CLEAR1   : m_op <= {8'b00000000 , 3'b000, 5'b00001, write_register     , 4'd0    ,7'b0000000};
				
				ADDI1    : m_op <= {8'b00101001 , 3'b000, 5'b00010, 15'b100000000000000, 4'd0    ,7'b0000000};
				ADDI2    : m_op <= {8'b00000000 , 3'b000, 5'b01000, write_register     , IR[10:7],7'b0000000};
				
				SHIFTR1  : m_op <= {8'b00110001 , 3'b000, 5'b00010, 15'b100000000000000, 4'd0    ,7'b0000000};
				SHIFTR2  : m_op <= {8'b00000000 , 3'b000, 5'b00111, write_register     , IR[10:7],7'b0000000};
				
				SHIFTL1  : m_op <= {8'b00111001 , 3'b000, 5'b00010, 15'b100000000000000, 4'd0    ,7'b0000000};
				SHIFTL2  : m_op <= {8'b00000000 , 3'b000, 5'b00110, write_register     , IR[10:7],7'b0000000};
				
				LOAD1    : m_op <= {8'b01000001 , 3'b000, 5'b00010, 15'b000010000000000, IR[6:3] ,7'b0000000};
				LOAD2    : m_op <= {8'b01000011 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0000101};
				//LOAD3    : m_op <= {8'b01000011 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0000101};
				LOAD4    : m_op <= {8'b01000100 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0010001};
				LOAD5    : m_op <= {8'b00000000 , 3'b000, 5'b00010, write_register     , 4'd12   ,7'b0000000};
				
				INC128   : m_op <= {8'b00000000 , 3'b000, 5'b00101, write_register     , IR[10:7],7'b0000001};
				
				STORE1   : m_op <= {8'b01010001 , 3'b000, 5'b00010, 15'b000010000000000, IR[10:7],7'b0000000};
				STORE2   : m_op <= {8'b01010011 , 3'b000, 5'b00010, 15'b000100000000000, IR[6:3] ,7'b0000000};
				//STORE3   : m_op <= {8'b01010011 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0001111};
				STORE4   : m_op <= {8'b00000000 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0001111};
				
				SUBI1    : m_op <= {8'b01011001 , 3'b000, 5'b00010, 15'b100000000000000, 4'd0    ,7'b0000000};
				SUBI2    : m_op <= {8'b00000000 , 3'b000, 5'b01001, write_register     , IR[10:7],7'b0000000};
				
				JUMPNZ1  : m_op <= {8'b01100001 , 3'b001, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0000000};
				JUMPNZ2  : m_op <= {8'b00000000 , 3'b000, 5'b01011, 15'b001000000000000, 4'd0    ,7'b0000000};
				JUMPNZ3  : m_op <= {8'b00000000 , 3'b000, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0000000};
				
				PAUSE1   : m_op <= {8'b11111000 , 3'b100, 5'b00000, 15'b000000000000000, 4'd0    ,7'b0000000};
				PAUSE2   : m_op <= {8'b00000000 , 3'b000, 5'b00001, 15'b101111111111111, 4'd0    ,7'b0000000};
				
				//default  : m_op <= 42'b0;
			endcase
			
			
		
		//end
	end
	

endmodule
