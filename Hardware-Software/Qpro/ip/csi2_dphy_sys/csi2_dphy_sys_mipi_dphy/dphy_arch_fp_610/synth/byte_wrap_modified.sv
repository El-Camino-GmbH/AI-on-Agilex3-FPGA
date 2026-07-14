// (C) 2001-2025 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.




// synthesis translate_off   

`ifdef DPHY_BHV_SIM
`define BHV_BYTE 1
`endif

`ifdef BHV_BYTE
`define byte_name dphy_byte_bhv
`endif

`ifdef BHV_BYTE
 `define assert_clk dphy_io.core_clk
 `define assert_rstn dphy_io.srst_n
`else
 `define assert_clk i_phyclk_notgated
 `define assert_rstn i_phy_phy_reset_n
`endif

`define SIM 1

// synthesis translate_on

`ifndef byte_name
`define byte_name tennm_byte
`endif

`undef REVA

module dphy_byte_wrap #(
    parameter BYTE_LOC = 0,
    parameter BYTE_N = 0,
    parameter NUM_LANES = 0,
    parameter DPHY_RX_EN = 0,
    parameter DPHY_TX_EN = 0,
    parameter BIT_RATE = 36'd3200000000,                
    parameter RX_CAP_EQ_MODE = 0,
    parameter TX_CAP_EQ_MODE = 0,
    parameter CONTINUOUS_CLK = 0,                       
    parameter RZQ_ID = "RZQ0",
    parameter VCCN_VOLTAGE = "VCCN_VOLTAGE_1P2V"
) ( 
    output logic [11:0] io_phy_pad_sig_bidir_out, 
    input wire [11:0] 	io_phy_pad_sig_bidir_in, 
    output logic [11:0] o_phy_pad_doe, 
    input wire [47:0] 	i_phy_tx_wr_data, 
    output logic [47:0] o_phy_core_data, 
    input wire [11:0] 	i_phy_gpio_dout, 
    input wire [11:0] 	i_phy_gpio_oe, 
    output logic [11:0] o_phy_gpio_din, 
    input wire [11:0] 	i_phy_gpio_dout_sel, 

    input wire 		i_phy_dfi_dram_clock_disable,
    input wire 		i_phyclk_notgated,
    
    input wire [1:0] 	i_phy_tx_wr_dqs_en4_del, 
    input wire [1:0] 	i_phy_tx_wr_dqs_en5_del, 
    input wire [1:0] 	i_phy_tx_wr_dqs_en6_del, 
    input wire [1:0] 	i_phy_tx_wr_dqs_en7_del, 
    input wire [1:0] 	i_phy_tx_wrdata_en0_del, 
    input wire [1:0] 	i_phy_tx_wrdata_en1_del, 
    input wire [1:0] 	i_phy_tx_wrdata_en2_del, 
    input wire [1:0] 	i_phy_tx_wrdata_en3_del, 
    input wire [1:0] 	i_phy_tx_wrdata_en8_del, 
    input wire [1:0] 	i_phy_tx_wrdata_en9_del, 
    input wire [1:0] 	i_phy_tx_wrdata_en10_del, 
    input wire [1:0] 	i_phy_tx_wrdata_en11_del, 
    input wire [3:0] 	i_phy_tx_picode0, 
    input wire [3:0] 	i_phy_tx_picode1, 
    input wire [3:0] 	i_phy_tx_picode2, 
    input wire [3:0] 	i_phy_tx_picode3, 
    input wire [3:0] 	i_phy_tx_picode4, 
    input wire [3:0] 	i_phy_tx_picode5, 
    input wire [3:0] 	i_phy_tx_picode6, 
    input wire [3:0] 	i_phy_tx_picode7, 
    input wire [3:0] 	i_phy_tx_picode8, 
    input wire [3:0] 	i_phy_tx_picode9, 
    input wire [3:0] 	i_phy_tx_picode10, 
    input wire [3:0] 	i_phy_tx_picode11, 
    input wire [31:0] 	i_phy_byte_tx_ctrl, 
    input wire 		i_phy_fifo_pack_select, 

    input wire [1:0] 	i_phy_fifo_read_enable_upper, 
    input wire [1:0] 	i_phy_fifo_read_enable_lower, 
    input wire 		i_phy_trainreset, 
    input wire [31:0] 	i_phy_byte_rx_ctrl, 
    input wire 		i_phy_txclk_gated, 
    input wire 		i_phy_rxclk_gated, 
    input wire 		i_phy_tx_clkrefdivby2, 
    input wire [11:0] 	i_phy_tx_clkpi, 
    input wire [5:0] 	i_phy_sdll0_dqsp, 
    input wire [5:0] 	i_phy_sdll0_dqsn, 
    input wire [5:0] 	i_phy_sdll1_dqsp, 
    input wire [5:0] 	i_phy_sdll1_dqsn, 
    output logic 	o_phy_rx_dqs_p4, 
    output logic 	o_phy_rx_dqs_n4, 
    output logic 	o_phy_rx_dqs_amp_p5, 
    output logic 	o_phy_rx_dqs_p6, 
    output logic 	o_phy_rx_dqs_n6, 
    output logic 	o_phy_rx_dqs_amp_p7, 
    output logic 	o_phy_rx_fwdclk, 

    input wire [11:0] 	i_phy_rx_senseampen, 
    input wire [5:0] 	i_phy_sdll0_rx_d0pienable, 
    input wire 		i_phy_sdll0_rx_d0rcvenpre, 
    input wire 		i_phy_sdll0_rx_d0reset, 
`ifdef REVA
    input wire 		i_phy_sdll0_rx_d0sdlparkvalue, 
    input wire 		i_phy_sdll1_rx_d0sdlparkvalue, 
`else
    input wire [2:0] 	i_phy_parkclk_to_rxtop_n0_pl1,
    input wire [2:0] 	i_phy_parkclk_to_rxtop_n1_pl1,
`endif
    input wire [5:0] 	i_phy_sdll1_rx_d0pienable, 
    input wire 		i_phy_sdll1_rx_d0rcvenpre, 
    input wire 		i_phy_sdll1_rx_d0reset, 
    output logic [4:0] 	o_DCCXtalkControl_DCCSamples,
    output logic 	o_DCCXtalkControl_RunDCC,
    output logic [1:0] 	o_DCCXtalkControl_SelMeasPoint,
    output logic [4:0] 	o_DDRCrRxEQRank01_RxDFETap0Rank0,
    output logic [3:0] 	o_DDRCrRxEQRank01_RxDFETap1Rank0,
    output logic [3:0] 	o_DDRCrRxEQRank01_RxDFETap2Rank0,
    output logic [2:0] 	o_DDRCrRxEQRank01_RxDFETap3Rank0,
    output logic [4:0] 	o_DDRCrRxEQRank01_RxDFETap0Rank1,
    output logic [3:0] 	o_DDRCrRxEQRank01_RxDFETap1Rank1,
    output logic [3:0] 	o_DDRCrRxEQRank01_RxDFETap2Rank1,
    output logic [2:0] 	o_DDRCrRxEQRank01_RxDFETap3Rank1,
    output logic [4:0] 	o_DDRCrRxEQRank23_RxDFETap0Rank2,
    output logic [3:0] 	o_DDRCrRxEQRank23_RxDFETap1Rank2,
    output logic [3:0] 	o_DDRCrRxEQRank23_RxDFETap2Rank2,
    output logic [2:0] 	o_DDRCrRxEQRank23_RxDFETap3Rank2,
    output logic [4:0] 	o_DDRCrRxEQRank23_RxDFETap0Rank3,
    output logic [3:0] 	o_DDRCrRxEQRank23_RxDFETap1Rank3,
    output logic [3:0] 	o_DDRCrRxEQRank23_RxDFETap2Rank3,
    output logic [2:0] 	o_DDRCrRxEQRank23_RxDFETap3Rank3,
    output logic [4:0] 	o_mipi_rb_rxdly_direct_ctrl,
    output logic [4:0] 	o_mipi_rx_diff_en,
    output logic [4:0] 	o_mipi_rx_dphylprxen,
    output logic [47:0] o_phy_tx_wr_data_pl,
    output logic 	o_from_phy_rx_x16dqsn_p4,
    output logic 	o_from_phy_rx_x16dqsp_p4,
    output logic [11:0] o_rx_rxdqsampresult,
    output logic [11:0] o_rxdphylprxen,
    output logic [11:0] o_rxlvdien,
    output logic 	o_rzq_en,
    output logic [2:0] 	o_tx_modectrl_4,
    input wire 		i_dcd_ter_en,
    input wire 		i_from_sdll0_o_dcdsawl_clk,
    input wire 		i_from_sdll1_o_dcdsawl_clk, 
    input wire [1:0] 	i_dqsmode,
    input wire [1:0] 	i_n0_odt_seg_rotate_en,
    input wire [1:0] 	i_n1_odt_seg_rotate_en,
    input wire [11:0] 	i_odt_en,
    input wire [11:0] 	i_odt_parken,
    input wire [11:0] 	i_odt_parken_dqsn,
    input wire 		i_phy_ddrcrdatacontrol0_enodtrotation,
    input wire 		i_phy_ddrcrdatacontrol4_unmatchedrx,
    input wire [11:0] 	i_phy_rx_dfemuxout_0,
    input wire [11:0] 	i_phy_rx_dfemuxout_1,
    input wire 		i_phy_occ_phy_clk,
    input wire [11:0] 	i_phy_rx_rcvenmuxout_0,
    input wire [11:0] 	i_phy_rx_rcvenmuxout_1,
    input wire [1:0] 	i_phy_rddata_en_dly,
    input wire 		i_phy_rx_d0cben,
    input wire 		i_phy_rx_d0drvsel,
    input wire 		i_rxfifo_rb_avm_wr_pipestage,
    input wire 		i_phy_phy_clk_gated,
    input wire [1:0] 	i_phy_tx_wrdata_en0,
    input wire [1:0] 	i_phy_tx_wrdata_en1,
    input wire [1:0] 	i_phy_tx_wrdata_en2,
    input wire [1:0] 	i_phy_tx_wrdata_en3,
    input wire [1:0] 	i_phy_tx_wr_dqs_en4,
    input wire [1:0] 	i_phy_tx_wr_dqs_en5,
    input wire [1:0] 	i_phy_tx_wr_dqs_en6,
    input wire [1:0] 	i_phy_tx_wr_dqs_en7,
    input wire [1:0] 	i_phy_tx_wrdata_en8,
    input wire [1:0] 	i_phy_tx_wrdata_en9,
    input wire [1:0] 	i_phy_tx_wrdata_en10,
    input wire [1:0] 	i_phy_tx_wrdata_en11,
    input wire [16:0] 	i_X1CounterDCCPin_00_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_01_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_02_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_03_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_04_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_05_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_06_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_07_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_08_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_09_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_10_DCCCount,
    input wire [16:0] 	i_X1CounterDCCPin_11_DCCCount, 
    input wire 		i_rxfifo_skew,
    input wire [13:0] 	i_rxfifo_spare,
    output logic [11:0] rxnpathenable,
    output logic [11:0] rxppathenable,
    input wire 		i_phy_phy_reset_n,
    input wire [3:0] 	i_phy_datatrainfeedback_dqsnparklovohcode,
    input wire 		i_phy_datatrainfeedback_dqsnparklowvoh, 
    input wire [11:0] 	i_phy_ddrcrcmdbustrain_ddrdqovrddata,
    input wire [11:0] 	i_phy_ddrcrcmdbustrain_ddrdqovrdmodeen,
    output logic 	o_phy_cr_iamca_00,
    output logic 	o_phy_cr_iamca_01,
    output logic 	o_phy_cr_iamca_02,
    output logic 	o_phy_cr_iamca_03,
    output logic 	o_phy_cr_iamca_04,
    output logic 	o_phy_cr_iamca_05,
    output logic 	o_phy_cr_iamca_06,
    output logic 	o_phy_cr_iamca_07,
    output logic 	o_phy_cr_iamca_08,
    output logic 	o_phy_cr_iamca_09,
    output logic 	o_phy_cr_iamca_10,
    output logic 	o_phy_cr_iamca_11,
    output logic 	o_phy_mipi_idle,
    input wire 		pllclk,
    output logic 	from_io12phy_txdigitop_0_o_tx_drven_ph0_toviewdigin,
    output logic 	from_io12phy_txdigitop_0_o_tx_drven_ph1_toviewdigin,
    output logic 	from_io12phy_txdigitop_4_o_tx_drven_ph0_toviewdigin,
    output logic 	from_io12phy_txdigitop_4_o_tx_drven_ph1_toviewdigin,
    output logic [1:0] 	o_delayed_oe_p0_toviewdigin,
    output logic [1:0] 	o_delayed_oe_p4_toviewdigin,
    output logic [11:0] o_rb_txfifo_in_sel,
    input wire 		i_occ_mux_auxclk,
    input wire          i_nbiasen,
    input wire          i_pbiasen,		
			dphy_io_if dphy_io             
);
    // synthesis translate_off    
//we should be able to remove these!!    
    timeunit 1ns;
    timeprecision 1ps;

    logic av_rst_n;
    
    `ifndef BHV_BYTE
        initial 
        begin
            av_rst_n <= 1'b1;
            
            #10 av_rst_n <= 1'b0;
            #10 av_rst_n <= 1'b1;
        end
    `endif
    // synthesis translate_on        


    wire [11:0] phy_gpio_din;

    // synthesis translate_off

   wire 	rx_data_rd_en_d;
   logic [2:0] 	rx_data_rd_en_pipe;
   logic 	rx_data_rd_en_nedge;

  
     
        wire [5:0]   dphy_hs_en;

   generate
      if ((DPHY_RX_EN == 1) && (CONTINUOUS_CLK == 0)) begin
      
	 always @(posedge `assert_clk or negedge `assert_rstn) begin: pipe_inst
	    if (`assert_rstn == 1'b0)
	      rx_data_rd_en_pipe <= 3'b0;
	    else
	      rx_data_rd_en_pipe[2:0] <= {rx_data_rd_en_pipe[1:0], dphy_io.rx_data_read_en[0]};   
	 end
	`ifdef BHV_BYTE
		 assign rx_data_rd_en_nedge = rx_data_rd_en_pipe[0] & ~dphy_io.rx_data_read_en[0];
	`else	
		 assign rx_data_rd_en_nedge = rx_data_rd_en_pipe[2] & ~rx_data_rd_en_pipe[1];
	`endif	 	
	 property NOT_rd_data_en_and_ckpair_hs_b;
	    not (rx_data_rd_en_nedge && ~dphy_hs_en[2]);	    
	 endproperty 

	 
      end
   endgenerate

   
        `ifdef BHV_BYTE
            assign byte_inst.dphy_hs_en = dphy_hs_en;
    // synthesis translate_on
            assign o_phy_gpio_din = phy_gpio_din;
    // synthesis translate_off
        `else
            genvar p;
            for (p =0; p<12; p++)
            begin: LP_path
                localparam pp = (p >> 1);
                assign o_phy_gpio_din[p] = dphy_hs_en[pp] == 1'b1 ? 1'b0 : phy_gpio_din[p];
            end        
        `endif 
   
    // synthesis translate_on





    localparam D0_USED = ( BYTE_N == 1 || NUM_LANES > 0 );
    localparam D1_USED = ( BYTE_N == 1 || NUM_LANES > 1 );
    localparam D2_USED = ( BYTE_N == 1 || NUM_LANES > 2 );
    localparam D3_USED = ( BYTE_N == 1 || NUM_LANES > 3 );
    localparam CK_USED = ( BYTE_N == 0 );
    localparam D0_USED_TX = D0_USED && (  DPHY_TX_EN == 1 );
    localparam D1_USED_TX = D1_USED && (  DPHY_TX_EN == 1 );
    localparam D2_USED_TX = D2_USED && (  DPHY_TX_EN == 1 );
    localparam D3_USED_TX = D3_USED && (  DPHY_TX_EN == 1 );
    localparam CK_USED_TX = CK_USED && (  DPHY_TX_EN == 1 );
    localparam D0_USED_RX = D0_USED && (  DPHY_RX_EN == 1 );
    localparam D1_USED_RX = D1_USED && (  DPHY_RX_EN == 1 );
    localparam D2_USED_RX = D2_USED && (  DPHY_RX_EN == 1 );
    localparam D3_USED_RX = D3_USED && (  DPHY_RX_EN == 1 );
    localparam CK_USED_RX = CK_USED && (  DPHY_RX_EN == 1 );




    `byte_name #(
        .base_address( (16'h3<<8) | (16'h1<<3) | BYTE_LOC ),
        .rx_serializer_rate( DPHY_RX_EN == 1 ? "RX_SERIALIZER_RATE_HALF_RATE" : "RX_SERIALIZER_RATE_BYPASS" ),
        .tx_serializer_rate( "TX_SERIALIZER_RATE_HALF_RATE" ),

        .pin0_pcomp( D0_USED ? "PIN0_PCOMP_ON" : "PIN0_PCOMP_OFF" ),
        .pin1_pcomp( D0_USED ? "PIN1_PCOMP_ON" : "PIN1_PCOMP_OFF" ),
        .pin2_pcomp( D1_USED ? "PIN2_PCOMP_ON" : "PIN2_PCOMP_OFF" ),
        .pin3_pcomp( D1_USED ? "PIN3_PCOMP_ON" : "PIN3_PCOMP_OFF" ),
        .pin4_pcomp( CK_USED ? "PIN4_PCOMP_ON" : "PIN4_PCOMP_OFF" ),
        .pin5_pcomp( CK_USED ? "PIN5_PCOMP_ON" : "PIN5_PCOMP_OFF" ),
        .pin6_pcomp( D2_USED ? "PIN6_PCOMP_ON" : "PIN6_PCOMP_OFF" ),
        .pin7_pcomp( D2_USED ? "PIN7_PCOMP_ON" : "PIN7_PCOMP_OFF" ),
        .pin8_pcomp( D3_USED ? "PIN8_PCOMP_ON" : "PIN8_PCOMP_OFF" ),
        .pin9_pcomp( D3_USED ? "PIN9_PCOMP_ON" : "PIN9_PCOMP_OFF" ),
        .pin10_pcomp( "PIN10_PCOMP_OFF" ),
        .pin11_pcomp( "PIN11_PCOMP_OFF" ),

        .pin0_rx_usage( D0_USED_RX ? "PIN0_RX_USAGE_MIPI" : "PIN0_RX_USAGE_GPIO" ),
        .pin1_rx_usage( D0_USED_RX ? "PIN1_RX_USAGE_MIPI" : "PIN1_RX_USAGE_GPIO" ),
        .pin2_rx_usage( D1_USED_RX ? "PIN2_RX_USAGE_MIPI" : "PIN2_RX_USAGE_GPIO" ),
        .pin3_rx_usage( D1_USED_RX ? "PIN3_RX_USAGE_MIPI" : "PIN3_RX_USAGE_GPIO" ),
        .pin4_rx_usage( CK_USED_RX ? ( CONTINUOUS_CLK == 1 ? "PIN4_RX_USAGE_MIPI_CLK_CONTINUOUS" : "PIN4_RX_USAGE_MIPI_CLK" ) : "PIN4_RX_USAGE_GPIO" ),
        .pin5_rx_usage( CK_USED_RX ? ( CONTINUOUS_CLK == 1 ? "PIN5_RX_USAGE_MIPI_CLK_CONTINUOUS" : "PIN5_RX_USAGE_MIPI_CLK" ) : "PIN5_RX_USAGE_GPIO" ),
        .pin6_rx_usage( D2_USED_RX ? "PIN6_RX_USAGE_MIPI" : "PIN6_RX_USAGE_GPIO" ),
        .pin7_rx_usage( D2_USED_RX ? "PIN7_RX_USAGE_MIPI" : "PIN7_RX_USAGE_GPIO" ),
        .pin8_rx_usage( D3_USED_RX ? "PIN8_RX_USAGE_MIPI" : "PIN8_RX_USAGE_GPIO" ),
        .pin9_rx_usage( D3_USED_RX ? "PIN9_RX_USAGE_MIPI" : "PIN9_RX_USAGE_GPIO" ),
        .pin10_rx_usage( "PIN10_RX_USAGE_GPIO" ),
        .pin11_rx_usage( "PIN11_RX_USAGE_GPIO" ),

        .pin0_direction( D0_USED ? ( DPHY_RX_EN == 1 ? "PIN0_DIRECTION_IN" : "PIN0_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin1_direction( D0_USED ? ( DPHY_RX_EN == 1 ? "PIN1_DIRECTION_IN" : "PIN1_DIRECTION_OUT" ) : "QPDS_UNSET"),
        .pin2_direction( D1_USED ? ( DPHY_RX_EN == 1 ? "PIN2_DIRECTION_IN" : "PIN2_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin3_direction( D1_USED ? ( DPHY_RX_EN == 1 ? "PIN3_DIRECTION_IN" : "PIN3_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin4_direction( CK_USED ? ( DPHY_RX_EN == 1 ? "PIN4_DIRECTION_IN" : "PIN4_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin5_direction( CK_USED ? ( DPHY_RX_EN == 1 ? "PIN5_DIRECTION_IN" : "PIN5_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin6_direction( D2_USED ? ( DPHY_RX_EN == 1 ? "PIN6_DIRECTION_IN" : "PIN6_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin7_direction( D2_USED ? ( DPHY_RX_EN == 1 ? "PIN7_DIRECTION_IN" : "PIN7_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin8_direction( D3_USED ? ( DPHY_RX_EN == 1 ? "PIN8_DIRECTION_IN" : "PIN8_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin9_direction( D3_USED ? ( DPHY_RX_EN == 1 ? "PIN9_DIRECTION_IN" : "PIN9_DIRECTION_OUT" ) : "QPDS_UNSET" ),
        .pin10_direction( "QPDS_UNSET" ),
        .pin11_direction( "QPDS_UNSET" ),
        
        .pin0_tx_rate( "PIN0_TX_RATE_DDR"),
        .pin1_tx_rate( "PIN1_TX_RATE_DDR"),
        .pin2_tx_rate( "PIN2_TX_RATE_DDR"),
        .pin3_tx_rate( "PIN3_TX_RATE_DDR"),
        .pin4_tx_rate( "PIN4_TX_RATE_DDR"),
        .pin5_tx_rate( "PIN5_TX_RATE_DDR"),
        .pin6_tx_rate( "PIN6_TX_RATE_DDR"),
        .pin7_tx_rate( "PIN7_TX_RATE_DDR"),
        .pin8_tx_rate( "PIN8_TX_RATE_DDR"),
        .pin9_tx_rate( "PIN9_TX_RATE_DDR"),
        .pin10_tx_rate( "PIN10_TX_RATE_DDR" ),
        .pin11_tx_rate( "PIN11_TX_RATE_DDR" ),

        .pin0_tx_usage( D0_USED_TX ? "PIN0_TX_USAGE_MIPI" : "PIN0_TX_USAGE_GPIO" ),
        .pin1_tx_usage( D0_USED_TX ? "PIN1_TX_USAGE_MIPI" : "PIN1_TX_USAGE_GPIO" ),
        .pin2_tx_usage( D1_USED_TX ? "PIN2_TX_USAGE_MIPI" : "PIN2_TX_USAGE_GPIO" ),
        .pin3_tx_usage( D1_USED_TX ? "PIN3_TX_USAGE_MIPI" : "PIN3_TX_USAGE_GPIO" ),
        .pin4_tx_usage( CK_USED_TX ? ( CONTINUOUS_CLK == 1 ? "PIN4_TX_USAGE_MIPI_CLK_CONTINUOUS" : "PIN4_TX_USAGE_MIPI_CLK" ) : "PIN4_TX_USAGE_GPIO" ),
        .pin5_tx_usage( CK_USED_TX ? ( CONTINUOUS_CLK == 1 ? "PIN5_TX_USAGE_MIPI_CLK_CONTINUOUS" : "PIN5_TX_USAGE_MIPI_CLK" ) : "PIN5_TX_USAGE_GPIO" ),
        .pin6_tx_usage( D2_USED_TX ? "PIN6_TX_USAGE_MIPI" : "PIN6_TX_USAGE_GPIO" ),
        .pin7_tx_usage( D2_USED_TX ? "PIN7_TX_USAGE_MIPI" : "PIN7_TX_USAGE_GPIO" ),
        .pin8_tx_usage( D3_USED_TX ? "PIN8_TX_USAGE_MIPI" : "PIN8_TX_USAGE_GPIO" ),
        .pin9_tx_usage( D3_USED_TX ? "PIN9_TX_USAGE_MIPI" : "PIN9_TX_USAGE_GPIO" ),
        .pin10_tx_usage( "PIN10_TX_USAGE_GPIO" ),
        .pin11_tx_usage( "PIN11_TX_USAGE_GPIO" ),

        .pin0_rx_bus_hold( D0_USED_RX ? "PIN0_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin1_rx_bus_hold( D0_USED_RX ? "PIN1_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin2_rx_bus_hold( D1_USED_RX ? "PIN2_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin3_rx_bus_hold( D1_USED_RX ? "PIN3_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin4_rx_bus_hold( CK_USED_RX ? "PIN4_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin5_rx_bus_hold( CK_USED_RX ? "PIN5_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin6_rx_bus_hold( D2_USED_RX ? "PIN6_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin7_rx_bus_hold( D2_USED_RX ? "PIN7_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin8_rx_bus_hold( D3_USED_RX ? "PIN8_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin9_rx_bus_hold( D3_USED_RX ? "PIN9_RX_BUS_HOLD_OFF" : "QPDS_UNSET" ),
        .pin10_rx_bus_hold( "QPDS_UNSET" ),
        .pin11_rx_bus_hold( "QPDS_UNSET" ),
        .pin0_rx_equalization( D0_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN0_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN0_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN0_RX_EQUALIZATION_MEDIUM" : "PIN0_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin1_rx_equalization( D0_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN1_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN1_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN1_RX_EQUALIZATION_MEDIUM" : "PIN1_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin2_rx_equalization( D1_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN2_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN2_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN2_RX_EQUALIZATION_MEDIUM" : "PIN2_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin3_rx_equalization( D1_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN3_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN3_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN3_RX_EQUALIZATION_MEDIUM" : "PIN3_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin4_rx_equalization( CK_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN4_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN4_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN4_RX_EQUALIZATION_MEDIUM" : "PIN4_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin5_rx_equalization( CK_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN5_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN5_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN5_RX_EQUALIZATION_MEDIUM" : "PIN5_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin6_rx_equalization( D2_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN6_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN6_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN6_RX_EQUALIZATION_MEDIUM" : "PIN6_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin7_rx_equalization( D2_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN7_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN7_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN7_RX_EQUALIZATION_MEDIUM" : "PIN7_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin8_rx_equalization( D3_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN8_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN8_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN8_RX_EQUALIZATION_MEDIUM" : "PIN8_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin9_rx_equalization( D3_USED_RX ? ( RX_CAP_EQ_MODE == 0 ? "PIN9_RX_EQUALIZATION_OFF" : RX_CAP_EQ_MODE == 1 ? "PIN9_RX_EQUALIZATION_SMALL" :
                                              RX_CAP_EQ_MODE == 2 ? "PIN9_RX_EQUALIZATION_MEDIUM" : "PIN9_RX_EQUALIZATION_LARGE" ) : "QPDS_UNSET" ),
        .pin10_rx_equalization( "QPDS_UNSET" ),
        .pin11_rx_equalization( "QPDS_UNSET" ),
        .pin0_rx_io_standard( D0_USED ? ( DPHY_RX_EN == 1 ? "PIN0_RX_IO_STANDARD_IOSTD_DPHY" : "PIN0_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin1_rx_io_standard( D0_USED ? ( DPHY_RX_EN == 1 ? "PIN1_RX_IO_STANDARD_IOSTD_DPHY" : "PIN1_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin2_rx_io_standard( D1_USED ? ( DPHY_RX_EN == 1 ? "PIN2_RX_IO_STANDARD_IOSTD_DPHY" : "PIN2_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin3_rx_io_standard( D1_USED ? ( DPHY_RX_EN == 1 ? "PIN3_RX_IO_STANDARD_IOSTD_DPHY" : "PIN3_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin4_rx_io_standard( CK_USED ? ( DPHY_RX_EN == 1 ? "PIN4_RX_IO_STANDARD_IOSTD_DPHY" : "PIN4_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin5_rx_io_standard( CK_USED ? ( DPHY_RX_EN == 1 ? "PIN5_RX_IO_STANDARD_IOSTD_DPHY" : "PIN5_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin6_rx_io_standard( D2_USED ? ( DPHY_RX_EN == 1 ? "PIN6_RX_IO_STANDARD_IOSTD_DPHY" : "PIN6_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin7_rx_io_standard( D2_USED ? ( DPHY_RX_EN == 1 ? "PIN7_RX_IO_STANDARD_IOSTD_DPHY" : "PIN7_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin8_rx_io_standard( D3_USED ? ( DPHY_RX_EN == 1 ? "PIN8_RX_IO_STANDARD_IOSTD_DPHY" : "PIN8_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin9_rx_io_standard( D3_USED ? ( DPHY_RX_EN == 1 ? "PIN9_RX_IO_STANDARD_IOSTD_DPHY" : "PIN9_RX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin10_rx_io_standard( "QPDS_UNSET" ),
        .pin11_rx_io_standard( "QPDS_UNSET" ),
        .pin0_rx_rzq_id( "QPDS_UNSET" ),
        .pin1_rx_rzq_id( "QPDS_UNSET" ),
        .pin2_rx_rzq_id( "QPDS_UNSET" ),
        .pin3_rx_rzq_id( "QPDS_UNSET" ),
        .pin4_rx_rzq_id( "QPDS_UNSET" ),
        .pin5_rx_rzq_id( "QPDS_UNSET" ),
        .pin6_rx_rzq_id( "QPDS_UNSET" ),
        .pin7_rx_rzq_id( "QPDS_UNSET" ),
        .pin8_rx_rzq_id( "QPDS_UNSET" ),
        .pin9_rx_rzq_id( "QPDS_UNSET" ),		 
        .pin10_rx_rzq_id( "QPDS_UNSET" ),
        .pin11_rx_rzq_id( "QPDS_UNSET" ),
	.pin0_rx_rzq_cycle( D0_USED_RX ? "QPDS_UNSET" : "PIN0_RX_RZQ_CYCLE_OFF"),	 
        .pin1_rx_rzq_cycle( D0_USED_RX ? "QPDS_UNSET" : "PIN1_RX_RZQ_CYCLE_OFF"),	 
        .pin2_rx_rzq_cycle( D1_USED_RX ? "QPDS_UNSET" : "PIN2_RX_RZQ_CYCLE_OFF"),	 
        .pin3_rx_rzq_cycle( D1_USED_RX ? "QPDS_UNSET" : "PIN3_RX_RZQ_CYCLE_OFF"),	 
        .pin4_rx_rzq_cycle( CK_USED_RX ? "QPDS_UNSET" : "PIN4_RX_RZQ_CYCLE_OFF"),	 
        .pin5_rx_rzq_cycle( CK_USED_RX ? "QPDS_UNSET" : "PIN5_RX_RZQ_CYCLE_OFF"),	 
        .pin6_rx_rzq_cycle( D2_USED_RX ? "QPDS_UNSET" : "PIN6_RX_RZQ_CYCLE_OFF"),	 
        .pin7_rx_rzq_cycle( D2_USED_RX ? "QPDS_UNSET" : "PIN7_RX_RZQ_CYCLE_OFF"),	 
        .pin8_rx_rzq_cycle( D3_USED_RX ? "QPDS_UNSET" : "PIN8_RX_RZQ_CYCLE_OFF"),	 
        .pin9_rx_rzq_cycle( D3_USED_RX ? "QPDS_UNSET" : "PIN9_RX_RZQ_CYCLE_OFF"),		 
        .pin10_rx_rzq_cycle( "PIN10_RX_RZQ_CYCLE_OFF" ),	 
        .pin11_rx_rzq_cycle( "PIN11_RX_RZQ_CYCLE_OFF" ),		 
        .pin0_rx_schmitt_trigger( D0_USED_RX ? "PIN0_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin1_rx_schmitt_trigger( D0_USED_RX ? "PIN1_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin2_rx_schmitt_trigger( D1_USED_RX ? "PIN2_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin3_rx_schmitt_trigger( D1_USED_RX ? "PIN3_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin4_rx_schmitt_trigger( CK_USED_RX ? "PIN4_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin5_rx_schmitt_trigger( CK_USED_RX ? "PIN5_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin6_rx_schmitt_trigger( D2_USED_RX ? "PIN6_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin7_rx_schmitt_trigger( D2_USED_RX ? "PIN7_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin8_rx_schmitt_trigger( D3_USED_RX ? "PIN8_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin9_rx_schmitt_trigger( D3_USED_RX ? "PIN9_RX_SCHMITT_TRIGGER_OFF" : "QPDS_UNSET" ),
        .pin10_rx_schmitt_trigger( "QPDS_UNSET" ),
        .pin11_rx_schmitt_trigger( "QPDS_UNSET" ),

        .pin0_rx_termination( D0_USED_RX ? "PIN0_RX_TERMINATION_RT_DIFF" : ( D0_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN0_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin1_rx_termination( D0_USED_RX ? "PIN1_RX_TERMINATION_RT_DIFF" : ( D0_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN1_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin2_rx_termination( D1_USED_RX ? "PIN2_RX_TERMINATION_RT_DIFF" : ( D1_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN2_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin3_rx_termination( D1_USED_RX ? "PIN3_RX_TERMINATION_RT_DIFF" : ( D1_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN3_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin4_rx_termination( CK_USED_RX ? "PIN4_RX_TERMINATION_RT_DIFF" : ( CK_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN4_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin5_rx_termination( CK_USED_RX ? "PIN5_RX_TERMINATION_RT_DIFF" : ( CK_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN5_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin6_rx_termination( D2_USED_RX ? "PIN6_RX_TERMINATION_RT_DIFF" : ( D2_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN6_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin7_rx_termination( D2_USED_RX ? "PIN7_RX_TERMINATION_RT_DIFF" : ( D2_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN7_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin8_rx_termination( D3_USED_RX ? "PIN8_RX_TERMINATION_RT_DIFF" : ( D3_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN8_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin9_rx_termination( D3_USED_RX ? "PIN9_RX_TERMINATION_RT_DIFF" : ( D3_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN9_RX_TERMINATION_RT_OFF" : "QPDS_UNSET" ) ),
        .pin10_rx_termination( "QPDS_UNSET" ),
        .pin11_rx_termination( "QPDS_UNSET" ),
		 
        .pin0_rx_usage_mode( D0_USED_RX ? "PIN0_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin1_rx_usage_mode( D0_USED_RX ? "PIN1_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin2_rx_usage_mode( D1_USED_RX ? "PIN2_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin3_rx_usage_mode( D1_USED_RX ? "PIN3_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin4_rx_usage_mode( CK_USED_RX ? "PIN4_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin5_rx_usage_mode( CK_USED_RX ? "PIN5_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin6_rx_usage_mode( D2_USED_RX ? "PIN6_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin7_rx_usage_mode( D2_USED_RX ? "PIN7_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin8_rx_usage_mode( D3_USED_RX ? "PIN8_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin9_rx_usage_mode( D3_USED_RX ? "PIN9_RX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin10_rx_usage_mode( "QPDS_UNSET" ),
        .pin11_rx_usage_mode( "QPDS_UNSET" ),

        .pin0_rx_vref( D0_USED_RX ? "PIN0_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin1_rx_vref( D0_USED_RX ? "PIN1_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin2_rx_vref( D1_USED_RX ? "PIN2_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin3_rx_vref( D1_USED_RX ? "PIN3_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin4_rx_vref( CK_USED_RX ? "PIN4_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin5_rx_vref( CK_USED_RX ? "PIN5_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin6_rx_vref( D2_USED_RX ? "PIN6_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin7_rx_vref( D2_USED_RX ? "PIN7_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin8_rx_vref( D3_USED_RX ? "PIN8_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin9_rx_vref( D3_USED_RX ? "PIN9_RX_VREF_OFF" : "QPDS_UNSET" ),
        .pin10_rx_vref( "QPDS_UNSET" ),
        .pin11_rx_vref( "QPDS_UNSET" ),
        .pin0_rx_weak_pull_down( D0_USED_RX ? "PIN0_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin1_rx_weak_pull_down( D0_USED_RX ? "PIN1_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin2_rx_weak_pull_down( D1_USED_RX ? "PIN2_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin3_rx_weak_pull_down( D1_USED_RX ? "PIN3_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin4_rx_weak_pull_down( CK_USED_RX ? "PIN4_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin5_rx_weak_pull_down( CK_USED_RX ? "PIN5_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin6_rx_weak_pull_down( D2_USED_RX ? "PIN6_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin7_rx_weak_pull_down( D2_USED_RX ? "PIN7_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin8_rx_weak_pull_down( D3_USED_RX ? "PIN8_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin9_rx_weak_pull_down( D3_USED_RX ? "PIN9_RX_WEAK_PULL_DOWN_OFF" : "QPDS_UNSET" ),
        .pin10_rx_weak_pull_down( "QPDS_UNSET" ),
        .pin11_rx_weak_pull_down( "QPDS_UNSET" ),
        .pin0_rx_weak_pull_up( D0_USED_RX ? "PIN0_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin1_rx_weak_pull_up( D0_USED_RX ? "PIN1_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin2_rx_weak_pull_up( D1_USED_RX ? "PIN2_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin3_rx_weak_pull_up( D1_USED_RX ? "PIN3_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin4_rx_weak_pull_up( CK_USED_RX ? "PIN4_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin5_rx_weak_pull_up( CK_USED_RX ? "PIN5_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin6_rx_weak_pull_up( D2_USED_RX ? "PIN6_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin7_rx_weak_pull_up( D2_USED_RX ? "PIN7_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin8_rx_weak_pull_up( D3_USED_RX ? "PIN8_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin9_rx_weak_pull_up( D3_USED_RX ? "PIN9_RX_WEAK_PULL_UP_OFF" : "QPDS_UNSET" ),
        .pin10_rx_weak_pull_up( "QPDS_UNSET" ),
        .pin11_rx_weak_pull_up( "QPDS_UNSET" ),
        .pin0_tx_equalization( D0_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN0_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN0_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN0_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN0_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin1_tx_equalization( D0_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN1_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN1_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN1_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN1_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin2_tx_equalization( D1_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN2_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN2_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN2_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN2_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin3_tx_equalization( D1_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN3_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN3_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN3_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN3_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin4_tx_equalization( CK_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN4_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN4_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN4_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN4_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin5_tx_equalization( CK_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN5_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN5_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN5_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN5_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin6_tx_equalization( D2_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN6_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN6_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN6_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN6_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin7_tx_equalization( D2_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN7_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN7_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN7_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN7_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin8_tx_equalization( D3_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN8_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN8_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN8_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN8_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin9_tx_equalization( D3_USED_TX ? ( TX_CAP_EQ_MODE == 0 ? "PIN9_TX_EQUALIZATION_OFF" :
                                              TX_CAP_EQ_MODE == 1 ? "PIN9_TX_EQUALIZATION_2TAPS_MEDIUM_LP" :
                                              TX_CAP_EQ_MODE == 2 ? "PIN9_TX_EQUALIZATION_2TAPS_HIGH_LP" : "PIN9_TX_EQUALIZATION_2TAPS_MEDIUM_CZ" ) : "QPDS_UNSET" ),
        .pin10_tx_equalization( "QPDS_UNSET" ),
        .pin11_tx_equalization( "QPDS_UNSET" ),
        .pin0_tx_io_standard( D0_USED ? ( DPHY_TX_EN == 1 ? "PIN0_TX_IO_STANDARD_IOSTD_DPHY" : "PIN0_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin1_tx_io_standard( D0_USED ? ( DPHY_TX_EN == 1 ? "PIN1_TX_IO_STANDARD_IOSTD_DPHY" : "PIN1_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin2_tx_io_standard( D1_USED ? ( DPHY_TX_EN == 1 ? "PIN2_TX_IO_STANDARD_IOSTD_DPHY" : "PIN2_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin3_tx_io_standard( D1_USED ? ( DPHY_TX_EN == 1 ? "PIN3_TX_IO_STANDARD_IOSTD_DPHY" : "PIN3_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin4_tx_io_standard( CK_USED ? ( DPHY_TX_EN == 1 ? "PIN4_TX_IO_STANDARD_IOSTD_DPHY" : "PIN4_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin5_tx_io_standard( CK_USED ? ( DPHY_TX_EN == 1 ? "PIN5_TX_IO_STANDARD_IOSTD_DPHY" : "PIN5_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin6_tx_io_standard( D2_USED ? ( DPHY_TX_EN == 1 ? "PIN6_TX_IO_STANDARD_IOSTD_DPHY" : "PIN6_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin7_tx_io_standard( D2_USED ? ( DPHY_TX_EN == 1 ? "PIN7_TX_IO_STANDARD_IOSTD_DPHY" : "PIN7_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin8_tx_io_standard( D3_USED ? ( DPHY_TX_EN == 1 ? "PIN8_TX_IO_STANDARD_IOSTD_DPHY" : "PIN8_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        .pin9_tx_io_standard( D3_USED ? ( DPHY_TX_EN == 1 ? "PIN9_TX_IO_STANDARD_IOSTD_DPHY" : "PIN9_TX_IO_STANDARD_IOSTD_OFF" ) : "QPDS_UNSET" ),
        /*.pin0_tx_io_standard( D0_USED_TX ? "PIN0_TX_IO_STANDARD_IOSTD_DPHY" : "PIN0_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin1_tx_io_standard( D0_USED_TX ? "PIN1_TX_IO_STANDARD_IOSTD_DPHY" : "PIN1_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin2_tx_io_standard( D1_USED_TX ? "PIN2_TX_IO_STANDARD_IOSTD_DPHY" : "PIN2_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin3_tx_io_standard( D1_USED_TX ? "PIN3_TX_IO_STANDARD_IOSTD_DPHY" : "PIN3_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin4_tx_io_standard( CK_USED_TX ? "PIN4_TX_IO_STANDARD_IOSTD_DPHY" : "PIN4_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin5_tx_io_standard( CK_USED_TX ? "PIN5_TX_IO_STANDARD_IOSTD_DPHY" : "PIN5_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin6_tx_io_standard( D2_USED_TX ? "PIN6_TX_IO_STANDARD_IOSTD_DPHY" : "PIN6_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin7_tx_io_standard( D2_USED_TX ? "PIN7_TX_IO_STANDARD_IOSTD_DPHY" : "PIN7_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin8_tx_io_standard( D3_USED_TX ? "PIN8_TX_IO_STANDARD_IOSTD_DPHY" : "PIN8_TX_IO_STANDARD_IOSTD_OFF" ),
        .pin9_tx_io_standard( D3_USED_TX ? "PIN9_TX_IO_STANDARD_IOSTD_DPHY" : "PIN9_TX_IO_STANDARD_IOSTD_OFF" ),*/
        .pin10_tx_io_standard( "QPDS_UNSET" ),
        .pin11_tx_io_standard( "QPDS_UNSET" ),
        .pin0_tx_open_drain( D0_USED_TX ? "PIN0_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin1_tx_open_drain( D0_USED_TX ? "PIN1_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin2_tx_open_drain( D1_USED_TX ? "PIN2_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin3_tx_open_drain( D1_USED_TX ? "PIN3_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin4_tx_open_drain( CK_USED_TX ? "PIN4_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin5_tx_open_drain( CK_USED_TX ? "PIN5_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin6_tx_open_drain( D2_USED_TX ? "PIN6_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin7_tx_open_drain( D2_USED_TX ? "PIN7_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin8_tx_open_drain( D3_USED_TX ? "PIN8_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin9_tx_open_drain( D3_USED_TX ? "PIN9_TX_OPEN_DRAIN_OFF" : "QPDS_UNSET" ),
        .pin10_tx_open_drain( "QPDS_UNSET" ),
        .pin11_tx_open_drain( "QPDS_UNSET" ),
        .pin0_tx_rzq_id( "QPDS_UNSET" ),
        .pin1_tx_rzq_id( "QPDS_UNSET" ),
        .pin2_tx_rzq_id( "QPDS_UNSET" ),
        .pin3_tx_rzq_id( "QPDS_UNSET" ),
        .pin4_tx_rzq_id( "QPDS_UNSET" ),
        .pin5_tx_rzq_id( "QPDS_UNSET" ),
        .pin6_tx_rzq_id( "QPDS_UNSET" ),
        .pin7_tx_rzq_id( "QPDS_UNSET" ),
        .pin8_tx_rzq_id( "QPDS_UNSET" ),
        .pin9_tx_rzq_id( "QPDS_UNSET" ),		 
        .pin10_tx_rzq_id( "QPDS_UNSET" ),
        .pin11_tx_rzq_id( "QPDS_UNSET" ),
	    .pin0_tx_rzq_cycle( D0_USED_TX ? "QPDS_UNSET" : "PIN0_TX_RZQ_CYCLE_OFF"),	 
        .pin1_tx_rzq_cycle( D0_USED_TX ? "QPDS_UNSET" : "PIN1_TX_RZQ_CYCLE_OFF"),	 
        .pin2_tx_rzq_cycle( D1_USED_TX ? "QPDS_UNSET" : "PIN2_TX_RZQ_CYCLE_OFF"),	 
        .pin3_tx_rzq_cycle( D1_USED_TX ? "QPDS_UNSET" : "PIN3_TX_RZQ_CYCLE_OFF"),	 
        .pin4_tx_rzq_cycle( CK_USED_TX ? "QPDS_UNSET" : "PIN4_TX_RZQ_CYCLE_OFF"),	 
        .pin5_tx_rzq_cycle( CK_USED_TX ? "QPDS_UNSET" : "PIN5_TX_RZQ_CYCLE_OFF"),	 
        .pin6_tx_rzq_cycle( D2_USED_TX ? "QPDS_UNSET" : "PIN6_TX_RZQ_CYCLE_OFF"),	 
        .pin7_tx_rzq_cycle( D2_USED_TX ? "QPDS_UNSET" : "PIN7_TX_RZQ_CYCLE_OFF"),	 
        .pin8_tx_rzq_cycle( D3_USED_TX ? "QPDS_UNSET" : "PIN8_TX_RZQ_CYCLE_OFF"),	 
        .pin9_tx_rzq_cycle( D3_USED_TX ? "QPDS_UNSET" : "PIN9_TX_RZQ_CYCLE_OFF"),	 
        .pin10_tx_rzq_cycle( "PIN10_TX_RZQ_CYCLE_OFF" ),	 
        .pin11_tx_rzq_cycle( "PIN11_TX_RZQ_CYCLE_OFF" ),		 
        .pin0_tx_slew_rate( D0_USED_TX ? (BIT_RATE < 1500000000 ? "PIN0_TX_SLEW_RATE_FAST" : "PIN0_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin1_tx_slew_rate( D0_USED_TX ? (BIT_RATE < 1500000000 ? "PIN1_TX_SLEW_RATE_FAST" : "PIN1_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin2_tx_slew_rate( D1_USED_TX ? (BIT_RATE < 1500000000 ? "PIN2_TX_SLEW_RATE_FAST" : "PIN2_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin3_tx_slew_rate( D1_USED_TX ? (BIT_RATE < 1500000000 ? "PIN3_TX_SLEW_RATE_FAST" : "PIN3_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin4_tx_slew_rate( CK_USED_TX ? (BIT_RATE < 1500000000 ? "PIN4_TX_SLEW_RATE_FAST" : "PIN4_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin5_tx_slew_rate( CK_USED_TX ? (BIT_RATE < 1500000000 ? "PIN5_TX_SLEW_RATE_FAST" : "PIN5_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin6_tx_slew_rate( D2_USED_TX ? (BIT_RATE < 1500000000 ? "PIN6_TX_SLEW_RATE_FAST" : "PIN6_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin7_tx_slew_rate( D2_USED_TX ? (BIT_RATE < 1500000000 ? "PIN7_TX_SLEW_RATE_FAST" : "PIN7_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin8_tx_slew_rate( D3_USED_TX ? (BIT_RATE < 1500000000 ? "PIN8_TX_SLEW_RATE_FAST" : "PIN8_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin9_tx_slew_rate( D3_USED_TX ? (BIT_RATE < 1500000000 ? "PIN9_TX_SLEW_RATE_FAST" : "PIN9_TX_SLEW_RATE_FASTEST") : "QPDS_UNSET" ),
        .pin10_tx_slew_rate( "QPDS_UNSET" ),
        .pin11_tx_slew_rate( "QPDS_UNSET" ),
        .pin0_tx_termination( D0_USED_TX ? "PIN0_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin1_tx_termination( D0_USED_TX ? "PIN1_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin2_tx_termination( D1_USED_TX ? "PIN2_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin3_tx_termination( D1_USED_TX ? "PIN3_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin4_tx_termination( CK_USED_TX ? "PIN4_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin5_tx_termination( CK_USED_TX ? "PIN5_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin6_tx_termination( D2_USED_TX ? "PIN6_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin7_tx_termination( D2_USED_TX ? "PIN7_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin8_tx_termination( D3_USED_TX ? "PIN8_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin9_tx_termination( D3_USED_TX ? "PIN9_TX_TERMINATION_SERIES_45_OHM_CAL" : "QPDS_UNSET" ),
        .pin10_tx_termination( "QPDS_UNSET" ),
        .pin11_tx_termination( "QPDS_UNSET" ),

        .pin0_tx_usage_mode( D0_USED_TX ? "PIN0_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin1_tx_usage_mode( D0_USED_TX ? "PIN1_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin2_tx_usage_mode( D1_USED_TX ? "PIN2_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin3_tx_usage_mode( D1_USED_TX ? "PIN3_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin4_tx_usage_mode( CK_USED_TX ? "PIN4_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin5_tx_usage_mode( CK_USED_TX ? "PIN5_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin6_tx_usage_mode( D2_USED_TX ? "PIN6_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin7_tx_usage_mode( D2_USED_TX ? "PIN7_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin8_tx_usage_mode( D3_USED_TX ? "PIN8_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin9_tx_usage_mode( D3_USED_TX ? "PIN9_TX_USAGE_MODE_DPHY" : "QPDS_UNSET" ),
        .pin10_tx_usage_mode( "QPDS_UNSET" ),
        .pin11_tx_usage_mode( "QPDS_UNSET" ), 

        .pin01_diff_bus_hold( "QPDS_UNSET" ),
        .pin23_diff_bus_hold( "QPDS_UNSET" ),
        .pin45_diff_bus_hold( "QPDS_UNSET" ),
        .pin67_diff_bus_hold( "QPDS_UNSET" ),
        .pin89_diff_bus_hold( "QPDS_UNSET" ),
        .pin1011_diff_bus_hold( "QPDS_UNSET" ),
        .pin01_diff_io_standard( D0_USED ? "PIN01_DIFF_IO_STANDARD_IOSTD_OFF" : "QPDS_UNSET" ),
        .pin23_diff_io_standard( D1_USED ? "PIN23_DIFF_IO_STANDARD_IOSTD_OFF" : "QPDS_UNSET" ),
        .pin45_diff_io_standard( CK_USED ? "PIN45_DIFF_IO_STANDARD_IOSTD_OFF" : "QPDS_UNSET" ),
        .pin67_diff_io_standard( D2_USED ? "PIN67_DIFF_IO_STANDARD_IOSTD_OFF" : "QPDS_UNSET" ),                 
        .pin89_diff_io_standard( D3_USED ? "PIN89_DIFF_IO_STANDARD_IOSTD_OFF" : "QPDS_UNSET" ),
        .pin1011_diff_io_standard( "QPDS_UNSET" ),		 
        .pin01_diff_rx_equalization( "QPDS_UNSET" ),
        .pin23_diff_rx_equalization( "QPDS_UNSET" ),
        .pin45_diff_rx_equalization( "QPDS_UNSET" ),
        .pin67_diff_rx_equalization( "QPDS_UNSET" ),
        .pin89_diff_rx_equalization( "QPDS_UNSET" ),
        .pin1011_diff_rx_equalization( "QPDS_UNSET" ),
        .pin01_diff_rzq_id( "QPDS_UNSET" ),
        .pin23_diff_rzq_id( "QPDS_UNSET" ),
        .pin45_diff_rzq_id( "QPDS_UNSET" ),
        .pin67_diff_rzq_id( "QPDS_UNSET" ),
        .pin89_diff_rzq_id( "QPDS_UNSET" ),
        .pin1011_diff_rzq_id( "QPDS_UNSET" ),
        .pin01_diff_schmitt_trigger( "QPDS_UNSET" ),
        .pin23_diff_schmitt_trigger( "QPDS_UNSET" ),
        .pin45_diff_schmitt_trigger( "QPDS_UNSET" ),
        .pin67_diff_schmitt_trigger( "QPDS_UNSET" ),
        .pin89_diff_schmitt_trigger( "QPDS_UNSET" ),
        .pin1011_diff_schmitt_trigger( "QPDS_UNSET" ),
        .pin01_diff_termination( D0_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN01_DIFF_TERMINATION_RT_OFF" : "QPDS_UNSET" ),
        .pin23_diff_termination( D1_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN23_DIFF_TERMINATION_RT_OFF" : "QPDS_UNSET" ),
        .pin45_diff_termination( CK_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN45_DIFF_TERMINATION_RT_OFF" : "QPDS_UNSET" ),
        .pin67_diff_termination( D2_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN67_DIFF_TERMINATION_RT_OFF" : "QPDS_UNSET" ),
        .pin89_diff_termination( D3_USED_TX  && (CONTINUOUS_CLK == 1) ? "PIN89_DIFF_TERMINATION_RT_OFF" : "QPDS_UNSET" ),
        .pin1011_diff_termination( "QPDS_UNSET" ),
        .pin01_diff_usage_mode( "QPDS_UNSET" ),
        .pin23_diff_usage_mode( "QPDS_UNSET" ),
        .pin45_diff_usage_mode( "QPDS_UNSET" ),
        .pin67_diff_usage_mode( "QPDS_UNSET" ),
        .pin89_diff_usage_mode( "QPDS_UNSET" ),
	    .pin1011_diff_usage_mode( "QPDS_UNSET" ),

        .pin01_diff_vref( "QPDS_UNSET" ),
        .pin23_diff_vref( "QPDS_UNSET" ),
        .pin45_diff_vref( "QPDS_UNSET" ),
        .pin67_diff_vref( "QPDS_UNSET" ),
        .pin89_diff_vref( "QPDS_UNSET" ),
        .pin1011_diff_vref( "QPDS_UNSET" ),
        .pin01_diff_weak_pull_down( "QPDS_UNSET" ),
        .pin23_diff_weak_pull_down( "QPDS_UNSET" ),
        .pin45_diff_weak_pull_down( "QPDS_UNSET" ),
        .pin67_diff_weak_pull_down( "QPDS_UNSET" ),
        .pin89_diff_weak_pull_down( "QPDS_UNSET" ),
        .pin1011_diff_weak_pull_down( "QPDS_UNSET" ),
        .pin01_diff_weak_pull_up( "QPDS_UNSET" ),
        .pin23_diff_weak_pull_up( "QPDS_UNSET" ),
        .pin45_diff_weak_pull_up( "QPDS_UNSET" ),
        .pin67_diff_weak_pull_up( "QPDS_UNSET" ),
        .pin89_diff_weak_pull_up( "QPDS_UNSET" ),
        .pin1011_diff_weak_pull_up( "QPDS_UNSET" ),
        
        /*
*/
        .pin0_rx_gpio( "PIN0_RX_GPIO_OFF" ),
        .pin1_rx_gpio( "PIN1_RX_GPIO_OFF" ),
        .pin2_rx_gpio( "PIN2_RX_GPIO_OFF" ),
        .pin3_rx_gpio( "PIN3_RX_GPIO_OFF" ),
        .pin4_rx_gpio( "PIN4_RX_GPIO_OFF" ),
        .pin5_rx_gpio( "PIN5_RX_GPIO_OFF" ),
        .pin6_rx_gpio( "PIN6_RX_GPIO_OFF" ),
        .pin7_rx_gpio( "PIN7_RX_GPIO_OFF" ),
        .pin8_rx_gpio( "PIN8_RX_GPIO_OFF" ),
        .pin9_rx_gpio( "PIN9_RX_GPIO_OFF" ),
        .pin10_rx_gpio( "PIN10_RX_GPIO_OFF" ),
        .pin11_rx_gpio( "PIN11_RX_GPIO_OFF" ),
/*
        .pin0_rx_gpio( "PIN0_RX_GPIO_ON" ),
        .pin1_rx_gpio( "PIN1_RX_GPIO_ON" ),
        .pin2_rx_gpio( "PIN2_RX_GPIO_ON" ),
        .pin3_rx_gpio( "PIN3_RX_GPIO_ON" ),
        .pin4_rx_gpio( "PIN4_RX_GPIO_ON" ),
        .pin5_rx_gpio( "PIN5_RX_GPIO_ON" ),
        .pin6_rx_gpio( "PIN6_RX_GPIO_ON" ),
        .pin7_rx_gpio( "PIN7_RX_GPIO_ON" ),
        .pin8_rx_gpio( "PIN8_RX_GPIO_ON" ),
        .pin9_rx_gpio( "PIN9_RX_GPIO_ON" ),
        .pin10_rx_gpio( "PIN10_RX_GPIO_ON" ),
        .pin11_rx_gpio( "PIN11_RX_GPIO_ON" )
*/
        
        .pin0_rx_sampler_mode(D0_USED_RX ? "PIN0_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN0_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),
        .pin1_rx_sampler_mode(D0_USED_RX ? "PIN1_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN1_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE" ),        
        .pin2_rx_sampler_mode(D1_USED_RX ? "PIN2_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN2_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin3_rx_sampler_mode(D1_USED_RX ? "PIN3_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN3_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin4_rx_sampler_mode(CK_USED_RX ? "PIN4_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN4_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin5_rx_sampler_mode(CK_USED_RX ? "PIN5_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN5_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin6_rx_sampler_mode(D2_USED_RX ? "PIN6_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN6_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin7_rx_sampler_mode(D2_USED_RX ? "PIN7_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN7_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin8_rx_sampler_mode(D3_USED_RX ? "PIN8_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN8_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin9_rx_sampler_mode(D3_USED_RX ? "PIN9_RX_SAMPLER_MODE_MATCHED_LOW_COMMON_MODE" : "PIN9_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin10_rx_sampler_mode("PIN10_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE"),        
        .pin11_rx_sampler_mode("PIN11_RX_SAMPLER_MODE_MATCHED_HIGH_COMMON_MODE")
        
    ) byte_inst (
        .io_phy_pad_sig_bidir_out( io_phy_pad_sig_bidir_out ),        
        .io_phy_pad_sig_bidir_in( io_phy_pad_sig_bidir_in ),          
        .o_phy_io_pad_doe_0( o_phy_pad_doe[0] ),                      
        .o_phy_io_pad_doe_1( o_phy_pad_doe[1] ),                      
        .o_phy_io_pad_doe_2( o_phy_pad_doe[2] ),                      
        .o_phy_io_pad_doe_3( o_phy_pad_doe[3] ),                      
        .o_phy_io_pad_doe_4( o_phy_pad_doe[4] ),                      
        .o_phy_io_pad_doe_5( o_phy_pad_doe[5] ),                      
        .o_phy_io_pad_doe_6( o_phy_pad_doe[6] ),                      
        .o_phy_io_pad_doe_7( o_phy_pad_doe[7] ),                      
        .o_phy_io_pad_doe_8( o_phy_pad_doe[8] ),                      
        .o_phy_io_pad_doe_9( o_phy_pad_doe[9] ),                      
        .o_phy_io_pad_doe_10( o_phy_pad_doe[10] ),                    
        .o_phy_io_pad_doe_11( o_phy_pad_doe[11] ),                    
        .i_phy_tx_wr_data( i_phy_tx_wr_data ),                        
        .o_phy_core_data( o_phy_core_data ),                          
        .i_phy_gpio_dout( i_phy_gpio_dout ),                          
        .i_phy_gpio_oe( i_phy_gpio_oe ),                              
        .o_phy_gpio_din( phy_gpio_din ),                              
        .i_phy_gpio_dout_sel( i_phy_gpio_dout_sel ),                  
        .i_phy_tx_wr_dqs_en4_del( i_phy_tx_wr_dqs_en4_del ),          
        .i_phy_tx_wr_dqs_en5_del( i_phy_tx_wr_dqs_en5_del ),          
        .i_phy_tx_wr_dqs_en6_del( i_phy_tx_wr_dqs_en6_del ),          
        .i_phy_tx_wr_dqs_en7_del( i_phy_tx_wr_dqs_en7_del ),          
        .i_phy_tx_wrdata_en0_del( i_phy_tx_wrdata_en0_del ),          
        .i_phy_tx_wrdata_en1_del( i_phy_tx_wrdata_en1_del ),          
        .i_phy_tx_wrdata_en2_del( i_phy_tx_wrdata_en2_del ),          
        .i_phy_tx_wrdata_en3_del( i_phy_tx_wrdata_en3_del ),          
        .i_phy_tx_wrdata_en8_del( i_phy_tx_wrdata_en8_del ),          
        .i_phy_tx_wrdata_en9_del( i_phy_tx_wrdata_en9_del ),          
        .i_phy_tx_wrdata_en10_del( i_phy_tx_wrdata_en10_del ),        
        .i_phy_tx_wrdata_en11_del( i_phy_tx_wrdata_en11_del ),        
        .i_phy_tx_picode0( i_phy_tx_picode0 ),                        
        .i_phy_tx_picode1( i_phy_tx_picode1 ),                        
        .i_phy_tx_picode2( i_phy_tx_picode2 ),                        
        .i_phy_tx_picode3( i_phy_tx_picode3 ),                        
        .i_phy_tx_picode4( i_phy_tx_picode4 ),                        
        .i_phy_tx_picode5( i_phy_tx_picode5 ),                        
        .i_phy_tx_picode6( i_phy_tx_picode6 ),                        
        .i_phy_tx_picode7( i_phy_tx_picode7 ),                        
        .i_phy_tx_picode8( i_phy_tx_picode8 ),                        
        .i_phy_tx_picode9( i_phy_tx_picode9 ),                        
        .i_phy_tx_picode10( i_phy_tx_picode10 ),                      
        .i_phy_tx_picode11( i_phy_tx_picode11 ),                      
        .i_phy_byte_tx_ctrl( i_phy_byte_tx_ctrl ),                    
        .i_phy_fifo_pack_select( i_phy_fifo_pack_select ),            

        .i_phy_fifo_read_enable_upper( i_phy_fifo_read_enable_upper ),            
        .i_phy_fifo_read_enable_lower( i_phy_fifo_read_enable_lower ),            
        .i_phy_trainreset( i_phy_trainreset ),                        
        .i_phy_byte_rx_ctrl( i_phy_byte_rx_ctrl ),                    
        .i_phy_txclk_gated( i_phy_txclk_gated ),                      
        .i_phy_rxclk_gated( i_phy_rxclk_gated ),                      
        .i_phy_tx_clkrefdivby2( i_phy_tx_clkrefdivby2 ),              
        .i_phy_tx_clkpi( i_phy_tx_clkpi ),                            
        .i_phy_sdll0_dqsp( i_phy_sdll0_dqsp ),                        
        .i_phy_sdll0_dqsn( i_phy_sdll0_dqsn ),                        
        .i_phy_sdll1_dqsp( i_phy_sdll1_dqsp ),                        
        .i_phy_sdll1_dqsn( i_phy_sdll1_dqsn ),                        
        .o_phy_rx_dqs_p4( o_phy_rx_dqs_p4 ),                          
        .o_phy_rx_dqs_n4( o_phy_rx_dqs_n4 ),                          
        .o_phy_rx_dqs_amp_p5( o_phy_rx_dqs_amp_p5 ),                  
        .o_phy_rx_dqs_p6( o_phy_rx_dqs_p6 ),                          
        .o_phy_rx_dqs_n6( o_phy_rx_dqs_n6 ),                          
        .o_phy_rx_dqs_amp_p7( o_phy_rx_dqs_amp_p7 ),                  
        .i_phy_avbb_avl_in_clk(),                                     
        .i_phy_avbb_avl_in_rst_n(),                                   
        .i_phy_avbb_avl_in_avm_address(),                             
        .i_phy_avbb_avl_in_avm_read(),                                
        .i_phy_avbb_avl_in_avm_write(),                               
        .i_phy_avbb_avl_in_avm_writedata(),                           

        .i_phy_dfi_dram_clock_disable(i_phy_dfi_dram_clock_disable),
        .i_phyclk_notgated(i_phyclk_notgated),

        .o_phy_avbb_avl_out_avm_readdata(  ),                         
        .o_phy_rx_fwdclk( o_phy_rx_fwdclk ),                          
        .i_phy_rx_senseampen( i_phy_rx_senseampen ),                  
        .i_phy_sdll0_rx_d0pienable( i_phy_sdll0_rx_d0pienable ),      
        .i_phy_sdll0_rx_d0rcvenpre( i_phy_sdll0_rx_d0rcvenpre ),      
        .i_phy_sdll0_rx_d0reset( i_phy_sdll0_rx_d0reset ),            
`ifdef REVA
        .i_phy_sdll0_rx_d0sdlparkvalue( i_phy_sdll0_rx_d0sdlparkvalue ), 
        .i_phy_sdll1_rx_d0sdlparkvalue( i_phy_sdll1_rx_d0sdlparkvalue ),  
`else
        .i_phy_parkclk_to_rxtop_n0_pl1( i_phy_parkclk_to_rxtop_n0_pl1 ), 
        .i_phy_parkclk_to_rxtop_n1_pl1( i_phy_parkclk_to_rxtop_n1_pl1 ), 
`endif
        .i_phy_sdll1_rx_d0pienable( i_phy_sdll1_rx_d0pienable ),      
        .i_phy_sdll1_rx_d0rcvenpre( i_phy_sdll1_rx_d0rcvenpre ),      
        .i_phy_sdll1_rx_d0reset( i_phy_sdll1_rx_d0reset ),            
	    .i_dcd_ter_en(i_dcd_ter_en),
	    .i_from_sdll0_o_dcdsawl_clk(i_from_sdll0_o_dcdsawl_clk),
	    .i_from_sdll1_o_dcdsawl_clk(i_from_sdll1_o_dcdsawl_clk),
        .i_dqsmode(i_dqsmode),
        .i_n0_odt_seg_rotate_en(i_n0_odt_seg_rotate_en),
        .i_n1_odt_seg_rotate_en(i_n1_odt_seg_rotate_en),
        .i_odt_en(i_odt_en),
        .i_odt_parken(i_odt_parken),
        .i_odt_parken_dqsn(i_odt_parken_dqsn),
        .i_phy_ddrcrdatacontrol0_enodtrotation(i_phy_ddrcrdatacontrol0_enodtrotation),
        .i_phy_ddrcrdatacontrol4_unmatchedrx(i_phy_ddrcrdatacontrol4_unmatchedrx),
        .i_phy_occ_phy_clk(i_phy_occ_phy_clk),
        .i_phy_phy_clk_gated(i_phy_phy_clk_gated),
        .i_phy_phy_reset_n(i_phy_phy_reset_n),
        .i_phy_rddata_en_dly(i_phy_rddata_en_dly),
        .i_phy_rx_d0cben(i_phy_rx_d0cben),
        .i_phy_rx_d0drvsel(i_phy_rx_d0drvsel),
        .i_phy_rx_dfemuxout_0(i_phy_rx_dfemuxout_0),
        .i_phy_rx_dfemuxout_1(i_phy_rx_dfemuxout_1),
        .i_phy_rx_rcvenmuxout_0(i_phy_rx_rcvenmuxout_0),
        .i_phy_rx_rcvenmuxout_1(i_phy_rx_rcvenmuxout_1),
        .i_phy_tx_wrdata_en0(i_phy_tx_wrdata_en0),
        .i_phy_tx_wrdata_en1(i_phy_tx_wrdata_en1),
        .i_phy_tx_wrdata_en2(i_phy_tx_wrdata_en2),
        .i_phy_tx_wrdata_en3(i_phy_tx_wrdata_en3),
        .i_phy_tx_wr_dqs_en4(i_phy_tx_wr_dqs_en4),
        .i_phy_tx_wr_dqs_en5(i_phy_tx_wr_dqs_en5),
        .i_phy_tx_wr_dqs_en6(i_phy_tx_wr_dqs_en6),
        .i_phy_tx_wr_dqs_en7(i_phy_tx_wr_dqs_en7),
        .i_phy_tx_wrdata_en8(i_phy_tx_wrdata_en8),
        .i_phy_tx_wrdata_en9(i_phy_tx_wrdata_en9),
        .i_phy_tx_wrdata_en10(i_phy_tx_wrdata_en10),
        .i_phy_tx_wrdata_en11(i_phy_tx_wrdata_en11),
        .i_rxfifo_rb_avm_wr_pipestage(i_rxfifo_rb_avm_wr_pipestage),
        .i_rxfifo_skew(i_rxfifo_skew),
        .i_rxfifo_spare(i_rxfifo_spare),
        .i_X1CounterDCCPin_00_DCCCount(i_X1CounterDCCPin_00_DCCCount),
        .i_X1CounterDCCPin_01_DCCCount(i_X1CounterDCCPin_01_DCCCount),
        .i_X1CounterDCCPin_02_DCCCount(i_X1CounterDCCPin_02_DCCCount),
        .i_X1CounterDCCPin_03_DCCCount(i_X1CounterDCCPin_03_DCCCount),
        .i_X1CounterDCCPin_04_DCCCount(i_X1CounterDCCPin_04_DCCCount),
        .i_X1CounterDCCPin_05_DCCCount(i_X1CounterDCCPin_05_DCCCount),
        .i_X1CounterDCCPin_06_DCCCount(i_X1CounterDCCPin_06_DCCCount),
        .i_X1CounterDCCPin_07_DCCCount(i_X1CounterDCCPin_07_DCCCount),
        .i_X1CounterDCCPin_08_DCCCount(i_X1CounterDCCPin_08_DCCCount),
        .i_X1CounterDCCPin_09_DCCCount(i_X1CounterDCCPin_09_DCCCount),
        .i_X1CounterDCCPin_10_DCCCount(i_X1CounterDCCPin_10_DCCCount),
        .i_X1CounterDCCPin_11_DCCCount(i_X1CounterDCCPin_11_DCCCount),
	    .o_DCCXtalkControl_DCCSamples(o_DCCXtalkControl_DCCSamples),
	    .o_DCCXtalkControl_RunDCC(o_DCCXtalkControl_RunDCC),
	    .o_DCCXtalkControl_SelMeasPoint(o_DCCXtalkControl_SelMeasPoint),
        .o_DDRCrRxEQRank01_RxDFETap0Rank0(o_DDRCrRxEQRank01_RxDFETap0Rank0),
        .o_DDRCrRxEQRank01_RxDFETap1Rank0(o_DDRCrRxEQRank01_RxDFETap1Rank0),
        .o_DDRCrRxEQRank01_RxDFETap2Rank0(o_DDRCrRxEQRank01_RxDFETap2Rank0),
        .o_DDRCrRxEQRank01_RxDFETap3Rank0(o_DDRCrRxEQRank01_RxDFETap3Rank0),
        .o_DDRCrRxEQRank01_RxDFETap0Rank1(o_DDRCrRxEQRank01_RxDFETap0Rank1),
        .o_DDRCrRxEQRank01_RxDFETap1Rank1(o_DDRCrRxEQRank01_RxDFETap1Rank1),
        .o_DDRCrRxEQRank01_RxDFETap2Rank1(o_DDRCrRxEQRank01_RxDFETap2Rank1),
        .o_DDRCrRxEQRank01_RxDFETap3Rank1(o_DDRCrRxEQRank01_RxDFETap3Rank1),
        .o_DDRCrRxEQRank23_RxDFETap0Rank2(o_DDRCrRxEQRank23_RxDFETap0Rank2),
        .o_DDRCrRxEQRank23_RxDFETap1Rank2(o_DDRCrRxEQRank23_RxDFETap1Rank2),
        .o_DDRCrRxEQRank23_RxDFETap2Rank2(o_DDRCrRxEQRank23_RxDFETap2Rank2),
        .o_DDRCrRxEQRank23_RxDFETap3Rank2(o_DDRCrRxEQRank23_RxDFETap3Rank2),
        .o_DDRCrRxEQRank23_RxDFETap0Rank3(o_DDRCrRxEQRank23_RxDFETap0Rank3),
        .o_DDRCrRxEQRank23_RxDFETap1Rank3(o_DDRCrRxEQRank23_RxDFETap1Rank3),
        .o_DDRCrRxEQRank23_RxDFETap2Rank3(o_DDRCrRxEQRank23_RxDFETap2Rank3),
        .o_DDRCrRxEQRank23_RxDFETap3Rank3(o_DDRCrRxEQRank23_RxDFETap3Rank3),
        .o_from_phy_rx_x16dqsn_p4(o_from_phy_rx_x16dqsn_p4),
        .o_from_phy_rx_x16dqsp_p4(o_from_phy_rx_x16dqsp_p4),
        .o_mipi_rb_rxdly_direct_ctrl(o_mipi_rb_rxdly_direct_ctrl),
        .o_mipi_rx_diff_en(o_mipi_rx_diff_en),
        .o_mipi_rx_dphylprxen(o_mipi_rx_dphylprxen),
        .o_phy_tx_wr_data_pl(o_phy_tx_wr_data_pl),
	    .o_rx_rxdqsampresult(o_rx_rxdqsampresult),
        .o_rxdphylprxen_0(o_rxdphylprxen[0]),
        .o_rxdphylprxen_1(o_rxdphylprxen[1]),
        .o_rxdphylprxen_2(o_rxdphylprxen[2]),
        .o_rxdphylprxen_3(o_rxdphylprxen[3]),
        .o_rxdphylprxen_4(o_rxdphylprxen[4]),
        .o_rxdphylprxen_5(o_rxdphylprxen[5]),
        .o_rxdphylprxen_6(o_rxdphylprxen[6]),
        .o_rxdphylprxen_7(o_rxdphylprxen[7]),
        .o_rxdphylprxen_8(o_rxdphylprxen[8]),
        .o_rxdphylprxen_9(o_rxdphylprxen[9]),
        .o_rxdphylprxen_10(o_rxdphylprxen[10]),
        .o_rxdphylprxen_11(o_rxdphylprxen[11]),
        .o_rxlvdien_0(o_rxlvdien[0]),
        .o_rxlvdien_1(o_rxlvdien[1]),
        .o_rxlvdien_2(o_rxlvdien[2]),
        .o_rxlvdien_3(o_rxlvdien[3]),
        .o_rxlvdien_4(o_rxlvdien[4]),
        .o_rxlvdien_5(o_rxlvdien[5]),
        .o_rxlvdien_6(o_rxlvdien[6]),
        .o_rxlvdien_7(o_rxlvdien[7]),
        .o_rxlvdien_8(o_rxlvdien[8]),
        .o_rxlvdien_9(o_rxlvdien[9]),
        .o_rxlvdien_10(o_rxlvdien[10]),
        .o_rxlvdien_11(o_rxlvdien[11]),
        .o_rzq_en(o_rzq_en),
        .o_tx_modectrl_4(o_tx_modectrl_4),
        .rxnpathenable_0(rxnpathenable[0]),
        .rxnpathenable_1(rxnpathenable[1]),
        .rxnpathenable_2(rxnpathenable[2]),
        .rxnpathenable_3(rxnpathenable[3]),
        .rxnpathenable_4(rxnpathenable[4]),
        .rxnpathenable_5(rxnpathenable[5]),
        .rxnpathenable_6(rxnpathenable[6]),
        .rxnpathenable_7(rxnpathenable[7]),
        .rxnpathenable_8(rxnpathenable[8]),
        .rxnpathenable_9(rxnpathenable[9]),
        .rxnpathenable_10(rxnpathenable[10]),
        .rxnpathenable_11(rxnpathenable[11]),
        .rxppathenable_0(rxppathenable[0]),
        .rxppathenable_1(rxppathenable[1]),
        .rxppathenable_2(rxppathenable[2]),
        .rxppathenable_3(rxppathenable[3]),
        .rxppathenable_4(rxppathenable[4]),
        .rxppathenable_5(rxppathenable[5]),
        .rxppathenable_6(rxppathenable[6]),
        .rxppathenable_7(rxppathenable[7]),
        .rxppathenable_8(rxppathenable[8]),
        .rxppathenable_9(rxppathenable[9]),
        .rxppathenable_10(rxppathenable[10]),
        .rxppathenable_11(rxppathenable[11]),
	    .i_phy_datatrainfeedback_dqsnparklovohcode(i_phy_datatrainfeedback_dqsnparklovohcode),
	    .i_phy_datatrainfeedback_dqsnparklowvoh(i_phy_datatrainfeedback_dqsnparklowvoh),
        .i_phy_ddrcrcmdbustrain_ddrdqovrddata(i_phy_ddrcrcmdbustrain_ddrdqovrddata),
        .i_phy_ddrcrcmdbustrain_ddrdqovrdmodeen(i_phy_ddrcrcmdbustrain_ddrdqovrdmodeen),
        .o_phy_cr_iamca_00(o_phy_cr_iamca_00),
        .o_phy_cr_iamca_01(o_phy_cr_iamca_01),
        .o_phy_cr_iamca_02(o_phy_cr_iamca_02),	 
        .o_phy_cr_iamca_03(o_phy_cr_iamca_03),
        .o_phy_cr_iamca_04(o_phy_cr_iamca_04),
        .o_phy_cr_iamca_05(o_phy_cr_iamca_05),	 
        .o_phy_cr_iamca_06(o_phy_cr_iamca_06),
        .o_phy_cr_iamca_07(o_phy_cr_iamca_07),
        .o_phy_cr_iamca_08(o_phy_cr_iamca_08),	 
        .o_phy_cr_iamca_09(o_phy_cr_iamca_09),
        .o_phy_cr_iamca_10(o_phy_cr_iamca_10),
        .o_phy_cr_iamca_11(o_phy_cr_iamca_11),
        .o_phy_mipi_idle(o_phy_mipi_idle),
        .from_io12phy_txdigitop_0_o_tx_drven_ph0_toviewdigin(from_io12phy_txdigitop_0_o_tx_drven_ph0_toviewdigin),
        .from_io12phy_txdigitop_0_o_tx_drven_ph1_toviewdigin(from_io12phy_txdigitop_0_o_tx_drven_ph1_toviewdigin),
	    .from_io12phy_txdigitop_4_o_tx_drven_ph0_toviewdigin(from_io12phy_txdigitop_4_o_tx_drven_ph0_toviewdigin),
	    .from_io12phy_txdigitop_4_o_tx_drven_ph1_toviewdigin(from_io12phy_txdigitop_4_o_tx_drven_ph1_toviewdigin),
	    .o_delayed_oe_p0_toviewdigin(o_delayed_oe_p0_toviewdigin),
	    .o_delayed_oe_p4_toviewdigin(o_delayed_oe_p4_toviewdigin),
	    .o_rb_txfifo_in_sel(o_rb_txfifo_in_sel),
	    .i_occ_mux_auxclk(i_occ_mux_auxclk),
	    .i_nbiasen(i_nbiasen),
	    .i_pbiasen(i_pbiasen)
   );
    
    
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oJjp6dkPfG3ZJglPm0ZkoAjM81keIe9z2rGdrpDsIwjW3y1kCsKGLOj/ZZhMc9qPscQ2Zb898+2N41ZFei/Aa+o6kJ22U5tpX7nkAP8vooOGx6pmgl+4A8OwUDQgI7wXZgtVkMcxONi1SWv/eV5jrIztk95TO0xRMFAu/5fn4XIJWOYOnBirvJ9gSw+AJUF/nmJcaSIaSTcpGTXW9iintir6i/Gr/1YmdmXdlxyvu2N4U4z+ik47YkuGT9Hap0BzQWOZ4fZg3DZIi0IOqblEZ0p0xM/ISM7Zv1l9+ucLD8TqzEcBPVKovUu9jVuVJRc61hbcVpfPmLFD3WAg/PInuMeoQHP68Kuljkph9GD8BwskQX/7VExdXCGEJJE+DvGYV81AYJ8MQiqLUj3E0In9HYRL+EBuyQf/dv443/W69K+ugGB87P5gPTcnsRVNJWZ4fz7beODiWZMDM4ez4Qfg3trgT5KtCwDZl96Rm493s83kVPDjJJ7gfB4IxJV7nf+RexGZnBx6rQiwEBXrK3lcCMHCfa561fVVeuNRx6Kq8/bthYI+7DhFlXLJ2Dugvvij7tesudQiX5qLBpt8ZC/yGC1vG++7Ha1k5Xp3ef4bxrEjVhD4NdjswI5qgXXvKwoGN0DtqF5m6zBExul3Q3bh9OCgBn7ve0RrinJoVEnBejRbICRU6Hijmn+zySWuvd1mT/EWFE2BmnoSbnEHyYS9YRoS8rzlsBbuD6Lo8XkBzSYxm7DRYWVhSyxoZF+aaXOOyz1UcPFKLwzMchf9owB4Opd"
`endif
