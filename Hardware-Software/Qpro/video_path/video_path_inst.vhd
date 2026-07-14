	component video_path is
		port (
			sys_clk_in_clk                                 : in  std_logic                      := 'X';             -- clk
			sys_rst_in_reset                               : in  std_logic                      := 'X';             -- reset
			mm_bus_in_waitrequest                          : out std_logic;                                         -- waitrequest
			mm_bus_in_readdata                             : out std_logic_vector(63 downto 0);                     -- readdata
			mm_bus_in_readdatavalid                        : out std_logic;                                         -- readdatavalid
			mm_bus_in_burstcount                           : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- burstcount
			mm_bus_in_writedata                            : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- writedata
			mm_bus_in_address                              : in  std_logic_vector(12 downto 0)  := (others => 'X'); -- address
			mm_bus_in_write                                : in  std_logic                      := 'X';             -- write
			mm_bus_in_read                                 : in  std_logic                      := 'X';             -- read
			mm_bus_in_byteenable                           : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- byteenable
			mm_bus_in_debugaccess                          : in  std_logic                      := 'X';             -- debugaccess
			vvp_demosaic_axi4s_vid_in_tdata                : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- tdata
			vvp_demosaic_axi4s_vid_in_tvalid               : in  std_logic                      := 'X';             -- tvalid
			vvp_demosaic_axi4s_vid_in_tready               : out std_logic;                                         -- tready
			vvp_demosaic_axi4s_vid_in_tlast                : in  std_logic                      := 'X';             -- tlast
			vvp_demosaic_axi4s_vid_in_tuser                : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- tuser
			vvp_vfw_debug_av_mm_mem_write_host_address     : out std_logic_vector(31 downto 0);                     -- address
			vvp_vfw_debug_av_mm_mem_write_host_waitrequest : in  std_logic                      := 'X';             -- waitrequest
			vvp_vfw_debug_av_mm_mem_write_host_burstcount  : out std_logic_vector(4 downto 0);                      -- burstcount
			vvp_vfw_debug_av_mm_mem_write_host_write       : out std_logic;                                         -- write
			vvp_vfw_debug_av_mm_mem_write_host_writedata   : out std_logic_vector(127 downto 0);                    -- writedata
			vvp_vfw_debug_frame_writer_int_irq             : out std_logic                                          -- irq
		);
	end component video_path;

	u0 : component video_path
		port map (
			sys_clk_in_clk                                 => CONNECTED_TO_sys_clk_in_clk,                                 --                         sys_clk_in.clk
			sys_rst_in_reset                               => CONNECTED_TO_sys_rst_in_reset,                               --                         sys_rst_in.reset
			mm_bus_in_waitrequest                          => CONNECTED_TO_mm_bus_in_waitrequest,                          --                          mm_bus_in.waitrequest
			mm_bus_in_readdata                             => CONNECTED_TO_mm_bus_in_readdata,                             --                                   .readdata
			mm_bus_in_readdatavalid                        => CONNECTED_TO_mm_bus_in_readdatavalid,                        --                                   .readdatavalid
			mm_bus_in_burstcount                           => CONNECTED_TO_mm_bus_in_burstcount,                           --                                   .burstcount
			mm_bus_in_writedata                            => CONNECTED_TO_mm_bus_in_writedata,                            --                                   .writedata
			mm_bus_in_address                              => CONNECTED_TO_mm_bus_in_address,                              --                                   .address
			mm_bus_in_write                                => CONNECTED_TO_mm_bus_in_write,                                --                                   .write
			mm_bus_in_read                                 => CONNECTED_TO_mm_bus_in_read,                                 --                                   .read
			mm_bus_in_byteenable                           => CONNECTED_TO_mm_bus_in_byteenable,                           --                                   .byteenable
			mm_bus_in_debugaccess                          => CONNECTED_TO_mm_bus_in_debugaccess,                          --                                   .debugaccess
			vvp_demosaic_axi4s_vid_in_tdata                => CONNECTED_TO_vvp_demosaic_axi4s_vid_in_tdata,                --          vvp_demosaic_axi4s_vid_in.tdata
			vvp_demosaic_axi4s_vid_in_tvalid               => CONNECTED_TO_vvp_demosaic_axi4s_vid_in_tvalid,               --                                   .tvalid
			vvp_demosaic_axi4s_vid_in_tready               => CONNECTED_TO_vvp_demosaic_axi4s_vid_in_tready,               --                                   .tready
			vvp_demosaic_axi4s_vid_in_tlast                => CONNECTED_TO_vvp_demosaic_axi4s_vid_in_tlast,                --                                   .tlast
			vvp_demosaic_axi4s_vid_in_tuser                => CONNECTED_TO_vvp_demosaic_axi4s_vid_in_tuser,                --                                   .tuser
			vvp_vfw_debug_av_mm_mem_write_host_address     => CONNECTED_TO_vvp_vfw_debug_av_mm_mem_write_host_address,     -- vvp_vfw_debug_av_mm_mem_write_host.address
			vvp_vfw_debug_av_mm_mem_write_host_waitrequest => CONNECTED_TO_vvp_vfw_debug_av_mm_mem_write_host_waitrequest, --                                   .waitrequest
			vvp_vfw_debug_av_mm_mem_write_host_burstcount  => CONNECTED_TO_vvp_vfw_debug_av_mm_mem_write_host_burstcount,  --                                   .burstcount
			vvp_vfw_debug_av_mm_mem_write_host_write       => CONNECTED_TO_vvp_vfw_debug_av_mm_mem_write_host_write,       --                                   .write
			vvp_vfw_debug_av_mm_mem_write_host_writedata   => CONNECTED_TO_vvp_vfw_debug_av_mm_mem_write_host_writedata,   --                                   .writedata
			vvp_vfw_debug_frame_writer_int_irq             => CONNECTED_TO_vvp_vfw_debug_frame_writer_int_irq              --     vvp_vfw_debug_frame_writer_int.irq
		);

