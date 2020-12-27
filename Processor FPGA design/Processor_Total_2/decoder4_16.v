`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:24:57 07/22/2018 
// Design Name: 
// Module Name:    decoder4_16 
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
module decoder4_16(in,out);
	input[3:0] in;
	output [15:0] out;
	
	assign out = (16'b1<<in);

endmodule