module vvp_scaler_debug (
		input  wire        main_clock_clk,                    //          main_clock.clk,          Clock Input
		input  wire        main_reset_reset,                  //          main_reset.reset
		input  wire [95:0] axi4s_vid_in_tdata,                //        axi4s_vid_in.tdata
		input  wire        axi4s_vid_in_tvalid,               //                    .tvalid
		output wire        axi4s_vid_in_tready,               //                    .tready
		input  wire        axi4s_vid_in_tlast,                //                    .tlast
		input  wire [11:0] axi4s_vid_in_tuser,                //                    .tuser
		output wire [95:0] axi4s_vid_out_tdata,               //       axi4s_vid_out.tdata
		output wire        axi4s_vid_out_tvalid,              //                    .tvalid
		input  wire        axi4s_vid_out_tready,              //                    .tready
		output wire        axi4s_vid_out_tlast,               //                    .tlast
		output wire [11:0] axi4s_vid_out_tuser,               //                    .tuser
		input  wire        agent_clock_clk,                   //         agent_clock.clk,          Clock Input
		input  wire        agent_reset_reset,                 //         agent_reset.reset
		input  wire [6:0]  av_mm_control_agent_address,       // av_mm_control_agent.address
		input  wire        av_mm_control_agent_write,         //                    .write
		input  wire [3:0]  av_mm_control_agent_byteenable,    //                    .byteenable
		input  wire [31:0] av_mm_control_agent_writedata,     //                    .writedata
		input  wire        av_mm_control_agent_read,          //                    .read
		output wire [31:0] av_mm_control_agent_readdata,      //                    .readdata
		output wire        av_mm_control_agent_readdatavalid, //                    .readdatavalid
		output wire        av_mm_control_agent_waitrequest    //                    .waitrequest
	);
endmodule

