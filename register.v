`include "ISA.v"

module Register #(parameter WORD_LENGTH = `LEN_DATA) (
	input clk,
    input rst,
    input ld,
	input [WORD_LENGTH - 1:0] in,

	output reg [WORD_LENGTH - 1:0] out
);

	always@(posedge clk, posedge rst) begin
		if (rst) begin
			out <= 0;
		end else if (ld) begin
			out <= in;
		end
	end

endmodule
