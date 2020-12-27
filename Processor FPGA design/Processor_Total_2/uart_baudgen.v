`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:32:28 07/23/2018 
// Design Name: 
// Module Name:    uart_baudgen 
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
module uart_baudgen(input wire clk, output wire rx_clk, output wire tx_clk);
	parameter rx_max = 25000000 / (115200 * 16);
	parameter tx_max = 25000000 / 115200;
	parameter rx_width = clog2(rx_max);
	parameter tx_width = clog2(tx_max);
	reg[rx_width - 1:0] rx_acc =0;
	reg[tx_width - 1:0] tx_acc =0;
	assign rx_clk = (rx_acc == 5'd0);
	assign tx_clk = (tx_acc == 9'd0);
	always @(posedge clk) begin
		if (rx_acc == rx_max[rx_width - 1:0])
			rx_acc <= 0;
		else
			rx_acc <= rx_acc + 5'b1;
	end
	always @(posedge clk) begin
		if (tx_acc == tx_max[tx_width - 1:0])
			tx_acc <= 0;
		else
			tx_acc <= tx_acc + 9'b1;
	end
function integer clog2;
input integer value;
begin
value = value-1;
for (clog2=0; value>0; clog2=clog2+1)
value = value>>1;
end
endfunction
endmodule