module csi2_dphy_sys_csi2_rx (
		input  wire        rx_srst_n_d0,              //                     d0_ppi_rx_hs_srst.reset_n,            PPI lane d0 reset for Tx HS clock.  Connect to DPHY IP.
		input  wire        rx_word_clk_hs_d0,         //                         d0_ppi_hs_clk.clk,                PPI lane d0 Tx HS word clock.  Connect to DPHY IP.
		output wire [1:0]  rx_data_width_hs_d0,       //                             d0_ppi_hs.RxDataWidthHS,      PPI lane d0 Rx HS data width. Connect to DPHY IP.
		input  wire [15:0] rx_data_hs_d0,             //                                      .RxDataHS,           PPI lane d0 Rx HS data. Connect to DPHY IP.
		input  wire [1:0]  rx_valid_hs_d0,            //                                      .RxValidHS,          PPI lane d0 Rx HS data word valid. Connect to DPHY IP.
		input  wire        rx_active_hs_d0,           //                                      .RxActiveHS,         PPI lane d0 Rx HS active. Connect to DPHY IP.
		input  wire        rx_sync_hs_d0,             //                                      .RxSyncHS,           PPI lane d0 Rx HS sync. Connect to DPHY IP.
		output wire        rx_detect_eob_hs_d0,       //                                      .RxDetectEobHS,      PPI lane d0 Rx HS end-of-burst detected. Connect to DPHY IP.
		input  wire        rx_clk_active_hs_d0,       //                                      .RxClkActiveHS,      PPI lane d0 Rx HS clock active. Connect to DPHY IP.
		input  wire        rx_ddr_clk_hs_d0,          //                                      .RxDDRClkHS,         PPI lane d0 Rx HS DDR clock as received. Connect to DPHY IP.
		input  wire        rx_skew_cal_hs_d0,         //                                      .RxSkewCalHS,        PPI lane d0 Rx HS skew calibration active. Connect to DPHY IP.
		input  wire        rx_alternate_cal_hs_d0,    //                                      .RxAlternateCalHS,   PPI lane d0 Rx HS alternate calibration active. Connect to DPHY IP.
		input  wire        rx_error_cal_hs_d0,        //                                      .RxErrorCalHS,       PPI lane d0 Rx HS calibration error detected. Connect to DPHY IP.
		input  wire        rx_clk_esc_d0,             //                             d0_ppi_lp.RxClkEsc,           PPI lane d0 Rx escape clock. Connect to DPHY IP.
		input  wire        rx_lpdt_esc_d0,            //                                      .RxLpdtEsc,          PPI lane d0 Rx escape LP data active. Connect to DPHY IP.
		input  wire        rx_ulps_esc_d0,            //                                      .RxUlpsEsc,          PPI lane d0 Rx ultra-low power state. Connect to DPHY IP.
		input  wire [3:0]  rx_trigger_esc_d0,         //                                      .RxTriggerEsc,       PPI lane d0 Rx event triggered. Connect to DPHY IP.
		input  wire        rx_wake_up_d0,             //                                      .RxWakeup,           PPI lane d0 Rx wakeup pulse detected. Connect to DPHY IP.
		input  wire [7:0]  rx_data_esc_d0,            //                                      .RxDataEsc,          PPI lane d0 Rx escape mode data. Connect to DPHY IP.
		input  wire        rx_valid_esc_d0,           //                                      .RxValidEsc,         PPI lane d0 Rx escape mode data valid. Connect to DPHY IP.
		output wire        turn_request_d0,           //                           d0_ppi_ctrl.TurnRequest,        PPI lane d0 turnaround request. Connect to DPHY IP.
		input  wire        direction_d0,              //                                      .Direction,          PPI lane d0 direction. Connect to DPHY IP.
		output wire        turn_disable_d0,           //                                      .TurnDisable,        PPI lane d0 disable turnaround. Connect to DPHY IP.
		output wire        force_rx_mode_d0,          //                                      .ForceRxmode,        PPI lane d0 force to Rx mode. Connect to DPHY IP.
		output wire        force_tx_stop_mode_d0,     //                                      .ForceTxStopmode,    PPI lane d0 force to Tx stop mode. Connect to DPHY IP.
		input  wire        stop_state_d0,             //                                      .Stopstate,          PPI lane d0 lane is in stop state. Connect to DPHY IP.
		output wire        enable_d0,                 //                                      .Enable,             PPI lane d0 enable. Connect to DPHY IP.
		output wire        alp_mode_d0,               //                                      .AlpMode,            PPI lane d0 ALP mode selected. Connect to DPHY IP.
		output wire        tx_ulps_clk_d0,            //                                      .TxUlpsClk,          PPI lane d0 force Tx clock lane into ULPS. Connect to DPHY IP.
		input  wire        rx_ulps_clk_not_d0,        //                                      .RxUlpsClkNot,       PPI lane d0 Rx clock lane is in ULPS. Connect to DPHY IP.
		input  wire        ulps_active_not_d0,        //                                      .UlpsActiveNot,      PPI lane d0 ULPS inactive. Connect to DPHY IP.
		output wire        tx_hsidle_clk_hs_d0,       //                                      .TxHSIdleClkHS,      PPI lane d0 initiate HS idle. Connect to DPHY IP.
		input  wire        tx_hsidle_clk_ready_hs_d0, //                                      .TxHSIdleClkReadyHS, PPI lane d0 ready for HS idle initiation. Connect to DPHY IP.
		input  wire        i_err_sot_hs_d0,           //                       i_d0_ppi_rx_err.ErrSotHS,           PPI lane d0 input DPHY Rx error flag ErrSotHS.  Connect to DPHY IP.
		input  wire        i_err_sot_sync_hs_d0,      //                                      .ErrSotSyncHS,       PPI lane d0 input DPHY Rx error flag ErrSotSyncHS.  Connect to DPHY IP.
		input  wire        i_err_esc_d0,              //                                      .ErrEsc,             PPI lane d0 input DPHY Rx error flag ErrEsc.  Connect to DPHY IP.
		input  wire        i_err_sync_d0,             //                                      .ErrSyncEsc,         PPI lane d0 input DPHY Rx error flag ErrSyncEsc.  Connect to DPHY IP.
		input  wire        i_err_control_d0,          //                                      .ErrControl,         PPI lane d0 input DPHY Rx error flag ErrControl.  Connect to DPHY IP.
		input  wire        i_err_contention_lp0_d0,   //                                      .ErrContentionLP0,   PPI lane d0 input DPHY Rx error flag ErrContentionLP0.  Connect to DPHY IP.
		input  wire        i_err_contention_lp1_d0,   //                                      .ErrContentionLP1,   PPI lane d0 input DPHY Rx error flag ErrContentionLP1.  Connect to DPHY IP.
		output wire        o_err_sot_hs_d0,           //                       o_d0_ppi_rx_err.ErrSotHS,           PPI lane d0 passthrough DPHY Rx error flag ErrSotHS.
		output wire        o_err_sot_sync_hs_d0,      //                                      .ErrSotSyncHS,       PPI lane d0 passthrough DPHY Rx error flag ErrSotSyncHS.
		output wire        o_err_esc_d0,              //                                      .ErrEsc,             PPI lane d0 passthrough DPHY Rx error flag ErrEsc.
		output wire        o_err_sync_d0,             //                                      .ErrSyncEsc,         PPI lane d0 passthrough DPHY Rx error flag ErrSyncEsc.
		output wire        o_err_control_d0,          //                                      .ErrControl,         PPI lane d0 passthrough DPHY Rx error flag ErrControl.
		output wire        o_err_contention_lp0_d0,   //                                      .ErrContentionLP0,   PPI lane d0 passthrough DPHY Rx error flag ErrContentionLP0.
		output wire        o_err_contention_lp1_d0,   //                                      .ErrContentionLP1,   PPI lane d0 passthrough DPHY Rx error flag ErrContentionLP1.
		input  wire        rx_srst_n_d1,              //                     d1_ppi_rx_hs_srst.reset_n,            PPI lane d1 reset for Tx HS clock.  Connect to DPHY IP.
		input  wire        rx_word_clk_hs_d1,         //                         d1_ppi_hs_clk.clk,                PPI lane d1 Tx HS word clock.  Connect to DPHY IP.
		output wire [1:0]  rx_data_width_hs_d1,       //                             d1_ppi_hs.RxDataWidthHS,      PPI lane d1 Rx HS data width. Connect to DPHY IP.
		input  wire [15:0] rx_data_hs_d1,             //                                      .RxDataHS,           PPI lane d1 Rx HS data. Connect to DPHY IP.
		input  wire [1:0]  rx_valid_hs_d1,            //                                      .RxValidHS,          PPI lane d1 Rx HS data word valid. Connect to DPHY IP.
		input  wire        rx_active_hs_d1,           //                                      .RxActiveHS,         PPI lane d1 Rx HS active. Connect to DPHY IP.
		input  wire        rx_sync_hs_d1,             //                                      .RxSyncHS,           PPI lane d1 Rx HS sync. Connect to DPHY IP.
		output wire        rx_detect_eob_hs_d1,       //                                      .RxDetectEobHS,      PPI lane d1 Rx HS end-of-burst detected. Connect to DPHY IP.
		input  wire        rx_clk_active_hs_d1,       //                                      .RxClkActiveHS,      PPI lane d1 Rx HS clock active. Connect to DPHY IP.
		input  wire        rx_ddr_clk_hs_d1,          //                                      .RxDDRClkHS,         PPI lane d1 Rx HS DDR clock as received. Connect to DPHY IP.
		input  wire        rx_skew_cal_hs_d1,         //                                      .RxSkewCalHS,        PPI lane d1 Rx HS skew calibration active. Connect to DPHY IP.
		input  wire        rx_alternate_cal_hs_d1,    //                                      .RxAlternateCalHS,   PPI lane d1 Rx HS alternate calibration active. Connect to DPHY IP.
		input  wire        rx_error_cal_hs_d1,        //                                      .RxErrorCalHS,       PPI lane d1 Rx HS calibration error detected. Connect to DPHY IP.
		input  wire        rx_clk_esc_d1,             //                             d1_ppi_lp.RxClkEsc,           PPI lane d1 Rx escape clock. Connect to DPHY IP.
		input  wire        rx_lpdt_esc_d1,            //                                      .RxLpdtEsc,          PPI lane d1 Rx escape LP data active. Connect to DPHY IP.
		input  wire        rx_ulps_esc_d1,            //                                      .RxUlpsEsc,          PPI lane d1 Rx ultra-low power state. Connect to DPHY IP.
		input  wire [3:0]  rx_trigger_esc_d1,         //                                      .RxTriggerEsc,       PPI lane d1 Rx event triggered. Connect to DPHY IP.
		input  wire        rx_wake_up_d1,             //                                      .RxWakeup,           PPI lane d1 Rx wakeup pulse detected. Connect to DPHY IP.
		input  wire [7:0]  rx_data_esc_d1,            //                                      .RxDataEsc,          PPI lane d1 Rx escape mode data. Connect to DPHY IP.
		input  wire        rx_valid_esc_d1,           //                                      .RxValidEsc,         PPI lane d1 Rx escape mode data valid. Connect to DPHY IP.
		output wire        turn_request_d1,           //                           d1_ppi_ctrl.TurnRequest,        PPI lane d1 turnaround request. Connect to DPHY IP.
		input  wire        direction_d1,              //                                      .Direction,          PPI lane d1 direction. Connect to DPHY IP.
		output wire        turn_disable_d1,           //                                      .TurnDisable,        PPI lane d1 disable turnaround. Connect to DPHY IP.
		output wire        force_rx_mode_d1,          //                                      .ForceRxmode,        PPI lane d1 force to Rx mode. Connect to DPHY IP.
		output wire        force_tx_stop_mode_d1,     //                                      .ForceTxStopmode,    PPI lane d1 force to Tx stop mode. Connect to DPHY IP.
		input  wire        stop_state_d1,             //                                      .Stopstate,          PPI lane d1 lane is in stop state. Connect to DPHY IP.
		output wire        enable_d1,                 //                                      .Enable,             PPI lane d1 enable. Connect to DPHY IP.
		output wire        alp_mode_d1,               //                                      .AlpMode,            PPI lane d1 ALP mode selected. Connect to DPHY IP.
		output wire        tx_ulps_clk_d1,            //                                      .TxUlpsClk,          PPI lane d1 force Tx clock lane into ULPS. Connect to DPHY IP.
		input  wire        rx_ulps_clk_not_d1,        //                                      .RxUlpsClkNot,       PPI lane d1 Rx clock lane is in ULPS. Connect to DPHY IP.
		input  wire        ulps_active_not_d1,        //                                      .UlpsActiveNot,      PPI lane d1 ULPS inactive. Connect to DPHY IP.
		output wire        tx_hsidle_clk_hs_d1,       //                                      .TxHSIdleClkHS,      PPI lane d1 initiate HS idle. Connect to DPHY IP.
		input  wire        tx_hsidle_clk_ready_hs_d1, //                                      .TxHSIdleClkReadyHS, PPI lane d1 ready for HS idle initiation. Connect to DPHY IP.
		input  wire        i_err_sot_hs_d1,           //                       i_d1_ppi_rx_err.ErrSotHS,           PPI lane d1 input DPHY Rx error flag ErrSotHS.  Connect to DPHY IP.
		input  wire        i_err_sot_sync_hs_d1,      //                                      .ErrSotSyncHS,       PPI lane d1 input DPHY Rx error flag ErrSotSyncHS.  Connect to DPHY IP.
		input  wire        i_err_esc_d1,              //                                      .ErrEsc,             PPI lane d1 input DPHY Rx error flag ErrEsc.  Connect to DPHY IP.
		input  wire        i_err_sync_d1,             //                                      .ErrSyncEsc,         PPI lane d1 input DPHY Rx error flag ErrSyncEsc.  Connect to DPHY IP.
		input  wire        i_err_control_d1,          //                                      .ErrControl,         PPI lane d1 input DPHY Rx error flag ErrControl.  Connect to DPHY IP.
		input  wire        i_err_contention_lp0_d1,   //                                      .ErrContentionLP0,   PPI lane d1 input DPHY Rx error flag ErrContentionLP0.  Connect to DPHY IP.
		input  wire        i_err_contention_lp1_d1,   //                                      .ErrContentionLP1,   PPI lane d1 input DPHY Rx error flag ErrContentionLP1.  Connect to DPHY IP.
		output wire        o_err_sot_hs_d1,           //                       o_d1_ppi_rx_err.ErrSotHS,           PPI lane d1 passthrough DPHY Rx error flag ErrSotHS.
		output wire        o_err_sot_sync_hs_d1,      //                                      .ErrSotSyncHS,       PPI lane d1 passthrough DPHY Rx error flag ErrSotSyncHS.
		output wire        o_err_esc_d1,              //                                      .ErrEsc,             PPI lane d1 passthrough DPHY Rx error flag ErrEsc.
		output wire        o_err_sync_d1,             //                                      .ErrSyncEsc,         PPI lane d1 passthrough DPHY Rx error flag ErrSyncEsc.
		output wire        o_err_control_d1,          //                                      .ErrControl,         PPI lane d1 passthrough DPHY Rx error flag ErrControl.
		output wire        o_err_contention_lp0_d1,   //                                      .ErrContentionLP0,   PPI lane d1 passthrough DPHY Rx error flag ErrContentionLP0.
		output wire        o_err_contention_lp1_d1,   //                                      .ErrContentionLP1,   PPI lane d1 passthrough DPHY Rx error flag ErrContentionLP1.
		input  wire        rx_srst_n_ck,              //                     ck_ppi_rx_hs_srst.reset_n,            PPI lane ck reset for Tx HS clock.  Connect to DPHY IP.
		input  wire        rx_word_clk_hs_ck,         //                         ck_ppi_hs_clk.clk,                PPI lane ck Tx HS word clock.  Connect to DPHY IP.
		output wire [1:0]  rx_data_width_hs_ck,       //                             ck_ppi_hs.RxDataWidthHS,      PPI lane ck Rx HS data width. Connect to DPHY IP.
		input  wire [15:0] rx_data_hs_ck,             //                                      .RxDataHS,           PPI lane ck Rx HS data. Connect to DPHY IP.
		input  wire [1:0]  rx_valid_hs_ck,            //                                      .RxValidHS,          PPI lane ck Rx HS data word valid. Connect to DPHY IP.
		input  wire        rx_active_hs_ck,           //                                      .RxActiveHS,         PPI lane ck Rx HS active. Connect to DPHY IP.
		input  wire        rx_sync_hs_ck,             //                                      .RxSyncHS,           PPI lane ck Rx HS sync. Connect to DPHY IP.
		output wire        rx_detect_eob_hs_ck,       //                                      .RxDetectEobHS,      PPI lane ck Rx HS end-of-burst detected. Connect to DPHY IP.
		input  wire        rx_clk_active_hs_ck,       //                                      .RxClkActiveHS,      PPI lane ck Rx HS clock active. Connect to DPHY IP.
		input  wire        rx_ddr_clk_hs_ck,          //                                      .RxDDRClkHS,         PPI lane ck Rx HS DDR clock as received. Connect to DPHY IP.
		input  wire        rx_skew_cal_hs_ck,         //                                      .RxSkewCalHS,        PPI lane ck Rx HS skew calibration active. Connect to DPHY IP.
		input  wire        rx_alternate_cal_hs_ck,    //                                      .RxAlternateCalHS,   PPI lane ck Rx HS alternate calibration active. Connect to DPHY IP.
		input  wire        rx_error_cal_hs_ck,        //                                      .RxErrorCalHS,       PPI lane ck Rx HS calibration error detected. Connect to DPHY IP.
		input  wire        rx_clk_esc_ck,             //                             ck_ppi_lp.RxClkEsc,           PPI lane ck Rx escape clock. Connect to DPHY IP.
		input  wire        rx_lpdt_esc_ck,            //                                      .RxLpdtEsc,          PPI lane ck Rx escape LP data active. Connect to DPHY IP.
		input  wire        rx_ulps_esc_ck,            //                                      .RxUlpsEsc,          PPI lane ck Rx ultra-low power state. Connect to DPHY IP.
		input  wire [3:0]  rx_trigger_esc_ck,         //                                      .RxTriggerEsc,       PPI lane ck Rx event triggered. Connect to DPHY IP.
		input  wire        rx_wake_up_ck,             //                                      .RxWakeup,           PPI lane ck Rx wakeup pulse detected. Connect to DPHY IP.
		input  wire [7:0]  rx_data_esc_ck,            //                                      .RxDataEsc,          PPI lane ck Rx escape mode data. Connect to DPHY IP.
		input  wire        rx_valid_esc_ck,           //                                      .RxValidEsc,         PPI lane ck Rx escape mode data valid. Connect to DPHY IP.
		output wire        turn_request_ck,           //                           ck_ppi_ctrl.TurnRequest,        PPI lane ck turnaround request. Connect to DPHY IP.
		input  wire        direction_ck,              //                                      .Direction,          PPI lane ck direction. Connect to DPHY IP.
		output wire        turn_disable_ck,           //                                      .TurnDisable,        PPI lane ck disable turnaround. Connect to DPHY IP.
		output wire        force_rx_mode_ck,          //                                      .ForceRxmode,        PPI lane ck force to Rx mode. Connect to DPHY IP.
		output wire        force_tx_stop_mode_ck,     //                                      .ForceTxStopmode,    PPI lane ck force to Tx stop mode. Connect to DPHY IP.
		input  wire        stop_state_ck,             //                                      .Stopstate,          PPI lane ck lane is in stop state. Connect to DPHY IP.
		output wire        enable_ck,                 //                                      .Enable,             PPI lane ck enable. Connect to DPHY IP.
		output wire        alp_mode_ck,               //                                      .AlpMode,            PPI lane ck ALP mode selected. Connect to DPHY IP.
		output wire        tx_ulps_clk_ck,            //                                      .TxUlpsClk,          PPI lane ck force Tx clock lane into ULPS. Connect to DPHY IP.
		input  wire        rx_ulps_clk_not_ck,        //                                      .RxUlpsClkNot,       PPI lane ck Rx clock lane is in ULPS. Connect to DPHY IP.
		input  wire        ulps_active_not_ck,        //                                      .UlpsActiveNot,      PPI lane ck ULPS inactive. Connect to DPHY IP.
		output wire        tx_hsidle_clk_hs_ck,       //                                      .TxHSIdleClkHS,      PPI lane ck initiate HS idle. Connect to DPHY IP.
		input  wire        tx_hsidle_clk_ready_hs_ck, //                                      .TxHSIdleClkReadyHS, PPI lane ck ready for HS idle initiation. Connect to DPHY IP.
		input  wire        i_err_sot_hs_ck,           //                       i_ck_ppi_rx_err.ErrSotHS,           PPI lane ck input DPHY Rx error flag ErrSotHS.  Connect to DPHY IP.
		input  wire        i_err_sot_sync_hs_ck,      //                                      .ErrSotSyncHS,       PPI lane ck input DPHY Rx error flag ErrSotSyncHS.  Connect to DPHY IP.
		input  wire        i_err_esc_ck,              //                                      .ErrEsc,             PPI lane ck input DPHY Rx error flag ErrEsc.  Connect to DPHY IP.
		input  wire        i_err_sync_ck,             //                                      .ErrSyncEsc,         PPI lane ck input DPHY Rx error flag ErrSyncEsc.  Connect to DPHY IP.
		input  wire        i_err_control_ck,          //                                      .ErrControl,         PPI lane ck input DPHY Rx error flag ErrControl.  Connect to DPHY IP.
		input  wire        i_err_contention_lp0_ck,   //                                      .ErrContentionLP0,   PPI lane ck input DPHY Rx error flag ErrContentionLP0.  Connect to DPHY IP.
		input  wire        i_err_contention_lp1_ck,   //                                      .ErrContentionLP1,   PPI lane ck input DPHY Rx error flag ErrContentionLP1.  Connect to DPHY IP.
		output wire        o_err_sot_hs_ck,           //                       o_ck_ppi_rx_err.ErrSotHS,           PPI lane ck passthrough DPHY Rx error flag ErrSotHS.
		output wire        o_err_sot_sync_hs_ck,      //                                      .ErrSotSyncHS,       PPI lane ck passthrough DPHY Rx error flag ErrSotSyncHS.
		output wire        o_err_esc_ck,              //                                      .ErrEsc,             PPI lane ck passthrough DPHY Rx error flag ErrEsc.
		output wire        o_err_sync_ck,             //                                      .ErrSyncEsc,         PPI lane ck passthrough DPHY Rx error flag ErrSyncEsc.
		output wire        o_err_control_ck,          //                                      .ErrControl,         PPI lane ck passthrough DPHY Rx error flag ErrControl.
		output wire        o_err_contention_lp0_ck,   //                                      .ErrContentionLP0,   PPI lane ck passthrough DPHY Rx error flag ErrContentionLP0.
		output wire        o_err_contention_lp1_ck,   //                                      .ErrContentionLP1,   PPI lane ck passthrough DPHY Rx error flag ErrContentionLP1.
		input  wire        axi4s_clk,                 //                             axi4s_clk.clk,                Clock used for video streaming and control interfaces.  Refer to the user guide for detailed restrictions on the rate of this clock depending on configuration.
		input  wire        axi4s_rst,                 //                             axi4s_rst.reset,              Reset for axi4s_clk domain.
		output wire [63:0] axi4s_vid_out_0_tdata,     //           video_streaming_interface_0.tdata,              Rx video channel 0 pixel data.  See the Intel FPGA Streaming Video Protocol specification for details.
		output wire        axi4s_vid_out_0_tvalid,    //                                      .tvalid,             Rx video channel 0 data valid.
		input  wire        axi4s_vid_out_0_tready,    //                                      .tready,             Rx video channel 0 TREADY.
		output wire        axi4s_vid_out_0_tlast,     //                                      .tlast,              Rx video channel 0 TLAST.
		output wire [7:0]  axi4s_vid_out_0_tuser,     //                                      .tuser,              Rx video channel 0 TUSER.
		input  wire        control_write,             //           avalon_mm_control_interface.write,              Write
		input  wire        control_read,              //                                      .read,               Read
		input  wire [9:0]  control_address,           //                                      .address,            Address
		input  wire [31:0] control_writedata,         //                                      .writedata,          Write data
		output wire [31:0] control_readdata,          //                                      .readdata,           Read data
		output wire        control_readdatavalid,     //                                      .readdatavalid,      Read data valid
		output wire        control_waitrequest,       //                                      .waitrequest,        Wait request
		input  wire [3:0]  control_byteenable,        //                                      .byteenable,         Byte enable
		output wire        control_irq                // avalon_mm_control_interface_interrupt.irq,                Interrupt request
	);
endmodule

