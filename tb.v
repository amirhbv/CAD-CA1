`include "ISA.v"

module TB();
    reg clk = 0;
	reg rst = 0;
	reg start = 0;
	reg [`LEN_DATA - 1:0] data_in;
	wire done = 0;
	wire one_done = 0;
	wire [`LEN_DATA - 1:0] data_out;

    always #(20) clk = ~clk;

    Shifter UUT(
        .clk(clk),
        .rst(rst),
        .start(start),

		.data_in(data_in),

		.done(done),
		.one_done(one_done),
		.data_out(data_out)
    );

    integer input_file, output_file, i, j;

    initial begin
        rst = 1;
        #50 ;
        rst = 0;
        #50
        start = 1;
        #50
        start = 0;
			input_file = $fopen("samples/0.in", "r");
			output_file = $fopen("samples/0.out", "w");
			i = 0;
			while (!$feof(input_file) && done != 1) begin
				j = 0;
				$fscanf(input_file, "%b\n", data_in);
				while (one_done != 1 || j < `SIZE_PAGE) begin
					$display("doing page %d cell %d\n", i, j);
					#20 j = j + 1;
				end
				$fwrite(output_file, "%b\n", data_out);
				$display("----\n%b\n%b\n----\n", data_in, data_out);
				i = i + 1;
			end
			$fclose(input_file);
			$fclose(input_file);
        #50
        $stop;
    end
endmodule // TB
