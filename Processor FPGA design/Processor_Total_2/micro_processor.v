`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:43:00 07/22/2018 
// Design Name: 
// Module Name:    micro_processor 
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
module micro_processor(clk,resume_sw,enablle,enable_check,pause_LED,fetch_LED,toMEM,frmMEM,weM,add_M,M_enable,testout);

	input clk;
	input resume_sw;
	input enablle;
	output enable_check;
	output pause_LED;
	output fetch_LED;
	output[15:0] toMEM;
	input[15:0] frmMEM;
	output weM;
	output[15:0] add_M;
	output M_enable;
	
	
	output wire[15:0] testout;
	
	
	//IR control
	 wire wM_IR;
	 wire [15:0] IR_to_CU;/////////////////////////changed
	
	//PC control
	 wire r_PC,w_PC,rM_PC;
	
	//DR control
	 wire r_DR,w_DR,rM_DR,wM_DR;
	
	//AR control
	 wire rM_AR,w_AR;
	
	//GPR control
	 wire r_10,r_9,r_8,r_7,r_6,r_5,r_4,r_3,r_2,r_1;
	 wire w_10,w_9,w_8,w_7,w_6,w_5,w_4,w_3,w_2,w_1;

	//ACC control
	 wire w_ACC;
	 wire[15:0] A_BUS;
	 
	 //internal
	 //wire resume;
	 wire[15:0] B_BUS,C_BUS;
	 wire[41:0] u_operation;
	 wire z_sig;
	 wire [15:0] decoder_sig;
	 
	 //short
	 wire nt_cn;
	 
	 
	 //edge_detecter edge_detect(clk,resume_sw,resume);
	 
	 alu_unit alu_U(clk,A_BUS,B_BUS,u_operation[30:26],C_BUS,z_sig);
	 
	 decoder4_16 decoder(u_operation[10:7],{nt_cn,nt_cn,r_PC,r_DR,nt_cn,r_10,r_9,r_8,r_7,r_6,r_5,r_4,r_3,r_2,r_1,nt_cn});
	 
	 contrl_UNIT ctrl(clk,IR_to_CU,z_sig,u_operation,B_BUS,resume_sw,enablle,fetch_LED,pause_LED);
	 
	 REG_ty_ir IR(clk,frmMEM,wM_IR,IR_to_CU);
	 REG_ty_pc PC(clk,r_PC,w_PC,rM_PC,C_BUS,B_BUS,add_M,testout);
	 REG_ty_2  DR(clk,r_DR,w_DR,rM_DR,wM_DR,C_BUS,B_BUS,frmMEM,toMEM);
	 REG_ty_1  AR(clk,C_BUS,rM_AR,w_AR,add_M);
	 
	 REG_ty_1 R10(clk,C_BUS,r_10,w_10,B_BUS);
	 REG_ty_1  R9(clk,C_BUS,r_9,w_9,B_BUS);
	 REG_ty_1  R8(clk,C_BUS,r_8,w_8,B_BUS);
	 REG_ty_1  R7(clk,C_BUS,r_7,w_7,B_BUS);
	 REG_ty_1  R6(clk,C_BUS,r_6,w_6,B_BUS);
	 REG_ty_1  R5(clk,C_BUS,r_5,w_5,B_BUS);
	 REG_ty_1  R4(clk,C_BUS,r_4,w_4,B_BUS);
	 REG_ty_1  R3(clk,C_BUS,r_3,w_3,B_BUS);
	 REG_ty_1  R2(clk,C_BUS,r_2,w_2,B_BUS);
	 REG_ty_1  R1(clk,C_BUS,r_1,w_1,B_BUS);
	 
	 REG_ty_ir ACC(clk,C_BUS,w_ACC,A_BUS);
	 

	 assign enable_check =enablle;
	 assign {w_ACC,nt_cn,w_PC,w_DR,w_AR,w_10,w_9,w_8,w_7,w_6,w_5,w_4,w_3,w_2,w_1} = u_operation[25:11];
	 //assign {nt_cn,nt_cn,r_PC,r_DR,nt_cn,r_10,r_9,r_8,r_7,r_6,r_5,r_4,r_3,r_2,r_1,nt_cn} = decoder_sig[15:0];
	 assign {wM_IR,rM_PC,wM_DR,rM_DR,rM_AR,weM,M_enable} = u_operation[6:0];
	 
endmodule
