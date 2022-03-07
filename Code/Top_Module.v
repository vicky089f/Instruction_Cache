`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:38:10 10/04/2020 
// Design Name: 
// Module Name:    Top_Module 
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
module Top_Module(
    input clk,
	 input [31:0] pc,
    output [31:0] instr,
    output stall
    );

wire hit;
wire mem_ready;
wire c_ready;
wire w_sel;
wire mem_rd;
wire c_rd;
wire c_wr;
wire [31:0] data_m2c;
wire cache_reset;
wire write_done;

controller X(
	.clk(clk),
	.hit(hit),
	.mem_ready(mem_ready),
	.cache_ready(c_ready),
	.write_done(write_done),
	.cache_reset(cache_reset),
	.cache_wr(c_wr),
	.cache_rd(c_rd),
	.mem_rd(mem_rd),
	.w_sel(w_sel),
	.stall(stall));

cache Y(
	.clk(clk),
	.reset(cache_reset),
	.addr(pc),
	.data_in(data_m2c),
	.wren(c_wr),
	.rden(c_rd),
	.w_sel(w_sel),
	.data_out(instr),
	.ready(c_ready),
	.write_done(write_done),
	.hit(hit));

ram Z(
	.clk(clk),
	//.wren(),
	.rden(mem_rd),
	.addr(pc),
	.w_sel(w_sel),
	.ready(mem_ready),
	.data_out(data_m2c));


endmodule
