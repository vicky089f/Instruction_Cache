`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:28:54 09/29/2020 
// Design Name: 
// Module Name:    ram 
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
module ram(
    input clk,
    //input wren,
	 input rden,
    //input [31:0] data_in,
    input [31:0] addr,
	 input w_sel,
	 output reg ready,
    output reg [31:0] data_out
    );
integer i;
reg [31:0] my_ram [31:0];
reg [31:0] q;
reg r;

initial begin //initialising ram with some data
	for(i=0;i<32;i=i+1)
	begin
		my_ram[i] = i;
	end
end

always@(posedge clk)
begin
//	if(wren)
//	begin
//		my_ram[addr[6:2]] <= data_in[31:0];
//	end

	if(rden)
	begin
		q = my_ram[{addr[6:3],w_sel}];
		//q = my_ram[addr[6:2]];
		r = 1;
	end
	else
	begin
		q = 32'h zz_zz_zz_zz;
		r = 0;
		ready = 0;
	end
end

always@(q or w_sel)
begin
	ready = 0;

	repeat(10) begin
		@(posedge clk);
	end
	data_out = q;
	ready = r;
end

always@(posedge ready)
begin
	repeat(1) @(negedge clk)
	ready = 0;
end

endmodule
