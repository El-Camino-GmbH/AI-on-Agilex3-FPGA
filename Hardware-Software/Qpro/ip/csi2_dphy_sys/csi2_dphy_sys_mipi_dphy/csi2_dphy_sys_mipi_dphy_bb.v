module csi2_dphy_sys_mipi_dphy (
		input  wire        rzq,                         //                     rzq.rzq
		input  wire        ref_clk_0_p,                 //               ref_clk_0.clk
		input  wire        arst_n,                      //                    arst.reset_n
		output wire        LINK0_link_core_clk,         //     LINK0_link_core_clk.clk
		output wire        LINK0_link_srst_n,           //    LINK0_link_core_srst.reset_n
		output wire        LINK0_link_arst_n,           //    LINK0_link_core_arst.reset_n
		input  wire        axil_clk,                    //                 reg_clk.clk
		input  wire        srst_axil_n,                 //                reg_srst.reset_n
		input  wire [11:0] axi_lite_awaddr,             //                axi_lite.awaddr
		input  wire        axi_lite_awvalid,            //                        .awvalid
		output wire        axi_lite_awready,            //                        .awready
		input  wire [31:0] axi_lite_wdata,              //                        .wdata
		input  wire [3:0]  axi_lite_wstrb,              //                        .wstrb
		input  wire        axi_lite_wvalid,             //                        .wvalid
		output wire        axi_lite_wready,             //                        .wready
		output wire [1:0]  axi_lite_bresp,              //                        .bresp
		output wire        axi_lite_bvalid,             //                        .bvalid
		input  wire        axi_lite_bready,             //                        .bready
		input  wire [11:0] axi_lite_araddr,             //                        .araddr
		input  wire        axi_lite_arvalid,            //                        .arvalid
		output wire        axi_lite_arready,            //                        .arready
		output wire [31:0] axi_lite_rdata,              //                        .rdata
		output wire [1:0]  axi_lite_rresp,              //                        .rresp
		output wire        axi_lite_rvalid,             //                        .rvalid
		input  wire        axi_lite_rready,             //                        .rready
		input  wire [2:0]  axi_lite_arprot,             //                        .arprot
		input  wire [2:0]  axi_lite_awprot,             //                        .awprot
		output wire        LINK0_D0_RxWordClkHS,        //  LINK0_D0_ppi_rx_hs_clk.clk
		output wire        LINK0_D1_RxWordClkHS,        //  LINK0_D1_ppi_rx_hs_clk.clk
		output wire        LINK0_CK_RxWordClkHS,        //  LINK0_CK_ppi_rx_hs_clk.clk
		output wire        LINK0_D0_RxSRst_n,           // LINK0_D0_ppi_rx_hs_srst.reset_n
		output wire        LINK0_D1_RxSRst_n,           // LINK0_D1_ppi_rx_hs_srst.reset_n
		output wire        LINK0_CK_RxSRst_n,           // LINK0_CK_ppi_rx_hs_srst.reset_n
		input  wire [1:0]  LINK0_D0_RxDataWidthHS,      //      LINK0_D0_ppi_rx_hs.RxDataWidthHS
		output wire [15:0] LINK0_D0_RxDataHS,           //                        .RxDataHS
		output wire [1:0]  LINK0_D0_RxValidHS,          //                        .RxValidHS
		output wire        LINK0_D0_RxActiveHS,         //                        .RxActiveHS
		output wire        LINK0_D0_RxSyncHS,           //                        .RxSyncHS
		input  wire        LINK0_D0_RxDetectEobHS,      //                        .RxDetectEobHS
		output wire        LINK0_D0_RxClkActiveHS,      //                        .RxClkActiveHS
		output wire        LINK0_D0_RxDDRClkHS,         //                        .RxDDRClkHS
		output wire        LINK0_D0_RxSkewCalHS,        //                        .RxSkewCalHS
		output wire        LINK0_D0_RxAlternateCalHS,   //                        .RxAlternateCalHS
		output wire        LINK0_D0_RxErrorCalHS,       //                        .RxErrorCalHS
		input  wire [1:0]  LINK0_D1_RxDataWidthHS,      //      LINK0_D1_ppi_rx_hs.RxDataWidthHS
		output wire [15:0] LINK0_D1_RxDataHS,           //                        .RxDataHS
		output wire [1:0]  LINK0_D1_RxValidHS,          //                        .RxValidHS
		output wire        LINK0_D1_RxActiveHS,         //                        .RxActiveHS
		output wire        LINK0_D1_RxSyncHS,           //                        .RxSyncHS
		input  wire        LINK0_D1_RxDetectEobHS,      //                        .RxDetectEobHS
		output wire        LINK0_D1_RxClkActiveHS,      //                        .RxClkActiveHS
		output wire        LINK0_D1_RxDDRClkHS,         //                        .RxDDRClkHS
		output wire        LINK0_D1_RxSkewCalHS,        //                        .RxSkewCalHS
		output wire        LINK0_D1_RxAlternateCalHS,   //                        .RxAlternateCalHS
		output wire        LINK0_D1_RxErrorCalHS,       //                        .RxErrorCalHS
		input  wire [1:0]  LINK0_CK_RxDataWidthHS,      //      LINK0_CK_ppi_rx_hs.RxDataWidthHS
		output wire [15:0] LINK0_CK_RxDataHS,           //                        .RxDataHS
		output wire [1:0]  LINK0_CK_RxValidHS,          //                        .RxValidHS
		output wire        LINK0_CK_RxActiveHS,         //                        .RxActiveHS
		output wire        LINK0_CK_RxSyncHS,           //                        .RxSyncHS
		input  wire        LINK0_CK_RxDetectEobHS,      //                        .RxDetectEobHS
		output wire        LINK0_CK_RxClkActiveHS,      //                        .RxClkActiveHS
		output wire        LINK0_CK_RxDDRClkHS,         //                        .RxDDRClkHS
		output wire        LINK0_CK_RxSkewCalHS,        //                        .RxSkewCalHS
		output wire        LINK0_CK_RxAlternateCalHS,   //                        .RxAlternateCalHS
		output wire        LINK0_CK_RxErrorCalHS,       //                        .RxErrorCalHS
		output wire        LINK0_D0_RxClkEsc,           //      LINK0_D0_ppi_rx_lp.RxClkEsc
		output wire        LINK0_D0_RxLpdtEsc,          //                        .RxLpdtEsc
		output wire        LINK0_D0_RxUlpsEsc,          //                        .RxUlpsEsc
		output wire [3:0]  LINK0_D0_RxTriggerEsc,       //                        .RxTriggerEsc
		output wire        LINK0_D0_RxWakeup,           //                        .RxWakeup
		output wire [7:0]  LINK0_D0_RxDataEsc,          //                        .RxDataEsc
		output wire        LINK0_D0_RxValidEsc,         //                        .RxValidEsc
		output wire        LINK0_D1_RxClkEsc,           //      LINK0_D1_ppi_rx_lp.RxClkEsc
		output wire        LINK0_D1_RxLpdtEsc,          //                        .RxLpdtEsc
		output wire        LINK0_D1_RxUlpsEsc,          //                        .RxUlpsEsc
		output wire [3:0]  LINK0_D1_RxTriggerEsc,       //                        .RxTriggerEsc
		output wire        LINK0_D1_RxWakeup,           //                        .RxWakeup
		output wire [7:0]  LINK0_D1_RxDataEsc,          //                        .RxDataEsc
		output wire        LINK0_D1_RxValidEsc,         //                        .RxValidEsc
		output wire        LINK0_CK_RxClkEsc,           //      LINK0_CK_ppi_rx_lp.RxClkEsc
		output wire        LINK0_CK_RxLpdtEsc,          //                        .RxLpdtEsc
		output wire        LINK0_CK_RxUlpsEsc,          //                        .RxUlpsEsc
		output wire [3:0]  LINK0_CK_RxTriggerEsc,       //                        .RxTriggerEsc
		output wire        LINK0_CK_RxWakeup,           //                        .RxWakeup
		output wire [7:0]  LINK0_CK_RxDataEsc,          //                        .RxDataEsc
		output wire        LINK0_CK_RxValidEsc,         //                        .RxValidEsc
		input  wire        LINK0_D0_TurnRequest,        //       LINK0_D0_ppi_ctrl.TurnRequest
		output wire        LINK0_D0_Direction,          //                        .Direction
		input  wire        LINK0_D0_TurnDisable,        //                        .TurnDisable
		input  wire        LINK0_D0_ForceRxmode,        //                        .ForceRxmode
		input  wire        LINK0_D0_ForceTxStopmode,    //                        .ForceTxStopmode
		output wire        LINK0_D0_Stopstate,          //                        .Stopstate
		input  wire        LINK0_D0_Enable,             //                        .Enable
		input  wire        LINK0_D0_AlpMode,            //                        .AlpMode
		input  wire        LINK0_D0_TxUlpsClk,          //                        .TxUlpsClk
		output wire        LINK0_D0_RxUlpsClkNot,       //                        .RxUlpsClkNot
		output wire        LINK0_D0_UlpsActiveNot,      //                        .UlpsActiveNot
		input  wire        LINK0_D0_TxHSIdleClkHS,      //                        .TxHSIdleClkHS
		output wire        LINK0_D0_TxHSIdleClkReadyHS, //                        .TxHSIdleClkReadyHS
		input  wire        LINK0_D1_TurnRequest,        //       LINK0_D1_ppi_ctrl.TurnRequest
		output wire        LINK0_D1_Direction,          //                        .Direction
		input  wire        LINK0_D1_TurnDisable,        //                        .TurnDisable
		input  wire        LINK0_D1_ForceRxmode,        //                        .ForceRxmode
		input  wire        LINK0_D1_ForceTxStopmode,    //                        .ForceTxStopmode
		output wire        LINK0_D1_Stopstate,          //                        .Stopstate
		input  wire        LINK0_D1_Enable,             //                        .Enable
		input  wire        LINK0_D1_AlpMode,            //                        .AlpMode
		input  wire        LINK0_D1_TxUlpsClk,          //                        .TxUlpsClk
		output wire        LINK0_D1_RxUlpsClkNot,       //                        .RxUlpsClkNot
		output wire        LINK0_D1_UlpsActiveNot,      //                        .UlpsActiveNot
		input  wire        LINK0_D1_TxHSIdleClkHS,      //                        .TxHSIdleClkHS
		output wire        LINK0_D1_TxHSIdleClkReadyHS, //                        .TxHSIdleClkReadyHS
		input  wire        LINK0_CK_TurnRequest,        //       LINK0_CK_ppi_ctrl.TurnRequest
		output wire        LINK0_CK_Direction,          //                        .Direction
		input  wire        LINK0_CK_TurnDisable,        //                        .TurnDisable
		input  wire        LINK0_CK_ForceRxmode,        //                        .ForceRxmode
		input  wire        LINK0_CK_ForceTxStopmode,    //                        .ForceTxStopmode
		output wire        LINK0_CK_Stopstate,          //                        .Stopstate
		input  wire        LINK0_CK_Enable,             //                        .Enable
		input  wire        LINK0_CK_AlpMode,            //                        .AlpMode
		input  wire        LINK0_CK_TxUlpsClk,          //                        .TxUlpsClk
		output wire        LINK0_CK_RxUlpsClkNot,       //                        .RxUlpsClkNot
		output wire        LINK0_CK_UlpsActiveNot,      //                        .UlpsActiveNot
		input  wire        LINK0_CK_TxHSIdleClkHS,      //                        .TxHSIdleClkHS
		output wire        LINK0_CK_TxHSIdleClkReadyHS, //                        .TxHSIdleClkReadyHS
		output wire        LINK0_D0_ErrSotHS,           //     LINK0_D0_ppi_rx_err.ErrSotHS
		output wire        LINK0_D0_ErrSotSyncHS,       //                        .ErrSotSyncHS
		output wire        LINK0_D0_ErrEsc,             //                        .ErrEsc
		output wire        LINK0_D0_ErrSyncEsc,         //                        .ErrSyncEsc
		output wire        LINK0_D0_ErrControl,         //                        .ErrControl
		output wire        LINK0_D0_ErrContentionLP0,   //                        .ErrContentionLP0
		output wire        LINK0_D0_ErrContentionLP1,   //                        .ErrContentionLP1
		output wire        LINK0_D1_ErrSotHS,           //     LINK0_D1_ppi_rx_err.ErrSotHS
		output wire        LINK0_D1_ErrSotSyncHS,       //                        .ErrSotSyncHS
		output wire        LINK0_D1_ErrEsc,             //                        .ErrEsc
		output wire        LINK0_D1_ErrSyncEsc,         //                        .ErrSyncEsc
		output wire        LINK0_D1_ErrControl,         //                        .ErrControl
		output wire        LINK0_D1_ErrContentionLP0,   //                        .ErrContentionLP0
		output wire        LINK0_D1_ErrContentionLP1,   //                        .ErrContentionLP1
		output wire        LINK0_CK_ErrSotHS,           //     LINK0_CK_ppi_rx_err.ErrSotHS
		output wire        LINK0_CK_ErrSotSyncHS,       //                        .ErrSotSyncHS
		output wire        LINK0_CK_ErrEsc,             //                        .ErrEsc
		output wire        LINK0_CK_ErrSyncEsc,         //                        .ErrSyncEsc
		output wire        LINK0_CK_ErrControl,         //                        .ErrControl
		output wire        LINK0_CK_ErrContentionLP0,   //                        .ErrContentionLP0
		output wire        LINK0_CK_ErrContentionLP1,   //                        .ErrContentionLP1
		input  wire [1:0]  LINK0_dphy_link_dp,          //           LINK0_dphy_io.dphy_link_dp
		input  wire [1:0]  LINK0_dphy_link_dn,          //                        .dphy_link_dn
		input  wire        LINK0_dphy_link_cp,          //                        .dphy_link_cp
		input  wire        LINK0_dphy_link_cn,          //                        .dphy_link_cn
		output wire        reg_wr_en_o,                 //                 reg_bus.reg_wr_en_o
		output wire        reg_rd_en_o,                 //                        .reg_rd_en_o
		output wire [10:0] reg_raddr_o,                 //                        .reg_raddr_o
		output wire [10:0] reg_waddr_o,                 //                        .reg_waddr_o
		output wire [3:0]  reg_be_o,                    //                        .reg_be_o
		output wire [31:0] reg_din_o,                   //                        .reg_din_o
		input  wire [31:0] reg_dout_i                   //                        .reg_dout_i
	);
endmodule

