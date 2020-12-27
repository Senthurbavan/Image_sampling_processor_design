`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:45 07/22/2018 
// Design Name: 
// Module Name:    alu_unit 
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
module alu_unit(clk,A,B,control,dataBuff,z_sig);

	input clk;
	input [15:0] A,B;
	input [4:0] control;
	//output [15:0] data_out;
	output reg z_sig=0;
	output reg [15:0] dataBuff ;
	reg z1,z2,z3,z4;

	parameter NO_OPERATION = 5'b00000;
	parameter ZERO 		  = 5'b00001;
	parameter B_IN         = 5'b00010;
	parameter LOW          = 5'b00011;
	parameter SHIFTR8      = 5'b00100;
	parameter INC128       = 5'b00101;
	parameter SHIFTL       = 5'b00110;
	parameter SHIFTR       = 5'b00111;
	parameter ADD          = 5'b01000;
	parameter SUB          = 5'b01001;
	parameter MULTIPLY     = 5'b01010;
	parameter DECREMENT    = 5'b01011;
	parameter INCREMENT    = 5'b11100; //highest bit is one
	
	//assign data_out = dataBuff[15:0];
	
	always@(*)begin//A or B or control
		case(control)
			NO_OPERATION : dataBuff = 16'bz;	
			ZERO         : dataBuff = 0;
			B_IN         : dataBuff = B;
			LOW          : dataBuff = 16'h00FF & B;
			SHIFTR8      : dataBuff = B>>8;
			INC128       : dataBuff = B+128;
			SHIFTL       : dataBuff = B<<A;
			SHIFTR       : dataBuff = B>>A;
			ADD          : dataBuff = A+B;
			SUB          : dataBuff = B-A;
			MULTIPLY     : dataBuff = B*A;
			DECREMENT    : dataBuff = B-1;
			INCREMENT    : dataBuff = B+1;		
			default		 :	dataBuff = 16'bz; 
		endcase
	end
	
	
	always@(posedge clk)begin
		z1 <= (dataBuff==0);
		z2 <= z1;
		z3 <= z2;
		z4 <= z3;
		z_sig  <= z4;
	end


endmodule
