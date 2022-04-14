`include "ISA.v"

module Shifter(
    input clk,
    input rst,
    input start,

    input [`LEN_DATA - 1:0] data_in,

    output done,
    output one_done,
    output [`LEN_DATA - 1:0] data_out
);
	wire reset;
	wire inc;
	wire read;
	wire resetk;
	wire write;
	wire incij;

	Datapath datapath(
		.clk(clk),
		.rst(rst),

		.data_in(data_in),

		// inputs from controller
		.reset(reset),
		.inc(inc),
		.read(read),
		.resetk(resetk),
		.write(write),
		.incij(incij),

		// outputs to controller
		.done(done),
		.one_done(one_done),

		.data_out(data_out)
	);

	Controller controller(
		.clk(clk),
		.rst(rst),
		.start(start),

		.done(done),
		.one_done(one_done),

		.reset(reset),
		.inc(inc),
		.read(read),
		.resetk(resetk),
		.write(write),
		.incij(incij)
	);

endmodule
