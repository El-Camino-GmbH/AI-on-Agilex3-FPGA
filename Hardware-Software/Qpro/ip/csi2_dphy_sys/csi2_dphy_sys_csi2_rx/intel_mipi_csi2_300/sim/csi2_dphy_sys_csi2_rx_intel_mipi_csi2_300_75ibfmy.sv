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


// *********************************************************************
// Intel MIPI CSI-2 RX top level module
// *********************************************************************


`default_nettype none

module csi2_dphy_sys_csi2_rx_intel_mipi_csi2_300_75ibfmy #(
   parameter BITS_PER_LANE            = 16,
   parameter ENABLE_SCRAMBLING        = 0,
   parameter PIXELS_IN_PARALLEL       = 2,
   parameter SUPPORT_RGB444           = 0,
   parameter SUPPORT_RGB555           = 0,
   parameter SUPPORT_RGB565           = 0,
   parameter SUPPORT_RGB666           = 0,
   parameter SUPPORT_RGB888           = 0,
   parameter SUPPORT_LEGACY_YUV420_8B = 0,
   parameter SUPPORT_YUV420_8B        = 0,
   parameter SUPPORT_YUV420_10B       = 0,
   parameter SUPPORT_YUV422_8B        = 0,
   parameter SUPPORT_YUV422_10B       = 0,
   parameter SUPPORT_RAW6             = 0,
   parameter SUPPORT_RAW7             = 0,
   parameter SUPPORT_RAW8             = 0,
   parameter SUPPORT_RAW10            = 1,
   parameter SUPPORT_RAW12            = 0,
   parameter SUPPORT_RAW14            = 0,
   parameter SUPPORT_RAW16            = 0,
   parameter SUPPORT_RAW20            = 0,
   parameter SUPPORT_RAW24            = 0,
   parameter BUFFER_DEPTH             = 16384,
   parameter BITS_PER_PIXEL           = 10,
   parameter VVP_DATA_WIDTH           = 32,
   parameter VVP_USER_WIDTH           = 4,
   parameter MIPI_DATA_WIDTH          = 32,
   parameter MIPI_TUSER_WIDTH         = 1,
   parameter BYTES_PER_LANE           = BITS_PER_LANE/8,
   parameter ENABLE_CSR               = 1,
   parameter ENABLE_ECC               = 1,
   parameter ENABLE_CRC               = 1
)(
   //
   // DPHY PPI INTERFACE
   //
   // CLOCK LANE
   //
   input  wire                         rx_srst_n_ck,
   input  wire                         i_err_sot_hs_ck,
   input  wire                         i_err_sot_sync_hs_ck,
   input  wire                         i_err_esc_ck,
   input  wire                         i_err_sync_ck,
   input  wire                         i_err_control_ck,
   input  wire                         i_err_contention_lp0_ck,
   input  wire                         i_err_contention_lp1_ck,
   output logic                        o_err_sot_hs_ck,
   output logic                        o_err_sot_sync_hs_ck,
   output logic                        o_err_esc_ck,
   output logic                        o_err_sync_ck,
   output logic                        o_err_control_ck,
   output logic                        o_err_contention_lp0_ck,
   output logic                        o_err_contention_lp1_ck,
   input  wire                         rx_word_clk_hs_ck,
   output logic [1:0]                  rx_data_width_hs_ck,
   input  wire  [BYTES_PER_LANE*8-1:0] rx_data_hs_ck,
   input  wire  [BYTES_PER_LANE*1-1:0] rx_valid_hs_ck,
   input  wire                         rx_active_hs_ck,
   input  wire                         rx_sync_hs_ck,
   output logic                        rx_detect_eob_hs_ck,
   input  wire                         rx_clk_active_hs_ck,
   input  wire                         rx_ddr_clk_hs_ck,
   input  wire                         rx_skew_cal_hs_ck,
   input  wire                         rx_alternate_cal_hs_ck,
   input  wire                         rx_error_cal_hs_ck,
   input  wire                         rx_clk_esc_ck,
   input  wire                         rx_lpdt_esc_ck,
   input  wire                         rx_ulps_esc_ck,
   input  wire  [3:0]                  rx_trigger_esc_ck,
   input  wire                         rx_wake_up_ck,
   input  wire  [7:0]                  rx_data_esc_ck,
   input  wire                         rx_valid_esc_ck,
   output logic                        turn_request_ck,
   input  wire                         direction_ck,
   output logic                        turn_disable_ck,
   output logic                        force_rx_mode_ck,
   output logic                        force_tx_stop_mode_ck,
   input  wire                         stop_state_ck,
   output logic                        enable_ck,
   output logic                        alp_mode_ck,
   output logic                        tx_ulps_clk_ck,
   input  wire                         rx_ulps_clk_not_ck,
   input  wire                         ulps_active_not_ck,
   output logic                        tx_hsidle_clk_hs_ck,
   input  wire                         tx_hsidle_clk_ready_hs_ck,
   //
   // DATA LANE 0
   //
   input  wire                         rx_srst_n_d0,
   input  wire                         i_err_sot_hs_d0,
   input  wire                         i_err_sot_sync_hs_d0,
   input  wire                         i_err_esc_d0,
   input  wire                         i_err_sync_d0,
   input  wire                         i_err_control_d0,
   input  wire                         i_err_contention_lp0_d0,
   input  wire                         i_err_contention_lp1_d0,
   output logic                        o_err_sot_hs_d0,
   output logic                        o_err_sot_sync_hs_d0,
   output logic                        o_err_esc_d0,
   output logic                        o_err_sync_d0,
   output logic                        o_err_control_d0,
   output logic                        o_err_contention_lp0_d0,
   output logic                        o_err_contention_lp1_d0,
   input  wire                         rx_word_clk_hs_d0,
   output logic [1:0]                  rx_data_width_hs_d0,
   input  wire  [BYTES_PER_LANE*8-1:0] rx_data_hs_d0,
   input  wire  [BYTES_PER_LANE*1-1:0] rx_valid_hs_d0,
   input  wire                         rx_active_hs_d0,
   input  wire                         rx_sync_hs_d0,
   output logic                        rx_detect_eob_hs_d0,
   input  wire                         rx_clk_active_hs_d0,
   input  wire                         rx_ddr_clk_hs_d0,
   input  wire                         rx_skew_cal_hs_d0,
   input  wire                         rx_alternate_cal_hs_d0,
   input  wire                         rx_error_cal_hs_d0,
   input  wire                         rx_clk_esc_d0,
   input  wire                         rx_lpdt_esc_d0,
   input  wire                         rx_ulps_esc_d0,
   input  wire  [3:0]                  rx_trigger_esc_d0,
   input  wire                         rx_wake_up_d0,
   input  wire  [7:0]                  rx_data_esc_d0,
   input  wire                         rx_valid_esc_d0,
   output logic                        turn_request_d0,
   input  wire                         direction_d0,
   output logic                        turn_disable_d0,
   output logic                        force_rx_mode_d0,
   output logic                        force_tx_stop_mode_d0,
   input  wire                         stop_state_d0,
   output logic                        enable_d0,
   output logic                        alp_mode_d0,
   output logic                        tx_ulps_clk_d0,
   input  wire                         rx_ulps_clk_not_d0,
   input  wire                         ulps_active_not_d0,
   output logic                        tx_hsidle_clk_hs_d0,
   input  wire                         tx_hsidle_clk_ready_hs_d0,
   //
   // DATA LANE 1
   //
   input  wire                         rx_srst_n_d1,
   input  wire                         i_err_sot_hs_d1,
   input  wire                         i_err_sot_sync_hs_d1,
   input  wire                         i_err_esc_d1,
   input  wire                         i_err_sync_d1,
   input  wire                         i_err_control_d1,
   input  wire                         i_err_contention_lp0_d1,
   input  wire                         i_err_contention_lp1_d1,
   output logic                        o_err_sot_hs_d1,
   output logic                        o_err_sot_sync_hs_d1,
   output logic                        o_err_esc_d1,
   output logic                        o_err_sync_d1,
   output logic                        o_err_control_d1,
   output logic                        o_err_contention_lp0_d1,
   output logic                        o_err_contention_lp1_d1,
   input  wire                         rx_word_clk_hs_d1,
   output logic [1:0]                  rx_data_width_hs_d1,
   input  wire  [BYTES_PER_LANE*8-1:0] rx_data_hs_d1,
   input  wire  [BYTES_PER_LANE*1-1:0] rx_valid_hs_d1,
   input  wire                         rx_active_hs_d1,
   input  wire                         rx_sync_hs_d1,
   output logic                        rx_detect_eob_hs_d1,
   input  wire                         rx_clk_active_hs_d1,
   input  wire                         rx_ddr_clk_hs_d1,
   input  wire                         rx_skew_cal_hs_d1,
   input  wire                         rx_alternate_cal_hs_d1,
   input  wire                         rx_error_cal_hs_d1,
   input  wire                         rx_clk_esc_d1,
   input  wire                         rx_lpdt_esc_d1,
   input  wire                         rx_ulps_esc_d1,
   input  wire  [3:0]                  rx_trigger_esc_d1,
   input  wire                         rx_wake_up_d1,
   input  wire  [7:0]                  rx_data_esc_d1,
   input  wire                         rx_valid_esc_d1,
   output logic                        turn_request_d1,
   input  wire                         direction_d1,
   output logic                        turn_disable_d1,
   output logic                        force_rx_mode_d1,
   output logic                        force_tx_stop_mode_d1,
   input  wire                         stop_state_d1,
   output logic                        enable_d1,
   output logic                        alp_mode_d1,
   output logic                        tx_ulps_clk_d1,
   input  wire                         rx_ulps_clk_not_d1,
   input  wire                         ulps_active_not_d1,
   output logic                        tx_hsidle_clk_hs_d1,
   input  wire                         tx_hsidle_clk_ready_hs_d1,
   //
   // AVALON-MM CONTROL INTERFACE
   //
   //input  wire                         control_clk, // Use axi4s_clk for control interface. Create USE_AXI4S_CLK_FOR_CONTROL param to use separate clock.
   //input  wire                         control_rst,
   input  wire  [ 9:0]                 control_address,
   input  wire                         control_write,
   input  wire  [ 3:0]                 control_byteenable,
   input  wire  [31:0]                 control_writedata,
   input  wire                         control_read,
   output logic [31:0]                 control_readdata,
   output logic                        control_readdatavalid,
   output logic                        control_waitrequest,
   output logic                        control_irq,
   //
   // VIDEO STREAMING INTERFACE
   //
   output logic [VVP_DATA_WIDTH-1:0]   axi4s_vid_out_0_tdata,
   output logic                        axi4s_vid_out_0_tvalid,
   input  wire                         axi4s_vid_out_0_tready,
   output logic                        axi4s_vid_out_0_tlast,
   output logic [VVP_USER_WIDTH-1:0]   axi4s_vid_out_0_tuser,
   input  wire                         axi4s_clk,
   input  wire                         axi4s_rst
);

localparam int AVMM_ADDR_WIDTH      = 8;
localparam int AVMM_MUX_SEL_WIDTH   = 2;

localparam int TOTAL_AVMM_SLAVES  = 2;
localparam int PROTOCOL_SLAVE_NUM   = 0; // This is referring to MSB bits of control_address
localparam int CV2AXI_SLAVE_NUM     = 1; // This is referring to MSB bits of control_address
//localparam int UNUSED_SLAVE_NUM   = 2; // This is referring to MSB bits of control_address
//localparam int UNUSED_SLAVE_NUM   = 3; // This is referring to MSB bits of control_address

localparam  BYTES_IN_PARALLEL = BYTES_PER_LANE*2 >= 4 ? BYTES_PER_LANE*2 : 4;

logic [PIXELS_IN_PARALLEL*BITS_PER_PIXEL-1:0]   vid_out_data;
logic [PIXELS_IN_PARALLEL-1:0]                  vid_out_de;
logic                                           vid_out_valid;
logic [3:0]                                     vid_out_sof;
logic [PIXELS_IN_PARALLEL-1:0]                  vid_out_eol;
logic [5:0]                                     vid_out_dt;
logic [3:0]                                     vid_out_vc;
logic [3:0]                                     vid_out_interlaced;
logic [3:0]                                     vid_out_field;

// CSR mipi_protocol signals
logic [AVMM_ADDR_WIDTH-1:0]                     protocol_csr_address;
logic                                           protocol_csr_write;
logic [3:0]                                     protocol_csr_byteenable;
logic [31:0]                                    protocol_csr_writedata;
logic                                           protocol_csr_read;
logic [31:0]                                    protocol_csr_readdata;
logic                                           protocol_csr_readdatavalid;
logic                                           protocol_csr_waitrequest;
logic                                           protocol_csr_irq;
// CSR mux signals
logic [TOTAL_AVMM_SLAVES-1:0]                   slave_avmm_irq;
logic [TOTAL_AVMM_SLAVES-1:0]                   slave_avmm_waitrequest;
logic [TOTAL_AVMM_SLAVES-1:0]                   slave_avmm_readdatavalid;
logic [TOTAL_AVMM_SLAVES*32-1:0]                slave_avmm_readdata;
logic [TOTAL_AVMM_SLAVES-1:0]                   slave_avmm_write;
logic [TOTAL_AVMM_SLAVES-1:0]                   slave_avmm_read;
logic [TOTAL_AVMM_SLAVES*4-1:0]                 slave_avmm_byteenable;
logic [TOTAL_AVMM_SLAVES*32-1:0]                slave_avmm_writedata;
logic [TOTAL_AVMM_SLAVES*AVMM_ADDR_WIDTH-1:0]   slave_avmm_address;

generate
   if (PROTOCOL_SLAVE_NUM < TOTAL_AVMM_SLAVES) begin : g_PROTOCOL_SLAVE_NUM
      localparam i = PROTOCOL_SLAVE_NUM;
      // CSR Master to Slave Signals
      assign protocol_csr_write        = slave_avmm_write[i];
      assign protocol_csr_read         = slave_avmm_read[i];
      assign protocol_csr_writedata    = slave_avmm_writedata[i*32+:32];
      assign protocol_csr_address      = slave_avmm_address[i*AVMM_ADDR_WIDTH+:AVMM_ADDR_WIDTH];
      assign protocol_csr_byteenable   = slave_avmm_byteenable[i*4+:4];
      // CSR Slave to Master Signals
      assign slave_avmm_irq[i]               = protocol_csr_irq;
      assign slave_avmm_waitrequest[i]       = protocol_csr_waitrequest;
      assign slave_avmm_readdatavalid[i]     = protocol_csr_readdatavalid;
      assign slave_avmm_readdata[i*32+:32]   = protocol_csr_readdata;
   end
endgenerate

dphy_ppi_if #(
   .LANE(2),
   .BYTES_PER_LANE(BYTES_PER_LANE)
) dphy_ppi ();

dphy_ppi_if #(
   .LANE(1),
   .BYTES_PER_LANE(BYTES_PER_LANE)
) dphy_ppi_ck ();

// DPHY PPI interface signals mapping
   assign dphy_ppi.rx_srst[0] = rx_srst_n_d0;
   assign dphy_ppi.err_sot_hs[0] = i_err_sot_hs_d0;
   assign dphy_ppi.err_sot_sync_hs[0] = i_err_sot_sync_hs_d0;
   assign dphy_ppi.err_esc[0] = i_err_esc_d0;
   assign dphy_ppi.err_sync[0] = i_err_sync_d0;
   assign dphy_ppi.err_control[0] = i_err_control_d0;
   assign dphy_ppi.err_contention_lp0[0] = i_err_contention_lp0_d0;
   assign dphy_ppi.err_contention_lp1[0] = i_err_contention_lp1_d0;
   assign o_err_sot_hs_d0 = i_err_sot_hs_d0;
   assign o_err_sot_sync_hs_d0 = i_err_sot_sync_hs_d0;
   assign o_err_esc_d0 = i_err_esc_d0;
   assign o_err_sync_d0 = i_err_sync_d0;
   assign o_err_control_d0 = i_err_control_d0;
   assign o_err_contention_lp0_d0 = i_err_contention_lp0_d0;
   assign o_err_contention_lp1_d0 = i_err_contention_lp1_d0;
   assign dphy_ppi.rx_word_clk_hs[0] = rx_word_clk_hs_d0;
   assign rx_data_width_hs_d0 = dphy_ppi.rx_data_width_hs[0];
   assign dphy_ppi.rx_data_hs[0] = rx_data_hs_d0;
   assign dphy_ppi.rx_valid_hs[0] = rx_valid_hs_d0;
   assign dphy_ppi.rx_active_hs[0] = rx_active_hs_d0;
   assign dphy_ppi.rx_sync_hs[0] = rx_sync_hs_d0;
   assign rx_detect_eob_hs_d0 = dphy_ppi.rx_detect_eob_hs[0];
   assign dphy_ppi.rx_clk_active_hs[0] = rx_clk_active_hs_d0;
   assign dphy_ppi.rx_ddr_clk_hs[0] = rx_ddr_clk_hs_d0;
   assign dphy_ppi.rx_skew_cal_hs[0] = rx_skew_cal_hs_d0;
   assign dphy_ppi.rx_alternate_cal_hs[0] = rx_alternate_cal_hs_d0;
   assign dphy_ppi.rx_error_cal_hs[0] = rx_error_cal_hs_d0;
   assign dphy_ppi.rx_clk_esc[0] = rx_clk_esc_d0;
   assign dphy_ppi.rx_lpdt_esc[0] = rx_lpdt_esc_d0;
   assign dphy_ppi.rx_ulps_esc[0] = rx_ulps_esc_d0;
   assign dphy_ppi.rx_trigger_esc[0] = rx_trigger_esc_d0;
   assign dphy_ppi.rx_wake_up[0] = rx_wake_up_d0;
   assign dphy_ppi.rx_data_esc[0] = rx_data_esc_d0;
   assign dphy_ppi.rx_valid_esc[0] = rx_valid_esc_d0;
   assign turn_request_d0 = dphy_ppi.turn_request[0];
   assign dphy_ppi.direction[0] = direction_d0;
   assign turn_disable_d0 = dphy_ppi.turn_disable[0];
   assign force_rx_mode_d0 = dphy_ppi.force_rx_mode[0];
   assign force_tx_stop_mode_d0 = dphy_ppi.force_tx_stop_mode[0];
   assign dphy_ppi.stop_state[0] = stop_state_d0;
   assign enable_d0 = dphy_ppi.enable[0];
   assign alp_mode_d0 = dphy_ppi.alp_mode[0];
   assign tx_ulps_clk_d0 = dphy_ppi.tx_ulps_clk[0];
   assign dphy_ppi.rx_ulps_clk_not[0] = rx_ulps_clk_not_d0;
   assign dphy_ppi.ulps_active_not[0] = ulps_active_not_d0;
   assign tx_hsidle_clk_hs_d0 = dphy_ppi.tx_hsidle_clk_hs[0];
   assign dphy_ppi.tx_hsidle_clk_ready_hs[0] = tx_hsidle_clk_ready_hs_d0;
   assign dphy_ppi.rx_srst[1] = rx_srst_n_d1;
   assign dphy_ppi.err_sot_hs[1] = i_err_sot_hs_d1;
   assign dphy_ppi.err_sot_sync_hs[1] = i_err_sot_sync_hs_d1;
   assign dphy_ppi.err_esc[1] = i_err_esc_d1;
   assign dphy_ppi.err_sync[1] = i_err_sync_d1;
   assign dphy_ppi.err_control[1] = i_err_control_d1;
   assign dphy_ppi.err_contention_lp0[1] = i_err_contention_lp0_d1;
   assign dphy_ppi.err_contention_lp1[1] = i_err_contention_lp1_d1;
   assign o_err_sot_hs_d1 = i_err_sot_hs_d1;
   assign o_err_sot_sync_hs_d1 = i_err_sot_sync_hs_d1;
   assign o_err_esc_d1 = i_err_esc_d1;
   assign o_err_sync_d1 = i_err_sync_d1;
   assign o_err_control_d1 = i_err_control_d1;
   assign o_err_contention_lp0_d1 = i_err_contention_lp0_d1;
   assign o_err_contention_lp1_d1 = i_err_contention_lp1_d1;
   assign dphy_ppi.rx_word_clk_hs[1] = rx_word_clk_hs_d1;
   assign rx_data_width_hs_d1 = dphy_ppi.rx_data_width_hs[1];
   assign dphy_ppi.rx_data_hs[1] = rx_data_hs_d1;
   assign dphy_ppi.rx_valid_hs[1] = rx_valid_hs_d1;
   assign dphy_ppi.rx_active_hs[1] = rx_active_hs_d1;
   assign dphy_ppi.rx_sync_hs[1] = rx_sync_hs_d1;
   assign rx_detect_eob_hs_d1 = dphy_ppi.rx_detect_eob_hs[1];
   assign dphy_ppi.rx_clk_active_hs[1] = rx_clk_active_hs_d1;
   assign dphy_ppi.rx_ddr_clk_hs[1] = rx_ddr_clk_hs_d1;
   assign dphy_ppi.rx_skew_cal_hs[1] = rx_skew_cal_hs_d1;
   assign dphy_ppi.rx_alternate_cal_hs[1] = rx_alternate_cal_hs_d1;
   assign dphy_ppi.rx_error_cal_hs[1] = rx_error_cal_hs_d1;
   assign dphy_ppi.rx_clk_esc[1] = rx_clk_esc_d1;
   assign dphy_ppi.rx_lpdt_esc[1] = rx_lpdt_esc_d1;
   assign dphy_ppi.rx_ulps_esc[1] = rx_ulps_esc_d1;
   assign dphy_ppi.rx_trigger_esc[1] = rx_trigger_esc_d1;
   assign dphy_ppi.rx_wake_up[1] = rx_wake_up_d1;
   assign dphy_ppi.rx_data_esc[1] = rx_data_esc_d1;
   assign dphy_ppi.rx_valid_esc[1] = rx_valid_esc_d1;
   assign turn_request_d1 = dphy_ppi.turn_request[1];
   assign dphy_ppi.direction[1] = direction_d1;
   assign turn_disable_d1 = dphy_ppi.turn_disable[1];
   assign force_rx_mode_d1 = dphy_ppi.force_rx_mode[1];
   assign force_tx_stop_mode_d1 = dphy_ppi.force_tx_stop_mode[1];
   assign dphy_ppi.stop_state[1] = stop_state_d1;
   assign enable_d1 = dphy_ppi.enable[1];
   assign alp_mode_d1 = dphy_ppi.alp_mode[1];
   assign tx_ulps_clk_d1 = dphy_ppi.tx_ulps_clk[1];
   assign dphy_ppi.rx_ulps_clk_not[1] = rx_ulps_clk_not_d1;
   assign dphy_ppi.ulps_active_not[1] = ulps_active_not_d1;
   assign tx_hsidle_clk_hs_d1 = dphy_ppi.tx_hsidle_clk_hs[1];
   assign dphy_ppi.tx_hsidle_clk_ready_hs[1] = tx_hsidle_clk_ready_hs_d1;

// Clock Lane
assign dphy_ppi_ck.rx_srst = rx_srst_n_ck;
assign dphy_ppi_ck.err_sot_hs = i_err_sot_hs_ck;
assign dphy_ppi_ck.err_sot_sync_hs = i_err_sot_sync_hs_ck;
assign dphy_ppi_ck.err_esc = i_err_esc_ck;
assign dphy_ppi_ck.err_sync = i_err_sync_ck;
assign dphy_ppi_ck.err_control = i_err_control_ck;
assign dphy_ppi_ck.err_contention_lp0 = i_err_contention_lp0_ck;
assign dphy_ppi_ck.err_contention_lp1 = i_err_contention_lp1_ck;
assign o_err_sot_hs_ck = i_err_sot_hs_ck;
assign o_err_sot_sync_hs_ck = i_err_sot_sync_hs_ck;
assign o_err_esc_ck = i_err_esc_ck;
assign o_err_sync_ck = i_err_sync_ck;
assign o_err_control_ck = i_err_control_ck;
assign o_err_contention_lp0_ck = i_err_contention_lp0_ck;
assign o_err_contention_lp1_ck = i_err_contention_lp1_ck;
assign dphy_ppi_ck.rx_word_clk_hs = rx_word_clk_hs_ck;
assign rx_data_width_hs_ck = dphy_ppi_ck.rx_data_width_hs;
assign dphy_ppi_ck.rx_data_hs = rx_data_hs_ck;
assign dphy_ppi_ck.rx_valid_hs = rx_valid_hs_ck;
assign dphy_ppi_ck.rx_active_hs = rx_active_hs_ck;
assign dphy_ppi_ck.rx_sync_hs = rx_sync_hs_ck;
assign rx_detect_eob_hs_ck = dphy_ppi_ck.rx_detect_eob_hs;
assign dphy_ppi_ck.rx_clk_active_hs = rx_clk_active_hs_ck;
assign dphy_ppi_ck.rx_ddr_clk_hs = rx_ddr_clk_hs_ck;
assign dphy_ppi_ck.rx_skew_cal_hs = rx_skew_cal_hs_ck;
assign dphy_ppi_ck.rx_alternate_cal_hs = rx_alternate_cal_hs_ck;
assign dphy_ppi_ck.rx_error_cal_hs = rx_error_cal_hs_ck;
assign dphy_ppi_ck.rx_clk_esc = rx_clk_esc_ck;
assign dphy_ppi_ck.rx_lpdt_esc = rx_lpdt_esc_ck;
assign dphy_ppi_ck.rx_ulps_esc = rx_ulps_esc_ck;
assign dphy_ppi_ck.rx_trigger_esc = rx_trigger_esc_ck;
assign dphy_ppi_ck.rx_wake_up = rx_wake_up_ck;
assign dphy_ppi_ck.rx_data_esc = rx_data_esc_ck;
assign dphy_ppi_ck.rx_valid_esc = rx_valid_esc_ck;
assign dphy_ppi_ck.direction = direction_ck;
assign force_rx_mode_ck = dphy_ppi_ck.force_rx_mode;
assign dphy_ppi_ck.stop_state = stop_state_ck;
assign enable_ck = dphy_ppi_ck.enable;
assign alp_mode_ck = dphy_ppi_ck.alp_mode;
assign dphy_ppi_ck.rx_ulps_clk_not = rx_ulps_clk_not_ck;
assign dphy_ppi_ck.ulps_active_not = ulps_active_not_ck;
assign dphy_ppi_ck.tx_hsidle_clk_ready_hs = tx_hsidle_clk_ready_hs_ck;

// High-Speed Receive Signals
//assign  dphy_ppi_ck.rx_data_width_hs = $clog2(BYTES_PER_LANE);
//assign  dphy_ppi_ck.rx_detect_eob_hs = 1'b0; // Unsupported
// Control Signals
//assign  dphy_ppi_ck.force_rx_mode = 1'b0;
//assign  dphy_ppi_ck.enable = 1'b1;
assign  dphy_ppi_ck.alp_mode = 1'b0;

// Outputs Not used in CIL-SCNN
// Control Signals
assign turn_request_ck                 = 1'b0;
assign turn_disable_ck                 = 1'b0;
assign force_tx_stop_mode_ck           = 1'b0;
assign tx_ulps_clk_ck                  = 1'b0;
assign tx_hsidle_clk_hs_ck             = 1'b0;

mipi_rx_protocol #(
   .BYTES_PER_LANE           (BYTES_PER_LANE),
   .LANE                     (2),
   .BYTES_IN_PARALLEL        (BYTES_IN_PARALLEL),
   .ENABLE_SCRAMBLING        (ENABLE_SCRAMBLING),
   .ENABLE_VIDEO_INTERFACE   (1),
   .SUPPORT_RGB444           (SUPPORT_RGB444),
   .SUPPORT_RGB555           (SUPPORT_RGB555),
   .SUPPORT_RGB565           (SUPPORT_RGB565),
   .SUPPORT_RGB666           (SUPPORT_RGB666),
   .SUPPORT_RGB888           (SUPPORT_RGB888),
   .SUPPORT_LEGACY_YUV420_8B (SUPPORT_LEGACY_YUV420_8B),
   .SUPPORT_YUV420_8B        (SUPPORT_YUV420_8B),
   .SUPPORT_YUV420_10B       (SUPPORT_YUV420_10B),
   .SUPPORT_YUV422_8B        (SUPPORT_YUV422_8B),
   .SUPPORT_YUV422_10B       (SUPPORT_YUV422_10B),
   .SUPPORT_RAW6             (SUPPORT_RAW6),
   .SUPPORT_RAW7             (SUPPORT_RAW7),
   .SUPPORT_RAW8             (SUPPORT_RAW8),
   .SUPPORT_RAW10            (SUPPORT_RAW10),
   .SUPPORT_RAW12            (SUPPORT_RAW12),
   .SUPPORT_RAW14            (SUPPORT_RAW14),
   .SUPPORT_RAW16            (SUPPORT_RAW16),
   .SUPPORT_RAW20            (SUPPORT_RAW20),
   .SUPPORT_RAW24            (SUPPORT_RAW24),
   .BITS_PER_PIXEL           (BITS_PER_PIXEL),
   .PIXELS_IN_PARALLEL       (PIXELS_IN_PARALLEL),
   .ENABLE_MIPI_INTERFACE    (0),
   .MIPI_DATA_WIDTH          (MIPI_DATA_WIDTH),
   .FIFO_CLOCKS_ARE_SAME     (0),
   .FIFO_DEPTH               (BUFFER_DEPTH / PIXELS_IN_PARALLEL),
   .CSR_AVMM_ADDR_WIDTH      (AVMM_ADDR_WIDTH),
   .ENABLE_CSR               (ENABLE_CSR),
   .ENABLE_ECC               (ENABLE_ECC),
   .ENABLE_CRC               (ENABLE_CRC)
) mipi_rx_protocol_inst (
   .ls_clk             (dphy_ppi.rx_word_clk_hs[0]), // continuous and fixed clock
   .ls_rst             (~dphy_ppi.rx_srst[0]),
   .vid_clk            (axi4s_clk), // continuous and fixed clock
   .vid_rst            (axi4s_rst),
   .vid_out_data,
   .vid_out_de,
   .vid_out_valid,
   .vid_out_sof,
   .vid_out_eol,
   .vid_out_dt,
   .vid_out_vc,
   .vid_out_interlaced,
   .vid_out_field,
   .axi4s_clk(1'b0),
   .axi4s_rst(1'b0),
   .axi4s_mipi_out_tdata(),
   .axi4s_mipi_out_tvalid(),
   .axi4s_mipi_out_tlast(),
   .axi4s_mipi_out_tuser(),
   .axi4s_mipi_out_tkeep(),
   .axi4s_mipi_out_tready(1'b0),
   .csr_clk            (axi4s_clk),
   .csr_rst            (axi4s_rst),
   .csr_address        (protocol_csr_address),
   .csr_write          (protocol_csr_write),
   .csr_byteenable     (protocol_csr_byteenable),
   .csr_writedata      (protocol_csr_writedata),
   .csr_read           (protocol_csr_read),
   .csr_readdata       (protocol_csr_readdata),
   .csr_readdatavalid  (protocol_csr_readdatavalid),
   .csr_waitrequest    (protocol_csr_waitrequest),
   .csr_irq            (protocol_csr_irq),
   .dphy_ppi           (dphy_ppi),
   .dphy_ppi_ck        (dphy_ppi_ck)
);

logic [AVMM_ADDR_WIDTH-1:0] cv2axi_csr_address;
logic                       cv2axi_csr_write;
logic [                3:0] cv2axi_csr_byteenable;
logic [               31:0] cv2axi_csr_writedata;
logic                       cv2axi_csr_read;
logic [               31:0] cv2axi_csr_readdata;
logic                       cv2axi_csr_readdatavalid;
logic                       cv2axi_csr_waitrequest;
logic                       cv2axi_csr_irq;

generate
   if (CV2AXI_SLAVE_NUM < TOTAL_AVMM_SLAVES) begin : g_CV2AXI_SLAVE_NUM
      localparam i = CV2AXI_SLAVE_NUM;
      // CSR Master to Slave Signals
      assign cv2axi_csr_write = slave_avmm_write[i];
      assign cv2axi_csr_read = slave_avmm_read[i];
      assign cv2axi_csr_writedata = slave_avmm_writedata[i*32+:32];
      assign cv2axi_csr_address = slave_avmm_address[i*AVMM_ADDR_WIDTH+:AVMM_ADDR_WIDTH];
      assign cv2axi_csr_byteenable = slave_avmm_byteenable[i*4+:4];
      // CSR Slave to Master Signals
      assign slave_avmm_irq[i] = cv2axi_csr_irq;
      assign slave_avmm_waitrequest[i] = cv2axi_csr_waitrequest;
      assign slave_avmm_readdatavalid[i] = cv2axi_csr_readdatavalid;
      assign slave_avmm_readdata[i*32+:32] = cv2axi_csr_readdata;
   end
endgenerate

csi2_dphy_sys_csi2_rx_intel_mipi_csi2_intel_cv2axi_300_5fgsb2i #(
   .CLOCKS_ARE_SAME         (1),
   .FIFO_DEPTH              (BUFFER_DEPTH / PIXELS_IN_PARALLEL),
   .MIPI_TUSER_WIDTH        (MIPI_TUSER_WIDTH)
) cv2axi_inst (
   .cv_vid_clk              (axi4s_clk),
   .cv_vid_in_data          (vid_out_data),
   .cv_vid_in_de            (vid_out_de),
   .cv_vid_in_datavalid     (vid_out_valid),
   .cv_vid_in_sof           (vid_out_sof),
   .cv_vid_in_eol           (vid_out_eol),
   .cv_vid_in_dt            (vid_out_dt),
   .cv_vid_in_vc            (vid_out_vc),
   .cv_vid_in_interlaced    (vid_out_interlaced),
   .cv_vid_in_field         (vid_out_field),
   .cv_aux_in_data          (),
   .cv_aux_in_de            (),
   .cv_aux_in_sop           (),
   .cv_aux_in_eop           (),
   .axi4s_vid_out_0_tdata,
   .axi4s_vid_out_0_tvalid,
   .axi4s_vid_out_0_tready,
   .axi4s_vid_out_0_tlast,
   .axi4s_vid_out_0_tuser,
   .csr_clock_clk           (axi4s_clk),
   //.csr_rst                 (axi4s_rst),
   .csr_address             (cv2axi_csr_address),
   .csr_write               (cv2axi_csr_write),
   .csr_byteenable          (cv2axi_csr_byteenable),
   .csr_writedata           (cv2axi_csr_writedata),
   .csr_read                (cv2axi_csr_read),
   .csr_readdata            (cv2axi_csr_readdata),
   .csr_readdatavalid       (cv2axi_csr_readdatavalid),
   .csr_waitrequest         (cv2axi_csr_waitrequest),
   .csr_interrupt_irq       (cv2axi_csr_irq),
   .axi4s_clock_clk         (axi4s_clk),
   .axi4s_reset_reset       (axi4s_rst)
);

mipi_csr_ctrl_mux #(
    .TOTAL_AVMM_SLAVES          (TOTAL_AVMM_SLAVES),
    .AVMM_MUX_SEL_WIDTH         (AVMM_MUX_SEL_WIDTH),
    .AVMM_ADDR_WIDTH            (AVMM_ADDR_WIDTH)
) csr_ctrl_mux_inst (
    .csr_clk                    (axi4s_clk),
    .csr_rst                    (axi4s_rst),
    .control_read               (control_read),
    .control_write              (control_write),
    .control_byteenable         (control_byteenable),
    .control_writedata          (control_writedata),
    .control_address            (control_address),
    .control_readdata           (control_readdata),
    .control_readdatavalid      (control_readdatavalid),
    .control_waitrequest        (control_waitrequest),
    .control_irq                (control_irq),

    .slave_avmm_readdatavalid   (slave_avmm_readdatavalid),
    .slave_avmm_waitrequest     (slave_avmm_waitrequest),
    .slave_avmm_readdata        (slave_avmm_readdata),
    .slave_avmm_irq             (slave_avmm_irq),
    .slave_avmm_read            (slave_avmm_read),
    .slave_avmm_write           (slave_avmm_write),
    .slave_avmm_byteenable      (slave_avmm_byteenable),
    .slave_avmm_writedata       (slave_avmm_writedata),
    .slave_avmm_address         (slave_avmm_address)
);

endmodule

`default_nettype wire

