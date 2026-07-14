	video_path u0 (
		.sys_clk_in_clk                                 (_connected_to_sys_clk_in_clk_),                                 //   input,    width = 1,                         sys_clk_in.clk
		.sys_rst_in_reset                               (_connected_to_sys_rst_in_reset_),                               //   input,    width = 1,                         sys_rst_in.reset
		.mm_bus_in_waitrequest                          (_connected_to_mm_bus_in_waitrequest_),                          //  output,    width = 1,                          mm_bus_in.waitrequest
		.mm_bus_in_readdata                             (_connected_to_mm_bus_in_readdata_),                             //  output,   width = 64,                                   .readdata
		.mm_bus_in_readdatavalid                        (_connected_to_mm_bus_in_readdatavalid_),                        //  output,    width = 1,                                   .readdatavalid
		.mm_bus_in_burstcount                           (_connected_to_mm_bus_in_burstcount_),                           //   input,    width = 1,                                   .burstcount
		.mm_bus_in_writedata                            (_connected_to_mm_bus_in_writedata_),                            //   input,   width = 64,                                   .writedata
		.mm_bus_in_address                              (_connected_to_mm_bus_in_address_),                              //   input,   width = 13,                                   .address
		.mm_bus_in_write                                (_connected_to_mm_bus_in_write_),                                //   input,    width = 1,                                   .write
		.mm_bus_in_read                                 (_connected_to_mm_bus_in_read_),                                 //   input,    width = 1,                                   .read
		.mm_bus_in_byteenable                           (_connected_to_mm_bus_in_byteenable_),                           //   input,    width = 8,                                   .byteenable
		.mm_bus_in_debugaccess                          (_connected_to_mm_bus_in_debugaccess_),                          //   input,    width = 1,                                   .debugaccess
		.vvp_demosaic_axi4s_vid_in_tdata                (_connected_to_vvp_demosaic_axi4s_vid_in_tdata_),                //   input,   width = 64,          vvp_demosaic_axi4s_vid_in.tdata
		.vvp_demosaic_axi4s_vid_in_tvalid               (_connected_to_vvp_demosaic_axi4s_vid_in_tvalid_),               //   input,    width = 1,                                   .tvalid
		.vvp_demosaic_axi4s_vid_in_tready               (_connected_to_vvp_demosaic_axi4s_vid_in_tready_),               //  output,    width = 1,                                   .tready
		.vvp_demosaic_axi4s_vid_in_tlast                (_connected_to_vvp_demosaic_axi4s_vid_in_tlast_),                //   input,    width = 1,                                   .tlast
		.vvp_demosaic_axi4s_vid_in_tuser                (_connected_to_vvp_demosaic_axi4s_vid_in_tuser_),                //   input,    width = 8,                                   .tuser
		.vvp_vfw_debug_av_mm_mem_write_host_address     (_connected_to_vvp_vfw_debug_av_mm_mem_write_host_address_),     //  output,   width = 32, vvp_vfw_debug_av_mm_mem_write_host.address
		.vvp_vfw_debug_av_mm_mem_write_host_waitrequest (_connected_to_vvp_vfw_debug_av_mm_mem_write_host_waitrequest_), //   input,    width = 1,                                   .waitrequest
		.vvp_vfw_debug_av_mm_mem_write_host_burstcount  (_connected_to_vvp_vfw_debug_av_mm_mem_write_host_burstcount_),  //  output,    width = 5,                                   .burstcount
		.vvp_vfw_debug_av_mm_mem_write_host_write       (_connected_to_vvp_vfw_debug_av_mm_mem_write_host_write_),       //  output,    width = 1,                                   .write
		.vvp_vfw_debug_av_mm_mem_write_host_writedata   (_connected_to_vvp_vfw_debug_av_mm_mem_write_host_writedata_),   //  output,  width = 128,                                   .writedata
		.vvp_vfw_debug_frame_writer_int_irq             (_connected_to_vvp_vfw_debug_frame_writer_int_irq_)              //  output,    width = 1,     vvp_vfw_debug_frame_writer_int.irq
	);

