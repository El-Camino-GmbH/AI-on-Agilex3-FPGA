	irq_pulse_counter_0 u0 (
		.clk         (_connected_to_clk_),         //   input,   width = 1,   clk.clk
		.reset       (_connected_to_reset_),       //   input,   width = 1, reset.reset
		.irq         (_connected_to_irq_),         //   input,   width = 1,   irq.irq
		.count       (_connected_to_count_),       //  output,  width = 32, count.count
		.count_valid (_connected_to_count_valid_)  //  output,   width = 1,      .count_valid
	);

