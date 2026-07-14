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
// Intel MIPI CSI-2 TX top level module
// *********************************************************************


`default_nettype none

module csi2_dphy_sys_csi2_tx_intel_mipi_csi2_300_sjb35xa #(
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
   input  wire                          tx_word_clk_hs_ck,
   output logic [1:0]                   tx_data_width_hs_ck,
   output logic [BYTES_PER_LANE*8-1:0]  tx_data_hs_ck,
   output logic [BYTES_PER_LANE*1-1:0]  tx_word_valid_hs_ck,
   output logic                         tx_eq_active_hs_ck,
   output logic                         tx_eq_level_hs_ck,
   output logic                         tx_request_hs_ck,
   input  wire                          tx_ready_hs_ck,
   output logic                         tx_data_transfer_en_hs_ck,
   output logic                         tx_skew_cal_hs_ck,
   output logic                         tx_alternate_cal_hs_ck,
   input  wire                          tx_clk_esc_ck,
   output logic                         tx_request_esc_ck,
   output logic [3:0]                   tx_request_type_esc_ck,
   output logic                         tx_lpdt_esc_ck,
   output logic                         tx_ulps_exit_ck,
   output logic                         tx_ulps_esc_ck,
   output logic [3:0]                   tx_trigger_esc_ck,
   output logic [7:0]                   tx_data_esc_ck,
   output logic                         tx_valid_esc_ck,
   input  wire                          tx_ready_esc_ck,
   output logic                         turn_request_ck,
   input  wire                          direction_ck,
   output logic                         turn_disable_ck,
   output logic                         force_rx_mode_ck,
   output logic                         force_tx_stop_mode_ck,
   input  wire                          stop_state_ck,
   output logic                         enable_ck,
   output logic                         alp_mode_ck,
   output logic                         tx_ulps_clk_ck,
   input  wire                          rx_ulps_clk_not_ck,
   input  wire                          ulps_active_not_ck,
   output logic                         tx_hsidle_clk_hs_ck,
   input  wire                          tx_hsidle_clk_ready_hs_ck,
   //
   // DATA LANE 0
   //
   input  wire                          tx_word_clk_hs_d0,
   output logic [1:0]                   tx_data_width_hs_d0,
   output logic [BYTES_PER_LANE*8-1:0]  tx_data_hs_d0,
   output logic [BYTES_PER_LANE*1-1:0]  tx_word_valid_hs_d0,
   output logic                         tx_eq_active_hs_d0,
   output logic                         tx_eq_level_hs_d0,
   output logic                         tx_request_hs_d0,
   input  wire                          tx_ready_hs_d0,
   output logic                         tx_data_transfer_en_hs_d0,
   output logic                         tx_skew_cal_hs_d0,
   output logic                         tx_alternate_cal_hs_d0,
   input  wire                          tx_clk_esc_d0,
   output logic                         tx_request_esc_d0,
   output logic [3:0]                   tx_request_type_esc_d0,
   output logic                         tx_lpdt_esc_d0,
   output logic                         tx_ulps_exit_d0,
   output logic                         tx_ulps_esc_d0,
   output logic [3:0]                   tx_trigger_esc_d0,
   output logic [7:0]                   tx_data_esc_d0,
   output logic                         tx_valid_esc_d0,
   input  wire                          tx_ready_esc_d0,
   output logic                         turn_request_d0,
   input  wire                          direction_d0,
   output logic                         turn_disable_d0,
   output logic                         force_rx_mode_d0,
   output logic                         force_tx_stop_mode_d0,
   input  wire                          stop_state_d0,
   output logic                         enable_d0,
   output logic                         alp_mode_d0,
   output logic                         tx_ulps_clk_d0,
   input  wire                          rx_ulps_clk_not_d0,
   input  wire                          ulps_active_not_d0,
   output logic                         tx_hsidle_clk_hs_d0,
   input  wire                          tx_hsidle_clk_ready_hs_d0,
   //
   // DATA LANE 1
   //
   input  wire                          tx_word_clk_hs_d1,
   output logic [1:0]                   tx_data_width_hs_d1,
   output logic [BYTES_PER_LANE*8-1:0]  tx_data_hs_d1,
   output logic [BYTES_PER_LANE*1-1:0]  tx_word_valid_hs_d1,
   output logic                         tx_eq_active_hs_d1,
   output logic                         tx_eq_level_hs_d1,
   output logic                         tx_request_hs_d1,
   input  wire                          tx_ready_hs_d1,
   output logic                         tx_data_transfer_en_hs_d1,
   output logic                         tx_skew_cal_hs_d1,
   output logic                         tx_alternate_cal_hs_d1,
   input  wire                          tx_clk_esc_d1,
   output logic                         tx_request_esc_d1,
   output logic [3:0]                   tx_request_type_esc_d1,
   output logic                         tx_lpdt_esc_d1,
   output logic                         tx_ulps_exit_d1,
   output logic                         tx_ulps_esc_d1,
   output logic [3:0]                   tx_trigger_esc_d1,
   output logic [7:0]                   tx_data_esc_d1,
   output logic                         tx_valid_esc_d1,
   input  wire                          tx_ready_esc_d1,
   output logic                         turn_request_d1,
   input  wire                          direction_d1,
   output logic                         turn_disable_d1,
   output logic                         force_rx_mode_d1,
   output logic                         force_tx_stop_mode_d1,
   input  wire                          stop_state_d1,
   output logic                         enable_d1,
   output logic                         alp_mode_d1,
   output logic                         tx_ulps_clk_d1,
   input  wire                          rx_ulps_clk_not_d1,
   input  wire                          ulps_active_not_d1,
   output logic                         tx_hsidle_clk_hs_d1,
   input  wire                          tx_hsidle_clk_ready_hs_d1,
   //
   // VIDEO STREAMING INTERFACE
   //
   input  wire                          axi4s_clk,
   input  wire                          axi4s_rst,
   input  wire  [VVP_DATA_WIDTH-1:0]    axi4s_vid_in_0_tdata,
   input  wire                          axi4s_vid_in_0_tvalid,
   output logic                         axi4s_vid_in_0_tready,
   input  wire                          axi4s_vid_in_0_tlast,
   input  wire  [VVP_USER_WIDTH-1:0]    axi4s_vid_in_0_tuser,
   //
   // AVALON-MM CONTROL INTERFACE
   //
   input  wire  [ 9:0]                  control_address,
   input  wire                          control_write,
   input  wire  [ 3:0]                  control_byteenable,
   input  wire  [31:0]                  control_writedata,
   input  wire                          control_read,
   output logic [31:0]                  control_readdata,
   output logic                         control_readdatavalid,
   output logic                         control_waitrequest,
   output logic                         control_irq
);

localparam int AVMM_ADDR_WIDTH      = 8;
localparam int AVMM_MUX_SEL_WIDTH   = 2;

localparam int TOTAL_AVMM_SLAVES  = 2;
localparam int PROTOCOL_SLAVE_NUM   = 0; // This is referring to MSB bits of control_address
localparam int AXI2CV_SLAVE_NUM     = 1; // This is referring to MSB bits of control_address
//localparam int UNUSED_SLAVE_NUM   = 2; // This is referring to MSB bits of control_address
//localparam int UNUSED_SLAVE_NUM   = 3; // This is referring to MSB bits of control_address

localparam  BYTES_IN_PARALLEL       = BYTES_PER_LANE*2 >= 4 ? BYTES_PER_LANE*2 : 4;

wire  [PIXELS_IN_PARALLEL*BITS_PER_PIXEL-1:0]   vid_in_data;
wire  [PIXELS_IN_PARALLEL-1:0]                  vid_in_de;
wire                                            vid_in_valid;
wire                                            vid_in_ready;
wire  [PIXELS_IN_PARALLEL-1:0]                  vid_in_eol;
wire  [5:0]                                     vid_in_dt;
wire  [3:0]                                     vid_in_vc;
wire                                            vid_in_even;
wire  [MIPI_DATA_WIDTH-1:0]                     aux_in_data;
wire  [MIPI_DATA_WIDTH/8-1:0]                   aux_in_de;
wire                                            aux_in_valid;
wire                                            aux_in_sop;
wire                                            aux_in_eop;
wire  [5:0]                                     aux_in_dt;
wire  [1:0]                                     aux_in_type;
wire  [3:0]                                     aux_in_vc;
wire  [$clog2(MIPI_DATA_WIDTH/8+1)-1:0]        aux_in_empty;
wire                                            aux_in_ready;

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
   .BYTES_PER_LANE(1)
) dphy_ppi_ck ();

// DPHY PPI interface signals mapping
   assign dphy_ppi.tx_word_clk_hs[0] = tx_word_clk_hs_d0;
   assign tx_data_width_hs_d0 = dphy_ppi.tx_data_width_hs[0];
   assign tx_data_hs_d0 = dphy_ppi.tx_data_hs[0];
   assign tx_word_valid_hs_d0 = dphy_ppi.tx_word_valid_hs[0];
   assign tx_eq_active_hs_d0 = dphy_ppi.tx_eq_active_hs[0];
   assign tx_eq_level_hs_d0 = dphy_ppi.tx_eq_level_hs[0];
   assign tx_request_hs_d0 = dphy_ppi.tx_request_hs[0];
   assign dphy_ppi.tx_ready_hs[0] = tx_ready_hs_d0;
   assign tx_data_transfer_en_hs_d0 = dphy_ppi.tx_data_transfer_en_hs[0];
   assign tx_skew_cal_hs_d0 = dphy_ppi.tx_skew_cal_hs[0];
   assign tx_alternate_cal_hs_d0 = dphy_ppi.tx_alternate_cal_hs[0];
   assign dphy_ppi.tx_clk_esc[0] = tx_clk_esc_d0;
   assign tx_request_esc_d0 = dphy_ppi.tx_request_esc[0];
   assign tx_request_type_esc_d0 = dphy_ppi.tx_request_type_esc[0];
   assign tx_lpdt_esc_d0 = dphy_ppi.tx_lpdt_esc[0];
   assign tx_ulps_exit_d0 = dphy_ppi.tx_ulps_exit[0];
   assign tx_ulps_esc_d0 = dphy_ppi.tx_ulps_esc[0];
   assign tx_trigger_esc_d0 = dphy_ppi.tx_trigger_esc[0];
   assign tx_data_esc_d0 = dphy_ppi.tx_data_esc[0];
   assign tx_valid_esc_d0 = dphy_ppi.tx_valid_esc[0];
   assign dphy_ppi.tx_ready_esc[0] = tx_ready_esc_d0;
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
   assign dphy_ppi.tx_word_clk_hs[1] = tx_word_clk_hs_d1;
   assign tx_data_width_hs_d1 = dphy_ppi.tx_data_width_hs[1];
   assign tx_data_hs_d1 = dphy_ppi.tx_data_hs[1];
   assign tx_word_valid_hs_d1 = dphy_ppi.tx_word_valid_hs[1];
   assign tx_eq_active_hs_d1 = dphy_ppi.tx_eq_active_hs[1];
   assign tx_eq_level_hs_d1 = dphy_ppi.tx_eq_level_hs[1];
   assign tx_request_hs_d1 = dphy_ppi.tx_request_hs[1];
   assign dphy_ppi.tx_ready_hs[1] = tx_ready_hs_d1;
   assign tx_data_transfer_en_hs_d1 = dphy_ppi.tx_data_transfer_en_hs[1];
   assign tx_skew_cal_hs_d1 = dphy_ppi.tx_skew_cal_hs[1];
   assign tx_alternate_cal_hs_d1 = dphy_ppi.tx_alternate_cal_hs[1];
   assign dphy_ppi.tx_clk_esc[1] = tx_clk_esc_d1;
   assign tx_request_esc_d1 = dphy_ppi.tx_request_esc[1];
   assign tx_request_type_esc_d1 = dphy_ppi.tx_request_type_esc[1];
   assign tx_lpdt_esc_d1 = dphy_ppi.tx_lpdt_esc[1];
   assign tx_ulps_exit_d1 = dphy_ppi.tx_ulps_exit[1];
   assign tx_ulps_esc_d1 = dphy_ppi.tx_ulps_esc[1];
   assign tx_trigger_esc_d1 = dphy_ppi.tx_trigger_esc[1];
   assign tx_data_esc_d1 = dphy_ppi.tx_data_esc[1];
   assign tx_valid_esc_d1 = dphy_ppi.tx_valid_esc[1];
   assign dphy_ppi.tx_ready_esc[1] = tx_ready_esc_d1;
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
assign dphy_ppi_ck.tx_word_clk_hs = tx_word_clk_hs_ck;
assign tx_data_width_hs_ck = dphy_ppi_ck.tx_data_width_hs;
assign tx_data_hs_ck = dphy_ppi_ck.tx_data_hs;
assign tx_word_valid_hs_ck = dphy_ppi_ck.tx_word_valid_hs;
assign tx_eq_active_hs_ck = dphy_ppi_ck.tx_eq_active_hs;
assign tx_eq_level_hs_ck = dphy_ppi_ck.tx_eq_level_hs;
assign tx_request_hs_ck = dphy_ppi_ck.tx_request_hs;
assign dphy_ppi_ck.tx_ready_hs = tx_ready_hs_ck;
assign tx_data_transfer_en_hs_ck = dphy_ppi_ck.tx_data_transfer_en_hs;
assign tx_skew_cal_hs_ck = dphy_ppi_ck.tx_skew_cal_hs;
assign tx_alternate_cal_hs_ck = dphy_ppi_ck.tx_alternate_cal_hs;
assign dphy_ppi_ck.tx_clk_esc = tx_clk_esc_ck;
assign tx_request_esc_ck = dphy_ppi_ck.tx_request_esc;
assign tx_request_type_esc_ck = dphy_ppi_ck.tx_request_type_esc;
assign tx_lpdt_esc_ck = dphy_ppi_ck.tx_lpdt_esc;
assign tx_ulps_exit_ck = dphy_ppi_ck.tx_ulps_exit;
assign tx_ulps_esc_ck = dphy_ppi_ck.tx_ulps_esc;
assign tx_trigger_esc_ck = dphy_ppi_ck.tx_trigger_esc;
assign tx_data_esc_ck = dphy_ppi_ck.tx_data_esc;
assign tx_valid_esc_ck = dphy_ppi_ck.tx_valid_esc;
assign dphy_ppi_ck.tx_ready_esc = tx_ready_esc_ck;
assign turn_request_ck = dphy_ppi_ck.turn_request;
assign dphy_ppi_ck.direction = direction_ck;
assign turn_disable_ck = dphy_ppi_ck.turn_disable;
assign force_rx_mode_ck = dphy_ppi_ck.force_rx_mode;
assign force_tx_stop_mode_ck = dphy_ppi_ck.force_tx_stop_mode;
assign dphy_ppi_ck.stop_state = stop_state_ck;
assign enable_ck = dphy_ppi_ck.enable;
assign alp_mode_ck = dphy_ppi_ck.alp_mode;
assign tx_ulps_clk_ck = dphy_ppi_ck.tx_ulps_clk;
assign dphy_ppi_ck.rx_ulps_clk_not = rx_ulps_clk_not_ck;
assign dphy_ppi_ck.ulps_active_not = ulps_active_not_ck;
assign tx_hsidle_clk_hs_ck = dphy_ppi_ck.tx_hsidle_clk_hs;
assign dphy_ppi_ck.tx_hsidle_clk_ready_hs = tx_hsidle_clk_ready_hs_ck;

mipi_tx_protocol #(
   .BYTES_PER_LANE           (BYTES_PER_LANE),
   .LANE                     (2),
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
   .BUFFER_DEPTH             (BUFFER_DEPTH),
   .ENABLE_MIPI_INTERFACE    (0),
   .MIPI_DATA_WIDTH          (MIPI_DATA_WIDTH),
   .NUM_MIPI_CHANNELS        (1),
   .CSR_AVMM_ADDR_WIDTH      (AVMM_ADDR_WIDTH),
   .ENABLE_CSR               (ENABLE_CSR),
   .ENABLE_ECC               (ENABLE_ECC),
   .ENABLE_CRC               (ENABLE_CRC)
) mipi_tx_protocol_inst (
   .vid_clk           (axi4s_clk),
   .vid_rst           (axi4s_rst),
   .vid_in_data,
   .vid_in_de,
   .vid_in_valid,
   .vid_in_ready,
   .vid_in_eol,
   .vid_in_dt,
   .vid_in_vc,
   .vid_in_even,
   .aux_in_data,
   .aux_in_de,
   .aux_in_valid,
   .aux_in_sop,
   .aux_in_eop,
   .aux_in_type,
   .aux_in_vc,
   .aux_in_dt,
   .aux_in_empty,
   .aux_in_ready,
   .axi4s_clk(1'b0),
   .axi4s_rst(1'b0),
   .axi4s_mipi_in_tdata(),
   .axi4s_mipi_in_tvalid(),
   .axi4s_mipi_in_tlast(),
   .axi4s_mipi_in_tuser(),
   .axi4s_mipi_in_tkeep(),
   .axi4s_mipi_in_tready(),
   .csr_clk           (axi4s_clk),
   .csr_rst           (axi4s_rst),
   .csr_address       (protocol_csr_address),
   .csr_write         (protocol_csr_write),
   .csr_byteenable    (protocol_csr_byteenable),
   .csr_writedata     (protocol_csr_writedata),
   .csr_read          (protocol_csr_read),
   .csr_readdata      (protocol_csr_readdata),
   .csr_readdatavalid (protocol_csr_readdatavalid),
   .csr_waitrequest   (protocol_csr_waitrequest),
   .csr_irq           (protocol_csr_irq),
   .dphy_ppi          (dphy_ppi),
   .dphy_ppi_ck       (dphy_ppi_ck)
);

logic [AVMM_ADDR_WIDTH-1:0]                     axi2cv_csr_address;
logic                                           axi2cv_csr_write;
logic [3:0]                                     axi2cv_csr_byteenable;
logic [31:0]                                    axi2cv_csr_writedata;
logic                                           axi2cv_csr_read;
logic [31:0]                                    axi2cv_csr_readdata;
logic                                           axi2cv_csr_readdatavalid;
logic                                           axi2cv_csr_waitrequest;

generate
   if (AXI2CV_SLAVE_NUM < TOTAL_AVMM_SLAVES) begin : g_AXI2CV_SLAVE_NUM
      localparam i = AXI2CV_SLAVE_NUM;
      // CSR Master to Slave Signals
      assign axi2cv_csr_write       = slave_avmm_write[i];
      assign axi2cv_csr_read        = slave_avmm_read[i];
      assign axi2cv_csr_writedata   = slave_avmm_writedata[i*32+:32];
      assign axi2cv_csr_address     = slave_avmm_address[i*AVMM_ADDR_WIDTH+:AVMM_ADDR_WIDTH];
      assign axi2cv_csr_byteenable  = slave_avmm_byteenable[i*4+:4];
      // CSR Slave to Master Signals
      assign slave_avmm_irq[i]               = 1'b0;
      assign slave_avmm_waitrequest[i]       = axi2cv_csr_waitrequest;
      assign slave_avmm_readdatavalid[i]     = axi2cv_csr_readdatavalid;
      assign slave_avmm_readdata[i*32+:32]   = axi2cv_csr_readdata;
   end
endgenerate

csi2_dphy_sys_csi2_tx_intel_mipi_csi2_intel_axi2cv_300_s44gidq #(
   .CLOCKS_ARE_SAME        (0),
   .USE_ACTUAL_VID_CLK     (0)
   // .FIFO_DEPTH          (1920)
) axi2cv_inst (
   .axi4s_clock_clk        (axi4s_clk),
   .axi4s_reset_reset      (axi4s_rst),
   .axi4s_vid_in_0_tdata,
   .axi4s_vid_in_0_tvalid,
   .axi4s_vid_in_0_tready,
   .axi4s_vid_in_0_tlast,
   .axi4s_vid_in_0_tuser,
   .csr_clock_clk          (axi4s_clk),
   .csr_address            ({1'b0, axi2cv_csr_address}),
   .csr_write              (axi2cv_csr_write),
   .csr_byteenable         (axi2cv_csr_byteenable),
   .csr_writedata          (axi2cv_csr_writedata),
   .csr_read               (axi2cv_csr_read),
   .csr_readdata           (axi2cv_csr_readdata),
   .csr_readdatavalid      (axi2cv_csr_readdatavalid),
   .csr_waitrequest        (axi2cv_csr_waitrequest),
   .cv_vid_clk             (axi4s_clk),
   .cv_vid_out_data        (vid_in_data),
   .cv_vid_out_datavalid   (vid_in_valid),
   .cv_vid_out_ready       (vid_in_ready),
   .cv_vid_out_de          (vid_in_de),
   .cv_vid_out_eol         (vid_in_eol),
   .cv_vid_out_dt          (vid_in_dt),
   .cv_vid_out_vc          (vid_in_vc),
   .cv_vid_out_even        (vid_in_even),
   .cv_aux_out_data        (aux_in_data),
   .cv_aux_out_de          (aux_in_de),
   .cv_aux_out_valid       (aux_in_valid),
   .cv_aux_out_sop         (aux_in_sop),
   .cv_aux_out_eop         (aux_in_eop),
   .cv_aux_out_dt          (aux_in_dt),
   .cv_aux_out_type        (aux_in_type),
   .cv_aux_out_vc          (aux_in_vc),
   .cv_aux_out_empty       (aux_in_empty),
   .cv_aux_out_ready       (aux_in_ready)
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

