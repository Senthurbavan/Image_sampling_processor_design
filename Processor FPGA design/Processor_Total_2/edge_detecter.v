`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:23 07/22/2018 
// Design Name: 
// Module Name:    edge_detecter 
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
module edge_detecter(clk,signal,out);
	input clk , signal;
	output reg out=1'b0;
	
	
	reg reg0=0;
	reg reg1;
	
	always@(posedge clk) begin
			reg0 <= signal;
			reg1 <= reg0;
			
			if({reg0,reg1}==2'b10)begin
				out <=1;
			end else begin
				out <= 0;
			end
	end

endmodule

