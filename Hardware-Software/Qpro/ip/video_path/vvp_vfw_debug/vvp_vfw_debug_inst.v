	vvp_vfw_debug u0 (
		.main_clock_clk                    (_connected_to_main_clock_clk_),                    //   input,    width = 1,           main_clock.clk
		.main_reset_reset                  (_connected_to_main_reset_reset_),                  //   input,    width = 1,           main_reset.reset
		.mem_clock_clk                     (_connected_to_mem_clock_clk_),                     //   input,    width = 1,            mem_clock.clk
		.mem_reset_reset                   (_connected_to_mem_reset_reset_),                   //   input,    width = 1,            mem_reset.reset
		.axi4s_vid_in_tdata                (_connected_to_axi4s_vid_in_tdata_),                //   input,   width = 96,         axi4s_vid_in.tdata
		.axi4s_vid_in_tvalid               (_connected_to_axi4s_vid_in_tvalid_),               //   input,    width = 1,                     .tvalid
		.axi4s_vid_in_tready               (_connected_to_axi4s_vid_in_tready_),               //  output,    width = 1,                     .tready
		.axi4s_vid_in_tlast                (_connected_to_axi4s_vid_in_tlast_),                //   input,    width = 1,                     .tlast
		.axi4s_vid_in_tuser                (_connected_to_axi4s_vid_in_tuser_),                //   input,   width = 12,                     .tuser
		.av_mm_mem_write_host_address      (_connected_to_av_mm_mem_write_host_address_),      //  output,   width = 32, av_mm_mem_write_host.address
		.av_mm_mem_write_host_waitrequest  (_connected_to_av_mm_mem_write_host_waitrequest_),  //   input,    width = 1,                     .waitrequest
		.av_mm_mem_write_host_burstcount   (_connected_to_av_mm_mem_write_host_burstcount_),   //  output,    width = 5,                     .burstcount
		.av_mm_mem_write_host_write        (_connected_to_av_mm_mem_write_host_write_),        //  output,    width = 1,                     .write
		.av_mm_mem_write_host_writedata    (_connected_to_av_mm_mem_write_host_writedata_),    //  output,  width = 128,                     .writedata
		.control_clock_clk                 (_connected_to_control_clock_clk_),                 //   input,    width = 1,        control_clock.clk
		.control_reset_reset               (_connected_to_control_reset_reset_),               //   input,    width = 1,        control_reset.reset
		.av_mm_control_agent_address       (_connected_to_av_mm_control_agent_address_),       //   input,    width = 7,  av_mm_control_agent.address
		.av_mm_control_agent_write         (_connected_to_av_mm_control_agent_write_),         //   input,    width = 1,                     .write
		.av_mm_control_agent_byteenable    (_connected_to_av_mm_control_agent_byteenable_),    //   input,    width = 4,                     .byteenable
		.av_mm_control_agent_writedata     (_connected_to_av_mm_control_agent_writedata_),     //   input,   width = 32,                     .writedata
		.av_mm_control_agent_read          (_connected_to_av_mm_control_agent_read_),          //   input,    width = 1,                     .read
		.av_mm_control_agent_readdata      (_connected_to_av_mm_control_agent_readdata_),      //  output,   width = 32,                     .readdata
		.av_mm_control_agent_readdatavalid (_connected_to_av_mm_control_agent_readdatavalid_), //  output,    width = 1,                     .readdatavalid
		.av_mm_control_agent_waitrequest   (_connected_to_av_mm_control_agent_waitrequest_),   //  output,    width = 1,                     .waitrequest
		.frame_writer_int_irq              (_connected_to_frame_writer_int_irq_)               //  output,    width = 1,     frame_writer_int.irq
	);

