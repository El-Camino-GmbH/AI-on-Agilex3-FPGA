	component csi2_dphy_sys_csi2_tx is
		port (
			tx_word_clk_hs_d0         : in  std_logic                     := 'X';             -- clk
			tx_data_width_hs_d0       : out std_logic_vector(1 downto 0);                     -- TxDataWidthHS
			tx_data_hs_d0             : out std_logic_vector(15 downto 0);                    -- TxDataHS
			tx_word_valid_hs_d0       : out std_logic_vector(1 downto 0);                     -- TxWordValidHS
			tx_eq_active_hs_d0        : out std_logic;                                        -- TxEqActiveHS
			tx_eq_level_hs_d0         : out std_logic;                                        -- TxEqLevelHS
			tx_request_hs_d0          : out std_logic;                                        -- TxRequestHS
			tx_ready_hs_d0            : in  std_logic                     := 'X';             -- TxReadyHS
			tx_data_transfer_en_hs_d0 : out std_logic;                                        -- TxDataTransferEnHS
			tx_skew_cal_hs_d0         : out std_logic;                                        -- TxSkewCalHS
			tx_alternate_cal_hs_d0    : out std_logic;                                        -- TxAlternateCalHS
			tx_request_esc_d0         : out std_logic;                                        -- TxRequestEsc
			tx_request_type_esc_d0    : out std_logic_vector(3 downto 0);                     -- TxRequestTypeEsc
			tx_lpdt_esc_d0            : out std_logic;                                        -- TxLpdtEsc
			tx_ulps_exit_d0           : out std_logic;                                        -- TxUlpsExit
			tx_ulps_esc_d0            : out std_logic;                                        -- TxUlpsEsc
			tx_trigger_esc_d0         : out std_logic_vector(3 downto 0);                     -- TxTriggerEsc
			tx_data_esc_d0            : out std_logic_vector(7 downto 0);                     -- TxDataEsc
			tx_valid_esc_d0           : out std_logic;                                        -- TxValidEsc
			tx_ready_esc_d0           : in  std_logic                     := 'X';             -- TxReadyEsc
			turn_request_d0           : out std_logic;                                        -- TurnRequest
			direction_d0              : in  std_logic                     := 'X';             -- Direction
			turn_disable_d0           : out std_logic;                                        -- TurnDisable
			force_rx_mode_d0          : out std_logic;                                        -- ForceRxmode
			force_tx_stop_mode_d0     : out std_logic;                                        -- ForceTxStopmode
			stop_state_d0             : in  std_logic                     := 'X';             -- Stopstate
			enable_d0                 : out std_logic;                                        -- Enable
			alp_mode_d0               : out std_logic;                                        -- AlpMode
			tx_ulps_clk_d0            : out std_logic;                                        -- TxUlpsClk
			rx_ulps_clk_not_d0        : in  std_logic                     := 'X';             -- RxUlpsClkNot
			ulps_active_not_d0        : in  std_logic                     := 'X';             -- UlpsActiveNot
			tx_hsidle_clk_hs_d0       : out std_logic;                                        -- TxHSIdleClkHS
			tx_hsidle_clk_ready_hs_d0 : in  std_logic                     := 'X';             -- TxHSIdleClkReadyHS
			tx_clk_esc_d0             : in  std_logic                     := 'X';             -- clk
			tx_word_clk_hs_d1         : in  std_logic                     := 'X';             -- clk
			tx_data_width_hs_d1       : out std_logic_vector(1 downto 0);                     -- TxDataWidthHS
			tx_data_hs_d1             : out std_logic_vector(15 downto 0);                    -- TxDataHS
			tx_word_valid_hs_d1       : out std_logic_vector(1 downto 0);                     -- TxWordValidHS
			tx_eq_active_hs_d1        : out std_logic;                                        -- TxEqActiveHS
			tx_eq_level_hs_d1         : out std_logic;                                        -- TxEqLevelHS
			tx_request_hs_d1          : out std_logic;                                        -- TxRequestHS
			tx_ready_hs_d1            : in  std_logic                     := 'X';             -- TxReadyHS
			tx_data_transfer_en_hs_d1 : out std_logic;                                        -- TxDataTransferEnHS
			tx_skew_cal_hs_d1         : out std_logic;                                        -- TxSkewCalHS
			tx_alternate_cal_hs_d1    : out std_logic;                                        -- TxAlternateCalHS
			tx_request_esc_d1         : out std_logic;                                        -- TxRequestEsc
			tx_request_type_esc_d1    : out std_logic_vector(3 downto 0);                     -- TxRequestTypeEsc
			tx_lpdt_esc_d1            : out std_logic;                                        -- TxLpdtEsc
			tx_ulps_exit_d1           : out std_logic;                                        -- TxUlpsExit
			tx_ulps_esc_d1            : out std_logic;                                        -- TxUlpsEsc
			tx_trigger_esc_d1         : out std_logic_vector(3 downto 0);                     -- TxTriggerEsc
			tx_data_esc_d1            : out std_logic_vector(7 downto 0);                     -- TxDataEsc
			tx_valid_esc_d1           : out std_logic;                                        -- TxValidEsc
			tx_ready_esc_d1           : in  std_logic                     := 'X';             -- TxReadyEsc
			turn_request_d1           : out std_logic;                                        -- TurnRequest
			direction_d1              : in  std_logic                     := 'X';             -- Direction
			turn_disable_d1           : out std_logic;                                        -- TurnDisable
			force_rx_mode_d1          : out std_logic;                                        -- ForceRxmode
			force_tx_stop_mode_d1     : out std_logic;                                        -- ForceTxStopmode
			stop_state_d1             : in  std_logic                     := 'X';             -- Stopstate
			enable_d1                 : out std_logic;                                        -- Enable
			alp_mode_d1               : out std_logic;                                        -- AlpMode
			tx_ulps_clk_d1            : out std_logic;                                        -- TxUlpsClk
			rx_ulps_clk_not_d1        : in  std_logic                     := 'X';             -- RxUlpsClkNot
			ulps_active_not_d1        : in  std_logic                     := 'X';             -- UlpsActiveNot
			tx_hsidle_clk_hs_d1       : out std_logic;                                        -- TxHSIdleClkHS
			tx_hsidle_clk_ready_hs_d1 : in  std_logic                     := 'X';             -- TxHSIdleClkReadyHS
			tx_clk_esc_d1             : in  std_logic                     := 'X';             -- clk
			tx_word_clk_hs_ck         : in  std_logic                     := 'X';             -- clk
			tx_data_width_hs_ck       : out std_logic_vector(1 downto 0);                     -- TxDataWidthHS
			tx_data_hs_ck             : out std_logic_vector(15 downto 0);                    -- TxDataHS
			tx_word_valid_hs_ck       : out std_logic_vector(1 downto 0);                     -- TxWordValidHS
			tx_eq_active_hs_ck        : out std_logic;                                        -- TxEqActiveHS
			tx_eq_level_hs_ck         : out std_logic;                                        -- TxEqLevelHS
			tx_request_hs_ck          : out std_logic;                                        -- TxRequestHS
			tx_ready_hs_ck            : in  std_logic                     := 'X';             -- TxReadyHS
			tx_data_transfer_en_hs_ck : out std_logic;                                        -- TxDataTransferEnHS
			tx_skew_cal_hs_ck         : out std_logic;                                        -- TxSkewCalHS
			tx_alternate_cal_hs_ck    : out std_logic;                                        -- TxAlternateCalHS
			tx_request_esc_ck         : out std_logic;                                        -- TxRequestEsc
			tx_request_type_esc_ck    : out std_logic_vector(3 downto 0);                     -- TxRequestTypeEsc
			tx_lpdt_esc_ck            : out std_logic;                                        -- TxLpdtEsc
			tx_ulps_exit_ck           : out std_logic;                                        -- TxUlpsExit
			tx_ulps_esc_ck            : out std_logic;                                        -- TxUlpsEsc
			tx_trigger_esc_ck         : out std_logic_vector(3 downto 0);                     -- TxTriggerEsc
			tx_data_esc_ck            : out std_logic_vector(7 downto 0);                     -- TxDataEsc
			tx_valid_esc_ck           : out std_logic;                                        -- TxValidEsc
			tx_ready_esc_ck           : in  std_logic                     := 'X';             -- TxReadyEsc
			turn_request_ck           : out std_logic;                                        -- TurnRequest
			direction_ck              : in  std_logic                     := 'X';             -- Direction
			turn_disable_ck           : out std_logic;                                        -- TurnDisable
			force_rx_mode_ck          : out std_logic;                                        -- ForceRxmode
			force_tx_stop_mode_ck     : out std_logic;                                        -- ForceTxStopmode
			stop_state_ck             : in  std_logic                     := 'X';             -- Stopstate
			enable_ck                 : out std_logic;                                        -- Enable
			alp_mode_ck               : out std_logic;                                        -- AlpMode
			tx_ulps_clk_ck            : out std_logic;                                        -- TxUlpsClk
			rx_ulps_clk_not_ck        : in  std_logic                     := 'X';             -- RxUlpsClkNot
			ulps_active_not_ck        : in  std_logic                     := 'X';             -- UlpsActiveNot
			tx_hsidle_clk_hs_ck       : out std_logic;                                        -- TxHSIdleClkHS
			tx_hsidle_clk_ready_hs_ck : in  std_logic                     := 'X';             -- TxHSIdleClkReadyHS
			tx_clk_esc_ck             : in  std_logic                     := 'X';             -- clk
			axi4s_clk                 : in  std_logic                     := 'X';             -- clk
			axi4s_rst                 : in  std_logic                     := 'X';             -- reset
			axi4s_vid_in_0_tdata      : in  std_logic_vector(47 downto 0) := (others => 'X'); -- tdata
			axi4s_vid_in_0_tvalid     : in  std_logic                     := 'X';             -- tvalid
			axi4s_vid_in_0_tready     : out std_logic;                                        -- tready
			axi4s_vid_in_0_tlast      : in  std_logic                     := 'X';             -- tlast
			axi4s_vid_in_0_tuser      : in  std_logic_vector(5 downto 0)  := (others => 'X'); -- tuser
			control_write             : in  std_logic                     := 'X';             -- write
			control_read              : in  std_logic                     := 'X';             -- read
			control_address           : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- address
			control_writedata         : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			control_readdata          : out std_logic_vector(31 downto 0);                    -- readdata
			control_readdatavalid     : out std_logic;                                        -- readdatavalid
			control_waitrequest       : out std_logic;                                        -- waitrequest
			control_byteenable        : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			control_irq               : out std_logic                                         -- irq
		);
	end component csi2_dphy_sys_csi2_tx;

	u0 : component csi2_dphy_sys_csi2_tx
		port map (
			tx_word_clk_hs_d0         => CONNECTED_TO_tx_word_clk_hs_d0,         --                         d0_ppi_hs_clk.clk
			tx_data_width_hs_d0       => CONNECTED_TO_tx_data_width_hs_d0,       --                             d0_ppi_hs.TxDataWidthHS
			tx_data_hs_d0             => CONNECTED_TO_tx_data_hs_d0,             --                                      .TxDataHS
			tx_word_valid_hs_d0       => CONNECTED_TO_tx_word_valid_hs_d0,       --                                      .TxWordValidHS
			tx_eq_active_hs_d0        => CONNECTED_TO_tx_eq_active_hs_d0,        --                                      .TxEqActiveHS
			tx_eq_level_hs_d0         => CONNECTED_TO_tx_eq_level_hs_d0,         --                                      .TxEqLevelHS
			tx_request_hs_d0          => CONNECTED_TO_tx_request_hs_d0,          --                                      .TxRequestHS
			tx_ready_hs_d0            => CONNECTED_TO_tx_ready_hs_d0,            --                                      .TxReadyHS
			tx_data_transfer_en_hs_d0 => CONNECTED_TO_tx_data_transfer_en_hs_d0, --                                      .TxDataTransferEnHS
			tx_skew_cal_hs_d0         => CONNECTED_TO_tx_skew_cal_hs_d0,         --                                      .TxSkewCalHS
			tx_alternate_cal_hs_d0    => CONNECTED_TO_tx_alternate_cal_hs_d0,    --                                      .TxAlternateCalHS
			tx_request_esc_d0         => CONNECTED_TO_tx_request_esc_d0,         --                             d0_ppi_lp.TxRequestEsc
			tx_request_type_esc_d0    => CONNECTED_TO_tx_request_type_esc_d0,    --                                      .TxRequestTypeEsc
			tx_lpdt_esc_d0            => CONNECTED_TO_tx_lpdt_esc_d0,            --                                      .TxLpdtEsc
			tx_ulps_exit_d0           => CONNECTED_TO_tx_ulps_exit_d0,           --                                      .TxUlpsExit
			tx_ulps_esc_d0            => CONNECTED_TO_tx_ulps_esc_d0,            --                                      .TxUlpsEsc
			tx_trigger_esc_d0         => CONNECTED_TO_tx_trigger_esc_d0,         --                                      .TxTriggerEsc
			tx_data_esc_d0            => CONNECTED_TO_tx_data_esc_d0,            --                                      .TxDataEsc
			tx_valid_esc_d0           => CONNECTED_TO_tx_valid_esc_d0,           --                                      .TxValidEsc
			tx_ready_esc_d0           => CONNECTED_TO_tx_ready_esc_d0,           --                                      .TxReadyEsc
			turn_request_d0           => CONNECTED_TO_turn_request_d0,           --                           d0_ppi_ctrl.TurnRequest
			direction_d0              => CONNECTED_TO_direction_d0,              --                                      .Direction
			turn_disable_d0           => CONNECTED_TO_turn_disable_d0,           --                                      .TurnDisable
			force_rx_mode_d0          => CONNECTED_TO_force_rx_mode_d0,          --                                      .ForceRxmode
			force_tx_stop_mode_d0     => CONNECTED_TO_force_tx_stop_mode_d0,     --                                      .ForceTxStopmode
			stop_state_d0             => CONNECTED_TO_stop_state_d0,             --                                      .Stopstate
			enable_d0                 => CONNECTED_TO_enable_d0,                 --                                      .Enable
			alp_mode_d0               => CONNECTED_TO_alp_mode_d0,               --                                      .AlpMode
			tx_ulps_clk_d0            => CONNECTED_TO_tx_ulps_clk_d0,            --                                      .TxUlpsClk
			rx_ulps_clk_not_d0        => CONNECTED_TO_rx_ulps_clk_not_d0,        --                                      .RxUlpsClkNot
			ulps_active_not_d0        => CONNECTED_TO_ulps_active_not_d0,        --                                      .UlpsActiveNot
			tx_hsidle_clk_hs_d0       => CONNECTED_TO_tx_hsidle_clk_hs_d0,       --                                      .TxHSIdleClkHS
			tx_hsidle_clk_ready_hs_d0 => CONNECTED_TO_tx_hsidle_clk_ready_hs_d0, --                                      .TxHSIdleClkReadyHS
			tx_clk_esc_d0             => CONNECTED_TO_tx_clk_esc_d0,             --                      d0_ppi_tx_lp_clk.clk
			tx_word_clk_hs_d1         => CONNECTED_TO_tx_word_clk_hs_d1,         --                         d1_ppi_hs_clk.clk
			tx_data_width_hs_d1       => CONNECTED_TO_tx_data_width_hs_d1,       --                             d1_ppi_hs.TxDataWidthHS
			tx_data_hs_d1             => CONNECTED_TO_tx_data_hs_d1,             --                                      .TxDataHS
			tx_word_valid_hs_d1       => CONNECTED_TO_tx_word_valid_hs_d1,       --                                      .TxWordValidHS
			tx_eq_active_hs_d1        => CONNECTED_TO_tx_eq_active_hs_d1,        --                                      .TxEqActiveHS
			tx_eq_level_hs_d1         => CONNECTED_TO_tx_eq_level_hs_d1,         --                                      .TxEqLevelHS
			tx_request_hs_d1          => CONNECTED_TO_tx_request_hs_d1,          --                                      .TxRequestHS
			tx_ready_hs_d1            => CONNECTED_TO_tx_ready_hs_d1,            --                                      .TxReadyHS
			tx_data_transfer_en_hs_d1 => CONNECTED_TO_tx_data_transfer_en_hs_d1, --                                      .TxDataTransferEnHS
			tx_skew_cal_hs_d1         => CONNECTED_TO_tx_skew_cal_hs_d1,         --                                      .TxSkewCalHS
			tx_alternate_cal_hs_d1    => CONNECTED_TO_tx_alternate_cal_hs_d1,    --                                      .TxAlternateCalHS
			tx_request_esc_d1         => CONNECTED_TO_tx_request_esc_d1,         --                             d1_ppi_lp.TxRequestEsc
			tx_request_type_esc_d1    => CONNECTED_TO_tx_request_type_esc_d1,    --                                      .TxRequestTypeEsc
			tx_lpdt_esc_d1            => CONNECTED_TO_tx_lpdt_esc_d1,            --                                      .TxLpdtEsc
			tx_ulps_exit_d1           => CONNECTED_TO_tx_ulps_exit_d1,           --                                      .TxUlpsExit
			tx_ulps_esc_d1            => CONNECTED_TO_tx_ulps_esc_d1,            --                                      .TxUlpsEsc
			tx_trigger_esc_d1         => CONNECTED_TO_tx_trigger_esc_d1,         --                                      .TxTriggerEsc
			tx_data_esc_d1            => CONNECTED_TO_tx_data_esc_d1,            --                                      .TxDataEsc
			tx_valid_esc_d1           => CONNECTED_TO_tx_valid_esc_d1,           --                                      .TxValidEsc
			tx_ready_esc_d1           => CONNECTED_TO_tx_ready_esc_d1,           --                                      .TxReadyEsc
			turn_request_d1           => CONNECTED_TO_turn_request_d1,           --                           d1_ppi_ctrl.TurnRequest
			direction_d1              => CONNECTED_TO_direction_d1,              --                                      .Direction
			turn_disable_d1           => CONNECTED_TO_turn_disable_d1,           --                                      .TurnDisable
			force_rx_mode_d1          => CONNECTED_TO_force_rx_mode_d1,          --                                      .ForceRxmode
			force_tx_stop_mode_d1     => CONNECTED_TO_force_tx_stop_mode_d1,     --                                      .ForceTxStopmode
			stop_state_d1             => CONNECTED_TO_stop_state_d1,             --                                      .Stopstate
			enable_d1                 => CONNECTED_TO_enable_d1,                 --                                      .Enable
			alp_mode_d1               => CONNECTED_TO_alp_mode_d1,               --                                      .AlpMode
			tx_ulps_clk_d1            => CONNECTED_TO_tx_ulps_clk_d1,            --                                      .TxUlpsClk
			rx_ulps_clk_not_d1        => CONNECTED_TO_rx_ulps_clk_not_d1,        --                                      .RxUlpsClkNot
			ulps_active_not_d1        => CONNECTED_TO_ulps_active_not_d1,        --                                      .UlpsActiveNot
			tx_hsidle_clk_hs_d1       => CONNECTED_TO_tx_hsidle_clk_hs_d1,       --                                      .TxHSIdleClkHS
			tx_hsidle_clk_ready_hs_d1 => CONNECTED_TO_tx_hsidle_clk_ready_hs_d1, --                                      .TxHSIdleClkReadyHS
			tx_clk_esc_d1             => CONNECTED_TO_tx_clk_esc_d1,             --                      d1_ppi_tx_lp_clk.clk
			tx_word_clk_hs_ck         => CONNECTED_TO_tx_word_clk_hs_ck,         --                         ck_ppi_hs_clk.clk
			tx_data_width_hs_ck       => CONNECTED_TO_tx_data_width_hs_ck,       --                             ck_ppi_hs.TxDataWidthHS
			tx_data_hs_ck             => CONNECTED_TO_tx_data_hs_ck,             --                                      .TxDataHS
			tx_word_valid_hs_ck       => CONNECTED_TO_tx_word_valid_hs_ck,       --                                      .TxWordValidHS
			tx_eq_active_hs_ck        => CONNECTED_TO_tx_eq_active_hs_ck,        --                                      .TxEqActiveHS
			tx_eq_level_hs_ck         => CONNECTED_TO_tx_eq_level_hs_ck,         --                                      .TxEqLevelHS
			tx_request_hs_ck          => CONNECTED_TO_tx_request_hs_ck,          --                                      .TxRequestHS
			tx_ready_hs_ck            => CONNECTED_TO_tx_ready_hs_ck,            --                                      .TxReadyHS
			tx_data_transfer_en_hs_ck => CONNECTED_TO_tx_data_transfer_en_hs_ck, --                                      .TxDataTransferEnHS
			tx_skew_cal_hs_ck         => CONNECTED_TO_tx_skew_cal_hs_ck,         --                                      .TxSkewCalHS
			tx_alternate_cal_hs_ck    => CONNECTED_TO_tx_alternate_cal_hs_ck,    --                                      .TxAlternateCalHS
			tx_request_esc_ck         => CONNECTED_TO_tx_request_esc_ck,         --                             ck_ppi_lp.TxRequestEsc
			tx_request_type_esc_ck    => CONNECTED_TO_tx_request_type_esc_ck,    --                                      .TxRequestTypeEsc
			tx_lpdt_esc_ck            => CONNECTED_TO_tx_lpdt_esc_ck,            --                                      .TxLpdtEsc
			tx_ulps_exit_ck           => CONNECTED_TO_tx_ulps_exit_ck,           --                                      .TxUlpsExit
			tx_ulps_esc_ck            => CONNECTED_TO_tx_ulps_esc_ck,            --                                      .TxUlpsEsc
			tx_trigger_esc_ck         => CONNECTED_TO_tx_trigger_esc_ck,         --                                      .TxTriggerEsc
			tx_data_esc_ck            => CONNECTED_TO_tx_data_esc_ck,            --                                      .TxDataEsc
			tx_valid_esc_ck           => CONNECTED_TO_tx_valid_esc_ck,           --                                      .TxValidEsc
			tx_ready_esc_ck           => CONNECTED_TO_tx_ready_esc_ck,           --                                      .TxReadyEsc
			turn_request_ck           => CONNECTED_TO_turn_request_ck,           --                           ck_ppi_ctrl.TurnRequest
			direction_ck              => CONNECTED_TO_direction_ck,              --                                      .Direction
			turn_disable_ck           => CONNECTED_TO_turn_disable_ck,           --                                      .TurnDisable
			force_rx_mode_ck          => CONNECTED_TO_force_rx_mode_ck,          --                                      .ForceRxmode
			force_tx_stop_mode_ck     => CONNECTED_TO_force_tx_stop_mode_ck,     --                                      .ForceTxStopmode
			stop_state_ck             => CONNECTED_TO_stop_state_ck,             --                                      .Stopstate
			enable_ck                 => CONNECTED_TO_enable_ck,                 --                                      .Enable
			alp_mode_ck               => CONNECTED_TO_alp_mode_ck,               --                                      .AlpMode
			tx_ulps_clk_ck            => CONNECTED_TO_tx_ulps_clk_ck,            --                                      .TxUlpsClk
			rx_ulps_clk_not_ck        => CONNECTED_TO_rx_ulps_clk_not_ck,        --                                      .RxUlpsClkNot
			ulps_active_not_ck        => CONNECTED_TO_ulps_active_not_ck,        --                                      .UlpsActiveNot
			tx_hsidle_clk_hs_ck       => CONNECTED_TO_tx_hsidle_clk_hs_ck,       --                                      .TxHSIdleClkHS
			tx_hsidle_clk_ready_hs_ck => CONNECTED_TO_tx_hsidle_clk_ready_hs_ck, --                                      .TxHSIdleClkReadyHS
			tx_clk_esc_ck             => CONNECTED_TO_tx_clk_esc_ck,             --                      ck_ppi_tx_lp_clk.clk
			axi4s_clk                 => CONNECTED_TO_axi4s_clk,                 --                             axi4s_clk.clk
			axi4s_rst                 => CONNECTED_TO_axi4s_rst,                 --                             axi4s_rst.reset
			axi4s_vid_in_0_tdata      => CONNECTED_TO_axi4s_vid_in_0_tdata,      --           video_streaming_interface_0.tdata
			axi4s_vid_in_0_tvalid     => CONNECTED_TO_axi4s_vid_in_0_tvalid,     --                                      .tvalid
			axi4s_vid_in_0_tready     => CONNECTED_TO_axi4s_vid_in_0_tready,     --                                      .tready
			axi4s_vid_in_0_tlast      => CONNECTED_TO_axi4s_vid_in_0_tlast,      --                                      .tlast
			axi4s_vid_in_0_tuser      => CONNECTED_TO_axi4s_vid_in_0_tuser,      --                                      .tuser
			control_write             => CONNECTED_TO_control_write,             --           avalon_mm_control_interface.write
			control_read              => CONNECTED_TO_control_read,              --                                      .read
			control_address           => CONNECTED_TO_control_address,           --                                      .address
			control_writedata         => CONNECTED_TO_control_writedata,         --                                      .writedata
			control_readdata          => CONNECTED_TO_control_readdata,          --                                      .readdata
			control_readdatavalid     => CONNECTED_TO_control_readdatavalid,     --                                      .readdatavalid
			control_waitrequest       => CONNECTED_TO_control_waitrequest,       --                                      .waitrequest
			control_byteenable        => CONNECTED_TO_control_byteenable,        --                                      .byteenable
			control_irq               => CONNECTED_TO_control_irq                -- avalon_mm_control_interface_interrupt.irq
		);

