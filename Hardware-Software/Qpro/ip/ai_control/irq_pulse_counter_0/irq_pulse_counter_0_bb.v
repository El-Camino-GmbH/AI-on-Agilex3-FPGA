module irq_pulse_counter_0 (
		input  wire        clk,         //   clk.clk
		input  wire        reset,       // reset.reset
		input  wire        irq,         //   irq.irq
		output wire [31:0] count,       // count.count
		output wire        count_valid  //      .count_valid
	);
endmodule

