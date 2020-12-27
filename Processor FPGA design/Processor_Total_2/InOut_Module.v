`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:36:15 07/23/2018 
// Design Name: 
// Module Name:    InOut_Module 
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
module InOut_Module(datain,send,rec_IN,rec_IM,clk,rx,tx,dataout,address,RAM_w_en,tx_LED,rxIN_LED,rxIM_LED);

	parameter START_TX_ADDRESS = 34816;// 4095;
	parameter END_TX_ADDRESS = 51199;//6000;
	
	parameter START_INSTRUCTION_RX_ADDRESS = 1;
	parameter END_INSTRUCTION_RX_ADDRESS =44;//100;
	
	
	parameter START_IMAGE_RX_ADDRESS =128;//1024;
	parameter END_IMAGE_RX_ADDRESS =33409;//2047;

	//input wire [7:0] datain; //edited for 2 byte(1)
	input wire [15:0] datain;
	input send,rec_IN,rec_IM,clk,rx;
	output tx;
	//output [7:0] dataout; //edited for 2 byte(2)
	output reg[15:0] dataout;
	wire[7:0] tempout; //(created for 2 byte)
	reg[3:0] RX_state_in;
	reg[3:0] RX_state_img;
	reg[2:0] TX_state;
	output reg [15:0] address;
	output reg RAM_w_en;
	
	output reg tx_LED;
	output reg rxIN_LED;
	output reg rxIM_LED;
	
	reg snd;
	
	reg rdy_clr;
	wire tx_byte_fin;
	
	initial begin
		TX_state = 3'b0;
		RX_state_in = 4'b0;
		RX_state_img = 4'b0;
		tx_LED = 1'b0;
		rxIM_LED = 1'b0;
		rxIN_LED = 1'b0;
		RAM_w_en = 1'b0;
		dataout = 16'b0;
		address = 16'b0;
		snd =0;
	end
	
	//Uart uart_part(clk,datain,snd,rx,rdy_clr,tx,tx_state,rdy,dataout); //datain,dataout edited(3)
	uart_module uart_part(clk,datain[7:0],snd,rx,rdy_clr,tx,tx_byte_fin,rdy,tempout);
	
	
	/*always@(posedge send)begin
		state <= 1;
		tx_LED <= 0;
	end
	
	always@(posedge receive)begin
		state1 <= 1;
		rx_LED <= 0;
	end
	*/
	
	
	
	//Transmitter Part
	always@(posedge clk)begin
	
	
		case(TX_state)
			0: begin
				if(send==1 & rec_IN==0 & rec_IM==0) begin
					TX_state <= 1;
				end
			end
			1: begin
					tx_LED <= 0;
					address <= START_TX_ADDRESS;
					RAM_w_en <= 0;
					TX_state <=2;
			end
			2: begin 
				snd <= 1;
				TX_state <= 3;
			end
			3: begin
				snd <=0;
				TX_state <= 4;
			end
			4: begin
				if(tx_byte_fin)begin
					if(address == END_TX_ADDRESS)begin
						TX_state <= 5;
					end else begin
						address <= address +1;
						TX_state <= 2;
					end
				end
			end
			5: begin
				tx_LED <= 1;
				TX_state <= 0;
			end
			default : begin
				TX_state <= 0;
			end
		endcase
	//end Tx part
	
	
	
	//Receive Instruction
	case(RX_state_in)
		0: begin
			if(send==0 & rec_IN==1 & rec_IM==0) begin
				RX_state_in <= 1;
			end
		end
		1: begin
			rxIN_LED <= 0;
			address <= START_INSTRUCTION_RX_ADDRESS;
			RX_state_in <=2;
		end
		2: begin
			if(rdy)begin
				rdy_clr <= 1;
				dataout[15:8] <= tempout; 
				RX_state_in <= 3;
			end
		end
		3: begin
			rdy_clr <= 0;
			RX_state_in <= 4;
		end
		4: begin
			if(rdy)begin
				rdy_clr <= 1;
				dataout[7:0] <= tempout; 
				RX_state_in <= 5;
			end
		end
		5: begin
			RAM_w_en <= 1;
			rdy_clr <= 0;
			RX_state_in <= 6;
		end
		6: begin
			RAM_w_en <= 1;
			if(address == END_INSTRUCTION_RX_ADDRESS)begin
				RX_state_in <= 7;
			end else begin
				address <= address + 1;
				RX_state_in <= 2;
			end
		end
		7: begin
			rxIN_LED <= 1;
			RX_state_in <= 0;
		end
	endcase
	//Receive instruction End
		

		
	
	//Receive IMAGE
	case(RX_state_img)
		0: begin
			if(send==0 & rec_IN==0 & rec_IM==1) begin
				RX_state_img <= 1;
			end
		end
		1: begin
			rxIM_LED <= 0;
			address <= START_IMAGE_RX_ADDRESS;
			RX_state_img <=2;
		end
		2: begin
			if(rdy)begin
				rdy_clr <= 1;
				dataout[15:8] <= tempout; 
				RX_state_img <= 3;
			end
		end
		3: begin
			rdy_clr <= 0;
			RX_state_img <= 4;
		end
		4: begin
			if(rdy)begin
				rdy_clr <= 1;
				dataout[7:0] <= tempout; 
				RX_state_img <= 5;
			end
		end
		5: begin
			RAM_w_en <= 1;
			rdy_clr <= 0;
			RX_state_img <= 6;
		end
		6: begin
			RAM_w_en <= 1;
			if(address == END_IMAGE_RX_ADDRESS)begin
				RX_state_img <= 7;
			end else begin
				address <= address + 1;
				RX_state_img <= 2;
			end
		end
		7: begin
			rxIM_LED <= 1;
			RX_state_img <= 0;
		end
	endcase
	//Receive IMAGE End
		
		
	end
	
endmodule 