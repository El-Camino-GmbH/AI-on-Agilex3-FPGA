module ai_control (
		input  wire        clk_clk,                                       //                                    clk.clk
		output wire [31:0] mipi_control_pio_0_external_connection_export, // mipi_control_pio_0_external_connection.export
		input  wire        reset_reset,                                   //                                  reset.reset
		input  wire [63:0] video_path_0_axi4s_vid_in_tdata,               //              video_path_0_axi4s_vid_in.tdata
		input  wire        video_path_0_axi4s_vid_in_tvalid,              //                                       .tvalid
		output wire        video_path_0_axi4s_vid_in_tready,              //                                       .tready
		input  wire        video_path_0_axi4s_vid_in_tlast,               //                                       .tlast
		input  wire [7:0]  video_path_0_axi4s_vid_in_tuser                //                                       .tuser
	);
endmodule

