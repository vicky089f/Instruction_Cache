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
	
	integer i,file_addr;
	always #5 clk = ~clk;
	

	initial begin
		clk = 0;
		file_addr = $fopen("F:\\BITS\\Year 3 Sem 1\\ADV VLSI Arch\\Assignment 1\\ADV_VLSI\\address.txt","r");
		#20;
        
		// Add stimulus here
	end
	
	always@(negedge clk) begin
		if(stall == 0)
		 repeat(1) @(negedge clk) i <= $fscanf(file_addr, "%x\n", pc);
	end
      
endmodule

