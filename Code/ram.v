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
reg [7:0] my_ram [127:0];

initial begin //initialising ram with some data
	for(i=0;i<128;i=i+4)
	begin
		{my_ram[i+3],my_ram[i+2],my_ram[i+1],my_ram[i]} = {i+3,i+2,i+1,i};
	end
end

/*always@(posedge clk)
begin
	if(wren)
		my_ram[addr[6:2]] <= data_in[31:0];
end*/


always@(rden,w_sel)
begin
	if (rden)
	begin
		data_out <= repeat(4) @(posedge clk) 
		{my_ram[{addr[6:3],w_sel,addr[1:0]}+3],my_ram[{addr[6:3],w_sel,addr[1:0]}+2]
		,my_ram[{addr[6:3],w_sel,addr[1:0]}+1],my_ram[{addr[6:3],w_sel,addr[1:0]}]};
		
		ready <= repeat(4) @(posedge clk) 1'b1;
	end
end

always@(posedge ready)
begin
	ready <= repeat(1) @(negedge clk) 1'b0;
end

endmodule
