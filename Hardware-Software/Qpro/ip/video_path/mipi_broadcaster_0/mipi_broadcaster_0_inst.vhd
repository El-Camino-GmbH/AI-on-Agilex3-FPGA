	component mipi_broadcaster_0 is
		port (
			axi4s_vid_in_tdata     : in  std_logic_vector(63 downto 0) := (others => 'X'); -- tdata
			axi4s_vid_in_tvalid    : in  std_logic                     := 'X';             -- tvalid
			axi4s_vid_in_tready    : out std_logic;                                        -- tready
			axi4s_vid_in_tlast     : in  std_logic                     := 'X';             -- tlast
			axi4s_vid_in_tuser     : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- tuser
			axi4s_vid_out_0_tdata  : out std_logic_vector(63 downto 0);                    -- tdata
			axi4s_vid_out_0_tvalid : out std_logic;                                        -- tvalid
			axi4s_vid_out_0_tready : in  std_logic                     := 'X';             -- tready
			axi4s_vid_out_0_tlast  : out std_logic;                                        -- tlast
			axi4s_vid_out_0_tuser  : out std_logic_vector(7 downto 0);                     -- tuser
			axi4s_vid_out_1_tdata  : out std_logic_vector(63 downto 0);                    -- tdata
			axi4s_vid_out_1_tvalid : out std_logic;                                        -- tvalid
			axi4s_vid_out_1_tready : in  std_logic                     := 'X';             -- tready
			axi4s_vid_out_1_tlast  : out std_logic;                                        -- tlast
			axi4s_vid_out_1_tuser  : out std_logic_vector(7 downto 0);                     -- tuser
			vid_clock_clk          : in  std_logic                     := 'X';             -- clk
			vid_reset_reset        : in  std_logic                     := 'X'              -- reset
		);
	end component mipi_broadcaster_0;

	u0 : component mipi_broadcaster_0
		port map (
			axi4s_vid_in_tdata     => CONNECTED_TO_axi4s_vid_in_tdata,     --    axi4s_vid_in.tdata
			axi4s_vid_in_tvalid    => CONNECTED_TO_axi4s_vid_in_tvalid,    --                .tvalid
			axi4s_vid_in_tready    => CONNECTED_TO_axi4s_vid_in_tready,    --                .tready
			axi4s_vid_in_tlast     => CONNECTED_TO_axi4s_vid_in_tlast,     --                .tlast
			axi4s_vid_in_tuser     => CONNECTED_TO_axi4s_vid_in_tuser,     --                .tuser
			axi4s_vid_out_0_tdata  => CONNECTED_TO_axi4s_vid_out_0_tdata,  -- axi4s_vid_out_0.tdata
			axi4s_vid_out_0_tvalid => CONNECTED_TO_axi4s_vid_out_0_tvalid, --                .tvalid
			axi4s_vid_out_0_tready => CONNECTED_TO_axi4s_vid_out_0_tready, --                .tready
			axi4s_vid_out_0_tlast  => CONNECTED_TO_axi4s_vid_out_0_tlast,  --                .tlast
			axi4s_vid_out_0_tuser  => CONNECTED_TO_axi4s_vid_out_0_tuser,  --                .tuser
			axi4s_vid_out_1_tdata  => CONNECTED_TO_axi4s_vid_out_1_tdata,  -- axi4s_vid_out_1.tdata
			axi4s_vid_out_1_tvalid => CONNECTED_TO_axi4s_vid_out_1_tvalid, --                .tvalid
			axi4s_vid_out_1_tready => CONNECTED_TO_axi4s_vid_out_1_tready, --                .tready
			axi4s_vid_out_1_tlast  => CONNECTED_TO_axi4s_vid_out_1_tlast,  --                .tlast
			axi4s_vid_out_1_tuser  => CONNECTED_TO_axi4s_vid_out_1_tuser,  --                .tuser
			vid_clock_clk          => CONNECTED_TO_vid_clock_clk,          --       vid_clock.clk
			vid_reset_reset        => CONNECTED_TO_vid_reset_reset         --       vid_reset.reset
		);

