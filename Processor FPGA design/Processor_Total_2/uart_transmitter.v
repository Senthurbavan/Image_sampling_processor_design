`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:33:12 07/23/2018 
// Design Name: 
// Module Name:    uart_transmitter 
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
module uart_transmitter(input wire [7:0] datain,
		   input wire wr_en,
		   input wire clk_,
		   input wire clken,
		   output reg tx,
		   output reg tx_state);


	initial begin
		tx = 1'b1;
	end
	parameter STATE_IDLE	= 2'b00;
	parameter STATE_START= 2'b01;
	parameter STATE_DATA	= 2'b10;
	parameter STATE_STOP	= 2'b11;
	reg [7:0] data = 8'b00;
	reg [2:0] bitpos = 3'b0;
	reg [1:0] state = STATE_IDLE;
	always @(posedge clk_) begin
		case (state)
		STATE_IDLE: begin
			if (wr_en) begin
				tx_state <= 0;
				state <= STATE_START;
					data <= datain;
					bitpos <= 3'b0;
			end
		end
		STATE_START: begin
			if (clken) begin
				tx <= 1'b0;
				state <= STATE_DATA;
			end
		end
		STATE_DATA: begin
			if (clken) begin
				if (bitpos == 3'b111)
					state <= STATE_STOP;
				else
					bitpos <= bitpos + 3'b1;
					tx <= data[bitpos];
			end
		end
		STATE_STOP: begin
				if (clken) begin
					tx <= 1'b1;
					state <= STATE_IDLE;
					tx_state <= 1;
				end
		end
		default: begin
			tx <= 1'b1;
			state <= STATE_IDLE;
		end
		endcase
	end
	//assign tx_state = (state != STATE_IDLE);
endmodule 