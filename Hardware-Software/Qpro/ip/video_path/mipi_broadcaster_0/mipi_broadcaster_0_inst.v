	mipi_broadcaster_0 u0 (
		.axi4s_vid_in_tdata     (_connected_to_axi4s_vid_in_tdata_),     //   input,  width = 64,    axi4s_vid_in.tdata
		.axi4s_vid_in_tvalid    (_connected_to_axi4s_vid_in_tvalid_),    //   input,   width = 1,                .tvalid
		.axi4s_vid_in_tready    (_connected_to_axi4s_vid_in_tready_),    //  output,   width = 1,                .tready
		.axi4s_vid_in_tlast     (_connected_to_axi4s_vid_in_tlast_),     //   input,   width = 1,                .tlast
		.axi4s_vid_in_tuser     (_connected_to_axi4s_vid_in_tuser_),     //   input,   width = 8,                .tuser
		.axi4s_vid_out_0_tdata  (_connected_to_axi4s_vid_out_0_tdata_),  //  output,  width = 64, axi4s_vid_out_0.tdata
		.axi4s_vid_out_0_tvalid (_connected_to_axi4s_vid_out_0_tvalid_), //  output,   width = 1,                .tvalid
		.axi4s_vid_out_0_tready (_connected_to_axi4s_vid_out_0_tready_), //   input,   width = 1,                .tready
		.axi4s_vid_out_0_tlast  (_connected_to_axi4s_vid_out_0_tlast_),  //  output,   width = 1,                .tlast
		.axi4s_vid_out_0_tuser  (_connected_to_axi4s_vid_out_0_tuser_),  //  output,   width = 8,                .tuser
		.axi4s_vid_out_1_tdata  (_connected_to_axi4s_vid_out_1_tdata_),  //  output,  width = 64, axi4s_vid_out_1.tdata
		.axi4s_vid_out_1_tvalid (_connected_to_axi4s_vid_out_1_tvalid_), //  output,   width = 1,                .tvalid
		.axi4s_vid_out_1_tready (_connected_to_axi4s_vid_out_1_tready_), //   input,   width = 1,                .tready
		.axi4s_vid_out_1_tlast  (_connected_to_axi4s_vid_out_1_tlast_),  //  output,   width = 1,                .tlast
		.axi4s_vid_out_1_tuser  (_connected_to_axi4s_vid_out_1_tuser_),  //  output,   width = 8,                .tuser
		.vid_clock_clk          (_connected_to_vid_clock_clk_),          //   input,   width = 1,       vid_clock.clk
		.vid_reset_reset        (_connected_to_vid_reset_reset_)         //   input,   width = 1,       vid_reset.reset
	);

