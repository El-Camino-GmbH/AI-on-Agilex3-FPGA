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


`ifndef EASIC
    `define begin(label) begin : label
`else
    `define begin(label) begin
`endif

module intel_vvp_axi4s_broadcaster_core #(
    DEVICE_FAMILY           = "Agilex 7",

    VVP_INTF_TYPE           = "Full",
    BPS                     = 10,
    NUMBER_OF_COLOR_PLANES  = 3,
    PIXELS_IN_PARALLEL      = 2,
    OUTPUTS                 = 1,

    GLOBAL_STALL            = 0,

    IN_TREADY               = 1,

    OUT_0_TREADY            = 1,
    OUT_1_TREADY            = 1,
    OUT_2_TREADY            = 1,
    OUT_3_TREADY            = 1,
    OUT_4_TREADY            = 1,
    OUT_5_TREADY            = 1,
    OUT_6_TREADY            = 1,
    OUT_7_TREADY            = 1,
    OUT_8_TREADY            = 1,
    OUT_9_TREADY            = 1,
    OUT_10_TREADY           = 1,
    OUT_11_TREADY           = 1,
    OUT_12_TREADY           = 1,
    OUT_13_TREADY           = 1,
    OUT_14_TREADY           = 1,
    OUT_15_TREADY           = 1,
    OUT_16_TREADY           = 1,
    OUT_17_TREADY           = 1,
    OUT_18_TREADY           = 1,
    OUT_19_TREADY           = 1,
    OUT_20_TREADY           = 1,
    OUT_21_TREADY           = 1,
    OUT_22_TREADY           = 1,
    OUT_23_TREADY           = 1,
    OUT_24_TREADY           = 1,
    OUT_25_TREADY           = 1,
    OUT_26_TREADY           = 1,
    OUT_27_TREADY           = 1,
    OUT_28_TREADY           = 1,
    OUT_29_TREADY           = 1,
    OUT_30_TREADY           = 1,
    OUT_31_TREADY           = 1,

    OUT_0_FIFO              = 1,
    OUT_1_FIFO              = 1,
    OUT_2_FIFO              = 1,
    OUT_3_FIFO              = 1,
    OUT_4_FIFO              = 1,
    OUT_5_FIFO              = 1,
    OUT_6_FIFO              = 1,
    OUT_7_FIFO              = 1,
    OUT_8_FIFO              = 1,
    OUT_9_FIFO              = 1,
    OUT_10_FIFO             = 1,
    OUT_11_FIFO             = 1,
    OUT_12_FIFO             = 1,
    OUT_13_FIFO             = 1,
    OUT_14_FIFO             = 1,
    OUT_15_FIFO             = 1,
    OUT_16_FIFO             = 1,
    OUT_17_FIFO             = 1,
    OUT_18_FIFO             = 1,
    OUT_19_FIFO             = 1,
    OUT_20_FIFO             = 1,
    OUT_21_FIFO             = 1,
    OUT_22_FIFO             = 1,
    OUT_23_FIFO             = 1,
    OUT_24_FIFO             = 1,
    OUT_25_FIFO             = 1,
    OUT_26_FIFO             = 1,
    OUT_27_FIFO             = 1,
    OUT_28_FIFO             = 1,
    OUT_29_FIFO             = 1,
    OUT_30_FIFO             = 1,
    OUT_31_FIFO             = 1,

    OUT_0_FIFO_DEPTH        = 1024,
    OUT_1_FIFO_DEPTH        = 1024,
    OUT_2_FIFO_DEPTH        = 1024,
    OUT_3_FIFO_DEPTH        = 1024,
    OUT_4_FIFO_DEPTH        = 1024,
    OUT_5_FIFO_DEPTH        = 1024,
    OUT_6_FIFO_DEPTH        = 1024,
    OUT_7_FIFO_DEPTH        = 1024,
    OUT_8_FIFO_DEPTH        = 1024,
    OUT_9_FIFO_DEPTH        = 1024,
    OUT_10_FIFO_DEPTH       = 1024,
    OUT_11_FIFO_DEPTH       = 1024,
    OUT_12_FIFO_DEPTH       = 1024,
    OUT_13_FIFO_DEPTH       = 1024,
    OUT_14_FIFO_DEPTH       = 1024,
    OUT_15_FIFO_DEPTH       = 1024,
    OUT_16_FIFO_DEPTH       = 1024,
    OUT_17_FIFO_DEPTH       = 1024,
    OUT_18_FIFO_DEPTH       = 1024,
    OUT_19_FIFO_DEPTH       = 1024,
    OUT_20_FIFO_DEPTH       = 1024,
    OUT_21_FIFO_DEPTH       = 1024,
    OUT_22_FIFO_DEPTH       = 1024,
    OUT_23_FIFO_DEPTH       = 1024,
    OUT_24_FIFO_DEPTH       = 1024,
    OUT_25_FIFO_DEPTH       = 1024,
    OUT_26_FIFO_DEPTH       = 1024,
    OUT_27_FIFO_DEPTH       = 1024,
    OUT_28_FIFO_DEPTH       = 1024,
    OUT_29_FIFO_DEPTH       = 1024,
    OUT_30_FIFO_DEPTH       = 1024,
    OUT_31_FIFO_DEPTH       = 1024
)
(
    vid_clk,
    vid_rst,

    axi4s_vid_in_tdata,
    axi4s_vid_in_tuser,
    axi4s_vid_in_tlast,
    axi4s_vid_in_tvalid,
    axi4s_vid_in_tready,

    axi4s_vid_out_0_tdata,
    axi4s_vid_out_0_tuser,
    axi4s_vid_out_0_tlast,
    axi4s_vid_out_0_tvalid,
    axi4s_vid_out_0_tready,
    
    axi4s_vid_out_1_tdata,
    axi4s_vid_out_1_tuser,
    axi4s_vid_out_1_tlast,
    axi4s_vid_out_1_tvalid,
    axi4s_vid_out_1_tready,
    
    axi4s_vid_out_2_tdata,
    axi4s_vid_out_2_tuser,
    axi4s_vid_out_2_tlast,
    axi4s_vid_out_2_tvalid,
    axi4s_vid_out_2_tready,
    
    axi4s_vid_out_3_tdata,
    axi4s_vid_out_3_tuser,
    axi4s_vid_out_3_tlast,
    axi4s_vid_out_3_tvalid,
    axi4s_vid_out_3_tready,
    
    axi4s_vid_out_4_tdata,
    axi4s_vid_out_4_tuser,
    axi4s_vid_out_4_tlast,
    axi4s_vid_out_4_tvalid,
    axi4s_vid_out_4_tready,
    
    axi4s_vid_out_5_tdata,
    axi4s_vid_out_5_tuser,
    axi4s_vid_out_5_tlast,
    axi4s_vid_out_5_tvalid,
    axi4s_vid_out_5_tready,

    axi4s_vid_out_6_tdata,
    axi4s_vid_out_6_tuser,
    axi4s_vid_out_6_tlast,
    axi4s_vid_out_6_tvalid,
    axi4s_vid_out_6_tready,
    
    axi4s_vid_out_7_tdata,
    axi4s_vid_out_7_tuser,
    axi4s_vid_out_7_tlast,
    axi4s_vid_out_7_tvalid,
    axi4s_vid_out_7_tready,
    
    axi4s_vid_out_8_tdata,
    axi4s_vid_out_8_tuser,
    axi4s_vid_out_8_tlast,
    axi4s_vid_out_8_tvalid,
    axi4s_vid_out_8_tready,
    
    axi4s_vid_out_9_tdata,
    axi4s_vid_out_9_tuser,
    axi4s_vid_out_9_tlast,
    axi4s_vid_out_9_tvalid,
    axi4s_vid_out_9_tready,
    
    axi4s_vid_out_10_tdata,
    axi4s_vid_out_10_tuser,
    axi4s_vid_out_10_tlast,
    axi4s_vid_out_10_tvalid,
    axi4s_vid_out_10_tready,
    
    axi4s_vid_out_11_tdata,
    axi4s_vid_out_11_tuser,
    axi4s_vid_out_11_tlast,
    axi4s_vid_out_11_tvalid,
    axi4s_vid_out_11_tready,
    
    axi4s_vid_out_12_tdata,
    axi4s_vid_out_12_tuser,
    axi4s_vid_out_12_tlast,
    axi4s_vid_out_12_tvalid,
    axi4s_vid_out_12_tready,
    
    axi4s_vid_out_13_tdata,
    axi4s_vid_out_13_tuser,
    axi4s_vid_out_13_tlast,
    axi4s_vid_out_13_tvalid,
    axi4s_vid_out_13_tready,
    
    axi4s_vid_out_14_tdata,
    axi4s_vid_out_14_tuser,
    axi4s_vid_out_14_tlast,
    axi4s_vid_out_14_tvalid,
    axi4s_vid_out_14_tready,
    
    axi4s_vid_out_15_tdata,
    axi4s_vid_out_15_tuser,
    axi4s_vid_out_15_tlast,
    axi4s_vid_out_15_tvalid,
    axi4s_vid_out_15_tready,
    
    axi4s_vid_out_16_tdata,
    axi4s_vid_out_16_tuser,
    axi4s_vid_out_16_tlast,
    axi4s_vid_out_16_tvalid,
    axi4s_vid_out_16_tready,
    
    axi4s_vid_out_17_tdata,
    axi4s_vid_out_17_tuser,
    axi4s_vid_out_17_tlast,
    axi4s_vid_out_17_tvalid,
    axi4s_vid_out_17_tready,
    
    axi4s_vid_out_18_tdata,
    axi4s_vid_out_18_tuser,
    axi4s_vid_out_18_tlast,
    axi4s_vid_out_18_tvalid,
    axi4s_vid_out_18_tready,
    
    axi4s_vid_out_19_tdata,
    axi4s_vid_out_19_tuser,
    axi4s_vid_out_19_tlast,
    axi4s_vid_out_19_tvalid,
    axi4s_vid_out_19_tready,
    
    axi4s_vid_out_20_tdata,
    axi4s_vid_out_20_tuser,
    axi4s_vid_out_20_tlast,
    axi4s_vid_out_20_tvalid,
    axi4s_vid_out_20_tready,
    
    axi4s_vid_out_21_tdata,
    axi4s_vid_out_21_tuser,
    axi4s_vid_out_21_tlast,
    axi4s_vid_out_21_tvalid,
    axi4s_vid_out_21_tready,
    
    axi4s_vid_out_22_tdata,
    axi4s_vid_out_22_tuser,
    axi4s_vid_out_22_tlast,
    axi4s_vid_out_22_tvalid,
    axi4s_vid_out_22_tready,
    
    axi4s_vid_out_23_tdata,
    axi4s_vid_out_23_tuser,
    axi4s_vid_out_23_tlast,
    axi4s_vid_out_23_tvalid,
    axi4s_vid_out_23_tready,
    
    axi4s_vid_out_24_tdata,
    axi4s_vid_out_24_tuser,
    axi4s_vid_out_24_tlast,
    axi4s_vid_out_24_tvalid,
    axi4s_vid_out_24_tready,
    
    axi4s_vid_out_25_tdata,
    axi4s_vid_out_25_tuser,
    axi4s_vid_out_25_tlast,
    axi4s_vid_out_25_tvalid,
    axi4s_vid_out_25_tready,
    
    axi4s_vid_out_26_tdata,
    axi4s_vid_out_26_tuser,
    axi4s_vid_out_26_tlast,
    axi4s_vid_out_26_tvalid,
    axi4s_vid_out_26_tready,
    
    axi4s_vid_out_27_tdata,
    axi4s_vid_out_27_tuser,
    axi4s_vid_out_27_tlast,
    axi4s_vid_out_27_tvalid,
    axi4s_vid_out_27_tready,
    
    axi4s_vid_out_28_tdata,
    axi4s_vid_out_28_tuser,
    axi4s_vid_out_28_tlast,
    axi4s_vid_out_28_tvalid,
    axi4s_vid_out_28_tready,
    
    axi4s_vid_out_29_tdata,
    axi4s_vid_out_29_tuser,
    axi4s_vid_out_29_tlast,
    axi4s_vid_out_29_tvalid,
    axi4s_vid_out_29_tready,
    
    axi4s_vid_out_30_tdata,
    axi4s_vid_out_30_tuser,
    axi4s_vid_out_30_tlast,
    axi4s_vid_out_30_tvalid,
    axi4s_vid_out_30_tready,
    
    axi4s_vid_out_31_tdata,
    axi4s_vid_out_31_tuser,
    axi4s_vid_out_31_tlast,
    axi4s_vid_out_31_tvalid,
    axi4s_vid_out_31_tready
);

import intel_vvp_common_pkg::vvp_clog2;
import intel_vvp_common_pkg::vvp_max;
import intel_vvp_common_pkg::VVP_USER_KEEP_BITS;

// Changing MAX_PORTS requires manually changing the ports, parameter and array assignments
localparam MAX_PORTS = 32;

localparam [MAX_PORTS-1:0] OUT_TREADY = '{
    OUT_31_TREADY,
    OUT_30_TREADY,
    OUT_29_TREADY,
    OUT_28_TREADY,
    OUT_27_TREADY,
    OUT_26_TREADY,
    OUT_25_TREADY,
    OUT_24_TREADY,
    OUT_23_TREADY,
    OUT_22_TREADY,
    OUT_21_TREADY,
    OUT_20_TREADY,
    OUT_19_TREADY,
    OUT_18_TREADY,
    OUT_17_TREADY,
    OUT_16_TREADY,
    OUT_15_TREADY,
    OUT_14_TREADY,
    OUT_13_TREADY,
    OUT_12_TREADY,
    OUT_11_TREADY,
    OUT_10_TREADY,
    OUT_9_TREADY,
    OUT_8_TREADY,
    OUT_7_TREADY,
    OUT_6_TREADY,
    OUT_5_TREADY,
    OUT_4_TREADY,
    OUT_3_TREADY,
    OUT_2_TREADY,
    OUT_1_TREADY,
    OUT_0_TREADY
};

localparam [MAX_PORTS-1:0] OUT_FIFO = '{
    OUT_31_FIFO,
    OUT_30_FIFO,
    OUT_29_FIFO,
    OUT_28_FIFO,
    OUT_27_FIFO,
    OUT_26_FIFO,
    OUT_25_FIFO,
    OUT_24_FIFO,
    OUT_23_FIFO,
    OUT_22_FIFO,
    OUT_21_FIFO,
    OUT_20_FIFO,
    OUT_19_FIFO,
    OUT_18_FIFO,
    OUT_17_FIFO,
    OUT_16_FIFO,
    OUT_15_FIFO,
    OUT_14_FIFO,
    OUT_13_FIFO,
    OUT_12_FIFO,
    OUT_11_FIFO,
    OUT_10_FIFO,
    OUT_9_FIFO,
    OUT_8_FIFO,
    OUT_7_FIFO,
    OUT_6_FIFO,
    OUT_5_FIFO,
    OUT_4_FIFO,
    OUT_3_FIFO,
    OUT_2_FIFO,
    OUT_1_FIFO,
    OUT_0_FIFO
};

localparam [MAX_PORTS-1:0][31:0] OUT_FIFO_DEPTH = '{
    OUT_31_FIFO_DEPTH,
    OUT_30_FIFO_DEPTH,
    OUT_29_FIFO_DEPTH,
    OUT_28_FIFO_DEPTH,
    OUT_27_FIFO_DEPTH,
    OUT_26_FIFO_DEPTH,
    OUT_25_FIFO_DEPTH,
    OUT_24_FIFO_DEPTH,
    OUT_23_FIFO_DEPTH,
    OUT_22_FIFO_DEPTH,
    OUT_21_FIFO_DEPTH,
    OUT_20_FIFO_DEPTH,
    OUT_19_FIFO_DEPTH,
    OUT_18_FIFO_DEPTH,
    OUT_17_FIFO_DEPTH,
    OUT_16_FIFO_DEPTH,
    OUT_15_FIFO_DEPTH,
    OUT_14_FIFO_DEPTH,
    OUT_13_FIFO_DEPTH,
    OUT_12_FIFO_DEPTH,
    OUT_11_FIFO_DEPTH,
    OUT_10_FIFO_DEPTH,
    OUT_9_FIFO_DEPTH,
    OUT_8_FIFO_DEPTH,
    OUT_7_FIFO_DEPTH,
    OUT_6_FIFO_DEPTH,
    OUT_5_FIFO_DEPTH,
    OUT_4_FIFO_DEPTH,
    OUT_3_FIFO_DEPTH,
    OUT_2_FIFO_DEPTH,
    OUT_1_FIFO_DEPTH,
    OUT_0_FIFO_DEPTH
};

localparam PLANES = VVP_INTF_TYPE == "FR" ? NUMBER_OF_COLOR_PLANES+1 : NUMBER_OF_COLOR_PLANES;
localparam TUSER_WIDTH = vvp_max((PLANES*BPS+7)/8, VVP_USER_KEEP_BITS)*PIXELS_IN_PARALLEL;
localparam TDATA_WIDTH = TUSER_WIDTH*8;

input   logic vid_clk;
input   logic vid_rst;

input   logic [TDATA_WIDTH-1:0] axi4s_vid_in_tdata;
input   logic [TUSER_WIDTH-1:0] axi4s_vid_in_tuser;
input   logic                   axi4s_vid_in_tlast;
input   logic                   axi4s_vid_in_tvalid;
output  logic                   axi4s_vid_in_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_0_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_0_tuser;
output  logic                   axi4s_vid_out_0_tlast;
output  logic                   axi4s_vid_out_0_tvalid;
input   logic                   axi4s_vid_out_0_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_1_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_1_tuser;
output  logic                   axi4s_vid_out_1_tlast;
output  logic                   axi4s_vid_out_1_tvalid;
input   logic                   axi4s_vid_out_1_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_2_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_2_tuser;
output  logic                   axi4s_vid_out_2_tlast;
output  logic                   axi4s_vid_out_2_tvalid;
input   logic                   axi4s_vid_out_2_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_3_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_3_tuser;
output  logic                   axi4s_vid_out_3_tlast;
output  logic                   axi4s_vid_out_3_tvalid;
input   logic                   axi4s_vid_out_3_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_4_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_4_tuser;
output  logic                   axi4s_vid_out_4_tlast;
output  logic                   axi4s_vid_out_4_tvalid;
input   logic                   axi4s_vid_out_4_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_5_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_5_tuser;
output  logic                   axi4s_vid_out_5_tlast;
output  logic                   axi4s_vid_out_5_tvalid;
input   logic                   axi4s_vid_out_5_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_6_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_6_tuser;
output  logic                   axi4s_vid_out_6_tlast;
output  logic                   axi4s_vid_out_6_tvalid;
input   logic                   axi4s_vid_out_6_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_7_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_7_tuser;
output  logic                   axi4s_vid_out_7_tlast;
output  logic                   axi4s_vid_out_7_tvalid;
input   logic                   axi4s_vid_out_7_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_8_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_8_tuser;
output  logic                   axi4s_vid_out_8_tlast;
output  logic                   axi4s_vid_out_8_tvalid;
input   logic                   axi4s_vid_out_8_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_9_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_9_tuser;
output  logic                   axi4s_vid_out_9_tlast;
output  logic                   axi4s_vid_out_9_tvalid;
input   logic                   axi4s_vid_out_9_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_10_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_10_tuser;
output  logic                   axi4s_vid_out_10_tlast;
output  logic                   axi4s_vid_out_10_tvalid;
input   logic                   axi4s_vid_out_10_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_11_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_11_tuser;
output  logic                   axi4s_vid_out_11_tlast;
output  logic                   axi4s_vid_out_11_tvalid;
input   logic                   axi4s_vid_out_11_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_12_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_12_tuser;
output  logic                   axi4s_vid_out_12_tlast;
output  logic                   axi4s_vid_out_12_tvalid;
input   logic                   axi4s_vid_out_12_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_13_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_13_tuser;
output  logic                   axi4s_vid_out_13_tlast;
output  logic                   axi4s_vid_out_13_tvalid;
input   logic                   axi4s_vid_out_13_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_14_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_14_tuser;
output  logic                   axi4s_vid_out_14_tlast;
output  logic                   axi4s_vid_out_14_tvalid;
input   logic                   axi4s_vid_out_14_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_15_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_15_tuser;
output  logic                   axi4s_vid_out_15_tlast;
output  logic                   axi4s_vid_out_15_tvalid;
input   logic                   axi4s_vid_out_15_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_16_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_16_tuser;
output  logic                   axi4s_vid_out_16_tlast;
output  logic                   axi4s_vid_out_16_tvalid;
input   logic                   axi4s_vid_out_16_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_17_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_17_tuser;
output  logic                   axi4s_vid_out_17_tlast;
output  logic                   axi4s_vid_out_17_tvalid;
input   logic                   axi4s_vid_out_17_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_18_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_18_tuser;
output  logic                   axi4s_vid_out_18_tlast;
output  logic                   axi4s_vid_out_18_tvalid;
input   logic                   axi4s_vid_out_18_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_19_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_19_tuser;
output  logic                   axi4s_vid_out_19_tlast;
output  logic                   axi4s_vid_out_19_tvalid;
input   logic                   axi4s_vid_out_19_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_20_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_20_tuser;
output  logic                   axi4s_vid_out_20_tlast;
output  logic                   axi4s_vid_out_20_tvalid;
input   logic                   axi4s_vid_out_20_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_21_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_21_tuser;
output  logic                   axi4s_vid_out_21_tlast;
output  logic                   axi4s_vid_out_21_tvalid;
input   logic                   axi4s_vid_out_21_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_22_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_22_tuser;
output  logic                   axi4s_vid_out_22_tlast;
output  logic                   axi4s_vid_out_22_tvalid;
input   logic                   axi4s_vid_out_22_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_23_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_23_tuser;
output  logic                   axi4s_vid_out_23_tlast;
output  logic                   axi4s_vid_out_23_tvalid;
input   logic                   axi4s_vid_out_23_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_24_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_24_tuser;
output  logic                   axi4s_vid_out_24_tlast;
output  logic                   axi4s_vid_out_24_tvalid;
input   logic                   axi4s_vid_out_24_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_25_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_25_tuser;
output  logic                   axi4s_vid_out_25_tlast;
output  logic                   axi4s_vid_out_25_tvalid;
input   logic                   axi4s_vid_out_25_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_26_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_26_tuser;
output  logic                   axi4s_vid_out_26_tlast;
output  logic                   axi4s_vid_out_26_tvalid;
input   logic                   axi4s_vid_out_26_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_27_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_27_tuser;
output  logic                   axi4s_vid_out_27_tlast;
output  logic                   axi4s_vid_out_27_tvalid;
input   logic                   axi4s_vid_out_27_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_28_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_28_tuser;
output  logic                   axi4s_vid_out_28_tlast;
output  logic                   axi4s_vid_out_28_tvalid;
input   logic                   axi4s_vid_out_28_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_29_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_29_tuser;
output  logic                   axi4s_vid_out_29_tlast;
output  logic                   axi4s_vid_out_29_tvalid;
input   logic                   axi4s_vid_out_29_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_30_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_30_tuser;
output  logic                   axi4s_vid_out_30_tlast;
output  logic                   axi4s_vid_out_30_tvalid;
input   logic                   axi4s_vid_out_30_tready;

output  logic [TDATA_WIDTH-1:0] axi4s_vid_out_31_tdata;
output  logic [TUSER_WIDTH-1:0] axi4s_vid_out_31_tuser;
output  logic                   axi4s_vid_out_31_tlast;
output  logic                   axi4s_vid_out_31_tvalid;
input   logic                   axi4s_vid_out_31_tready;

logic               fifo_in_tvalid;
logic [OUTPUTS-1:0] fifo_in_tready;

logic                [TDATA_WIDTH-1:0] input_shim_tdata;
logic                [TUSER_WIDTH-1:0] input_shim_tuser;
logic                                  input_shim_tlast;
logic                                  input_shim_tvalid;
logic                                  input_shim_tready;

logic [MAX_PORTS-1:0][TDATA_WIDTH-1:0] fifo_out_tdata;
logic [MAX_PORTS-1:0][TUSER_WIDTH-1:0] fifo_out_tuser;
logic [MAX_PORTS-1:0]                  fifo_out_tlast;
logic [MAX_PORTS-1:0]                  fifo_out_tvalid;
logic [MAX_PORTS-1:0]                  fifo_out_tready;

intel_vvp_axi_pipeline_stage #(
    .DATA_WIDTH (TDATA_WIDTH)
)
u_input_shim (
    .clk                (vid_clk),
    .rst                (vid_rst),

    .axi_st_din_tdata   (axi4s_vid_in_tdata),
    .axi_st_din_tuser   (axi4s_vid_in_tuser),
    .axi_st_din_tlast   (axi4s_vid_in_tlast),
    .axi_st_din_tvalid  (axi4s_vid_in_tvalid),
    .axi_st_din_tready  (axi4s_vid_in_tready),

    .axi_st_dout_tdata  (input_shim_tdata),
    .axi_st_dout_tuser  (input_shim_tuser),
    .axi_st_dout_tlast  (input_shim_tlast),
    .axi_st_dout_tvalid (input_shim_tvalid),
    .axi_st_dout_tready (input_shim_tready)
);

assign fifo_in_tvalid     = GLOBAL_STALL ? &fifo_in_tready & input_shim_tvalid : input_shim_tvalid;
assign input_shim_tready  = GLOBAL_STALL ? &fifo_in_tready : 1'b1;


genvar i;
generate
    for (i=0; i<MAX_PORTS; i++) `begin(g_output)
        if (i<OUTPUTS) begin
            if (VVP_INTF_TYPE != "FR" || OUT_TREADY[i]) begin
                if (OUT_FIFO[i]) begin
                    intel_vvp_axi_streaming_fifo #(
                        .P_ASYNC            (0),
                        .P_FAMILY           (DEVICE_FAMILY),
                        .P_AXIS_TDATA_WIDTH (TDATA_WIDTH),
                        .P_DEPTH            (OUT_FIFO_DEPTH[i]),
                        .P_INPUT_REG        (1),
                        .P_OUTPUT_REG       (1)
                    )
                    u_axi_streaming_fifo (
                        .wr_clk             (vid_clk),
                        .wr_rst             (vid_rst),
            
                        .axi4s_in_tdata     (input_shim_tdata),
                        .axi4s_in_tuser     (input_shim_tuser),
                        .axi4s_in_tlast     (input_shim_tlast),
                        .axi4s_in_tvalid    (fifo_in_tvalid),
                        .axi4s_in_tready    (fifo_in_tready[i]),
            
                        .rd_clk             (vid_clk),
                        .rd_rst             (vid_rst),
            
                        .axi4s_out_tdata    (fifo_out_tdata[i]),
                        .axi4s_out_tuser    (fifo_out_tuser[i]),
                        .axi4s_out_tlast    (fifo_out_tlast[i]),
                        .axi4s_out_tvalid   (fifo_out_tvalid[i]),
                        .axi4s_out_tready   (fifo_out_tready[i])
                    );
                end
                else begin
                    intel_vvp_axi_pipeline_stage #(
                        .DATA_WIDTH         (TDATA_WIDTH)
                    )
                    u_axi_shim (
                        .clk                (vid_clk),
                        .rst                (vid_rst),
            
                        .axi_st_din_tdata   (input_shim_tdata),
                        .axi_st_din_tuser   (input_shim_tuser),
                        .axi_st_din_tlast   (input_shim_tlast),
                        .axi_st_din_tvalid  (fifo_in_tvalid),
                        .axi_st_din_tready  (fifo_in_tready[i]),
            
                        .axi_st_dout_tdata  (fifo_out_tdata[i]),
                        .axi_st_dout_tuser  (fifo_out_tuser[i]),
                        .axi_st_dout_tlast  (fifo_out_tlast[i]),
                        .axi_st_dout_tvalid (fifo_out_tvalid[i]),
                        .axi_st_dout_tready (fifo_out_tready[i])
                    );
                end
            end
            else begin
                always_ff @(posedge vid_clk) begin
                    fifo_out_tdata[i]   <= input_shim_tdata;
                    fifo_out_tuser[i]   <= input_shim_tuser;
                    fifo_out_tlast[i]   <= input_shim_tlast;
                    fifo_out_tvalid[i]  <= fifo_in_tvalid;
                end
                assign fifo_in_tready[i] = 1'b1;
            end
        end
        else begin
            always_comb begin
                fifo_out_tdata[i]   = {TDATA_WIDTH{1'b0}};
                fifo_out_tuser[i]   = {TUSER_WIDTH{1'b0}};
                fifo_out_tlast[i]   = 1'b0;
                fifo_out_tvalid[i]  = 1'b0;
            end
        end
    end
endgenerate

always_comb begin
    axi4s_vid_out_0_tdata                           = fifo_out_tdata[0];
    axi4s_vid_out_0_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_0_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[0][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_0_tlast                           = fifo_out_tlast[0];
    axi4s_vid_out_0_tvalid                          = fifo_out_tvalid[0];
    fifo_out_tready[0]                              = OUT_0_TREADY ? axi4s_vid_out_0_tready : 1'b1;
    
    axi4s_vid_out_1_tdata                           = fifo_out_tdata[1];
    axi4s_vid_out_1_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_1_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[1][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_1_tlast                           = fifo_out_tlast[1];
    axi4s_vid_out_1_tvalid                          = fifo_out_tvalid[1];
    fifo_out_tready[1]                              = OUT_1_TREADY ? axi4s_vid_out_1_tready : 1'b1;
    
    axi4s_vid_out_2_tdata                           = fifo_out_tdata[2];
    axi4s_vid_out_2_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_2_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[2][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_2_tlast                           = fifo_out_tlast[2];
    axi4s_vid_out_2_tvalid                          = fifo_out_tvalid[2];
    fifo_out_tready[2]                              = OUT_2_TREADY ? axi4s_vid_out_2_tready : 1'b1;
    
    axi4s_vid_out_3_tdata                           = fifo_out_tdata[3];
    axi4s_vid_out_3_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_3_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[3][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_3_tlast                           = fifo_out_tlast[3];
    axi4s_vid_out_3_tvalid                          = fifo_out_tvalid[3];
    fifo_out_tready[3]                              = OUT_3_TREADY ? axi4s_vid_out_3_tready : 1'b1;
    
    axi4s_vid_out_4_tdata                           = fifo_out_tdata[4];
    axi4s_vid_out_4_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_4_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[4][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_4_tlast                           = fifo_out_tlast[4];
    axi4s_vid_out_4_tvalid                          = fifo_out_tvalid[4];
    fifo_out_tready[4]                              = OUT_4_TREADY ? axi4s_vid_out_4_tready : 1'b1;
    
    axi4s_vid_out_5_tdata                           = fifo_out_tdata[5];
    axi4s_vid_out_5_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_5_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[5][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_5_tlast                           = fifo_out_tlast[5];
    axi4s_vid_out_5_tvalid                          = fifo_out_tvalid[5];
    fifo_out_tready[5]                              = OUT_5_TREADY ? axi4s_vid_out_5_tready : 1'b1;
    
    axi4s_vid_out_6_tdata                           = fifo_out_tdata[6];
    axi4s_vid_out_6_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_6_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[6][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_6_tlast                           = fifo_out_tlast[6];
    axi4s_vid_out_6_tvalid                          = fifo_out_tvalid[6];
    fifo_out_tready[6]                              = OUT_6_TREADY ? axi4s_vid_out_6_tready : 1'b1;
    
    axi4s_vid_out_7_tdata                           = fifo_out_tdata[7];
    axi4s_vid_out_7_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_7_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[7][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_7_tlast                           = fifo_out_tlast[7];
    axi4s_vid_out_7_tvalid                          = fifo_out_tvalid[7];
    fifo_out_tready[7]                              = OUT_7_TREADY ? axi4s_vid_out_7_tready : 1'b1;
    
    axi4s_vid_out_8_tdata                           = fifo_out_tdata[8];
    axi4s_vid_out_8_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_8_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[8][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_8_tlast                           = fifo_out_tlast[8];
    axi4s_vid_out_8_tvalid                          = fifo_out_tvalid[8];
    fifo_out_tready[8]                              = OUT_8_TREADY ? axi4s_vid_out_8_tready : 1'b1;
    
    axi4s_vid_out_9_tdata                           = fifo_out_tdata[9];
    axi4s_vid_out_9_tuser                           = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_9_tuser[VVP_USER_KEEP_BITS-1:0]   = fifo_out_tuser[9][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_9_tlast                           = fifo_out_tlast[9];
    axi4s_vid_out_9_tvalid                          = fifo_out_tvalid[9];
    fifo_out_tready[9]                              = OUT_9_TREADY ? axi4s_vid_out_9_tready : 1'b1;
    
    axi4s_vid_out_10_tdata                          = fifo_out_tdata[10];
    axi4s_vid_out_10_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_10_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[10][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_10_tlast                          = fifo_out_tlast[10];
    axi4s_vid_out_10_tvalid                         = fifo_out_tvalid[10];
    fifo_out_tready[10]                             = OUT_10_TREADY ? axi4s_vid_out_10_tready : 1'b1;
    
    axi4s_vid_out_11_tdata                          = fifo_out_tdata[11];
    axi4s_vid_out_11_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_11_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[11][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_11_tlast                          = fifo_out_tlast[11];
    axi4s_vid_out_11_tvalid                         = fifo_out_tvalid[11];
    fifo_out_tready[11]                             = OUT_11_TREADY ? axi4s_vid_out_11_tready : 1'b1;
    
    axi4s_vid_out_12_tdata                          = fifo_out_tdata[12];
    axi4s_vid_out_12_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_12_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[12][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_12_tlast                          = fifo_out_tlast[12];
    axi4s_vid_out_12_tvalid                         = fifo_out_tvalid[12];
    fifo_out_tready[12]                             = OUT_12_TREADY ? axi4s_vid_out_12_tready : 1'b1;
    
    axi4s_vid_out_13_tdata                          = fifo_out_tdata[13];
    axi4s_vid_out_13_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_13_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[13][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_13_tlast                          = fifo_out_tlast[13];
    axi4s_vid_out_13_tvalid                         = fifo_out_tvalid[13];
    fifo_out_tready[13]                             = OUT_13_TREADY ? axi4s_vid_out_13_tready : 1'b1;
    
    axi4s_vid_out_14_tdata                          = fifo_out_tdata[14];
    axi4s_vid_out_14_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_14_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[14][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_14_tlast                          = fifo_out_tlast[14];
    axi4s_vid_out_14_tvalid                         = fifo_out_tvalid[14];
    fifo_out_tready[14]                             = OUT_14_TREADY ? axi4s_vid_out_14_tready : 1'b1;
    
    axi4s_vid_out_15_tdata                          = fifo_out_tdata[15];
    axi4s_vid_out_15_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_15_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[15][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_15_tlast                          = fifo_out_tlast[15];
    axi4s_vid_out_15_tvalid                         = fifo_out_tvalid[15];
    fifo_out_tready[15]                             = OUT_15_TREADY ? axi4s_vid_out_15_tready : 1'b1;
    
    axi4s_vid_out_16_tdata                          = fifo_out_tdata[16];
    axi4s_vid_out_16_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_16_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[16][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_16_tlast                          = fifo_out_tlast[16];
    axi4s_vid_out_16_tvalid                         = fifo_out_tvalid[16];
    fifo_out_tready[16]                             = OUT_16_TREADY ? axi4s_vid_out_16_tready : 1'b1;
    
    axi4s_vid_out_17_tdata                          = fifo_out_tdata[17];
    axi4s_vid_out_17_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_17_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[17][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_17_tlast                          = fifo_out_tlast[17];
    axi4s_vid_out_17_tvalid                         = fifo_out_tvalid[17];
    fifo_out_tready[17]                             = OUT_17_TREADY ? axi4s_vid_out_17_tready : 1'b1;
    
    axi4s_vid_out_18_tdata                          = fifo_out_tdata[18];
    axi4s_vid_out_18_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_18_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[18][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_18_tlast                          = fifo_out_tlast[18];
    axi4s_vid_out_18_tvalid                         = fifo_out_tvalid[18];
    fifo_out_tready[18]                             = OUT_18_TREADY ? axi4s_vid_out_18_tready : 1'b1;
    
    axi4s_vid_out_19_tdata                          = fifo_out_tdata[19];
    axi4s_vid_out_19_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_19_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[19][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_19_tlast                          = fifo_out_tlast[19];
    axi4s_vid_out_19_tvalid                         = fifo_out_tvalid[19];
    fifo_out_tready[19]                             = OUT_19_TREADY ? axi4s_vid_out_19_tready : 1'b1;
    
    axi4s_vid_out_20_tdata                          = fifo_out_tdata[20];
    axi4s_vid_out_20_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_20_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[20][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_20_tlast                          = fifo_out_tlast[20];
    axi4s_vid_out_20_tvalid                         = fifo_out_tvalid[20];
    fifo_out_tready[20]                             = OUT_20_TREADY ? axi4s_vid_out_20_tready : 1'b1;
    
    axi4s_vid_out_21_tdata                          = fifo_out_tdata[21];
    axi4s_vid_out_21_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_21_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[21][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_21_tlast                          = fifo_out_tlast[21];
    axi4s_vid_out_21_tvalid                         = fifo_out_tvalid[21];
    fifo_out_tready[21]                             = OUT_21_TREADY ? axi4s_vid_out_21_tready : 1'b1;
    
    axi4s_vid_out_22_tdata                          = fifo_out_tdata[22];
    axi4s_vid_out_22_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_22_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[22][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_22_tlast                          = fifo_out_tlast[22];
    axi4s_vid_out_22_tvalid                         = fifo_out_tvalid[22];
    fifo_out_tready[22]                             = OUT_22_TREADY ? axi4s_vid_out_22_tready : 1'b1;
    
    axi4s_vid_out_23_tdata                          = fifo_out_tdata[23];
    axi4s_vid_out_23_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_23_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[23][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_23_tlast                          = fifo_out_tlast[23];
    axi4s_vid_out_23_tvalid                         = fifo_out_tvalid[23];
    fifo_out_tready[23]                             = OUT_23_TREADY ? axi4s_vid_out_23_tready : 1'b1;
    
    axi4s_vid_out_24_tdata                          = fifo_out_tdata[24];
    axi4s_vid_out_24_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_24_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[24][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_24_tlast                          = fifo_out_tlast[24];
    axi4s_vid_out_24_tvalid                         = fifo_out_tvalid[24];
    fifo_out_tready[24]                             = OUT_24_TREADY ? axi4s_vid_out_24_tready : 1'b1;
    
    axi4s_vid_out_25_tdata                          = fifo_out_tdata[25];
    axi4s_vid_out_25_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_25_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[25][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_25_tlast                          = fifo_out_tlast[25];
    axi4s_vid_out_25_tvalid                         = fifo_out_tvalid[25];
    fifo_out_tready[25]                             = OUT_25_TREADY ? axi4s_vid_out_25_tready : 1'b1;
    
    axi4s_vid_out_26_tdata                          = fifo_out_tdata[26];
    axi4s_vid_out_26_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_26_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[26][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_26_tlast                          = fifo_out_tlast[26];
    axi4s_vid_out_26_tvalid                         = fifo_out_tvalid[26];
    fifo_out_tready[26]                             = OUT_26_TREADY ? axi4s_vid_out_26_tready : 1'b1;
    
    axi4s_vid_out_27_tdata                          = fifo_out_tdata[27];
    axi4s_vid_out_27_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_27_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[27][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_27_tlast                          = fifo_out_tlast[27];
    axi4s_vid_out_27_tvalid                         = fifo_out_tvalid[27];
    fifo_out_tready[27]                             = OUT_27_TREADY ? axi4s_vid_out_27_tready : 1'b1;
    
    axi4s_vid_out_28_tdata                          = fifo_out_tdata[28];
    axi4s_vid_out_28_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_28_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[28][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_28_tlast                          = fifo_out_tlast[28];
    axi4s_vid_out_28_tvalid                         = fifo_out_tvalid[28];
    fifo_out_tready[28]                             = OUT_28_TREADY ? axi4s_vid_out_28_tready : 1'b1;
    
    axi4s_vid_out_29_tdata                          = fifo_out_tdata[29];
    axi4s_vid_out_29_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_29_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[29][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_29_tlast                          = fifo_out_tlast[29];
    axi4s_vid_out_29_tvalid                         = fifo_out_tvalid[29];
    fifo_out_tready[29]                             = OUT_29_TREADY ? axi4s_vid_out_29_tready : 1'b1;
    
    axi4s_vid_out_30_tdata                          = fifo_out_tdata[30];
    axi4s_vid_out_30_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_30_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[30][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_30_tlast                          = fifo_out_tlast[30];
    axi4s_vid_out_30_tvalid                         = fifo_out_tvalid[30];
    fifo_out_tready[30]                             = OUT_30_TREADY ? axi4s_vid_out_30_tready : 1'b1;
    
    axi4s_vid_out_31_tdata                          = fifo_out_tdata[31];
    axi4s_vid_out_31_tuser                          = {TUSER_WIDTH{1'b0}};
    axi4s_vid_out_31_tuser[VVP_USER_KEEP_BITS-1:0]  = fifo_out_tuser[31][VVP_USER_KEEP_BITS-1:0];
    axi4s_vid_out_31_tlast                          = fifo_out_tlast[31];
    axi4s_vid_out_31_tvalid                         = fifo_out_tvalid[31];
    fifo_out_tready[31]                             = OUT_31_TREADY ? axi4s_vid_out_31_tready : 1'b1;
end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "BZ0Ht6YxPJ87gDB7emtwhH1/wrKZwofwZOuVFTwIr8HS2tmMHNSls/bL9tIfiK7laWzXz3S8qIRIkhNNlv6+KU7OLHf7eR1F5d5xCx5ILSdaugzPdqwbK8DdwtdA2//Yal0jxDcnaTKJlTi0894oxdQ+Bb2rW1r+76IZ7KbYsN9YBH+oVxszebffMjPTuCyLHJIxZ+BGHt8VilUnkJSFCO6S8Ev5q0kTLeGAN1GGJLdPs+ED7u7+Of5QRd77sipcl9IUBjSLpVaMA0FS0yC382fBBPzBnjd14eQq8P5mhEwVvflPynn3dhivvcFnBfOTYqrgpQqMwl0OuV9gFo9IWZfznP8Xham1TLanIEeUFz7PnB/GjR0KQyPGyUN2+/grFCSsq5nwVrLBh8+3XodW716O8IuycaXt8oSIAX9AKRXWxzCvnnuzjvM5qpAIDtoAUCKk7o5oFyx5SrICZvo7BmT4KuCphr/QISenNYCkjy7jJGZjve4f8DEGrG+EmH1KP1JUsPpZFJYX5NF1/LWTV3VrITWTEyTTAPOA8vy6OIhSLLrDnbAEuiEERHpAnZ4MCOxIEKipSQPTY1fax5xRHIKg3TQGbHL0ELd6YjeRpje263Df2/JYMSOqggsXuDbJ0vjXE4CjpVGAYyIRfoEEBw+GhiAp6bc9BsBRNHmzmadDjxhGpj6Y7UzLKVBc6zvNvR8ist7YFP8Petism5o04WXXJguiU3C1D8obzQCYLDVkVV2+nHMRY8h71pnIEP8tJmXnA13NDXGXC/Ru28NNugY2/73cSpjstOkRugu3xd7LvdppSQ42rRO5z3my+mu66BGkfA0nH35TbNkwslDylZYBsTwFeo8ekBNGTP7fzQOjsrLr4i8gOClcNOTyltrdVb/dklaFlzFNY0eZaDWVXJqlib60Yvu8FMTpluPiP/6XMgkKivKGm1ewfuaqQMTGdTOctwjaZ/ndpbyzGSzMKfhduiH7hFcTZ6SGXp+pMXjitf+gFOT2EicRHDwPnosV"
`endif