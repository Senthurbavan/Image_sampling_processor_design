`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:19:57 07/23/2018 
// Design Name: 
// Module Name:    top_processor 
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
module top_processor(clk,enablle,top_enable,pause_LED,fetch_LED,rx,tx,tx_LED,rxIN_LED,rxIM_LED);

	input clk;
	//input resume_sw;//////////////////////////////////////////////////////////////////////////////////////
	
	reg resume_sw;
	
	input enablle;
	
	input top_enable;
	wire enable_check;
	output pause_LED;
	output fetch_LED;
	wire [15:0]toMEM;    //edit fro testbench
	wire [15:0]frmMEM;   //edit fro testbench
	wire weM;
	wire [15:0]add_M;    ////edit fro testbench
	wire M_enable;
	
	//toMEM,frmMEM,add_M,
	//output wire [15:0]toMEM;
	//output wire [15:0]frmMEM;
	//output wire [15:0]add_M;
	
	wire[15:0] testout;
	
	wire [15:0] fromRamToIO;
	wire [15:0] fromIOToRam;
	
	reg send;
	reg rec_IN;
	reg rec_IM;
	
	input rx;
	output tx;
	wire [15:0] addressFrmIO;
	wire RAM_w_en;
	
	output wire tx_LED;
	output wire rxIN_LED;
	output wire rxIM_LED;
	
	
	reg[3:0] halState ; 
	reg[27:0] delaycount ;
	
	
	
	
	
	clock clk_25_gen
   (// Clock in ports
    .CLK_IN1(clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk1)); 
	
	micro_processor u_pro(clk1,resume_sw,enablle,enable_check,pause_LED,fetch_LED,toMEM,frmMEM,weM,add_M,M_enable,testout);
	
	InOut_Module in_out(fromRamToIO,send,rec_IN,rec_IM,clk1,rx,tx,fromIOToRam,addressFrmIO,RAM_w_en,tx_LED,rxIN_LED,rxIM_LED);
	
	
	//a port for pro and b port for io
	blockBRAM bram(
  .clka(clk1), // input clka
  .ena(M_enable), // input ena
  .wea(weM), // input [0 : 0] wea
  .addra(add_M), // input [15 : 0] addra
  .dina(toMEM), // input [15 : 0] dina
  .douta(frmMEM), // output [15 : 0] douta
  
  .clkb(clk1), // input clkb
  .enb(1'b1), // input enb
  .web(RAM_w_en), // input [0 : 0] web
  .addrb(addressFrmIO), // input [15 : 0] addrb
  .dinb(fromIOToRam), // input [15 : 0] dinb
  .doutb(fromRamToIO) // output [15 : 0] doutb
);


	initial begin
		send <= 0;
		rec_IN <= 0;
		rec_IM <= 0;
		
		halState <= 0; 
		
		delaycount <= 0;
		resume_sw <= 0;
	end


	always@(negedge clk1)begin
		case(halState)
			0: begin
				if(top_enable) begin
					halState <= 1;
				end
			end
			1: begin
				rec_IN <= 1;
				halState <= 2;
			end
			2: begin
				rec_IN <= 0;
				halState <= 3;
			end
			3: begin
				if(rxIN_LED)begin
					halState <= 4;
				end
			end
			4: begin
				rec_IM <= 1;
				halState <= 5;
			end
			5: begin
				rec_IM <= 0;
				halState <= 6;
			end
			6: begin
				if(rxIM_LED)begin
					halState <= 7;
				end
			end
			7: begin
				delaycount <= delaycount+1;
				if(delaycount == 89478480) begin
					halState <= 8;
					delaycount <=0;
				end
			end
			8: begin
				resume_sw <=1;
				halState <= 9;
			end
			9: begin
				halState <= 10;
			end
			10: begin
				resume_sw <=0;
				halState <= 11;
			end
			11: begin
				if(pause_LED)begin
					halState <= 12;
				end
			end
			12: begin
				delaycount <= delaycount+1;
				if(delaycount == 89478480) begin
					halState <= 13;
					delaycount <=0;
				end
			end
			13: begin
				send <= 1;
				halState <= 14;
			end
			14: begin
				send <= 0;
				halState <= 15;
			end
			15: begin
				if(tx_LED)begin
					halState <= 4;
				end
			end
			default: begin
				halState <= 0;
			end
		endcase
	end






endmodule
