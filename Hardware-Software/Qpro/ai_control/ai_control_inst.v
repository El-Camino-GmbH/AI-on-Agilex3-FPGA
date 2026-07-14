	ai_control u0 (
		.clk_clk                                       (_connected_to_clk_clk_),                                       //   input,   width = 1,                                    clk.clk
		.mipi_control_pio_0_external_connection_export (_connected_to_mipi_control_pio_0_external_connection_export_), //  output,  width = 32, mipi_control_pio_0_external_connection.export
		.reset_reset                                   (_connected_to_reset_reset_),                                   //   input,   width = 1,                                  reset.reset
		.video_path_0_axi4s_vid_in_tdata               (_connected_to_video_path_0_axi4s_vid_in_tdata_),               //   input,  width = 64,              video_path_0_axi4s_vid_in.tdata
		.video_path_0_axi4s_vid_in_tvalid              (_connected_to_video_path_0_axi4s_vid_in_tvalid_),              //   input,   width = 1,                                       .tvalid
		.video_path_0_axi4s_vid_in_tready              (_connected_to_video_path_0_axi4s_vid_in_tready_),              //  output,   width = 1,                                       .tready
		.video_path_0_axi4s_vid_in_tlast               (_connected_to_video_path_0_axi4s_vid_in_tlast_),               //   input,   width = 1,                                       .tlast
		.video_path_0_axi4s_vid_in_tuser               (_connected_to_video_path_0_axi4s_vid_in_tuser_)                //   input,   width = 8,                                       .tuser
	);

