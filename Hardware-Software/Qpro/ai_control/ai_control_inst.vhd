	component ai_control is
		port (
			clk_clk                                       : in  std_logic                     := 'X';             -- clk
			mipi_control_pio_0_external_connection_export : out std_logic_vector(31 downto 0);                    -- export
			reset_reset                                   : in  std_logic                     := 'X';             -- reset
			video_path_0_axi4s_vid_in_tdata               : in  std_logic_vector(63 downto 0) := (others => 'X'); -- tdata
			video_path_0_axi4s_vid_in_tvalid              : in  std_logic                     := 'X';             -- tvalid
			video_path_0_axi4s_vid_in_tready              : out std_logic;                                        -- tready
			video_path_0_axi4s_vid_in_tlast               : in  std_logic                     := 'X';             -- tlast
			video_path_0_axi4s_vid_in_tuser               : in  std_logic_vector(7 downto 0)  := (others => 'X')  -- tuser
		);
	end component ai_control;

	u0 : component ai_control
		port map (
			clk_clk                                       => CONNECTED_TO_clk_clk,                                       --                                    clk.clk
			mipi_control_pio_0_external_connection_export => CONNECTED_TO_mipi_control_pio_0_external_connection_export, -- mipi_control_pio_0_external_connection.export
			reset_reset                                   => CONNECTED_TO_reset_reset,                                   --                                  reset.reset
			video_path_0_axi4s_vid_in_tdata               => CONNECTED_TO_video_path_0_axi4s_vid_in_tdata,               --              video_path_0_axi4s_vid_in.tdata
			video_path_0_axi4s_vid_in_tvalid              => CONNECTED_TO_video_path_0_axi4s_vid_in_tvalid,              --                                       .tvalid
			video_path_0_axi4s_vid_in_tready              => CONNECTED_TO_video_path_0_axi4s_vid_in_tready,              --                                       .tready
			video_path_0_axi4s_vid_in_tlast               => CONNECTED_TO_video_path_0_axi4s_vid_in_tlast,               --                                       .tlast
			video_path_0_axi4s_vid_in_tuser               => CONNECTED_TO_video_path_0_axi4s_vid_in_tuser                --                                       .tuser
		);

