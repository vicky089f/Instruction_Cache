`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:36:45 09/30/2020 
// Design Name: 
// Module Name:    controller 
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
module controller(
    input clk,
	 input hit,
    input mem_ready,
	 input cache_ready,
	 input write_done,
	 output reg cache_reset,
    output reg cache_wr,
	 output reg cache_rd,
    output reg mem_rd,
    output reg w_sel,
    output reg stall
    );

reg [2:0] state;
parameter reset = 3'b000;
parameter idle = 3'b001;
parameter rd = 3'b010;
parameter wr1 = 3'b011;
parameter wr2 = 3'b100;

always@ (posedge clk)
begin
	case (state)
	reset:	state = idle;
	idle:		begin
					if(hit == 1) state = rd;
					else if(hit == 0) state = wr1;
					else state = idle;
				end
	rd:		wait(cache_ready == 1) state = idle;
	wr1:		wait(write_done == 1) state = wr2;
	wr2:		wait(write_done == 1) state = rd;
	default:	state = reset;
	endcase
end


always@ (state)
begin
	if (state == reset)
	begin
		cache_reset <= 1;
		cache_wr <= 0;
		cache_rd <= 0;
		mem_rd <= 0;
		w_sel <= 1'bz;
		stall <= 0;
	end
	
	else if (state == idle)
	begin
		cache_reset <= 0;
		cache_wr <= 0;
		cache_rd <= 0;
		mem_rd <= 0;
		w_sel <= 1'bz;
		stall <= 0;
	end
	
	else if(state == rd)
	begin
		cache_reset <= 0;
		cache_wr <= 0;
		cache_rd <= 1;
		mem_rd <= 0;
		w_sel <= 1'bz;
		stall <= 0;
	end
	
	else if(state == wr1)
	begin
		cache_reset <= 0;
		cache_wr <= 0;
		cache_rd <= 0;
		mem_rd <= 1;
		w_sel <= 1'b0;
		stall <= 1;
		wait (mem_ready == 1) cache_wr <= 1;
		/*wait (write_done == 1) begin
			cache_wr = 0;
			mem_rd = 0;
		end*/
	end
	
	else if(state == wr2)
	begin
		cache_reset <= 0;
		cache_wr <= 0;
		cache_rd <= 0;
		mem_rd <= 1;
		w_sel <= 1'b1;
		stall <= 1;
		wait (mem_ready == 1) cache_wr <= 1;
		/*wait (write_done == 1) begin
			cache_wr = 0;
			mem_rd = 0;
		end*/
	end

end
endmodule
