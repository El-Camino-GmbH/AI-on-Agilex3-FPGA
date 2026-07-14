module vvp_vfw_debug (
		input  wire         main_clock_clk,                    //           main_clock.clk,          Clock Input
		input  wire         main_reset_reset,                  //           main_reset.reset
		input  wire         mem_clock_clk,                     //            mem_clock.clk,          Clock Input
		input  wire         mem_reset_reset,                   //            mem_reset.reset
		input  wire [95:0]  axi4s_vid_in_tdata,                //         axi4s_vid_in.tdata
		input  wire         axi4s_vid_in_tvalid,               //                     .tvalid
		output wire         axi4s_vid_in_tready,               //                     .tready
		input  wire         axi4s_vid_in_tlast,                //                     .tlast
		input  wire [11:0]  axi4s_vid_in_tuser,                //                     .tuser
		output wire [31:0]  av_mm_mem_write_host_address,      // av_mm_mem_write_host.address
		input  wire         av_mm_mem_write_host_waitrequest,  //                     .waitrequest
		output wire [4:0]   av_mm_mem_write_host_burstcount,   //                     .burstcount
		output wire         av_mm_mem_write_host_write,        //                     .write
		output wire [127:0] av_mm_mem_write_host_writedata,    //                     .writedata
		input  wire         control_clock_clk,                 //        control_clock.clk,          Clock Input
		input  wire         control_reset_reset,               //        control_reset.reset
		input  wire [6:0]   av_mm_control_agent_address,       //  av_mm_control_agent.address
		input  wire         av_mm_control_agent_write,         //                     .write
		input  wire [3:0]   av_mm_control_agent_byteenable,    //                     .byteenable
		input  wire [31:0]  av_mm_control_agent_writedata,     //                     .writedata
		input  wire         av_mm_control_agent_read,          //                     .read
		output wire [31:0]  av_mm_control_agent_readdata,      //                     .readdata
		output wire         av_mm_control_agent_readdatavalid, //                     .readdatavalid
		output wire         av_mm_control_agent_waitrequest,   //                     .waitrequest
		output wire         frame_writer_int_irq               //     frame_writer_int.irq
	);
endmodule

