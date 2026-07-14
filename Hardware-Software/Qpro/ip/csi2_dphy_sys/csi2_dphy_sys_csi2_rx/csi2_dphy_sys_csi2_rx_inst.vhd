	component csi2_dphy_sys_csi2_rx is
		port (
			rx_srst_n_d0              : in  std_logic                     := 'X';             -- reset_n
			rx_word_clk_hs_d0         : in  std_logic                     := 'X';             -- clk
			rx_data_width_hs_d0       : out std_logic_vector(1 downto 0);                     -- RxDataWidthHS
			rx_data_hs_d0             : in  std_logic_vector(15 downto 0) := (others => 'X'); -- RxDataHS
			rx_valid_hs_d0            : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- RxValidHS
			rx_active_hs_d0           : in  std_logic                     := 'X';             -- RxActiveHS
			rx_sync_hs_d0             : in  std_logic                     := 'X';             -- RxSyncHS
			rx_detect_eob_hs_d0       : out std_logic;                                        -- RxDetectEobHS
			rx_clk_active_hs_d0       : in  std_logic                     := 'X';             -- RxClkActiveHS
			rx_ddr_clk_hs_d0          : in  std_logic                     := 'X';             -- RxDDRClkHS
			rx_skew_cal_hs_d0         : in  std_logic                     := 'X';             -- RxSkewCalHS
			rx_alternate_cal_hs_d0    : in  std_logic                     := 'X';             -- RxAlternateCalHS
			rx_error_cal_hs_d0        : in  std_logic                     := 'X';             -- RxErrorCalHS
			rx_clk_esc_d0             : in  std_logic                     := 'X';             -- RxClkEsc
			rx_lpdt_esc_d0            : in  std_logic                     := 'X';             -- RxLpdtEsc
			rx_ulps_esc_d0            : in  std_logic                     := 'X';             -- RxUlpsEsc
			rx_trigger_esc_d0         : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- RxTriggerEsc
			rx_wake_up_d0             : in  std_logic                     := 'X';             -- RxWakeup
			rx_data_esc_d0            : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- RxDataEsc
			rx_valid_esc_d0           : in  std_logic                     := 'X';             -- RxValidEsc
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
			i_err_sot_hs_d0           : in  std_logic                     := 'X';             -- ErrSotHS
			i_err_sot_sync_hs_d0      : in  std_logic                     := 'X';             -- ErrSotSyncHS
			i_err_esc_d0              : in  std_logic                     := 'X';             -- ErrEsc
			i_err_sync_d0             : in  std_logic                     := 'X';             -- ErrSyncEsc
			i_err_control_d0          : in  std_logic                     := 'X';             -- ErrControl
			i_err_contention_lp0_d0   : in  std_logic                     := 'X';             -- ErrContentionLP0
			i_err_contention_lp1_d0   : in  std_logic                     := 'X';             -- ErrContentionLP1
			o_err_sot_hs_d0           : out std_logic;                                        -- ErrSotHS
			o_err_sot_sync_hs_d0      : out std_logic;                                        -- ErrSotSyncHS
			o_err_esc_d0              : out std_logic;                                        -- ErrEsc
			o_err_sync_d0             : out std_logic;                                        -- ErrSyncEsc
			o_err_control_d0          : out std_logic;                                        -- ErrControl
			o_err_contention_lp0_d0   : out std_logic;                                        -- ErrContentionLP0
			o_err_contention_lp1_d0   : out std_logic;                                        -- ErrContentionLP1
			rx_srst_n_d1              : in  std_logic                     := 'X';             -- reset_n
			rx_word_clk_hs_d1         : in  std_logic                     := 'X';             -- clk
			rx_data_width_hs_d1       : out std_logic_vector(1 downto 0);                     -- RxDataWidthHS
			rx_data_hs_d1             : in  std_logic_vector(15 downto 0) := (others => 'X'); -- RxDataHS
			rx_valid_hs_d1            : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- RxValidHS
			rx_active_hs_d1           : in  std_logic                     := 'X';             -- RxActiveHS
			rx_sync_hs_d1             : in  std_logic                     := 'X';             -- RxSyncHS
			rx_detect_eob_hs_d1       : out std_logic;                                        -- RxDetectEobHS
			rx_clk_active_hs_d1       : in  std_logic                     := 'X';             -- RxClkActiveHS
			rx_ddr_clk_hs_d1          : in  std_logic                     := 'X';             -- RxDDRClkHS
			rx_skew_cal_hs_d1         : in  std_logic                     := 'X';             -- RxSkewCalHS
			rx_alternate_cal_hs_d1    : in  std_logic                     := 'X';             -- RxAlternateCalHS
			rx_error_cal_hs_d1        : in  std_logic                     := 'X';             -- RxErrorCalHS
			rx_clk_esc_d1             : in  std_logic                     := 'X';             -- RxClkEsc
			rx_lpdt_esc_d1            : in  std_logic                     := 'X';             -- RxLpdtEsc
			rx_ulps_esc_d1            : in  std_logic                     := 'X';             -- RxUlpsEsc
			rx_trigger_esc_d1         : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- RxTriggerEsc
			rx_wake_up_d1             : in  std_logic                     := 'X';             -- RxWakeup
			rx_data_esc_d1            : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- RxDataEsc
			rx_valid_esc_d1           : in  std_logic                     := 'X';             -- RxValidEsc
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
			i_err_sot_hs_d1           : in  std_logic                     := 'X';             -- ErrSotHS
			i_err_sot_sync_hs_d1      : in  std_logic                     := 'X';             -- ErrSotSyncHS
			i_err_esc_d1              : in  std_logic                     := 'X';             -- ErrEsc
			i_err_sync_d1             : in  std_logic                     := 'X';             -- ErrSyncEsc
			i_err_control_d1          : in  std_logic                     := 'X';             -- ErrControl
			i_err_contention_lp0_d1   : in  std_logic                     := 'X';             -- ErrContentionLP0
			i_err_contention_lp1_d1   : in  std_logic                     := 'X';             -- ErrContentionLP1
			o_err_sot_hs_d1           : out std_logic;                                        -- ErrSotHS
			o_err_sot_sync_hs_d1      : out std_logic;                                        -- ErrSotSyncHS
			o_err_esc_d1              : out std_logic;                                        -- ErrEsc
			o_err_sync_d1             : out std_logic;                                        -- ErrSyncEsc
			o_err_control_d1          : out std_logic;                                        -- ErrControl
			o_err_contention_lp0_d1   : out std_logic;                                        -- ErrContentionLP0
			o_err_contention_lp1_d1   : out std_logic;                                        -- ErrContentionLP1
			rx_srst_n_ck              : in  std_logic                     := 'X';             -- reset_n
			rx_word_clk_hs_ck         : in  std_logic                     := 'X';             -- clk
			rx_data_width_hs_ck       : out std_logic_vector(1 downto 0);                     -- RxDataWidthHS
			rx_data_hs_ck             : in  std_logic_vector(15 downto 0) := (others => 'X'); -- RxDataHS
			rx_valid_hs_ck            : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- RxValidHS
			rx_active_hs_ck           : in  std_logic                     := 'X';             -- RxActiveHS
			rx_sync_hs_ck             : in  std_logic                     := 'X';             -- RxSyncHS
			rx_detect_eob_hs_ck       : out std_logic;                                        -- RxDetectEobHS
			rx_clk_active_hs_ck       : in  std_logic                     := 'X';             -- RxClkActiveHS
			rx_ddr_clk_hs_ck          : in  std_logic                     := 'X';             -- RxDDRClkHS
			rx_skew_cal_hs_ck         : in  std_logic                     := 'X';             -- RxSkewCalHS
			rx_alternate_cal_hs_ck    : in  std_logic                     := 'X';             -- RxAlternateCalHS
			rx_error_cal_hs_ck        : in  std_logic                     := 'X';             -- RxErrorCalHS
			rx_clk_esc_ck             : in  std_logic                     := 'X';             -- RxClkEsc
			rx_lpdt_esc_ck            : in  std_logic                     := 'X';             -- RxLpdtEsc
			rx_ulps_esc_ck            : in  std_logic                     := 'X';             -- RxUlpsEsc
			rx_trigger_esc_ck         : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- RxTriggerEsc
			rx_wake_up_ck             : in  std_logic                     := 'X';             -- RxWakeup
			rx_data_esc_ck            : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- RxDataEsc
			rx_valid_esc_ck           : in  std_logic                     := 'X';             -- RxValidEsc
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
			i_err_sot_hs_ck           : in  std_logic                     := 'X';             -- ErrSotHS
			i_err_sot_sync_hs_ck      : in  std_logic                     := 'X';             -- ErrSotSyncHS
			i_err_esc_ck              : in  std_logic                     := 'X';             -- ErrEsc
			i_err_sync_ck             : in  std_logic                     := 'X';             -- ErrSyncEsc
			i_err_control_ck          : in  std_logic                     := 'X';             -- ErrControl
			i_err_contention_lp0_ck   : in  std_logic                     := 'X';             -- ErrContentionLP0
			i_err_contention_lp1_ck   : in  std_logic                     := 'X';             -- ErrContentionLP1
			o_err_sot_hs_ck           : out std_logic;                                        -- ErrSotHS
			o_err_sot_sync_hs_ck      : out std_logic;                                        -- ErrSotSyncHS
			o_err_esc_ck              : out std_logic;                                        -- ErrEsc
			o_err_sync_ck             : out std_logic;                                        -- ErrSyncEsc
			o_err_control_ck          : out std_logic;                                        -- ErrControl
			o_err_contention_lp0_ck   : out std_logic;                                        -- ErrContentionLP0
			o_err_contention_lp1_ck   : out std_logic;                                        -- ErrContentionLP1
			axi4s_clk                 : in  std_logic                     := 'X';             -- clk
			axi4s_rst                 : in  std_logic                     := 'X';             -- reset
			axi4s_vid_out_0_tdata     : out std_logic_vector(63 downto 0);                    -- tdata
			axi4s_vid_out_0_tvalid    : out std_logic;                                        -- tvalid
			axi4s_vid_out_0_tready    : in  std_logic                     := 'X';             -- tready
			axi4s_vid_out_0_tlast     : out std_logic;                                        -- tlast
			axi4s_vid_out_0_tuser     : out std_logic_vector(7 downto 0);                     -- tuser
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
	end component csi2_dphy_sys_csi2_rx;

	u0 : component csi2_dphy_sys_csi2_rx
		port map (
			rx_srst_n_d0              => CONNECTED_TO_rx_srst_n_d0,              --                     d0_ppi_rx_hs_srst.reset_n
			rx_word_clk_hs_d0         => CONNECTED_TO_rx_word_clk_hs_d0,         --                         d0_ppi_hs_clk.clk
			rx_data_width_hs_d0       => CONNECTED_TO_rx_data_width_hs_d0,       --                             d0_ppi_hs.RxDataWidthHS
			rx_data_hs_d0             => CONNECTED_TO_rx_data_hs_d0,             --                                      .RxDataHS
			rx_valid_hs_d0            => CONNECTED_TO_rx_valid_hs_d0,            --                                      .RxValidHS
			rx_active_hs_d0           => CONNECTED_TO_rx_active_hs_d0,           --                                      .RxActiveHS
			rx_sync_hs_d0             => CONNECTED_TO_rx_sync_hs_d0,             --                                      .RxSyncHS
			rx_detect_eob_hs_d0       => CONNECTED_TO_rx_detect_eob_hs_d0,       --                                      .RxDetectEobHS
			rx_clk_active_hs_d0       => CONNECTED_TO_rx_clk_active_hs_d0,       --                                      .RxClkActiveHS
			rx_ddr_clk_hs_d0          => CONNECTED_TO_rx_ddr_clk_hs_d0,          --                                      .RxDDRClkHS
			rx_skew_cal_hs_d0         => CONNECTED_TO_rx_skew_cal_hs_d0,         --                                      .RxSkewCalHS
			rx_alternate_cal_hs_d0    => CONNECTED_TO_rx_alternate_cal_hs_d0,    --                                      .RxAlternateCalHS
			rx_error_cal_hs_d0        => CONNECTED_TO_rx_error_cal_hs_d0,        --                                      .RxErrorCalHS
			rx_clk_esc_d0             => CONNECTED_TO_rx_clk_esc_d0,             --                             d0_ppi_lp.RxClkEsc
			rx_lpdt_esc_d0            => CONNECTED_TO_rx_lpdt_esc_d0,            --                                      .RxLpdtEsc
			rx_ulps_esc_d0            => CONNECTED_TO_rx_ulps_esc_d0,            --                                      .RxUlpsEsc
			rx_trigger_esc_d0         => CONNECTED_TO_rx_trigger_esc_d0,         --                                      .RxTriggerEsc
			rx_wake_up_d0             => CONNECTED_TO_rx_wake_up_d0,             --                                      .RxWakeup
			rx_data_esc_d0            => CONNECTED_TO_rx_data_esc_d0,            --                                      .RxDataEsc
			rx_valid_esc_d0           => CONNECTED_TO_rx_valid_esc_d0,           --                                      .RxValidEsc
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
			i_err_sot_hs_d0           => CONNECTED_TO_i_err_sot_hs_d0,           --                       i_d0_ppi_rx_err.ErrSotHS
			i_err_sot_sync_hs_d0      => CONNECTED_TO_i_err_sot_sync_hs_d0,      --                                      .ErrSotSyncHS
			i_err_esc_d0              => CONNECTED_TO_i_err_esc_d0,              --                                      .ErrEsc
			i_err_sync_d0             => CONNECTED_TO_i_err_sync_d0,             --                                      .ErrSyncEsc
			i_err_control_d0          => CONNECTED_TO_i_err_control_d0,          --                                      .ErrControl
			i_err_contention_lp0_d0   => CONNECTED_TO_i_err_contention_lp0_d0,   --                                      .ErrContentionLP0
			i_err_contention_lp1_d0   => CONNECTED_TO_i_err_contention_lp1_d0,   --                                      .ErrContentionLP1
			o_err_sot_hs_d0           => CONNECTED_TO_o_err_sot_hs_d0,           --                       o_d0_ppi_rx_err.ErrSotHS
			o_err_sot_sync_hs_d0      => CONNECTED_TO_o_err_sot_sync_hs_d0,      --                                      .ErrSotSyncHS
			o_err_esc_d0              => CONNECTED_TO_o_err_esc_d0,              --                                      .ErrEsc
			o_err_sync_d0             => CONNECTED_TO_o_err_sync_d0,             --                                      .ErrSyncEsc
			o_err_control_d0          => CONNECTED_TO_o_err_control_d0,          --                                      .ErrControl
			o_err_contention_lp0_d0   => CONNECTED_TO_o_err_contention_lp0_d0,   --                                      .ErrContentionLP0
			o_err_contention_lp1_d0   => CONNECTED_TO_o_err_contention_lp1_d0,   --                                      .ErrContentionLP1
			rx_srst_n_d1              => CONNECTED_TO_rx_srst_n_d1,              --                     d1_ppi_rx_hs_srst.reset_n
			rx_word_clk_hs_d1         => CONNECTED_TO_rx_word_clk_hs_d1,         --                         d1_ppi_hs_clk.clk
			rx_data_width_hs_d1       => CONNECTED_TO_rx_data_width_hs_d1,       --                             d1_ppi_hs.RxDataWidthHS
			rx_data_hs_d1             => CONNECTED_TO_rx_data_hs_d1,             --                                      .RxDataHS
			rx_valid_hs_d1            => CONNECTED_TO_rx_valid_hs_d1,            --                                      .RxValidHS
			rx_active_hs_d1           => CONNECTED_TO_rx_active_hs_d1,           --                                      .RxActiveHS
			rx_sync_hs_d1             => CONNECTED_TO_rx_sync_hs_d1,             --                                      .RxSyncHS
			rx_detect_eob_hs_d1       => CONNECTED_TO_rx_detect_eob_hs_d1,       --                                      .RxDetectEobHS
			rx_clk_active_hs_d1       => CONNECTED_TO_rx_clk_active_hs_d1,       --                                      .RxClkActiveHS
			rx_ddr_clk_hs_d1          => CONNECTED_TO_rx_ddr_clk_hs_d1,          --                                      .RxDDRClkHS
			rx_skew_cal_hs_d1         => CONNECTED_TO_rx_skew_cal_hs_d1,         --                                      .RxSkewCalHS
			rx_alternate_cal_hs_d1    => CONNECTED_TO_rx_alternate_cal_hs_d1,    --                                      .RxAlternateCalHS
			rx_error_cal_hs_d1        => CONNECTED_TO_rx_error_cal_hs_d1,        --                                      .RxErrorCalHS
			rx_clk_esc_d1             => CONNECTED_TO_rx_clk_esc_d1,             --                             d1_ppi_lp.RxClkEsc
			rx_lpdt_esc_d1            => CONNECTED_TO_rx_lpdt_esc_d1,            --                                      .RxLpdtEsc
			rx_ulps_esc_d1            => CONNECTED_TO_rx_ulps_esc_d1,            --                                      .RxUlpsEsc
			rx_trigger_esc_d1         => CONNECTED_TO_rx_trigger_esc_d1,         --                                      .RxTriggerEsc
			rx_wake_up_d1             => CONNECTED_TO_rx_wake_up_d1,             --                                      .RxWakeup
			rx_data_esc_d1            => CONNECTED_TO_rx_data_esc_d1,            --                                      .RxDataEsc
			rx_valid_esc_d1           => CONNECTED_TO_rx_valid_esc_d1,           --                                      .RxValidEsc
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
			i_err_sot_hs_d1           => CONNECTED_TO_i_err_sot_hs_d1,           --                       i_d1_ppi_rx_err.ErrSotHS
			i_err_sot_sync_hs_d1      => CONNECTED_TO_i_err_sot_sync_hs_d1,      --                                      .ErrSotSyncHS
			i_err_esc_d1              => CONNECTED_TO_i_err_esc_d1,              --                                      .ErrEsc
			i_err_sync_d1             => CONNECTED_TO_i_err_sync_d1,             --                                      .ErrSyncEsc
			i_err_control_d1          => CONNECTED_TO_i_err_control_d1,          --                                      .ErrControl
			i_err_contention_lp0_d1   => CONNECTED_TO_i_err_contention_lp0_d1,   --                                      .ErrContentionLP0
			i_err_contention_lp1_d1   => CONNECTED_TO_i_err_contention_lp1_d1,   --                                      .ErrContentionLP1
			o_err_sot_hs_d1           => CONNECTED_TO_o_err_sot_hs_d1,           --                       o_d1_ppi_rx_err.ErrSotHS
			o_err_sot_sync_hs_d1      => CONNECTED_TO_o_err_sot_sync_hs_d1,      --                                      .ErrSotSyncHS
			o_err_esc_d1              => CONNECTED_TO_o_err_esc_d1,              --                                      .ErrEsc
			o_err_sync_d1             => CONNECTED_TO_o_err_sync_d1,             --                                      .ErrSyncEsc
			o_err_control_d1          => CONNECTED_TO_o_err_control_d1,          --                                      .ErrControl
			o_err_contention_lp0_d1   => CONNECTED_TO_o_err_contention_lp0_d1,   --                                      .ErrContentionLP0
			o_err_contention_lp1_d1   => CONNECTED_TO_o_err_contention_lp1_d1,   --                                      .ErrContentionLP1
			rx_srst_n_ck              => CONNECTED_TO_rx_srst_n_ck,              --                     ck_ppi_rx_hs_srst.reset_n
			rx_word_clk_hs_ck         => CONNECTED_TO_rx_word_clk_hs_ck,         --                         ck_ppi_hs_clk.clk
			rx_data_width_hs_ck       => CONNECTED_TO_rx_data_width_hs_ck,       --                             ck_ppi_hs.RxDataWidthHS
			rx_data_hs_ck             => CONNECTED_TO_rx_data_hs_ck,             --                                      .RxDataHS
			rx_valid_hs_ck            => CONNECTED_TO_rx_valid_hs_ck,            --                                      .RxValidHS
			rx_active_hs_ck           => CONNECTED_TO_rx_active_hs_ck,           --                                      .RxActiveHS
			rx_sync_hs_ck             => CONNECTED_TO_rx_sync_hs_ck,             --                                      .RxSyncHS
			rx_detect_eob_hs_ck       => CONNECTED_TO_rx_detect_eob_hs_ck,       --                                      .RxDetectEobHS
			rx_clk_active_hs_ck       => CONNECTED_TO_rx_clk_active_hs_ck,       --                                      .RxClkActiveHS
			rx_ddr_clk_hs_ck          => CONNECTED_TO_rx_ddr_clk_hs_ck,          --                                      .RxDDRClkHS
			rx_skew_cal_hs_ck         => CONNECTED_TO_rx_skew_cal_hs_ck,         --                                      .RxSkewCalHS
			rx_alternate_cal_hs_ck    => CONNECTED_TO_rx_alternate_cal_hs_ck,    --                                      .RxAlternateCalHS
			rx_error_cal_hs_ck        => CONNECTED_TO_rx_error_cal_hs_ck,        --                                      .RxErrorCalHS
			rx_clk_esc_ck             => CONNECTED_TO_rx_clk_esc_ck,             --                             ck_ppi_lp.RxClkEsc
			rx_lpdt_esc_ck            => CONNECTED_TO_rx_lpdt_esc_ck,            --                                      .RxLpdtEsc
			rx_ulps_esc_ck            => CONNECTED_TO_rx_ulps_esc_ck,            --                                      .RxUlpsEsc
			rx_trigger_esc_ck         => CONNECTED_TO_rx_trigger_esc_ck,         --                                      .RxTriggerEsc
			rx_wake_up_ck             => CONNECTED_TO_rx_wake_up_ck,             --                                      .RxWakeup
			rx_data_esc_ck            => CONNECTED_TO_rx_data_esc_ck,            --                                      .RxDataEsc
			rx_valid_esc_ck           => CONNECTED_TO_rx_valid_esc_ck,           --                                      .RxValidEsc
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
			i_err_sot_hs_ck           => CONNECTED_TO_i_err_sot_hs_ck,           --                       i_ck_ppi_rx_err.ErrSotHS
			i_err_sot_sync_hs_ck      => CONNECTED_TO_i_err_sot_sync_hs_ck,      --                                      .ErrSotSyncHS
			i_err_esc_ck              => CONNECTED_TO_i_err_esc_ck,              --                                      .ErrEsc
			i_err_sync_ck             => CONNECTED_TO_i_err_sync_ck,             --                                      .ErrSyncEsc
			i_err_control_ck          => CONNECTED_TO_i_err_control_ck,          --                                      .ErrControl
			i_err_contention_lp0_ck   => CONNECTED_TO_i_err_contention_lp0_ck,   --                                      .ErrContentionLP0
			i_err_contention_lp1_ck   => CONNECTED_TO_i_err_contention_lp1_ck,   --                                      .ErrContentionLP1
			o_err_sot_hs_ck           => CONNECTED_TO_o_err_sot_hs_ck,           --                       o_ck_ppi_rx_err.ErrSotHS
			o_err_sot_sync_hs_ck      => CONNECTED_TO_o_err_sot_sync_hs_ck,      --                                      .ErrSotSyncHS
			o_err_esc_ck              => CONNECTED_TO_o_err_esc_ck,              --                                      .ErrEsc
			o_err_sync_ck             => CONNECTED_TO_o_err_sync_ck,             --                                      .ErrSyncEsc
			o_err_control_ck          => CONNECTED_TO_o_err_control_ck,          --                                      .ErrControl
			o_err_contention_lp0_ck   => CONNECTED_TO_o_err_contention_lp0_ck,   --                                      .ErrContentionLP0
			o_err_contention_lp1_ck   => CONNECTED_TO_o_err_contention_lp1_ck,   --                                      .ErrContentionLP1
			axi4s_clk                 => CONNECTED_TO_axi4s_clk,                 --                             axi4s_clk.clk
			axi4s_rst                 => CONNECTED_TO_axi4s_rst,                 --                             axi4s_rst.reset
			axi4s_vid_out_0_tdata     => CONNECTED_TO_axi4s_vid_out_0_tdata,     --           video_streaming_interface_0.tdata
			axi4s_vid_out_0_tvalid    => CONNECTED_TO_axi4s_vid_out_0_tvalid,    --                                      .tvalid
			axi4s_vid_out_0_tready    => CONNECTED_TO_axi4s_vid_out_0_tready,    --                                      .tready
			axi4s_vid_out_0_tlast     => CONNECTED_TO_axi4s_vid_out_0_tlast,     --                                      .tlast
			axi4s_vid_out_0_tuser     => CONNECTED_TO_axi4s_vid_out_0_tuser,     --                                      .tuser
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

