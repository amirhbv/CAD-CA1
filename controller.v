`include "ISA.v"

module Controller(
    input clk,
    input rst,
    input start,
    input done,
    input one_done,

	output reg reset,
	output reg inc,
	output reg read,
	output reg resetk,
	output reg write,
	output reg incij
);
    reg [`LEN_STATE - 1:0] ns, ps;
    parameter [`LEN_STATE - 1:0]
        IDLE = 0,
        START = 1,
        READ = 2,
        WRITE_ONE = 3,
        READ_ONE = 4,
        DONE = 5;

    always @(posedge clk, posedge rst) begin
        if (rst) ps <= IDLE;
        else ps <= ns;
    end

    always @ (ps, start, done, one_done) begin
        case (ps)
            IDLE      : ns = start ? START : IDLE;
            START     : ns = READ;
            READ      : ns = done ? DONE : WRITE_ONE;
            WRITE_ONE : ns = one_done ? READ : READ_ONE;
            READ_ONE  : ns = WRITE_ONE;
            DONE      : ns = DONE;
            default: ns = IDLE;
        endcase
    end

    always @ (ps) begin
        reset = `DISABLE;
        inc = `DISABLE;
        read = `DISABLE;
        resetk = `DISABLE;
        write = `DISABLE;
        incij = `DISABLE;
        case (ps)
            START: begin
                resetk = `ENABLE;
            end
            READ: begin
                reset = `ENABLE;
                inc = `ENABLE;
                read = `ENABLE;
            end
            WRITE_ONE: begin
                write = `ENABLE;
            end
            READ_ONE: begin
                incij = `ENABLE;
            end
        endcase
    end
endmodule
