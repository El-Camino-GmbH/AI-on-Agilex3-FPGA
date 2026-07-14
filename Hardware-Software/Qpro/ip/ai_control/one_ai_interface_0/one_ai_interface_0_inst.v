	one_ai_interface_0 #(
		.BUFFER_BASE_ADDR (STD_LOGIC_VECTOR_VALUE_FOR_BUFFER_BASE_ADDR)
	) u0 (
		.clk               (_connected_to_clk_),               //   input,   width = 1,              clock.clk
		.reset_n           (_connected_to_reset_n_),           //   input,   width = 1,              reset.reset_n
		.avm_address       (_connected_to_avm_address_),       //  output,  width = 32,    avalon_master_0.address
		.avm_read          (_connected_to_avm_read_),          //  output,   width = 1,                   .read
		.avm_readdata      (_connected_to_avm_readdata_),      //   input,  width = 32,                   .readdata
		.avm_waitrequest   (_connected_to_avm_waitrequest_),   //   input,   width = 1,                   .waitrequest
		.avm_readdatavalid (_connected_to_avm_readdatavalid_), //   input,   width = 1,                   .readdatavalid
		.avm_burstcount    (_connected_to_avm_burstcount_),    //  output,   width = 8,                   .burstcount
		.avs_address       (_connected_to_avs_address_),       //   input,   width = 8,     avalon_slave_0.address
		.avs_read          (_connected_to_avs_read_),          //   input,   width = 1,                   .read
		.avs_readdata      (_connected_to_avs_readdata_),      //  output,  width = 32,                   .readdata
		.avs_write         (_connected_to_avs_write_),         //   input,   width = 1,                   .write
		.avs_writedata     (_connected_to_avs_writedata_),     //   input,  width = 32,                   .writedata
		.frame_writer_irq  (_connected_to_frame_writer_irq_)   //   input,   width = 1, interrupt_receiver.irq
	);

