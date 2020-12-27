`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:49 07/22/2018 
// Design Name: 
// Module Name:    REG_ty_ir 
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
module REG_ty_ir(clk,data_in,write_en,data_out);
	parameter width = 16;
	input clk,write_en;
	input [width-1:0] data_in;
	output wire[width-1:0] data_out;
	reg[width-1:0] register;
	
	initial begin
		register=16'b0;
	end
	
	always@(posedge clk)begin
		if(write_en) begin
			register = data_in;
		end
	end
	
	assign data_out = register; //tri state WARNING
	
endmodule
