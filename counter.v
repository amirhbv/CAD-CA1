`include "ISA.v"

module Counter(
    input clk,
    input rst,
    input en,

    output [`LEN_COUNTER_DATA - 1:0] out
);
 	wire [`LEN_COUNTER_DATA - 1:0] next_out = out + 1;

	Register #(.WORD_LENGTH(`LEN_COUNTER_DATA)) counter_register(
		.clk(clk),
        .rst(rst),
		.ld(en),
		.in(next_out),

		.out(out)
	);

endmodule
