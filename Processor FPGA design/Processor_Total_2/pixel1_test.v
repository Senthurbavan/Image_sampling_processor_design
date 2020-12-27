`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:43:52 07/27/2018
// Design Name:   top_processor
// Module Name:   E:/m/Processor_Total_2/pixel1_test.v
// Project Name:  Processor_Total_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pixel1_test;

	// Inputs
	reg clk;
	reg resume_sw;
	reg enablle;
	reg send;
	reg receive;
	reg rx;

	// Outputs
	wire [15:0] toMEM;
	wire [15:0] add_M;
	wire enable_check;
	wire pause_LED;
	wire fetch_LED;
	wire tx;
	wire tx_LED;
	wire rx_LED;
	wire [15:0] testout;

	// Instantiate the Unit Under Test (UUT)
	top_processor uut (
		.toMEM(toMEM), 
		.add_M(add_M), 
		.clk(clk), 
		.resume_sw(resume_sw), 
		.enablle(enablle), 
		.enable_check(enable_check), 
		.pause_LED(pause_LED), 
		.fetch_LED(fetch_LED), 
		.send(send), 
		.receive(receive), 
		.rx(rx), 
		.tx(tx), 
		.tx_LED(tx_LED), 
		.rx_LED(rx_LED), 
		.testout(testout)
	);

	always
		#5 clk = !clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		resume_sw = 0;
		enablle = 0;
		send = 0;
		receive = 0;
		rx = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		enablle = 1;

	end
      
endmodule
