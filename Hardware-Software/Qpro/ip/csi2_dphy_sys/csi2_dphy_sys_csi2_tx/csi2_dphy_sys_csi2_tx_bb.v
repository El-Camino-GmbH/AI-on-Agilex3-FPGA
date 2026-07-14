module csi2_dphy_sys_csi2_tx (
		input  wire        tx_word_clk_hs_d0,         //                         d0_ppi_hs_clk.clk,                PPI lane d0 Tx HS word clock.  Connect to DPHY IP.
		output wire [1:0]  tx_data_width_hs_d0,       //                             d0_ppi_hs.TxDataWidthHS,      PPI lane d0 Tx HS data width. Connect to DPHY IP.
		output wire [15:0] tx_data_hs_d0,             //                                      .TxDataHS,           PPI lane d0 Tx HS data. Connect to DPHY IP.
		output wire [1:0]  tx_word_valid_hs_d0,       //                                      .TxWordValidHS,      PPI lane d0 Tx HS data word valid. Connect to DPHY IP.
		output wire        tx_eq_active_hs_d0,        //                                      .TxEqActiveHS,       PPI lane d0 Tx HS equalization active. Connect to DPHY IP.
		output wire        tx_eq_level_hs_d0,         //                                      .TxEqLevelHS,        PPI lane d0 Tx HS equalization level indicator. Connect to DPHY IP.
		output wire        tx_request_hs_d0,          //                                      .TxRequestHS,        PPI lane d0 Tx HS request. Connect to DPHY IP.
		input  wire        tx_ready_hs_d0,            //                                      .TxReadyHS,          PPI lane d0 Tx HS ready. Connect to DPHY IP.
		output wire        tx_data_transfer_en_hs_d0, //                                      .TxDataTransferEnHS, PPI lane d0 Tx HS data transfer enable. Connect to DPHY IP.
		output wire        tx_skew_cal_hs_d0,         //                                      .TxSkewCalHS,        PPI lane d0 Tx HS skew calibration initiate. Connect to DPHY IP.
		output wire        tx_alternate_cal_hs_d0,    //                                      .TxAlternateCalHS,   PPI lane d0 Tx HS alternate calibration initiate. Connect to DPHY IP.
		output wire        tx_request_esc_d0,         //                             d0_ppi_lp.TxRequestEsc,       PPI lane d0 Tx escape request. Connect to DPHY IP.
		output wire [3:0]  tx_request_type_esc_d0,    //                                      .TxRequestTypeEsc,   PPI lane d0 Tx escape request type. Connect to DPHY IP.
		output wire        tx_lpdt_esc_d0,            //                                      .TxLpdtEsc,          PPI lane d0 Tx escape LP data active. Connect to DPHY IP.
		output wire        tx_ulps_exit_d0,           //                                      .TxUlpsExit,         PPI lane d0 Tx ultra-low power state exit request. Connect to DPHY IP.
		output wire        tx_ulps_esc_d0,            //                                      .TxUlpsEsc,          PPI lane d0 Tx ultra-low power state entry request. Connect to DPHY IP.
		output wire [3:0]  tx_trigger_esc_d0,         //                                      .TxTriggerEsc,       PPI lane d0 Tx event trigger. Connect to DPHY IP.
		output wire [7:0]  tx_data_esc_d0,            //                                      .TxDataEsc,          PPI lane d0 Tx escape mode data. Connect to DPHY IP.
		output wire        tx_valid_esc_d0,           //                                      .TxValidEsc,         PPI lane d0 Tx escape mode data valid. Connect to DPHY IP.
		input  wire        tx_ready_esc_d0,           //                                      .TxReadyEsc,         PPI lane d0 Tx escape ready. Connect to DPHY IP.
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
		input  wire        tx_clk_esc_d0,             //                      d0_ppi_tx_lp_clk.clk,                PPI lane d0 clock for Tx LP.  Connect to DPHY IP.
		input  wire        tx_word_clk_hs_d1,         //                         d1_ppi_hs_clk.clk,                PPI lane d1 Tx HS word clock.  Connect to DPHY IP.
		output wire [1:0]  tx_data_width_hs_d1,       //                             d1_ppi_hs.TxDataWidthHS,      PPI lane d1 Tx HS data width. Connect to DPHY IP.
		output wire [15:0] tx_data_hs_d1,             //                                      .TxDataHS,           PPI lane d1 Tx HS data. Connect to DPHY IP.
		output wire [1:0]  tx_word_valid_hs_d1,       //                                      .TxWordValidHS,      PPI lane d1 Tx HS data word valid. Connect to DPHY IP.
		output wire        tx_eq_active_hs_d1,        //                                      .TxEqActiveHS,       PPI lane d1 Tx HS equalization active. Connect to DPHY IP.
		output wire        tx_eq_level_hs_d1,         //                                      .TxEqLevelHS,        PPI lane d1 Tx HS equalization level indicator. Connect to DPHY IP.
		output wire        tx_request_hs_d1,          //                                      .TxRequestHS,        PPI lane d1 Tx HS request. Connect to DPHY IP.
		input  wire        tx_ready_hs_d1,            //                                      .TxReadyHS,          PPI lane d1 Tx HS ready. Connect to DPHY IP.
		output wire        tx_data_transfer_en_hs_d1, //                                      .TxDataTransferEnHS, PPI lane d1 Tx HS data transfer enable. Connect to DPHY IP.
		output wire        tx_skew_cal_hs_d1,         //                                      .TxSkewCalHS,        PPI lane d1 Tx HS skew calibration initiate. Connect to DPHY IP.
		output wire        tx_alternate_cal_hs_d1,    //                                      .TxAlternateCalHS,   PPI lane d1 Tx HS alternate calibration initiate. Connect to DPHY IP.
		output wire        tx_request_esc_d1,         //                             d1_ppi_lp.TxRequestEsc,       PPI lane d1 Tx escape request. Connect to DPHY IP.
		output wire [3:0]  tx_request_type_esc_d1,    //                                      .TxRequestTypeEsc,   PPI lane d1 Tx escape request type. Connect to DPHY IP.
		output wire        tx_lpdt_esc_d1,            //                                      .TxLpdtEsc,          PPI lane d1 Tx escape LP data active. Connect to DPHY IP.
		output wire        tx_ulps_exit_d1,           //                                      .TxUlpsExit,         PPI lane d1 Tx ultra-low power state exit request. Connect to DPHY IP.
		output wire        tx_ulps_esc_d1,            //                                      .TxUlpsEsc,          PPI lane d1 Tx ultra-low power state entry request. Connect to DPHY IP.
		output wire [3:0]  tx_trigger_esc_d1,         //                                      .TxTriggerEsc,       PPI lane d1 Tx event trigger. Connect to DPHY IP.
		output wire [7:0]  tx_data_esc_d1,            //                                      .TxDataEsc,          PPI lane d1 Tx escape mode data. Connect to DPHY IP.
		output wire        tx_valid_esc_d1,           //                                      .TxValidEsc,         PPI lane d1 Tx escape mode data valid. Connect to DPHY IP.
		input  wire        tx_ready_esc_d1,           //                                      .TxReadyEsc,         PPI lane d1 Tx escape ready. Connect to DPHY IP.
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
		input  wire        tx_clk_esc_d1,             //                      d1_ppi_tx_lp_clk.clk,                PPI lane d1 clock for Tx LP.  Connect to DPHY IP.
		input  wire        tx_word_clk_hs_ck,         //                         ck_ppi_hs_clk.clk,                PPI lane ck Tx HS word clock.  Connect to DPHY IP.
		output wire [1:0]  tx_data_width_hs_ck,       //                             ck_ppi_hs.TxDataWidthHS,      PPI lane ck Tx HS data width. Connect to DPHY IP.
		output wire [15:0] tx_data_hs_ck,             //                                      .TxDataHS,           PPI lane ck Tx HS data. Connect to DPHY IP.
		output wire [1:0]  tx_word_valid_hs_ck,       //                                      .TxWordValidHS,      PPI lane ck Tx HS data word valid. Connect to DPHY IP.
		output wire        tx_eq_active_hs_ck,        //                                      .TxEqActiveHS,       PPI lane ck Tx HS equalization active. Connect to DPHY IP.
		output wire        tx_eq_level_hs_ck,         //                                      .TxEqLevelHS,        PPI lane ck Tx HS equalization level indicator. Connect to DPHY IP.
		output wire        tx_request_hs_ck,          //                                      .TxRequestHS,        PPI lane ck Tx HS request. Connect to DPHY IP.
		input  wire        tx_ready_hs_ck,            //                                      .TxReadyHS,          PPI lane ck Tx HS ready. Connect to DPHY IP.
		output wire        tx_data_transfer_en_hs_ck, //                                      .TxDataTransferEnHS, PPI lane ck Tx HS data transfer enable. Connect to DPHY IP.
		output wire        tx_skew_cal_hs_ck,         //                                      .TxSkewCalHS,        PPI lane ck Tx HS skew calibration initiate. Connect to DPHY IP.
		output wire        tx_alternate_cal_hs_ck,    //                                      .TxAlternateCalHS,   PPI lane ck Tx HS alternate calibration initiate. Connect to DPHY IP.
		output wire        tx_request_esc_ck,         //                             ck_ppi_lp.TxRequestEsc,       PPI lane ck Tx escape request. Connect to DPHY IP.
		output wire [3:0]  tx_request_type_esc_ck,    //                                      .TxRequestTypeEsc,   PPI lane ck Tx escape request type. Connect to DPHY IP.
		output wire        tx_lpdt_esc_ck,            //                                      .TxLpdtEsc,          PPI lane ck Tx escape LP data active. Connect to DPHY IP.
		output wire        tx_ulps_exit_ck,           //                                      .TxUlpsExit,         PPI lane ck Tx ultra-low power state exit request. Connect to DPHY IP.
		output wire        tx_ulps_esc_ck,            //                                      .TxUlpsEsc,          PPI lane ck Tx ultra-low power state entry request. Connect to DPHY IP.
		output wire [3:0]  tx_trigger_esc_ck,         //                                      .TxTriggerEsc,       PPI lane ck Tx event trigger. Connect to DPHY IP.
		output wire [7:0]  tx_data_esc_ck,            //                                      .TxDataEsc,          PPI lane ck Tx escape mode data. Connect to DPHY IP.
		output wire        tx_valid_esc_ck,           //                                      .TxValidEsc,         PPI lane ck Tx escape mode data valid. Connect to DPHY IP.
		input  wire        tx_ready_esc_ck,           //                                      .TxReadyEsc,         PPI lane ck Tx escape ready. Connect to DPHY IP.
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
		input  wire        tx_clk_esc_ck,             //                      ck_ppi_tx_lp_clk.clk,                PPI lane ck clock for Tx LP.  Connect to DPHY IP.
		input  wire        axi4s_clk,                 //                             axi4s_clk.clk,                Clock used for video streaming and control interfaces.  Refer to the user guide for detailed restrictions on the rate of this clock depending on configuration.
		input  wire        axi4s_rst,                 //                             axi4s_rst.reset,              Reset for axi4s_clk domain.
		input  wire [47:0] axi4s_vid_in_0_tdata,      //           video_streaming_interface_0.tdata,              Tx video channel 0 pixel data.  See the Intel FPGA Streaming Video Protocol specification for details.
		input  wire        axi4s_vid_in_0_tvalid,     //                                      .tvalid,             Tx video channel 0 data valid.
		output wire        axi4s_vid_in_0_tready,     //                                      .tready,             Tx video channel 0 TREADY.
		input  wire        axi4s_vid_in_0_tlast,      //                                      .tlast,              Tx video channel 0 TLAST.
		input  wire [5:0]  axi4s_vid_in_0_tuser,      //                                      .tuser,              Tx video channel 0 TUSER.
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

