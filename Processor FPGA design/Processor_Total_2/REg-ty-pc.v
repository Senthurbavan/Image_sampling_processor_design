`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:13:26 07/22/2018 
// Design Name: 
// Module Name:    REg-ty-pc 
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
module REG_ty_pc(clk,rR,wR,rM,din,dout,Mdout,testout);//testout
	parameter width = 16;
	input clk,rR,wR,rM;
	input [width-1:0] din;
	output [width-1:0] dout,Mdout;
	output [15:0] testout; //test
	reg[width-1:0] register;
	
	initial begin
		register = 16'b0;
	end
	
	always@(posedge clk) begin
		if(wR)begin
			register = din;
		end
	end
	
	assign testout = register;
	assign dout = (rR)? register:16'bz; //tri state WARNING
	assign Mdout = (rM)? register:16'bz;


endmodule 
