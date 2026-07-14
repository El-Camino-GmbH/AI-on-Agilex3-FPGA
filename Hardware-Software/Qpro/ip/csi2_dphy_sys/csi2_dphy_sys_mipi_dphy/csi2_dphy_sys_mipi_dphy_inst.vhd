	component csi2_dphy_sys_mipi_dphy is
		port (
			rzq                         : in  std_logic                     := 'X';             -- rzq
			ref_clk_0_p                 : in  std_logic                     := 'X';             -- clk
			arst_n                      : in  std_logic                     := 'X';             -- reset_n
			LINK0_link_core_clk         : out std_logic;                                        -- clk
			LINK0_link_srst_n           : out std_logic;                                        -- reset_n
			LINK0_link_arst_n           : out std_logic;                                        -- reset_n
			axil_clk                    : in  std_logic                     := 'X';             -- clk
			srst_axil_n                 : in  std_logic                     := 'X';             -- reset_n
			axi_lite_awaddr             : in  std_logic_vector(11 downto 0) := (others => 'X'); -- awaddr
			axi_lite_awvalid            : in  std_logic                     := 'X';             -- awvalid
			axi_lite_awready            : out std_logic;                                        -- awready
			axi_lite_wdata              : in  std_logic_vector(31 downto 0) := (others => 'X'); -- wdata
			axi_lite_wstrb              : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- wstrb
			axi_lite_wvalid             : in  std_logic                     := 'X';             -- wvalid
			axi_lite_wready             : out std_logic;                                        -- wready
			axi_lite_bresp              : out std_logic_vector(1 downto 0);                     -- bresp
			axi_lite_bvalid             : out std_logic;                                        -- bvalid
			axi_lite_bready             : in  std_logic                     := 'X';             -- bready
			axi_lite_araddr             : in  std_logic_vector(11 downto 0) := (others => 'X'); -- araddr
			axi_lite_arvalid            : in  std_logic                     := 'X';             -- arvalid
			axi_lite_arready            : out std_logic;                                        -- arready
			axi_lite_rdata              : out std_logic_vector(31 downto 0);                    -- rdata
			axi_lite_rresp              : out std_logic_vector(1 downto 0);                     -- rresp
			axi_lite_rvalid             : out std_logic;                                        -- rvalid
			axi_lite_rready             : in  std_logic                     := 'X';             -- rready
			axi_lite_arprot             : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- arprot
			axi_lite_awprot             : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- awprot
			LINK0_D0_RxWordClkHS        : out std_logic;                                        -- clk
			LINK0_D1_RxWordClkHS        : out std_logic;                                        -- clk
			LINK0_CK_RxWordClkHS        : out std_logic;                                        -- clk
			LINK0_D0_RxSRst_n           : out std_logic;                                        -- reset_n
			LINK0_D1_RxSRst_n           : out std_logic;                                        -- reset_n
			LINK0_CK_RxSRst_n           : out std_logic;                                        -- reset_n
			LINK0_D0_RxDataWidthHS      : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- RxDataWidthHS
			LINK0_D0_RxDataHS           : out std_logic_vector(15 downto 0);                    -- RxDataHS
			LINK0_D0_RxValidHS          : out std_logic_vector(1 downto 0);                     -- RxValidHS
			LINK0_D0_RxActiveHS         : out std_logic;                                        -- RxActiveHS
			LINK0_D0_RxSyncHS           : out std_logic;                                        -- RxSyncHS
			LINK0_D0_RxDetectEobHS      : in  std_logic                     := 'X';             -- RxDetectEobHS
			LINK0_D0_RxClkActiveHS      : out std_logic;                                        -- RxClkActiveHS
			LINK0_D0_RxDDRClkHS         : out std_logic;                                        -- RxDDRClkHS
			LINK0_D0_RxSkewCalHS        : out std_logic;                                        -- RxSkewCalHS
			LINK0_D0_RxAlternateCalHS   : out std_logic;                                        -- RxAlternateCalHS
			LINK0_D0_RxErrorCalHS       : out std_logic;                                        -- RxErrorCalHS
			LINK0_D1_RxDataWidthHS      : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- RxDataWidthHS
			LINK0_D1_RxDataHS           : out std_logic_vector(15 downto 0);                    -- RxDataHS
			LINK0_D1_RxValidHS          : out std_logic_vector(1 downto 0);                     -- RxValidHS
			LINK0_D1_RxActiveHS         : out std_logic;                                        -- RxActiveHS
			LINK0_D1_RxSyncHS           : out std_logic;                                        -- RxSyncHS
			LINK0_D1_RxDetectEobHS      : in  std_logic                     := 'X';             -- RxDetectEobHS
			LINK0_D1_RxClkActiveHS      : out std_logic;                                        -- RxClkActiveHS
			LINK0_D1_RxDDRClkHS         : out std_logic;                                        -- RxDDRClkHS
			LINK0_D1_RxSkewCalHS        : out std_logic;                                        -- RxSkewCalHS
			LINK0_D1_RxAlternateCalHS   : out std_logic;                                        -- RxAlternateCalHS
			LINK0_D1_RxErrorCalHS       : out std_logic;                                        -- RxErrorCalHS
			LINK0_CK_RxDataWidthHS      : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- RxDataWidthHS
			LINK0_CK_RxDataHS           : out std_logic_vector(15 downto 0);                    -- RxDataHS
			LINK0_CK_RxValidHS          : out std_logic_vector(1 downto 0);                     -- RxValidHS
			LINK0_CK_RxActiveHS         : out std_logic;                                        -- RxActiveHS
			LINK0_CK_RxSyncHS           : out std_logic;                                        -- RxSyncHS
			LINK0_CK_RxDetectEobHS      : in  std_logic                     := 'X';             -- RxDetectEobHS
			LINK0_CK_RxClkActiveHS      : out std_logic;                                        -- RxClkActiveHS
			LINK0_CK_RxDDRClkHS         : out std_logic;                                        -- RxDDRClkHS
			LINK0_CK_RxSkewCalHS        : out std_logic;                                        -- RxSkewCalHS
			LINK0_CK_RxAlternateCalHS   : out std_logic;                                        -- RxAlternateCalHS
			LINK0_CK_RxErrorCalHS       : out std_logic;                                        -- RxErrorCalHS
			LINK0_D0_RxClkEsc           : out std_logic;                                        -- RxClkEsc
			LINK0_D0_RxLpdtEsc          : out std_logic;                                        -- RxLpdtEsc
			LINK0_D0_RxUlpsEsc          : out std_logic;                                        -- RxUlpsEsc
			LINK0_D0_RxTriggerEsc       : out std_logic_vector(3 downto 0);                     -- RxTriggerEsc
			LINK0_D0_RxWakeup           : out std_logic;                                        -- RxWakeup
			LINK0_D0_RxDataEsc          : out std_logic_vector(7 downto 0);                     -- RxDataEsc
			LINK0_D0_RxValidEsc         : out std_logic;                                        -- RxValidEsc
			LINK0_D1_RxClkEsc           : out std_logic;                                        -- RxClkEsc
			LINK0_D1_RxLpdtEsc          : out std_logic;                                        -- RxLpdtEsc
			LINK0_D1_RxUlpsEsc          : out std_logic;                                        -- RxUlpsEsc
			LINK0_D1_RxTriggerEsc       : out std_logic_vector(3 downto 0);                     -- RxTriggerEsc
			LINK0_D1_RxWakeup           : out std_logic;                                        -- RxWakeup
			LINK0_D1_RxDataEsc          : out std_logic_vector(7 downto 0);                     -- RxDataEsc
			LINK0_D1_RxValidEsc         : out std_logic;                                        -- RxValidEsc
			LINK0_CK_RxClkEsc           : out std_logic;                                        -- RxClkEsc
			LINK0_CK_RxLpdtEsc          : out std_logic;                                        -- RxLpdtEsc
			LINK0_CK_RxUlpsEsc          : out std_logic;                                        -- RxUlpsEsc
			LINK0_CK_RxTriggerEsc       : out std_logic_vector(3 downto 0);                     -- RxTriggerEsc
			LINK0_CK_RxWakeup           : out std_logic;                                        -- RxWakeup
			LINK0_CK_RxDataEsc          : out std_logic_vector(7 downto 0);                     -- RxDataEsc
			LINK0_CK_RxValidEsc         : out std_logic;                                        -- RxValidEsc
			LINK0_D0_TurnRequest        : in  std_logic                     := 'X';             -- TurnRequest
			LINK0_D0_Direction          : out std_logic;                                        -- Direction
			LINK0_D0_TurnDisable        : in  std_logic                     := 'X';             -- TurnDisable
			LINK0_D0_ForceRxmode        : in  std_logic                     := 'X';             -- ForceRxmode
			LINK0_D0_ForceTxStopmode    : in  std_logic                     := 'X';             -- ForceTxStopmode
			LINK0_D0_Stopstate          : out std_logic;                                        -- Stopstate
			LINK0_D0_Enable             : in  std_logic                     := 'X';             -- Enable
			LINK0_D0_AlpMode            : in  std_logic                     := 'X';             -- AlpMode
			LINK0_D0_TxUlpsClk          : in  std_logic                     := 'X';             -- TxUlpsClk
			LINK0_D0_RxUlpsClkNot       : out std_logic;                                        -- RxUlpsClkNot
			LINK0_D0_UlpsActiveNot      : out std_logic;                                        -- UlpsActiveNot
			LINK0_D0_TxHSIdleClkHS      : in  std_logic                     := 'X';             -- TxHSIdleClkHS
			LINK0_D0_TxHSIdleClkReadyHS : out std_logic;                                        -- TxHSIdleClkReadyHS
			LINK0_D1_TurnRequest        : in  std_logic                     := 'X';             -- TurnRequest
			LINK0_D1_Direction          : out std_logic;                                        -- Direction
			LINK0_D1_TurnDisable        : in  std_logic                     := 'X';             -- TurnDisable
			LINK0_D1_ForceRxmode        : in  std_logic                     := 'X';             -- ForceRxmode
			LINK0_D1_ForceTxStopmode    : in  std_logic                     := 'X';             -- ForceTxStopmode
			LINK0_D1_Stopstate          : out std_logic;                                        -- Stopstate
			LINK0_D1_Enable             : in  std_logic                     := 'X';             -- Enable
			LINK0_D1_AlpMode            : in  std_logic                     := 'X';             -- AlpMode
			LINK0_D1_TxUlpsClk          : in  std_logic                     := 'X';             -- TxUlpsClk
			LINK0_D1_RxUlpsClkNot       : out std_logic;                                        -- RxUlpsClkNot
			LINK0_D1_UlpsActiveNot      : out std_logic;                                        -- UlpsActiveNot
			LINK0_D1_TxHSIdleClkHS      : in  std_logic                     := 'X';             -- TxHSIdleClkHS
			LINK0_D1_TxHSIdleClkReadyHS : out std_logic;                                        -- TxHSIdleClkReadyHS
			LINK0_CK_TurnRequest        : in  std_logic                     := 'X';             -- TurnRequest
			LINK0_CK_Direction          : out std_logic;                                        -- Direction
			LINK0_CK_TurnDisable        : in  std_logic                     := 'X';             -- TurnDisable
			LINK0_CK_ForceRxmode        : in  std_logic                     := 'X';             -- ForceRxmode
			LINK0_CK_ForceTxStopmode    : in  std_logic                     := 'X';             -- ForceTxStopmode
			LINK0_CK_Stopstate          : out std_logic;                                        -- Stopstate
			LINK0_CK_Enable             : in  std_logic                     := 'X';             -- Enable
			LINK0_CK_AlpMode            : in  std_logic                     := 'X';             -- AlpMode
			LINK0_CK_TxUlpsClk          : in  std_logic                     := 'X';             -- TxUlpsClk
			LINK0_CK_RxUlpsClkNot       : out std_logic;                                        -- RxUlpsClkNot
			LINK0_CK_UlpsActiveNot      : out std_logic;                                        -- UlpsActiveNot
			LINK0_CK_TxHSIdleClkHS      : in  std_logic                     := 'X';             -- TxHSIdleClkHS
			LINK0_CK_TxHSIdleClkReadyHS : out std_logic;                                        -- TxHSIdleClkReadyHS
			LINK0_D0_ErrSotHS           : out std_logic;                                        -- ErrSotHS
			LINK0_D0_ErrSotSyncHS       : out std_logic;                                        -- ErrSotSyncHS
			LINK0_D0_ErrEsc             : out std_logic;                                        -- ErrEsc
			LINK0_D0_ErrSyncEsc         : out std_logic;                                        -- ErrSyncEsc
			LINK0_D0_ErrControl         : out std_logic;                                        -- ErrControl
			LINK0_D0_ErrContentionLP0   : out std_logic;                                        -- ErrContentionLP0
			LINK0_D0_ErrContentionLP1   : out std_logic;                                        -- ErrContentionLP1
			LINK0_D1_ErrSotHS           : out std_logic;                                        -- ErrSotHS
			LINK0_D1_ErrSotSyncHS       : out std_logic;                                        -- ErrSotSyncHS
			LINK0_D1_ErrEsc             : out std_logic;                                        -- ErrEsc
			LINK0_D1_ErrSyncEsc         : out std_logic;                                        -- ErrSyncEsc
			LINK0_D1_ErrControl         : out std_logic;                                        -- ErrControl
			LINK0_D1_ErrContentionLP0   : out std_logic;                                        -- ErrContentionLP0
			LINK0_D1_ErrContentionLP1   : out std_logic;                                        -- ErrContentionLP1
			LINK0_CK_ErrSotHS           : out std_logic;                                        -- ErrSotHS
			LINK0_CK_ErrSotSyncHS       : out std_logic;                                        -- ErrSotSyncHS
			LINK0_CK_ErrEsc             : out std_logic;                                        -- ErrEsc
			LINK0_CK_ErrSyncEsc         : out std_logic;                                        -- ErrSyncEsc
			LINK0_CK_ErrControl         : out std_logic;                                        -- ErrControl
			LINK0_CK_ErrContentionLP0   : out std_logic;                                        -- ErrContentionLP0
			LINK0_CK_ErrContentionLP1   : out std_logic;                                        -- ErrContentionLP1
			LINK0_dphy_link_dp          : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- dphy_link_dp
			LINK0_dphy_link_dn          : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- dphy_link_dn
			LINK0_dphy_link_cp          : in  std_logic                     := 'X';             -- dphy_link_cp
			LINK0_dphy_link_cn          : in  std_logic                     := 'X';             -- dphy_link_cn
			reg_wr_en_o                 : out std_logic;                                        -- reg_wr_en_o
			reg_rd_en_o                 : out std_logic;                                        -- reg_rd_en_o
			reg_raddr_o                 : out std_logic_vector(10 downto 0);                    -- reg_raddr_o
			reg_waddr_o                 : out std_logic_vector(10 downto 0);                    -- reg_waddr_o
			reg_be_o                    : out std_logic_vector(3 downto 0);                     -- reg_be_o
			reg_din_o                   : out std_logic_vector(31 downto 0);                    -- reg_din_o
			reg_dout_i                  : in  std_logic_vector(31 downto 0) := (others => 'X')  -- reg_dout_i
		);
	end component csi2_dphy_sys_mipi_dphy;

	u0 : component csi2_dphy_sys_mipi_dphy
		port map (
			rzq                         => CONNECTED_TO_rzq,                         --                     rzq.rzq
			ref_clk_0_p                 => CONNECTED_TO_ref_clk_0_p,                 --               ref_clk_0.clk
			arst_n                      => CONNECTED_TO_arst_n,                      --                    arst.reset_n
			LINK0_link_core_clk         => CONNECTED_TO_LINK0_link_core_clk,         --     LINK0_link_core_clk.clk
			LINK0_link_srst_n           => CONNECTED_TO_LINK0_link_srst_n,           --    LINK0_link_core_srst.reset_n
			LINK0_link_arst_n           => CONNECTED_TO_LINK0_link_arst_n,           --    LINK0_link_core_arst.reset_n
			axil_clk                    => CONNECTED_TO_axil_clk,                    --                 reg_clk.clk
			srst_axil_n                 => CONNECTED_TO_srst_axil_n,                 --                reg_srst.reset_n
			axi_lite_awaddr             => CONNECTED_TO_axi_lite_awaddr,             --                axi_lite.awaddr
			axi_lite_awvalid            => CONNECTED_TO_axi_lite_awvalid,            --                        .awvalid
			axi_lite_awready            => CONNECTED_TO_axi_lite_awready,            --                        .awready
			axi_lite_wdata              => CONNECTED_TO_axi_lite_wdata,              --                        .wdata
			axi_lite_wstrb              => CONNECTED_TO_axi_lite_wstrb,              --                        .wstrb
			axi_lite_wvalid             => CONNECTED_TO_axi_lite_wvalid,             --                        .wvalid
			axi_lite_wready             => CONNECTED_TO_axi_lite_wready,             --                        .wready
			axi_lite_bresp              => CONNECTED_TO_axi_lite_bresp,              --                        .bresp
			axi_lite_bvalid             => CONNECTED_TO_axi_lite_bvalid,             --                        .bvalid
			axi_lite_bready             => CONNECTED_TO_axi_lite_bready,             --                        .bready
			axi_lite_araddr             => CONNECTED_TO_axi_lite_araddr,             --                        .araddr
			axi_lite_arvalid            => CONNECTED_TO_axi_lite_arvalid,            --                        .arvalid
			axi_lite_arready            => CONNECTED_TO_axi_lite_arready,            --                        .arready
			axi_lite_rdata              => CONNECTED_TO_axi_lite_rdata,              --                        .rdata
			axi_lite_rresp              => CONNECTED_TO_axi_lite_rresp,              --                        .rresp
			axi_lite_rvalid             => CONNECTED_TO_axi_lite_rvalid,             --                        .rvalid
			axi_lite_rready             => CONNECTED_TO_axi_lite_rready,             --                        .rready
			axi_lite_arprot             => CONNECTED_TO_axi_lite_arprot,             --                        .arprot
			axi_lite_awprot             => CONNECTED_TO_axi_lite_awprot,             --                        .awprot
			LINK0_D0_RxWordClkHS        => CONNECTED_TO_LINK0_D0_RxWordClkHS,        --  LINK0_D0_ppi_rx_hs_clk.clk
			LINK0_D1_RxWordClkHS        => CONNECTED_TO_LINK0_D1_RxWordClkHS,        --  LINK0_D1_ppi_rx_hs_clk.clk
			LINK0_CK_RxWordClkHS        => CONNECTED_TO_LINK0_CK_RxWordClkHS,        --  LINK0_CK_ppi_rx_hs_clk.clk
			LINK0_D0_RxSRst_n           => CONNECTED_TO_LINK0_D0_RxSRst_n,           -- LINK0_D0_ppi_rx_hs_srst.reset_n
			LINK0_D1_RxSRst_n           => CONNECTED_TO_LINK0_D1_RxSRst_n,           -- LINK0_D1_ppi_rx_hs_srst.reset_n
			LINK0_CK_RxSRst_n           => CONNECTED_TO_LINK0_CK_RxSRst_n,           -- LINK0_CK_ppi_rx_hs_srst.reset_n
			LINK0_D0_RxDataWidthHS      => CONNECTED_TO_LINK0_D0_RxDataWidthHS,      --      LINK0_D0_ppi_rx_hs.RxDataWidthHS
			LINK0_D0_RxDataHS           => CONNECTED_TO_LINK0_D0_RxDataHS,           --                        .RxDataHS
			LINK0_D0_RxValidHS          => CONNECTED_TO_LINK0_D0_RxValidHS,          --                        .RxValidHS
			LINK0_D0_RxActiveHS         => CONNECTED_TO_LINK0_D0_RxActiveHS,         --                        .RxActiveHS
			LINK0_D0_RxSyncHS           => CONNECTED_TO_LINK0_D0_RxSyncHS,           --                        .RxSyncHS
			LINK0_D0_RxDetectEobHS      => CONNECTED_TO_LINK0_D0_RxDetectEobHS,      --                        .RxDetectEobHS
			LINK0_D0_RxClkActiveHS      => CONNECTED_TO_LINK0_D0_RxClkActiveHS,      --                        .RxClkActiveHS
			LINK0_D0_RxDDRClkHS         => CONNECTED_TO_LINK0_D0_RxDDRClkHS,         --                        .RxDDRClkHS
			LINK0_D0_RxSkewCalHS        => CONNECTED_TO_LINK0_D0_RxSkewCalHS,        --                        .RxSkewCalHS
			LINK0_D0_RxAlternateCalHS   => CONNECTED_TO_LINK0_D0_RxAlternateCalHS,   --                        .RxAlternateCalHS
			LINK0_D0_RxErrorCalHS       => CONNECTED_TO_LINK0_D0_RxErrorCalHS,       --                        .RxErrorCalHS
			LINK0_D1_RxDataWidthHS      => CONNECTED_TO_LINK0_D1_RxDataWidthHS,      --      LINK0_D1_ppi_rx_hs.RxDataWidthHS
			LINK0_D1_RxDataHS           => CONNECTED_TO_LINK0_D1_RxDataHS,           --                        .RxDataHS
			LINK0_D1_RxValidHS          => CONNECTED_TO_LINK0_D1_RxValidHS,          --                        .RxValidHS
			LINK0_D1_RxActiveHS         => CONNECTED_TO_LINK0_D1_RxActiveHS,         --                        .RxActiveHS
			LINK0_D1_RxSyncHS           => CONNECTED_TO_LINK0_D1_RxSyncHS,           --                        .RxSyncHS
			LINK0_D1_RxDetectEobHS      => CONNECTED_TO_LINK0_D1_RxDetectEobHS,      --                        .RxDetectEobHS
			LINK0_D1_RxClkActiveHS      => CONNECTED_TO_LINK0_D1_RxClkActiveHS,      --                        .RxClkActiveHS
			LINK0_D1_RxDDRClkHS         => CONNECTED_TO_LINK0_D1_RxDDRClkHS,         --                        .RxDDRClkHS
			LINK0_D1_RxSkewCalHS        => CONNECTED_TO_LINK0_D1_RxSkewCalHS,        --                        .RxSkewCalHS
			LINK0_D1_RxAlternateCalHS   => CONNECTED_TO_LINK0_D1_RxAlternateCalHS,   --                        .RxAlternateCalHS
			LINK0_D1_RxErrorCalHS       => CONNECTED_TO_LINK0_D1_RxErrorCalHS,       --                        .RxErrorCalHS
			LINK0_CK_RxDataWidthHS      => CONNECTED_TO_LINK0_CK_RxDataWidthHS,      --      LINK0_CK_ppi_rx_hs.RxDataWidthHS
			LINK0_CK_RxDataHS           => CONNECTED_TO_LINK0_CK_RxDataHS,           --                        .RxDataHS
			LINK0_CK_RxValidHS          => CONNECTED_TO_LINK0_CK_RxValidHS,          --                        .RxValidHS
			LINK0_CK_RxActiveHS         => CONNECTED_TO_LINK0_CK_RxActiveHS,         --                        .RxActiveHS
			LINK0_CK_RxSyncHS           => CONNECTED_TO_LINK0_CK_RxSyncHS,           --                        .RxSyncHS
			LINK0_CK_RxDetectEobHS      => CONNECTED_TO_LINK0_CK_RxDetectEobHS,      --                        .RxDetectEobHS
			LINK0_CK_RxClkActiveHS      => CONNECTED_TO_LINK0_CK_RxClkActiveHS,      --                        .RxClkActiveHS
			LINK0_CK_RxDDRClkHS         => CONNECTED_TO_LINK0_CK_RxDDRClkHS,         --                        .RxDDRClkHS
			LINK0_CK_RxSkewCalHS        => CONNECTED_TO_LINK0_CK_RxSkewCalHS,        --                        .RxSkewCalHS
			LINK0_CK_RxAlternateCalHS   => CONNECTED_TO_LINK0_CK_RxAlternateCalHS,   --                        .RxAlternateCalHS
			LINK0_CK_RxErrorCalHS       => CONNECTED_TO_LINK0_CK_RxErrorCalHS,       --                        .RxErrorCalHS
			LINK0_D0_RxClkEsc           => CONNECTED_TO_LINK0_D0_RxClkEsc,           --      LINK0_D0_ppi_rx_lp.RxClkEsc
			LINK0_D0_RxLpdtEsc          => CONNECTED_TO_LINK0_D0_RxLpdtEsc,          --                        .RxLpdtEsc
			LINK0_D0_RxUlpsEsc          => CONNECTED_TO_LINK0_D0_RxUlpsEsc,          --                        .RxUlpsEsc
			LINK0_D0_RxTriggerEsc       => CONNECTED_TO_LINK0_D0_RxTriggerEsc,       --                        .RxTriggerEsc
			LINK0_D0_RxWakeup           => CONNECTED_TO_LINK0_D0_RxWakeup,           --                        .RxWakeup
			LINK0_D0_RxDataEsc          => CONNECTED_TO_LINK0_D0_RxDataEsc,          --                        .RxDataEsc
			LINK0_D0_RxValidEsc         => CONNECTED_TO_LINK0_D0_RxValidEsc,         --                        .RxValidEsc
			LINK0_D1_RxClkEsc           => CONNECTED_TO_LINK0_D1_RxClkEsc,           --      LINK0_D1_ppi_rx_lp.RxClkEsc
			LINK0_D1_RxLpdtEsc          => CONNECTED_TO_LINK0_D1_RxLpdtEsc,          --                        .RxLpdtEsc
			LINK0_D1_RxUlpsEsc          => CONNECTED_TO_LINK0_D1_RxUlpsEsc,          --                        .RxUlpsEsc
			LINK0_D1_RxTriggerEsc       => CONNECTED_TO_LINK0_D1_RxTriggerEsc,       --                        .RxTriggerEsc
			LINK0_D1_RxWakeup           => CONNECTED_TO_LINK0_D1_RxWakeup,           --                        .RxWakeup
			LINK0_D1_RxDataEsc          => CONNECTED_TO_LINK0_D1_RxDataEsc,          --                        .RxDataEsc
			LINK0_D1_RxValidEsc         => CONNECTED_TO_LINK0_D1_RxValidEsc,         --                        .RxValidEsc
			LINK0_CK_RxClkEsc           => CONNECTED_TO_LINK0_CK_RxClkEsc,           --      LINK0_CK_ppi_rx_lp.RxClkEsc
			LINK0_CK_RxLpdtEsc          => CONNECTED_TO_LINK0_CK_RxLpdtEsc,          --                        .RxLpdtEsc
			LINK0_CK_RxUlpsEsc          => CONNECTED_TO_LINK0_CK_RxUlpsEsc,          --                        .RxUlpsEsc
			LINK0_CK_RxTriggerEsc       => CONNECTED_TO_LINK0_CK_RxTriggerEsc,       --                        .RxTriggerEsc
			LINK0_CK_RxWakeup           => CONNECTED_TO_LINK0_CK_RxWakeup,           --                        .RxWakeup
			LINK0_CK_RxDataEsc          => CONNECTED_TO_LINK0_CK_RxDataEsc,          --                        .RxDataEsc
			LINK0_CK_RxValidEsc         => CONNECTED_TO_LINK0_CK_RxValidEsc,         --                        .RxValidEsc
			LINK0_D0_TurnRequest        => CONNECTED_TO_LINK0_D0_TurnRequest,        --       LINK0_D0_ppi_ctrl.TurnRequest
			LINK0_D0_Direction          => CONNECTED_TO_LINK0_D0_Direction,          --                        .Direction
			LINK0_D0_TurnDisable        => CONNECTED_TO_LINK0_D0_TurnDisable,        --                        .TurnDisable
			LINK0_D0_ForceRxmode        => CONNECTED_TO_LINK0_D0_ForceRxmode,        --                        .ForceRxmode
			LINK0_D0_ForceTxStopmode    => CONNECTED_TO_LINK0_D0_ForceTxStopmode,    --                        .ForceTxStopmode
			LINK0_D0_Stopstate          => CONNECTED_TO_LINK0_D0_Stopstate,          --                        .Stopstate
			LINK0_D0_Enable             => CONNECTED_TO_LINK0_D0_Enable,             --                        .Enable
			LINK0_D0_AlpMode            => CONNECTED_TO_LINK0_D0_AlpMode,            --                        .AlpMode
			LINK0_D0_TxUlpsClk          => CONNECTED_TO_LINK0_D0_TxUlpsClk,          --                        .TxUlpsClk
			LINK0_D0_RxUlpsClkNot       => CONNECTED_TO_LINK0_D0_RxUlpsClkNot,       --                        .RxUlpsClkNot
			LINK0_D0_UlpsActiveNot      => CONNECTED_TO_LINK0_D0_UlpsActiveNot,      --                        .UlpsActiveNot
			LINK0_D0_TxHSIdleClkHS      => CONNECTED_TO_LINK0_D0_TxHSIdleClkHS,      --                        .TxHSIdleClkHS
			LINK0_D0_TxHSIdleClkReadyHS => CONNECTED_TO_LINK0_D0_TxHSIdleClkReadyHS, --                        .TxHSIdleClkReadyHS
			LINK0_D1_TurnRequest        => CONNECTED_TO_LINK0_D1_TurnRequest,        --       LINK0_D1_ppi_ctrl.TurnRequest
			LINK0_D1_Direction          => CONNECTED_TO_LINK0_D1_Direction,          --                        .Direction
			LINK0_D1_TurnDisable        => CONNECTED_TO_LINK0_D1_TurnDisable,        --                        .TurnDisable
			LINK0_D1_ForceRxmode        => CONNECTED_TO_LINK0_D1_ForceRxmode,        --                        .ForceRxmode
			LINK0_D1_ForceTxStopmode    => CONNECTED_TO_LINK0_D1_ForceTxStopmode,    --                        .ForceTxStopmode
			LINK0_D1_Stopstate          => CONNECTED_TO_LINK0_D1_Stopstate,          --                        .Stopstate
			LINK0_D1_Enable             => CONNECTED_TO_LINK0_D1_Enable,             --                        .Enable
			LINK0_D1_AlpMode            => CONNECTED_TO_LINK0_D1_AlpMode,            --                        .AlpMode
			LINK0_D1_TxUlpsClk          => CONNECTED_TO_LINK0_D1_TxUlpsClk,          --                        .TxUlpsClk
			LINK0_D1_RxUlpsClkNot       => CONNECTED_TO_LINK0_D1_RxUlpsClkNot,       --                        .RxUlpsClkNot
			LINK0_D1_UlpsActiveNot      => CONNECTED_TO_LINK0_D1_UlpsActiveNot,      --                        .UlpsActiveNot
			LINK0_D1_TxHSIdleClkHS      => CONNECTED_TO_LINK0_D1_TxHSIdleClkHS,      --                        .TxHSIdleClkHS
			LINK0_D1_TxHSIdleClkReadyHS => CONNECTED_TO_LINK0_D1_TxHSIdleClkReadyHS, --                        .TxHSIdleClkReadyHS
			LINK0_CK_TurnRequest        => CONNECTED_TO_LINK0_CK_TurnRequest,        --       LINK0_CK_ppi_ctrl.TurnRequest
			LINK0_CK_Direction          => CONNECTED_TO_LINK0_CK_Direction,          --                        .Direction
			LINK0_CK_TurnDisable        => CONNECTED_TO_LINK0_CK_TurnDisable,        --                        .TurnDisable
			LINK0_CK_ForceRxmode        => CONNECTED_TO_LINK0_CK_ForceRxmode,        --                        .ForceRxmode
			LINK0_CK_ForceTxStopmode    => CONNECTED_TO_LINK0_CK_ForceTxStopmode,    --                        .ForceTxStopmode
			LINK0_CK_Stopstate          => CONNECTED_TO_LINK0_CK_Stopstate,          --                        .Stopstate
			LINK0_CK_Enable             => CONNECTED_TO_LINK0_CK_Enable,             --                        .Enable
			LINK0_CK_AlpMode            => CONNECTED_TO_LINK0_CK_AlpMode,            --                        .AlpMode
			LINK0_CK_TxUlpsClk          => CONNECTED_TO_LINK0_CK_TxUlpsClk,          --                        .TxUlpsClk
			LINK0_CK_RxUlpsClkNot       => CONNECTED_TO_LINK0_CK_RxUlpsClkNot,       --                        .RxUlpsClkNot
			LINK0_CK_UlpsActiveNot      => CONNECTED_TO_LINK0_CK_UlpsActiveNot,      --                        .UlpsActiveNot
			LINK0_CK_TxHSIdleClkHS      => CONNECTED_TO_LINK0_CK_TxHSIdleClkHS,      --                        .TxHSIdleClkHS
			LINK0_CK_TxHSIdleClkReadyHS => CONNECTED_TO_LINK0_CK_TxHSIdleClkReadyHS, --                        .TxHSIdleClkReadyHS
			LINK0_D0_ErrSotHS           => CONNECTED_TO_LINK0_D0_ErrSotHS,           --     LINK0_D0_ppi_rx_err.ErrSotHS
			LINK0_D0_ErrSotSyncHS       => CONNECTED_TO_LINK0_D0_ErrSotSyncHS,       --                        .ErrSotSyncHS
			LINK0_D0_ErrEsc             => CONNECTED_TO_LINK0_D0_ErrEsc,             --                        .ErrEsc
			LINK0_D0_ErrSyncEsc         => CONNECTED_TO_LINK0_D0_ErrSyncEsc,         --                        .ErrSyncEsc
			LINK0_D0_ErrControl         => CONNECTED_TO_LINK0_D0_ErrControl,         --                        .ErrControl
			LINK0_D0_ErrContentionLP0   => CONNECTED_TO_LINK0_D0_ErrContentionLP0,   --                        .ErrContentionLP0
			LINK0_D0_ErrContentionLP1   => CONNECTED_TO_LINK0_D0_ErrContentionLP1,   --                        .ErrContentionLP1
			LINK0_D1_ErrSotHS           => CONNECTED_TO_LINK0_D1_ErrSotHS,           --     LINK0_D1_ppi_rx_err.ErrSotHS
			LINK0_D1_ErrSotSyncHS       => CONNECTED_TO_LINK0_D1_ErrSotSyncHS,       --                        .ErrSotSyncHS
			LINK0_D1_ErrEsc             => CONNECTED_TO_LINK0_D1_ErrEsc,             --                        .ErrEsc
			LINK0_D1_ErrSyncEsc         => CONNECTED_TO_LINK0_D1_ErrSyncEsc,         --                        .ErrSyncEsc
			LINK0_D1_ErrControl         => CONNECTED_TO_LINK0_D1_ErrControl,         --                        .ErrControl
			LINK0_D1_ErrContentionLP0   => CONNECTED_TO_LINK0_D1_ErrContentionLP0,   --                        .ErrContentionLP0
			LINK0_D1_ErrContentionLP1   => CONNECTED_TO_LINK0_D1_ErrContentionLP1,   --                        .ErrContentionLP1
			LINK0_CK_ErrSotHS           => CONNECTED_TO_LINK0_CK_ErrSotHS,           --     LINK0_CK_ppi_rx_err.ErrSotHS
			LINK0_CK_ErrSotSyncHS       => CONNECTED_TO_LINK0_CK_ErrSotSyncHS,       --                        .ErrSotSyncHS
			LINK0_CK_ErrEsc             => CONNECTED_TO_LINK0_CK_ErrEsc,             --                        .ErrEsc
			LINK0_CK_ErrSyncEsc         => CONNECTED_TO_LINK0_CK_ErrSyncEsc,         --                        .ErrSyncEsc
			LINK0_CK_ErrControl         => CONNECTED_TO_LINK0_CK_ErrControl,         --                        .ErrControl
			LINK0_CK_ErrContentionLP0   => CONNECTED_TO_LINK0_CK_ErrContentionLP0,   --                        .ErrContentionLP0
			LINK0_CK_ErrContentionLP1   => CONNECTED_TO_LINK0_CK_ErrContentionLP1,   --                        .ErrContentionLP1
			LINK0_dphy_link_dp          => CONNECTED_TO_LINK0_dphy_link_dp,          --           LINK0_dphy_io.dphy_link_dp
			LINK0_dphy_link_dn          => CONNECTED_TO_LINK0_dphy_link_dn,          --                        .dphy_link_dn
			LINK0_dphy_link_cp          => CONNECTED_TO_LINK0_dphy_link_cp,          --                        .dphy_link_cp
			LINK0_dphy_link_cn          => CONNECTED_TO_LINK0_dphy_link_cn,          --                        .dphy_link_cn
			reg_wr_en_o                 => CONNECTED_TO_reg_wr_en_o,                 --                 reg_bus.reg_wr_en_o
			reg_rd_en_o                 => CONNECTED_TO_reg_rd_en_o,                 --                        .reg_rd_en_o
			reg_raddr_o                 => CONNECTED_TO_reg_raddr_o,                 --                        .reg_raddr_o
			reg_waddr_o                 => CONNECTED_TO_reg_waddr_o,                 --                        .reg_waddr_o
			reg_be_o                    => CONNECTED_TO_reg_be_o,                    --                        .reg_be_o
			reg_din_o                   => CONNECTED_TO_reg_din_o,                   --                        .reg_din_o
			reg_dout_i                  => CONNECTED_TO_reg_dout_i                   --                        .reg_dout_i
		);

