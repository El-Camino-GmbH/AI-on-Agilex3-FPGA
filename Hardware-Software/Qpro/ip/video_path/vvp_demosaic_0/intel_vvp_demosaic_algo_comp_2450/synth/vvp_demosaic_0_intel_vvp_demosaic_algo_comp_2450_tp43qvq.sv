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


module vvp_demosaic_0_intel_vvp_demosaic_algo_comp_2450_tp43qvq #(

) (
  clk,
  rst,

  axi_st_cmd_tvalid,
  axi_st_cmd_tready,
  axi_st_cmd_tdata,

  axi_st_resp_tvalid,
  axi_st_resp_tready,
  axi_st_resp_tdata,

  av_mm_data_slave_write,
  av_mm_data_slave_read,
  av_mm_data_slave_byteenable,
  av_mm_data_slave_address,
  av_mm_data_slave_writedata,
  av_mm_data_slave_readdata,
  av_mm_data_slave_readdatavalid,
  av_mm_data_slave_waitrequest,

  axi_st_data_in_tvalid,
  axi_st_data_in_tlast,
  axi_st_data_in_tuser,
  axi_st_data_in_tdata,
  axi_st_data_in_tready,

  axi_st_data_out_tvalid,
  axi_st_data_out_tlast,
  axi_st_data_out_tuser,
  axi_st_data_out_tdata,
  axi_st_data_out_tready
);

  import intel_vvp_common_pkg::*;
  import intel_vvp_demosaic_pkg::*;

  localparam DEVICE_FAMILY              = "Agilex 3";
  localparam NUMBER_OF_COLOR_PLANES_IN  = 1;
  localparam NUMBER_OF_COLOR_PLANES_OUT = 3;
  localparam PIXELS_IN_PARALLEL         = 4;
  localparam MAX_WIDTH                  = 8192;
  localparam MAX_HEIGHT                 = 8192;
  localparam BPS_IN                     = 10;
  localparam BPS_OUT                    = 8;
  localparam V_TAPS                     = 5;
  localparam H_TAPS                     = 5;
  localparam PIPELINE_READY             = 1;
  localparam NO_BLANKING                = 1;
  localparam PIPELINE_DATA_MM           = 0;

  localparam DIN_WIDTH = (((BPS_IN*V_TAPS*NUMBER_OF_COLOR_PLANES_IN+7)/8)*8) < 16 ?
    16*PIXELS_IN_PARALLEL :
    PIXELS_IN_PARALLEL*(((BPS_IN*V_TAPS*NUMBER_OF_COLOR_PLANES_IN+7)/8)*8);
  localparam DIN_USR_WIDTH = DIN_WIDTH/8;

  localparam DOUT_WIDTH = (((BPS_OUT*NUMBER_OF_COLOR_PLANES_OUT+7)/8)*8) < 16 ?
    16*PIXELS_IN_PARALLEL :
    PIXELS_IN_PARALLEL*(((BPS_OUT*NUMBER_OF_COLOR_PLANES_OUT+7)/8)*8);
  localparam DOUT_USR_WIDTH = DOUT_WIDTH / 8;

  localparam SLAVE_ADDR_WIDTH = 0;
  localparam BE_WIDTH = VVP_SLAVE_DATA_WIDTH / 8;

  input  logic                                    clk;
  input  logic                                    rst;

  input  logic                                    axi_st_cmd_tvalid;
  output logic                                    axi_st_cmd_tready;
  input  logic [DEMOSAIC_CMD_PORT_WIDTH-1:0]  axi_st_cmd_tdata;

  output logic                                    axi_st_resp_tvalid;
  input  logic                                    axi_st_resp_tready;
  output logic [DEMOSAIC_RESP_PORT_WIDTH-1:0] axi_st_resp_tdata;

  input  logic                                    av_mm_data_slave_write;
  input  logic                                    av_mm_data_slave_read;
  input  logic [BE_WIDTH-1:0]                     av_mm_data_slave_byteenable;
  input  logic [vvp_max(2,SLAVE_ADDR_WIDTH)-1:0]  av_mm_data_slave_address;
  input  logic [VVP_SLAVE_DATA_WIDTH-1:0]         av_mm_data_slave_writedata;
  output logic [VVP_SLAVE_DATA_WIDTH-1:0]         av_mm_data_slave_readdata;
  output logic                                    av_mm_data_slave_readdatavalid;
  output logic                                    av_mm_data_slave_waitrequest;

  input  logic                                    axi_st_data_in_tvalid;
  input  logic                                    axi_st_data_in_tlast;
  input  logic [DIN_USR_WIDTH-1:0]                axi_st_data_in_tuser;
  input  logic [DIN_WIDTH-1:0]                    axi_st_data_in_tdata;
  output logic                                    axi_st_data_in_tready;

  output logic                                    axi_st_data_out_tvalid;
  output logic                                    axi_st_data_out_tlast;
  output logic [DOUT_USR_WIDTH-1:0]               axi_st_data_out_tuser;
  output logic [DOUT_WIDTH-1:0]                   axi_st_data_out_tdata;
  input  logic                                    axi_st_data_out_tready;

  intel_vvp_demosaic_algo_comp #(
    .DEVICE_FAMILY(DEVICE_FAMILY),
    .NUMBER_OF_COLOR_PLANES_IN(NUMBER_OF_COLOR_PLANES_IN),
    .NUMBER_OF_COLOR_PLANES_OUT(NUMBER_OF_COLOR_PLANES_OUT),
    .PIXELS_IN_PARALLEL(PIXELS_IN_PARALLEL),
    .MAX_WIDTH(MAX_WIDTH),
    .MAX_HEIGHT(MAX_HEIGHT),
    .BPS_IN(BPS_IN),
    .BPS_OUT(BPS_OUT),
    .V_TAPS(V_TAPS),
    .H_TAPS(H_TAPS),
    .PIPELINE_READY(PIPELINE_READY),
    .NO_BLANKING(NO_BLANKING),
    .PIPELINE_DATA_MM(PIPELINE_DATA_MM),
    .SLAVE_ADDR_WIDTH(SLAVE_ADDR_WIDTH)
  ) u_intel_vvp_demosaic_algo_comp (
    .clk(clk),
    .rst(rst),
    .axi_st_cmd_tvalid(axi_st_cmd_tvalid),
    .axi_st_cmd_tready(axi_st_cmd_tready),
    .axi_st_cmd_tdata(axi_st_cmd_tdata),
    .axi_st_resp_tvalid(axi_st_resp_tvalid),
    .axi_st_resp_tready(axi_st_resp_tready),
    .axi_st_resp_tdata(axi_st_resp_tdata),
    .av_mm_data_slave_write(av_mm_data_slave_write),
    .av_mm_data_slave_read(av_mm_data_slave_read),
    .av_mm_data_slave_byteenable(av_mm_data_slave_byteenable),
    .av_mm_data_slave_address(av_mm_data_slave_address),
    .av_mm_data_slave_writedata(av_mm_data_slave_writedata),
    .av_mm_data_slave_readdata(av_mm_data_slave_readdata),
    .av_mm_data_slave_readdatavalid(av_mm_data_slave_readdatavalid),
    .av_mm_data_slave_waitrequest(av_mm_data_slave_waitrequest),
    .axi_st_data_in_tvalid(axi_st_data_in_tvalid),
    .axi_st_data_in_tlast(axi_st_data_in_tlast),
    .axi_st_data_in_tuser(axi_st_data_in_tuser),
    .axi_st_data_in_tdata(axi_st_data_in_tdata),
    .axi_st_data_in_tready(axi_st_data_in_tready),
    .axi_st_data_out_tvalid(axi_st_data_out_tvalid),
    .axi_st_data_out_tlast(axi_st_data_out_tlast),
    .axi_st_data_out_tuser(axi_st_data_out_tuser),
    .axi_st_data_out_tdata(axi_st_data_out_tdata),
    .axi_st_data_out_tready(axi_st_data_out_tready)
  );

endmodule

