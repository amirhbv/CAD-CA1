`include "ISA.v"

module Datapath(
    input clk,
    input rst,

    input [`LEN_DATA - 1:0] data_in,

	// inputs from controller
	input reset,
	input inc,
	input read,
	input resetk,
	input write,
	input incij,

	// outputs to controller
    output done,
    output one_done,

    output [`LEN_DATA - 1:0] data_out
);
    wire [`LEN_COUNTER_DATA - 1:0] ij_counter_result;
    Counter ij_counter(
        .clk(clk),
        .rst(reset),
		.en(incij),

		.out(ij_counter_result)
    );

    assign one_done = ij_counter_result == `SIZE_PAGE;

    wire [`LEN_ROW_INDEX:0] i = ij_counter_result % 5;
    wire [`LEN_ROW_INDEX:0] j = ij_counter_result / 5;
    wire [`LEN_INDEX:0] input_selector = i * 5 + j;

    wire [`LEN_DATA - 1:0] current_page_data;
	Register #(.WORD_LENGTH(`LEN_DATA)) input_register(
		.clk(clk),
        .rst(rst),
		.ld(read),
		.in(data_in),

		.out(current_page_data)
	);

    wire mux_output = current_page_data[input_selector];

    wire [`LEN_COUNTER_DATA - 1:0] page_counter_result;
    Counter page_counter(
        .clk(clk),
        .rst(resetk),
		.en(inc),

		.out(page_counter_result)
    );

    assign done = page_counter_result == `NUM_PAGE;

    wire [`LEN_INDEX - 1:0] write_index = i * 5 + (i * 2 + j * 3) % 5;

	Memory output_memory(
		.clk(clk),
        .rst(rst),
	    .mem_write(write),
	    .address_in(write_index),
	    .data_in(mux_output),

	    .data_out(data_out)
	);

endmodule
