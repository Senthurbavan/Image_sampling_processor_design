`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:00 07/22/2018 
// Design Name: 
// Module Name:    REG-ty-1 
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
module REG_ty_1(clk,data_in,read_en,write_en,data_out);
	parameter width = 16;
	input clk,read_en,write_en;
	input [width-1:0] data_in;
	output wire[width-1:0] data_out;
	
	reg[width-1:0] register;
	
	initial begin
		register = 0; 
	end
	
	always@(posedge clk)begin
		if(write_en) begin
			register = data_in;
		end
	end
	
	assign data_out = (read_en)? register:16'bz; //tri state WARNING
	
endmodule
