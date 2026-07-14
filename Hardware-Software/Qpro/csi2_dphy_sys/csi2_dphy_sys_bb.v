module csi2_dphy_sys (
		output wire        csi2_rx_o_d0_ppi_rx_err_ErrSotHS,                  //                       csi2_rx_o_d0_ppi_rx_err.ErrSotHS
		output wire        csi2_rx_o_d0_ppi_rx_err_ErrSotSyncHS,              //                                              .ErrSotSyncHS
		output wire        csi2_rx_o_d0_ppi_rx_err_ErrEsc,                    //                                              .ErrEsc
		output wire        csi2_rx_o_d0_ppi_rx_err_ErrSyncEsc,                //                                              .ErrSyncEsc
		output wire        csi2_rx_o_d0_ppi_rx_err_ErrControl,                //                                              .ErrControl
		output wire        csi2_rx_o_d0_ppi_rx_err_ErrContentionLP0,          //                                              .ErrContentionLP0
		output wire        csi2_rx_o_d0_ppi_rx_err_ErrContentionLP1,          //                                              .ErrContentionLP1
		output wire        csi2_rx_o_d1_ppi_rx_err_ErrSotHS,                  //                       csi2_rx_o_d1_ppi_rx_err.ErrSotHS
		output wire        csi2_rx_o_d1_ppi_rx_err_ErrSotSyncHS,              //                                              .ErrSotSyncHS
		output wire        csi2_rx_o_d1_ppi_rx_err_ErrEsc,                    //                                              .ErrEsc
		output wire        csi2_rx_o_d1_ppi_rx_err_ErrSyncEsc,                //                                              .ErrSyncEsc
		output wire        csi2_rx_o_d1_ppi_rx_err_ErrControl,                //                                              .ErrControl
		output wire        csi2_rx_o_d1_ppi_rx_err_ErrContentionLP0,          //                                              .ErrContentionLP0
		output wire        csi2_rx_o_d1_ppi_rx_err_ErrContentionLP1,          //                                              .ErrContentionLP1
		output wire        csi2_rx_o_ck_ppi_rx_err_ErrSotHS,                  //                       csi2_rx_o_ck_ppi_rx_err.ErrSotHS
		output wire        csi2_rx_o_ck_ppi_rx_err_ErrSotSyncHS,              //                                              .ErrSotSyncHS
		output wire        csi2_rx_o_ck_ppi_rx_err_ErrEsc,                    //                                              .ErrEsc
		output wire        csi2_rx_o_ck_ppi_rx_err_ErrSyncEsc,                //                                              .ErrSyncEsc
		output wire        csi2_rx_o_ck_ppi_rx_err_ErrControl,                //                                              .ErrControl
		output wire        csi2_rx_o_ck_ppi_rx_err_ErrContentionLP0,          //                                              .ErrContentionLP0
		output wire        csi2_rx_o_ck_ppi_rx_err_ErrContentionLP1,          //                                              .ErrContentionLP1
		output wire [63:0] csi2_rx_video_streaming_interface_0_tdata,         //           csi2_rx_video_streaming_interface_0.tdata
		output wire        csi2_rx_video_streaming_interface_0_tvalid,        //                                              .tvalid
		input  wire        csi2_rx_video_streaming_interface_0_tready,        //                                              .tready
		output wire        csi2_rx_video_streaming_interface_0_tlast,         //                                              .tlast
		output wire [7:0]  csi2_rx_video_streaming_interface_0_tuser,         //                                              .tuser
		input  wire        csi2_rx_avalon_mm_control_interface_write,         //           csi2_rx_avalon_mm_control_interface.write
		input  wire        csi2_rx_avalon_mm_control_interface_read,          //                                              .read
		input  wire [9:0]  csi2_rx_avalon_mm_control_interface_address,       //                                              .address
		input  wire [31:0] csi2_rx_avalon_mm_control_interface_writedata,     //                                              .writedata
		output wire [31:0] csi2_rx_avalon_mm_control_interface_readdata,      //                                              .readdata
		output wire        csi2_rx_avalon_mm_control_interface_readdatavalid, //                                              .readdatavalid
		output wire        csi2_rx_avalon_mm_control_interface_waitrequest,   //                                              .waitrequest
		input  wire [3:0]  csi2_rx_avalon_mm_control_interface_byteenable,    //                                              .byteenable
		output wire        csi2_rx_avalon_mm_control_interface_interrupt_irq, // csi2_rx_avalon_mm_control_interface_interrupt.irq
		input  wire        mipi_dphy_rzq_rzq,                                 //                                 mipi_dphy_rzq.rzq
		input  wire        mipi_dphy_ref_clk_0_clk,                           //                           mipi_dphy_ref_clk_0.clk
		output wire        mipi_dphy_LINK0_link_core_srst_reset_n,            //                mipi_dphy_LINK0_link_core_srst.reset_n
		output wire        mipi_dphy_LINK0_link_core_arst_reset_n,            //                mipi_dphy_LINK0_link_core_arst.reset_n
		input  wire [11:0] mipi_dphy_axi_lite_awaddr,                         //                            mipi_dphy_axi_lite.awaddr
		input  wire        mipi_dphy_axi_lite_awvalid,                        //                                              .awvalid
		output wire        mipi_dphy_axi_lite_awready,                        //                                              .awready
		input  wire [31:0] mipi_dphy_axi_lite_wdata,                          //                                              .wdata
		input  wire [3:0]  mipi_dphy_axi_lite_wstrb,                          //                                              .wstrb
		input  wire        mipi_dphy_axi_lite_wvalid,                         //                                              .wvalid
		output wire        mipi_dphy_axi_lite_wready,                         //                                              .wready
		output wire [1:0]  mipi_dphy_axi_lite_bresp,                          //                                              .bresp
		output wire        mipi_dphy_axi_lite_bvalid,                         //                                              .bvalid
		input  wire        mipi_dphy_axi_lite_bready,                         //                                              .bready
		input  wire [11:0] mipi_dphy_axi_lite_araddr,                         //                                              .araddr
		input  wire        mipi_dphy_axi_lite_arvalid,                        //                                              .arvalid
		output wire        mipi_dphy_axi_lite_arready,                        //                                              .arready
		output wire [31:0] mipi_dphy_axi_lite_rdata,                          //                                              .rdata
		output wire [1:0]  mipi_dphy_axi_lite_rresp,                          //                                              .rresp
		output wire        mipi_dphy_axi_lite_rvalid,                         //                                              .rvalid
		input  wire        mipi_dphy_axi_lite_rready,                         //                                              .rready
		input  wire [2:0]  mipi_dphy_axi_lite_arprot,                         //                                              .arprot
		input  wire [2:0]  mipi_dphy_axi_lite_awprot,                         //                                              .awprot
		input  wire [1:0]  mipi_dphy_LINK0_dphy_io_dphy_link_dp,              //                       mipi_dphy_LINK0_dphy_io.dphy_link_dp
		input  wire [1:0]  mipi_dphy_LINK0_dphy_io_dphy_link_dn,              //                                              .dphy_link_dn
		input  wire        mipi_dphy_LINK0_dphy_io_dphy_link_cp,              //                                              .dphy_link_cp
		input  wire        mipi_dphy_LINK0_dphy_io_dphy_link_cn,              //                                              .dphy_link_cn
		output wire        mipi_dphy_reg_bus_reg_wr_en_o,                     //                             mipi_dphy_reg_bus.reg_wr_en_o
		output wire        mipi_dphy_reg_bus_reg_rd_en_o,                     //                                              .reg_rd_en_o
		output wire [10:0] mipi_dphy_reg_bus_reg_raddr_o,                     //                                              .reg_raddr_o
		output wire [10:0] mipi_dphy_reg_bus_reg_waddr_o,                     //                                              .reg_waddr_o
		output wire [3:0]  mipi_dphy_reg_bus_reg_be_o,                        //                                              .reg_be_o
		output wire [31:0] mipi_dphy_reg_bus_reg_din_o,                       //                                              .reg_din_o
		input  wire [31:0] mipi_dphy_reg_bus_reg_dout_i,                      //                                              .reg_dout_i
		input  wire        rx_axi4s_clk_bridge_in_clk_clk                     //                    rx_axi4s_clk_bridge_in_clk.clk
	);
endmodule

