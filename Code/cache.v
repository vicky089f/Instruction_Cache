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

//Block 0
reg [63:0] data_0 [3:0];
reg [26:0] tag_0 [3:0];
reg [3:0] valid_0; //valid_0 [7:0]
reg [3:0] lru_0; //lru_0[3:0]

//Block 1
reg [63:0] data_1 [3:0];
reg [26:0] tag_1 [3:0];
reg [3:0] valid_1; //valid_1 [7:0]
reg [3:0] lru_1; //lru_1[3:0]

wire [26:0] tag;
wire [1:0] index;
wire b_off;
wire t0,h0,t1,h1;

assign tag = addr[31:5];
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
		valid_0 <= 8'h00;
		valid_1 <= 8'h00;
	end


	if(rden)
	begin
		if(h0)
		begin
			if (b_off) data_out <= data_0[index][63:32];
			else data_out <= data_0[index][31:0];
			ready <= 1'b1;
			lru_0[index] <= 1'b0;
			lru_1[index] <= 1'b1;
		end
		else if(h1)
		begin
			if (b_off) data_out <= data_1[index][63:32];
			else data_out <= data_1[index][31:0];
			ready <= 1'b1;
			lru_1[index] <= 1'b0;
			lru_0[index] <= 1'b1;
		end
		else
		begin
			ready <= 0;
		end
	end


	if(wren)
	begin
		if(!valid_0[index]) //Block 0 if set[index]
		begin
			if(w_sel) data_0[index][63:32] <= data_in;
			else data_0[index][31:0] <= data_in;
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
			if(w_sel) data_1[index][63:32] <= data_in;
			else data_1[index][31:0] <= data_in;
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
			if(w_sel) data_0[index][63:32] <= data_in;
			else data_0[index][31:0] <= data_in;
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
			if(w_sel) data_1[index][63:32] <= data_in;
			else data_1[index][31:0] <= data_in;
			write_done <= 1;
			if(w_sel)
			begin
				valid_1[index] <= 1'b1;
				tag_1[index] <= tag;
				lru_1[index] <= 1'b0;
				lru_0[index] <= 1'b1;
			end
		end
		write_done <= repeat(1) @(negedge clk) 0;
	end
end

endmodule
