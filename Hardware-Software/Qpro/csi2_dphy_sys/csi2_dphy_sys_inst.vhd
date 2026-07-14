	component csi2_dphy_sys is
		port (
			csi2_rx_o_d0_ppi_rx_err_ErrSotHS                  : out std_logic;                                        -- ErrSotHS
			csi2_rx_o_d0_ppi_rx_err_ErrSotSyncHS              : out std_logic;                                        -- ErrSotSyncHS
			csi2_rx_o_d0_ppi_rx_err_ErrEsc                    : out std_logic;                                        -- ErrEsc
			csi2_rx_o_d0_ppi_rx_err_ErrSyncEsc                : out std_logic;                                        -- ErrSyncEsc
			csi2_rx_o_d0_ppi_rx_err_ErrControl                : out std_logic;                                        -- ErrControl
			csi2_rx_o_d0_ppi_rx_err_ErrContentionLP0          : out std_logic;                                        -- ErrContentionLP0
			csi2_rx_o_d0_ppi_rx_err_ErrContentionLP1          : out std_logic;                                        -- ErrContentionLP1
			csi2_rx_o_d1_ppi_rx_err_ErrSotHS                  : out std_logic;                                        -- ErrSotHS
			csi2_rx_o_d1_ppi_rx_err_ErrSotSyncHS              : out std_logic;                                        -- ErrSotSyncHS
			csi2_rx_o_d1_ppi_rx_err_ErrEsc                    : out std_logic;                                        -- ErrEsc
			csi2_rx_o_d1_ppi_rx_err_ErrSyncEsc                : out std_logic;                                        -- ErrSyncEsc
			csi2_rx_o_d1_ppi_rx_err_ErrControl                : out std_logic;                                        -- ErrControl
			csi2_rx_o_d1_ppi_rx_err_ErrContentionLP0          : out std_logic;                                        -- ErrContentionLP0
			csi2_rx_o_d1_ppi_rx_err_ErrContentionLP1          : out std_logic;                                        -- ErrContentionLP1
			csi2_rx_o_ck_ppi_rx_err_ErrSotHS                  : out std_logic;                                        -- ErrSotHS
			csi2_rx_o_ck_ppi_rx_err_ErrSotSyncHS              : out std_logic;                                        -- ErrSotSyncHS
			csi2_rx_o_ck_ppi_rx_err_ErrEsc                    : out std_logic;                                        -- ErrEsc
			csi2_rx_o_ck_ppi_rx_err_ErrSyncEsc                : out std_logic;                                        -- ErrSyncEsc
			csi2_rx_o_ck_ppi_rx_err_ErrControl                : out std_logic;                                        -- ErrControl
			csi2_rx_o_ck_ppi_rx_err_ErrContentionLP0          : out std_logic;                                        -- ErrContentionLP0
			csi2_rx_o_ck_ppi_rx_err_ErrContentionLP1          : out std_logic;                                        -- ErrContentionLP1
			csi2_rx_video_streaming_interface_0_tdata         : out std_logic_vector(63 downto 0);                    -- tdata
			csi2_rx_video_streaming_interface_0_tvalid        : out std_logic;                                        -- tvalid
			csi2_rx_video_streaming_interface_0_tready        : in  std_logic                     := 'X';             -- tready
			csi2_rx_video_streaming_interface_0_tlast         : out std_logic;                                        -- tlast
			csi2_rx_video_streaming_interface_0_tuser         : out std_logic_vector(7 downto 0);                     -- tuser
			csi2_rx_avalon_mm_control_interface_write         : in  std_logic                     := 'X';             -- write
			csi2_rx_avalon_mm_control_interface_read          : in  std_logic                     := 'X';             -- read
			csi2_rx_avalon_mm_control_interface_address       : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- address
			csi2_rx_avalon_mm_control_interface_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			csi2_rx_avalon_mm_control_interface_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			csi2_rx_avalon_mm_control_interface_readdatavalid : out std_logic;                                        -- readdatavalid
			csi2_rx_avalon_mm_control_interface_waitrequest   : out std_logic;                                        -- waitrequest
			csi2_rx_avalon_mm_control_interface_byteenable    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			csi2_rx_avalon_mm_control_interface_interrupt_irq : out std_logic;                                        -- irq
			mipi_dphy_rzq_rzq                                 : in  std_logic                     := 'X';             -- rzq
			mipi_dphy_ref_clk_0_clk                           : in  std_logic                     := 'X';             -- clk
			mipi_dphy_LINK0_link_core_srst_reset_n            : out std_logic;                                        -- reset_n
			mipi_dphy_LINK0_link_core_arst_reset_n            : out std_logic;                                        -- reset_n
			mipi_dphy_axi_lite_awaddr                         : in  std_logic_vector(11 downto 0) := (others => 'X'); -- awaddr
			mipi_dphy_axi_lite_awvalid                        : in  std_logic                     := 'X';             -- awvalid
			mipi_dphy_axi_lite_awready                        : out std_logic;                                        -- awready
			mipi_dphy_axi_lite_wdata                          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- wdata
			mipi_dphy_axi_lite_wstrb                          : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- wstrb
			mipi_dphy_axi_lite_wvalid                         : in  std_logic                     := 'X';             -- wvalid
			mipi_dphy_axi_lite_wready                         : out std_logic;                                        -- wready
			mipi_dphy_axi_lite_bresp                          : out std_logic_vector(1 downto 0);                     -- bresp
			mipi_dphy_axi_lite_bvalid                         : out std_logic;                                        -- bvalid
			mipi_dphy_axi_lite_bready                         : in  std_logic                     := 'X';             -- bready
			mipi_dphy_axi_lite_araddr                         : in  std_logic_vector(11 downto 0) := (others => 'X'); -- araddr
			mipi_dphy_axi_lite_arvalid                        : in  std_logic                     := 'X';             -- arvalid
			mipi_dphy_axi_lite_arready                        : out std_logic;                                        -- arready
			mipi_dphy_axi_lite_rdata                          : out std_logic_vector(31 downto 0);                    -- rdata
			mipi_dphy_axi_lite_rresp                          : out std_logic_vector(1 downto 0);                     -- rresp
			mipi_dphy_axi_lite_rvalid                         : out std_logic;                                        -- rvalid
			mipi_dphy_axi_lite_rready                         : in  std_logic                     := 'X';             -- rready
			mipi_dphy_axi_lite_arprot                         : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- arprot
			mipi_dphy_axi_lite_awprot                         : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- awprot
			mipi_dphy_LINK0_dphy_io_dphy_link_dp              : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- dphy_link_dp
			mipi_dphy_LINK0_dphy_io_dphy_link_dn              : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- dphy_link_dn
			mipi_dphy_LINK0_dphy_io_dphy_link_cp              : in  std_logic                     := 'X';             -- dphy_link_cp
			mipi_dphy_LINK0_dphy_io_dphy_link_cn              : in  std_logic                     := 'X';             -- dphy_link_cn
			mipi_dphy_reg_bus_reg_wr_en_o                     : out std_logic;                                        -- reg_wr_en_o
			mipi_dphy_reg_bus_reg_rd_en_o                     : out std_logic;                                        -- reg_rd_en_o
			mipi_dphy_reg_bus_reg_raddr_o                     : out std_logic_vector(10 downto 0);                    -- reg_raddr_o
			mipi_dphy_reg_bus_reg_waddr_o                     : out std_logic_vector(10 downto 0);                    -- reg_waddr_o
			mipi_dphy_reg_bus_reg_be_o                        : out std_logic_vector(3 downto 0);                     -- reg_be_o
			mipi_dphy_reg_bus_reg_din_o                       : out std_logic_vector(31 downto 0);                    -- reg_din_o
			mipi_dphy_reg_bus_reg_dout_i                      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- reg_dout_i
			rx_axi4s_clk_bridge_in_clk_clk                    : in  std_logic                     := 'X'              -- clk
		);
	end component csi2_dphy_sys;

	u0 : component csi2_dphy_sys
		port map (
			csi2_rx_o_d0_ppi_rx_err_ErrSotHS                  => CONNECTED_TO_csi2_rx_o_d0_ppi_rx_err_ErrSotHS,                  --                       csi2_rx_o_d0_ppi_rx_err.ErrSotHS
			csi2_rx_o_d0_ppi_rx_err_ErrSotSyncHS              => CONNECTED_TO_csi2_rx_o_d0_ppi_rx_err_ErrSotSyncHS,              --                                              .ErrSotSyncHS
			csi2_rx_o_d0_ppi_rx_err_ErrEsc                    => CONNECTED_TO_csi2_rx_o_d0_ppi_rx_err_ErrEsc,                    --                                              .ErrEsc
			csi2_rx_o_d0_ppi_rx_err_ErrSyncEsc                => CONNECTED_TO_csi2_rx_o_d0_ppi_rx_err_ErrSyncEsc,                --                                              .ErrSyncEsc
			csi2_rx_o_d0_ppi_rx_err_ErrControl                => CONNECTED_TO_csi2_rx_o_d0_ppi_rx_err_ErrControl,                --                                              .ErrControl
			csi2_rx_o_d0_ppi_rx_err_ErrContentionLP0          => CONNECTED_TO_csi2_rx_o_d0_ppi_rx_err_ErrContentionLP0,          --                                              .ErrContentionLP0
			csi2_rx_o_d0_ppi_rx_err_ErrContentionLP1          => CONNECTED_TO_csi2_rx_o_d0_ppi_rx_err_ErrContentionLP1,          --                                              .ErrContentionLP1
			csi2_rx_o_d1_ppi_rx_err_ErrSotHS                  => CONNECTED_TO_csi2_rx_o_d1_ppi_rx_err_ErrSotHS,                  --                       csi2_rx_o_d1_ppi_rx_err.ErrSotHS
			csi2_rx_o_d1_ppi_rx_err_ErrSotSyncHS              => CONNECTED_TO_csi2_rx_o_d1_ppi_rx_err_ErrSotSyncHS,              --                                              .ErrSotSyncHS
			csi2_rx_o_d1_ppi_rx_err_ErrEsc                    => CONNECTED_TO_csi2_rx_o_d1_ppi_rx_err_ErrEsc,                    --                                              .ErrEsc
			csi2_rx_o_d1_ppi_rx_err_ErrSyncEsc                => CONNECTED_TO_csi2_rx_o_d1_ppi_rx_err_ErrSyncEsc,                --                                              .ErrSyncEsc
			csi2_rx_o_d1_ppi_rx_err_ErrControl                => CONNECTED_TO_csi2_rx_o_d1_ppi_rx_err_ErrControl,                --                                              .ErrControl
			csi2_rx_o_d1_ppi_rx_err_ErrContentionLP0          => CONNECTED_TO_csi2_rx_o_d1_ppi_rx_err_ErrContentionLP0,          --                                              .ErrContentionLP0
			csi2_rx_o_d1_ppi_rx_err_ErrContentionLP1          => CONNECTED_TO_csi2_rx_o_d1_ppi_rx_err_ErrContentionLP1,          --                                              .ErrContentionLP1
			csi2_rx_o_ck_ppi_rx_err_ErrSotHS                  => CONNECTED_TO_csi2_rx_o_ck_ppi_rx_err_ErrSotHS,                  --                       csi2_rx_o_ck_ppi_rx_err.ErrSotHS
			csi2_rx_o_ck_ppi_rx_err_ErrSotSyncHS              => CONNECTED_TO_csi2_rx_o_ck_ppi_rx_err_ErrSotSyncHS,              --                                              .ErrSotSyncHS
			csi2_rx_o_ck_ppi_rx_err_ErrEsc                    => CONNECTED_TO_csi2_rx_o_ck_ppi_rx_err_ErrEsc,                    --                                              .ErrEsc
			csi2_rx_o_ck_ppi_rx_err_ErrSyncEsc                => CONNECTED_TO_csi2_rx_o_ck_ppi_rx_err_ErrSyncEsc,                --                                              .ErrSyncEsc
			csi2_rx_o_ck_ppi_rx_err_ErrControl                => CONNECTED_TO_csi2_rx_o_ck_ppi_rx_err_ErrControl,                --                                              .ErrControl
			csi2_rx_o_ck_ppi_rx_err_ErrContentionLP0          => CONNECTED_TO_csi2_rx_o_ck_ppi_rx_err_ErrContentionLP0,          --                                              .ErrContentionLP0
			csi2_rx_o_ck_ppi_rx_err_ErrContentionLP1          => CONNECTED_TO_csi2_rx_o_ck_ppi_rx_err_ErrContentionLP1,          --                                              .ErrContentionLP1
			csi2_rx_video_streaming_interface_0_tdata         => CONNECTED_TO_csi2_rx_video_streaming_interface_0_tdata,         --           csi2_rx_video_streaming_interface_0.tdata
			csi2_rx_video_streaming_interface_0_tvalid        => CONNECTED_TO_csi2_rx_video_streaming_interface_0_tvalid,        --                                              .tvalid
			csi2_rx_video_streaming_interface_0_tready        => CONNECTED_TO_csi2_rx_video_streaming_interface_0_tready,        --                                              .tready
			csi2_rx_video_streaming_interface_0_tlast         => CONNECTED_TO_csi2_rx_video_streaming_interface_0_tlast,         --                                              .tlast
			csi2_rx_video_streaming_interface_0_tuser         => CONNECTED_TO_csi2_rx_video_streaming_interface_0_tuser,         --                                              .tuser
			csi2_rx_avalon_mm_control_interface_write         => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_write,         --           csi2_rx_avalon_mm_control_interface.write
			csi2_rx_avalon_mm_control_interface_read          => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_read,          --                                              .read
			csi2_rx_avalon_mm_control_interface_address       => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_address,       --                                              .address
			csi2_rx_avalon_mm_control_interface_writedata     => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_writedata,     --                                              .writedata
			csi2_rx_avalon_mm_control_interface_readdata      => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_readdata,      --                                              .readdata
			csi2_rx_avalon_mm_control_interface_readdatavalid => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_readdatavalid, --                                              .readdatavalid
			csi2_rx_avalon_mm_control_interface_waitrequest   => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_waitrequest,   --                                              .waitrequest
			csi2_rx_avalon_mm_control_interface_byteenable    => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_byteenable,    --                                              .byteenable
			csi2_rx_avalon_mm_control_interface_interrupt_irq => CONNECTED_TO_csi2_rx_avalon_mm_control_interface_interrupt_irq, -- csi2_rx_avalon_mm_control_interface_interrupt.irq
			mipi_dphy_rzq_rzq                                 => CONNECTED_TO_mipi_dphy_rzq_rzq,                                 --                                 mipi_dphy_rzq.rzq
			mipi_dphy_ref_clk_0_clk                           => CONNECTED_TO_mipi_dphy_ref_clk_0_clk,                           --                           mipi_dphy_ref_clk_0.clk
			mipi_dphy_LINK0_link_core_srst_reset_n            => CONNECTED_TO_mipi_dphy_LINK0_link_core_srst_reset_n,            --                mipi_dphy_LINK0_link_core_srst.reset_n
			mipi_dphy_LINK0_link_core_arst_reset_n            => CONNECTED_TO_mipi_dphy_LINK0_link_core_arst_reset_n,            --                mipi_dphy_LINK0_link_core_arst.reset_n
			mipi_dphy_axi_lite_awaddr                         => CONNECTED_TO_mipi_dphy_axi_lite_awaddr,                         --                            mipi_dphy_axi_lite.awaddr
			mipi_dphy_axi_lite_awvalid                        => CONNECTED_TO_mipi_dphy_axi_lite_awvalid,                        --                                              .awvalid
			mipi_dphy_axi_lite_awready                        => CONNECTED_TO_mipi_dphy_axi_lite_awready,                        --                                              .awready
			mipi_dphy_axi_lite_wdata                          => CONNECTED_TO_mipi_dphy_axi_lite_wdata,                          --                                              .wdata
			mipi_dphy_axi_lite_wstrb                          => CONNECTED_TO_mipi_dphy_axi_lite_wstrb,                          --                                              .wstrb
			mipi_dphy_axi_lite_wvalid                         => CONNECTED_TO_mipi_dphy_axi_lite_wvalid,                         --                                              .wvalid
			mipi_dphy_axi_lite_wready                         => CONNECTED_TO_mipi_dphy_axi_lite_wready,                         --                                              .wready
			mipi_dphy_axi_lite_bresp                          => CONNECTED_TO_mipi_dphy_axi_lite_bresp,                          --                                              .bresp
			mipi_dphy_axi_lite_bvalid                         => CONNECTED_TO_mipi_dphy_axi_lite_bvalid,                         --                                              .bvalid
			mipi_dphy_axi_lite_bready                         => CONNECTED_TO_mipi_dphy_axi_lite_bready,                         --                                              .bready
			mipi_dphy_axi_lite_araddr                         => CONNECTED_TO_mipi_dphy_axi_lite_araddr,                         --                                              .araddr
			mipi_dphy_axi_lite_arvalid                        => CONNECTED_TO_mipi_dphy_axi_lite_arvalid,                        --                                              .arvalid
			mipi_dphy_axi_lite_arready                        => CONNECTED_TO_mipi_dphy_axi_lite_arready,                        --                                              .arready
			mipi_dphy_axi_lite_rdata                          => CONNECTED_TO_mipi_dphy_axi_lite_rdata,                          --                                              .rdata
			mipi_dphy_axi_lite_rresp                          => CONNECTED_TO_mipi_dphy_axi_lite_rresp,                          --                                              .rresp
			mipi_dphy_axi_lite_rvalid                         => CONNECTED_TO_mipi_dphy_axi_lite_rvalid,                         --                                              .rvalid
			mipi_dphy_axi_lite_rready                         => CONNECTED_TO_mipi_dphy_axi_lite_rready,                         --                                              .rready
			mipi_dphy_axi_lite_arprot                         => CONNECTED_TO_mipi_dphy_axi_lite_arprot,                         --                                              .arprot
			mipi_dphy_axi_lite_awprot                         => CONNECTED_TO_mipi_dphy_axi_lite_awprot,                         --                                              .awprot
			mipi_dphy_LINK0_dphy_io_dphy_link_dp              => CONNECTED_TO_mipi_dphy_LINK0_dphy_io_dphy_link_dp,              --                       mipi_dphy_LINK0_dphy_io.dphy_link_dp
			mipi_dphy_LINK0_dphy_io_dphy_link_dn              => CONNECTED_TO_mipi_dphy_LINK0_dphy_io_dphy_link_dn,              --                                              .dphy_link_dn
			mipi_dphy_LINK0_dphy_io_dphy_link_cp              => CONNECTED_TO_mipi_dphy_LINK0_dphy_io_dphy_link_cp,              --                                              .dphy_link_cp
			mipi_dphy_LINK0_dphy_io_dphy_link_cn              => CONNECTED_TO_mipi_dphy_LINK0_dphy_io_dphy_link_cn,              --                                              .dphy_link_cn
			mipi_dphy_reg_bus_reg_wr_en_o                     => CONNECTED_TO_mipi_dphy_reg_bus_reg_wr_en_o,                     --                             mipi_dphy_reg_bus.reg_wr_en_o
			mipi_dphy_reg_bus_reg_rd_en_o                     => CONNECTED_TO_mipi_dphy_reg_bus_reg_rd_en_o,                     --                                              .reg_rd_en_o
			mipi_dphy_reg_bus_reg_raddr_o                     => CONNECTED_TO_mipi_dphy_reg_bus_reg_raddr_o,                     --                                              .reg_raddr_o
			mipi_dphy_reg_bus_reg_waddr_o                     => CONNECTED_TO_mipi_dphy_reg_bus_reg_waddr_o,                     --                                              .reg_waddr_o
			mipi_dphy_reg_bus_reg_be_o                        => CONNECTED_TO_mipi_dphy_reg_bus_reg_be_o,                        --                                              .reg_be_o
			mipi_dphy_reg_bus_reg_din_o                       => CONNECTED_TO_mipi_dphy_reg_bus_reg_din_o,                       --                                              .reg_din_o
			mipi_dphy_reg_bus_reg_dout_i                      => CONNECTED_TO_mipi_dphy_reg_bus_reg_dout_i,                      --                                              .reg_dout_i
			rx_axi4s_clk_bridge_in_clk_clk                    => CONNECTED_TO_rx_axi4s_clk_bridge_in_clk_clk                     --                    rx_axi4s_clk_bridge_in_clk.clk
		);

