`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:40:25 10/06/2020
// Design Name:   Top_Module
// Module Name:   F:/BITS/Year 3 Sem 1/ADV VLSI Arch/Assignment 1/ADV_VLSI/tb_top.v
// Project Name:  ADV_VLSI
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Top_Module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top;

	// Inputs
	reg clk;
	reg [31:0] pc;

	// Outputs
	wire [31:0] instr;
	wire stall;

	// Instantiate the Unit Under Test (UUT)
	Top_Module uut (
		.clk(clk), 
		.pc(pc), 
		.instr(instr), 
		.stall(stall)
	);
	
	integer i;
	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		//pc = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		//pc = 0;
		/*for(i=0;i<15;i=i+1)
			#500 pc = pc + 4;
		
		
		#500 pc = 52;
		#500 pc = 4;
		#500 pc = 8;
		#500 pc = 36;
		#500 pc = 16;
		#500 pc = 56;
		#500 pc = 24;
		#500 pc = 60;
		
		#500 pc = 32;
		#500 pc = 20;
		#500 pc = 0;
		#500 pc = 44;
		#500 pc = 48;
		#500 pc = 12;
		#500 pc = 28;
		#500 pc = 40;
		
		pc = 64;
		for(i=0;i<15;i=i+1)
		#500 pc = pc + 4;
		
		#500 pc = 88;
		#500 pc = 68;
		#500 pc = 108;
		#500 pc = 124;
		#500 pc = 104;
		#500 pc = 96;
		#500 pc = 64;
		#500 pc = 112;
		
		#500 pc = 76;
		#500 pc = 72;
		#500 pc = 116;
		#500 pc = 100;
		#500 pc = 80;
		#500 pc = 92;
		#500 pc = 120;
		#500 pc = 84;
		
		
		#500 $finish;*/
		
		/*#500 pc = 32'h00;
		#500 pc = 32'h08;
		#500 pc = 32'h04;
		#500 pc = 32'h1C;
		#500 pc = 32'h24;
		#500 pc = 32'h14;
		#500 pc = 32'h24;
		#500 pc = 32'h54;
		
		#5000 $finish;*/
		
		#500 pc = 32'h00;
		#500 pc = 32'h08;
		#500 pc = 32'h04;
		#500 pc = 32'h1C;
		#500 pc = 32'h24;
		#500 pc = 32'h14;
		#500 pc = 32'h24;
		#500 pc = 32'h54;
		
		#1000 $finish;

	end
      
endmodule

