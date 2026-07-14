module mipi_broadcaster_0 (
		input  wire [63:0] axi4s_vid_in_tdata,     //    axi4s_vid_in.tdata
		input  wire        axi4s_vid_in_tvalid,    //                .tvalid
		output wire        axi4s_vid_in_tready,    //                .tready
		input  wire        axi4s_vid_in_tlast,     //                .tlast
		input  wire [7:0]  axi4s_vid_in_tuser,     //                .tuser
		output wire [63:0] axi4s_vid_out_0_tdata,  // axi4s_vid_out_0.tdata
		output wire        axi4s_vid_out_0_tvalid, //                .tvalid
		input  wire        axi4s_vid_out_0_tready, //                .tready
		output wire        axi4s_vid_out_0_tlast,  //                .tlast
		output wire [7:0]  axi4s_vid_out_0_tuser,  //                .tuser
		output wire [63:0] axi4s_vid_out_1_tdata,  // axi4s_vid_out_1.tdata
		output wire        axi4s_vid_out_1_tvalid, //                .tvalid
		input  wire        axi4s_vid_out_1_tready, //                .tready
		output wire        axi4s_vid_out_1_tlast,  //                .tlast
		output wire [7:0]  axi4s_vid_out_1_tuser,  //                .tuser
		input  wire        vid_clock_clk,          //       vid_clock.clk,   Clock Input
		input  wire        vid_reset_reset         //       vid_reset.reset
	);
endmodule

