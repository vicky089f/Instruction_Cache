`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:40:18 09/23/2020 
// Design Name: 
// Module Name:    cache 
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
module cache(
    input clk,
	 input reset,
	 input [31:0] addr,
    input [31:0] data_in,
    input wren,
	 input rden,
	 input w_sel,
	 output reg [31:0] data_out,
	 output reg ready,
	 output reg write_done,
    output hit
    );

reg [31:0] q;
reg r;

//Block 0
reg [31:0] data_0 [7:0];
reg [1:0] tag_0 [3:0];
reg [3:0] valid_0; //valid_0 [7:0]
reg [3:0] lru_0; //lru_0[3:0]

//Block 1
reg [31:0] data_1 [7:0];
reg [1:0] tag_1 [3:0];
reg [3:0] valid_1; //valid_1 [7:0]
reg [3:0] lru_1; //lru_1[3:0]

wire [1:0] tag, index;
wire b_off;
wire t0,h0,t1,h1;

assign tag = addr[6:5];
assign index = addr[4:3];
assign b_off = addr[2];


assign t0 = tag == tag_0[index];
assign t1 = tag == tag_1[index];
assign h0 = valid_0[index] && t0;
assign h1 = valid_1[index] && t1;
assign hit = h0|h1;


always@(posedge clk)
begin
	if(reset == 1)
	begin
		valid_0 = 8'h00;
		valid_1 = 8'h00;
	end


	if(rden)
	begin
		if(h0)
		begin
			q = data_0[{index,b_off}];
			r = 1;
			lru_0[index] = 1'b0;
			lru_1[index] = 1'b1;
				end
		else if(h1)
		begin
			q = data_1[{index,b_off}];
			r = 1;
			lru_1[index] = 1'b0;
			lru_0[index] = 1'b1;
		end
		else
		begin
			q = 32'hzz_zz_zz_zz;
			r = 0;
		end
	end


	if(wren)
	begin
		write_done = 0;
		if(!valid_0[index])
		begin
			data_0[{index,w_sel}] <= data_in;
			write_done <= 1;
			if(w_sel)
			begin
				valid_0[index] <= 1'b1;
				tag_0[index] <= tag;
				lru_0[index] <= 1'b0;
				lru_1[index] <= 1'b1;
			end
		end
		else if(!valid_1[index])
		begin
			data_1[{index,w_sel}] <= data_in;
			write_done <= 1;
			if(w_sel)
			begin
				valid_1[index] <= 1'b1;
				tag_1[index] <= tag;
				lru_1[index] <= 1'b0;
				lru_0[index] <= 1'b1;
			end
		end
		else if(lru_0[index])
		begin
			data_0[{index,w_sel}] <= data_in;
			write_done <= 1;
			if(w_sel)
			begin
				valid_0[index] <= 1'b1;
				tag_0[index] <= tag;
				lru_0[index] <= 1'b0;
				lru_1[index] <= 1'b1;
			end
		end
		else if(lru_1[index])
		begin
			data_1[{index,w_sel}] <= data_in;
			write_done <= 1;
			if(w_sel)
			begin
				valid_1[index] <= 1'b1;
				tag_1[index] <= tag;
				lru_1[index] <= 1'b0;
				lru_0[index] <= 1'b1;
			end
		end	
	end
end

always@(posedge write_done)
begin
	repeat(1) @(negedge clk)
		write_done = 0;
end

always@(q)
begin
	ready = 0;
	repeat(1) @(posedge clk);
	data_out = q;
	ready = r;
end

endmodule
