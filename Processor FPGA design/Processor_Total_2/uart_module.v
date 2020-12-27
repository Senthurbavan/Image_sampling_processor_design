`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:34:35 07/23/2018 
// Design Name: 
// Module Name:    uart_module 
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
module uart_module(clk_,datain,wr_en,rx,rdy_clr,tx,tx_state,rdy,data);

input clk_;
input  wr_en;
input  rdy_clr;
input  rx;
input  [7:0] datain;
output  tx;
output  tx_state;
output  rdy;
output  [7:0] data;

wire tx_clk,rx_clk;

//module bauarate_gen(input wire clk, output wire rx_clk, output wire tx_clk);

uart_baudgen baud(clk_,rx_clk,tx_clk);
uart_transmitter txx(datain, wr_en,clk_,tx_clk,tx,tx_state);
uart_receiver rxx(rx,rdy,rdy_clr,clk_,rx_clk,data);

endmodule 