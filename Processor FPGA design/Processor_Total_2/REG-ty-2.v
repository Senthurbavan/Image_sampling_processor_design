`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:18 07/22/2018 
// Design Name: 
// Module Name:    REG-ty-2 
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
module REG_ty_2(clk,rR,wR,rM,wM,din,dout,Mdin,Mdout);
	parameter width = 16;
	input clk,rR,wR,rM,wM;
	input [width-1:0] din,Mdin;
	output [width-1:0] dout,Mdout;
	
	reg[width-1:0] register;
	
	initial begin
		register = 16'b0;
	end
	
	always@(posedge clk) begin
		if(wR)begin
			register = din;
		end else if(wM) begin
			register = Mdin;
		end
	end
	
	
	assign dout = (rR)? register:16'bz; //tri state WARNING
	assign Mdout = (rM)? register:16'bz;


endmodule