module video_path (
		input  wire         sys_clk_in_clk,                                 //                         sys_clk_in.clk
		input  wire         sys_rst_in_reset,                               //                         sys_rst_in.reset
		output wire         mm_bus_in_waitrequest,                          //                          mm_bus_in.waitrequest
		output wire [63:0]  mm_bus_in_readdata,                             //                                   .readdata
		output wire         mm_bus_in_readdatavalid,                        //                                   .readdatavalid
		input  wire [0:0]   mm_bus_in_burstcount,                           //                                   .burstcount
		input  wire [63:0]  mm_bus_in_writedata,                            //                                   .writedata
		input  wire [12:0]  mm_bus_in_address,                              //                                   .address
		input  wire         mm_bus_in_write,                                //                                   .write
		input  wire         mm_bus_in_read,                                 //                                   .read
		input  wire [7:0]   mm_bus_in_byteenable,                           //                                   .byteenable
		input  wire         mm_bus_in_debugaccess,                          //                                   .debugaccess
		input  wire [63:0]  vvp_demosaic_axi4s_vid_in_tdata,                //          vvp_demosaic_axi4s_vid_in.tdata
		input  wire         vvp_demosaic_axi4s_vid_in_tvalid,               //                                   .tvalid
		output wire         vvp_demosaic_axi4s_vid_in_tready,               //                                   .tready
		input  wire         vvp_demosaic_axi4s_vid_in_tlast,                //                                   .tlast
		input  wire [7:0]   vvp_demosaic_axi4s_vid_in_tuser,                //                                   .tuser
		output wire [31:0]  vvp_vfw_debug_av_mm_mem_write_host_address,     // vvp_vfw_debug_av_mm_mem_write_host.address
		input  wire         vvp_vfw_debug_av_mm_mem_write_host_waitrequest, //                                   .waitrequest
		output wire [4:0]   vvp_vfw_debug_av_mm_mem_write_host_burstcount,  //                                   .burstcount
		output wire         vvp_vfw_debug_av_mm_mem_write_host_write,       //                                   .write
		output wire [127:0] vvp_vfw_debug_av_mm_mem_write_host_writedata,   //                                   .writedata
		output wire         vvp_vfw_debug_frame_writer_int_irq              //     vvp_vfw_debug_frame_writer_int.irq
	);
endmodule

