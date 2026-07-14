	interrupt_reader_interface_0 u0 (
		.clk               (_connected_to_clk_),               //   input,   width = 1,       clk.clk
		.reset             (_connected_to_reset_),             //   input,   width = 1,     reset.reset
		.avm_address       (_connected_to_avm_address_),       //  output,  width = 32,    master.address
		.avm_read          (_connected_to_avm_read_),          //  output,   width = 1,          .read
		.avm_readdata      (_connected_to_avm_readdata_),      //   input,  width = 32,          .readdata
		.avm_waitrequest   (_connected_to_avm_waitrequest_),   //   input,   width = 1,          .waitrequest
		.avm_readdatavalid (_connected_to_avm_readdatavalid_), //   input,   width = 1,          .readdatavalid
		.irq               (_connected_to_irq_),               //   input,   width = 1,       irq.irq
		.result_data       (_connected_to_result_data_),       //  output,  width = 32,    result.result_data
		.result_valid      (_connected_to_result_valid_),      //  output,   width = 1,          .result_valid
		.cycle_count       (_connected_to_cycle_count_),       //  output,  width = 32, cycle_cnt.cycle_count
		.cycle_count_valid (_connected_to_cycle_count_valid_), //  output,   width = 1,          .cycle_count_valid
		.error_timeout     (_connected_to_error_timeout_),     //  output,   width = 1,     error.error_timeout
		.error_clear       (_connected_to_error_clear_)        //   input,   width = 1,          .error_clear
	);

