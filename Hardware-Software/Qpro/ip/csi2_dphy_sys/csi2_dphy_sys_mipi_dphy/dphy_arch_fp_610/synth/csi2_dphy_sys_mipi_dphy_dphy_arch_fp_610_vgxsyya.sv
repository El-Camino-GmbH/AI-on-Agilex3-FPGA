// Auto-generated file
import dphy_pkg::*;
module csi2_dphy_sys_mipi_dphy_dphy_arch_fp_610_vgxsyya #(
   parameter NUM_PLL                                            = 0,
   parameter RZQ_ID                                             = 0,
   parameter SKEW_CAL_LEN                                       = 0,
   parameter ALT_CAL_LEN                                        = 0,
   parameter REF_CLK_FREQ_0                                     = 32'b00000000000000000000000000000000,
   parameter VCO_FREQ_0                                         = 36'b000000000000000000000000000000000000,
   parameter CORE_CLK_FREQ_0                                    = 36'b000000000000000000000000000000000000,
   parameter REF_CLK_IO_0                                       = 0,
   parameter REF_CLK_IO_SHARE                                   = 0,
   parameter REF_CLK_FREQ_1                                     = 32'b00000000000000000000000000000000,
   parameter VCO_FREQ_1                                         = 36'b000000000000000000000000000000000000,
   parameter CORE_CLK_FREQ_1                                    = 36'b000000000000000000000000000000000000,
   parameter REF_CLK_IO_1                                       = 0,
   parameter BIT_RATE_0                                         = 36'b000000000000000000000000000000000000,
   parameter BIT_RATE_1                                         = 36'b000000000000000000000000000000000000,
   parameter BIT_RATE_2                                         = 36'b000000000000000000000000000000000000,
   parameter BIT_RATE_3                                         = 36'b000000000000000000000000000000000000,
   parameter BIT_RATE_4                                         = 36'b000000000000000000000000000000000000,
   parameter BIT_RATE_5                                         = 36'b000000000000000000000000000000000000,
   parameter BIT_RATE_6                                         = 36'b000000000000000000000000000000000000,
   parameter BIT_RATE_7                                         = 36'b000000000000000000000000000000000000,
   parameter LINK_USED                                          = 8'b00000000,
   parameter PPI_WIDTH_16                                       = 8'b00000000,
   parameter NUM_LANES                                          = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter BYTE_LOC                                           = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter CONTINUOUS_CLK                                     = 8'b00000000,
   parameter SKEW_CAL_EN                                        = 8'b00000000,
   parameter PREAMBLE_EN                                        = 8'b00000000,
   parameter TM_EN                                              = 8'b00000000,
   parameter TM_LOOPBACK_MODE                                   = 8'b00000000,
   parameter LINK_PLL_SRC                                       = 8'b00000000,
   parameter PER_SKEW_CAL_EN                                    = 8'b00000000,
   parameter ALT_CAL_EN                                         = 8'b00000000,
   parameter PRBS_INIT_0                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter PRBS_INIT_1                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter PRBS_INIT_2                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter PRBS_INIT_3                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter PRBS_INIT_4                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter PRBS_INIT_5                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter PRBS_INIT_6                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter PRBS_INIT_7                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter DPHY_RX_EN                                         = 8'b00000000,
   parameter RX_PPI_WIDTH_16_C2P                                = 8'b00000000,
   parameter RX_AUTO_TYPE                                       = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_TIMING_REG_RW                                   = 8'b00000000,
   parameter RX_CAP_EQ_MODE                                     = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_CLK_LOSS_DETECT                                 = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_CLK_SETTLE                                      = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_HS_SETTLE                                       = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_INIT                                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_PREP_TIME_TM                                    = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_TM_CONTROL_RX_TM_EN                             = 8'b00000000,
   parameter RX_TM_CONTROL_RX_TM_LOOPBACK_MODE                  = 8'b00000000,
   parameter RX_BIT_RATE_MBPS_SEL                               = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_CLK_POST                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_DLANE_DESKEW_DELAY_0                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_DLANE_DESKEW_DELAY_1                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_DLANE_DESKEW_DELAY_2                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_DLANE_DESKEW_DELAY_3                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_DLANE_DESKEW_DELAY_4                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_DLANE_DESKEW_DELAY_5                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_DLANE_DESKEW_DELAY_6                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter RX_DLANE_DESKEW_DELAY_7                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter DPHY_TX_EN                                         = 8'b00000000,
   parameter TX_AUTO_TYPE                                       = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_TIMING_REG_RW                                   = 8'b00000000,
   parameter TX_CAP_EQ_MODE                                     = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_CLK_LANE_PS                                     = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_LPX                                             = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_HS_EXIT                                         = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_LP_EXIT                                         = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_CLK_PREPARE                                     = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_CLK_TRAIL                                       = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_CLK_ZERO                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_CLK_POST                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_CLK_PRE                                         = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_HS_PREPARE                                      = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_HS_ZERO                                         = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_HS_TRAIL                                        = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_INIT                                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_WAKE                                            = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_HS_TM_DESKEW_P                                  = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_TM_CONTROL_TX_TM_EN                             = 8'b00000000,
   parameter TX_TM_CONTROL_TX_TM_LOOPBACK_MODE                  = 8'b00000000,
   parameter TX_VCO_FREQ_MULT                                   = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TX_PREAMBLE_LEN_PREAMLBE_LEN                       = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter TM_LOOPBACK_PAIR                                   = 64'b0000000000000000000000000000000000000000000000000000000000000000,
   parameter SPEED_GRADE                                        = 0,
   parameter DEV_FAMILY                                         = ""
) (
   input  logic            rzq,
   input  logic            ref_clk_0_p,
   input  logic            arst_n,
   output logic            LINK0_link_core_clk,
   output logic            LINK0_link_srst_n,
   output logic            LINK0_link_arst_n,
   input  logic            axil_clk,
   input  logic            srst_axil_n,
   input  logic [11:0]     awaddr,
   input  logic            awvalid,
   output logic            awready,
   input  logic [31:0]     wdata,
   input  logic [3:0]      wstrb,
   input  logic            wvalid,
   output logic            wready,
   output logic [1:0]      bresp,
   output logic            bvalid,
   input  logic            bready,
   input  logic [11:0]     araddr,
   input  logic            arvalid,
   output logic            arready,
   output logic [31:0]     rdata,
   output logic [1:0]      rresp,
   output logic            rvalid,
   input  logic            rready,
   input  logic [2:0]      arprot,
   input  logic [2:0]      awprot,
   output logic            LINK0_D0_RxWordClkHS,
   output logic            LINK0_D1_RxWordClkHS,
   output logic            LINK0_CK_RxWordClkHS,
   output logic            LINK0_D0_RxSRst_n,
   output logic            LINK0_D1_RxSRst_n,
   output logic            LINK0_CK_RxSRst_n,
   input  logic [1:0]      LINK0_D0_RxDataWidthHS,
   output logic [15:0]     LINK0_D0_RxDataHS,
   output logic [1:0]      LINK0_D0_RxValidHS,
   output logic            LINK0_D0_RxActiveHS,
   output logic            LINK0_D0_RxSyncHS,
   input  logic            LINK0_D0_RxDetectEobHS,
   output logic            LINK0_D0_RxClkActiveHS,
   output logic            LINK0_D0_RxDDRClkHS,
   output logic            LINK0_D0_RxSkewCalHS,
   output logic            LINK0_D0_RxAlternateCalHS,
   output logic            LINK0_D0_RxErrorCalHS,
   input  logic [1:0]      LINK0_D1_RxDataWidthHS,
   output logic [15:0]     LINK0_D1_RxDataHS,
   output logic [1:0]      LINK0_D1_RxValidHS,
   output logic            LINK0_D1_RxActiveHS,
   output logic            LINK0_D1_RxSyncHS,
   input  logic            LINK0_D1_RxDetectEobHS,
   output logic            LINK0_D1_RxClkActiveHS,
   output logic            LINK0_D1_RxDDRClkHS,
   output logic            LINK0_D1_RxSkewCalHS,
   output logic            LINK0_D1_RxAlternateCalHS,
   output logic            LINK0_D1_RxErrorCalHS,
   input  logic [1:0]      LINK0_CK_RxDataWidthHS,
   output logic [15:0]     LINK0_CK_RxDataHS,
   output logic [1:0]      LINK0_CK_RxValidHS,
   output logic            LINK0_CK_RxActiveHS,
   output logic            LINK0_CK_RxSyncHS,
   input  logic            LINK0_CK_RxDetectEobHS,
   output logic            LINK0_CK_RxClkActiveHS,
   output logic            LINK0_CK_RxDDRClkHS,
   output logic            LINK0_CK_RxSkewCalHS,
   output logic            LINK0_CK_RxAlternateCalHS,
   output logic            LINK0_CK_RxErrorCalHS,
   output logic            LINK0_D0_RxClkEsc,
   output logic            LINK0_D0_RxLpdtEsc,
   output logic            LINK0_D0_RxUlpsEsc,
   output logic [3:0]      LINK0_D0_RxTriggerEsc,
   output logic            LINK0_D0_RxWakeup,
   output logic [7:0]      LINK0_D0_RxDataEsc,
   output logic            LINK0_D0_RxValidEsc,
   output logic            LINK0_D1_RxClkEsc,
   output logic            LINK0_D1_RxLpdtEsc,
   output logic            LINK0_D1_RxUlpsEsc,
   output logic [3:0]      LINK0_D1_RxTriggerEsc,
   output logic            LINK0_D1_RxWakeup,
   output logic [7:0]      LINK0_D1_RxDataEsc,
   output logic            LINK0_D1_RxValidEsc,
   output logic            LINK0_CK_RxClkEsc,
   output logic            LINK0_CK_RxLpdtEsc,
   output logic            LINK0_CK_RxUlpsEsc,
   output logic [3:0]      LINK0_CK_RxTriggerEsc,
   output logic            LINK0_CK_RxWakeup,
   output logic [7:0]      LINK0_CK_RxDataEsc,
   output logic            LINK0_CK_RxValidEsc,
   input  logic            LINK0_D0_TurnRequest,
   output logic            LINK0_D0_Direction,
   input  logic            LINK0_D0_TurnDisable,
   input  logic            LINK0_D0_ForceRxmode,
   input  logic            LINK0_D0_ForceTxStopmode,
   output logic            LINK0_D0_Stopstate,
   input  logic            LINK0_D0_Enable,
   input  logic            LINK0_D0_AlpMode,
   input  logic            LINK0_D0_TxUlpsClk,
   output logic            LINK0_D0_RxUlpsClkNot,
   output logic            LINK0_D0_UlpsActiveNot,
   input  logic            LINK0_D0_TxHSIdleClkHS,
   output logic            LINK0_D0_TxHSIdleClkReadyHS,
   input  logic            LINK0_D1_TurnRequest,
   output logic            LINK0_D1_Direction,
   input  logic            LINK0_D1_TurnDisable,
   input  logic            LINK0_D1_ForceRxmode,
   input  logic            LINK0_D1_ForceTxStopmode,
   output logic            LINK0_D1_Stopstate,
   input  logic            LINK0_D1_Enable,
   input  logic            LINK0_D1_AlpMode,
   input  logic            LINK0_D1_TxUlpsClk,
   output logic            LINK0_D1_RxUlpsClkNot,
   output logic            LINK0_D1_UlpsActiveNot,
   input  logic            LINK0_D1_TxHSIdleClkHS,
   output logic            LINK0_D1_TxHSIdleClkReadyHS,
   input  logic            LINK0_CK_TurnRequest,
   output logic            LINK0_CK_Direction,
   input  logic            LINK0_CK_TurnDisable,
   input  logic            LINK0_CK_ForceRxmode,
   input  logic            LINK0_CK_ForceTxStopmode,
   output logic            LINK0_CK_Stopstate,
   input  logic            LINK0_CK_Enable,
   input  logic            LINK0_CK_AlpMode,
   input  logic            LINK0_CK_TxUlpsClk,
   output logic            LINK0_CK_RxUlpsClkNot,
   output logic            LINK0_CK_UlpsActiveNot,
   input  logic            LINK0_CK_TxHSIdleClkHS,
   output logic            LINK0_CK_TxHSIdleClkReadyHS,
   output logic            LINK0_D0_ErrSotHS,
   output logic            LINK0_D0_ErrSotSyncHS,
   output logic            LINK0_D0_ErrEsc,
   output logic            LINK0_D0_ErrSyncEsc,
   output logic            LINK0_D0_ErrControl,
   output logic            LINK0_D0_ErrContentionLP0,
   output logic            LINK0_D0_ErrContentionLP1,
   output logic            LINK0_D1_ErrSotHS,
   output logic            LINK0_D1_ErrSotSyncHS,
   output logic            LINK0_D1_ErrEsc,
   output logic            LINK0_D1_ErrSyncEsc,
   output logic            LINK0_D1_ErrControl,
   output logic            LINK0_D1_ErrContentionLP0,
   output logic            LINK0_D1_ErrContentionLP1,
   output logic            LINK0_CK_ErrSotHS,
   output logic            LINK0_CK_ErrSotSyncHS,
   output logic            LINK0_CK_ErrEsc,
   output logic            LINK0_CK_ErrSyncEsc,
   output logic            LINK0_CK_ErrControl,
   output logic            LINK0_CK_ErrContentionLP0,
   output logic            LINK0_CK_ErrContentionLP1,
   input  logic [1:0]      LINK0_dphy_link_dp,
   input  logic [1:0]      LINK0_dphy_link_dn,
   input  logic            LINK0_dphy_link_cp,
   input  logic            LINK0_dphy_link_cn,
   output logic            reg_wr_en_o,
   output logic            reg_rd_en_o,
   output logic [10:0]     reg_raddr_o,
   output logic [10:0]     reg_waddr_o,
   output logic [3:0]      reg_be_o,
   output logic [31:0]     reg_din_o,
   input  logic [31:0]     reg_dout_i
);
   timeunit 1ns;
   timeprecision 1ps;

    // system verilog interfaces
    ppi_if #(8) ppi [7:0] ();
    wire [7:0] link_core_clk;
    wire [7:0] link_srst_n;
    wire [7:0] link_arst_n;
    wire [7:0] [7:0] dphy_link_dp;
    wire [7:0] [7:0] dphy_link_dn;
    wire [7:0] dphy_link_cp;
    wire [7:0] dphy_link_cn;

   dphy_top # (
      .NUM_PLL (NUM_PLL),
      .RZQ_ID (RZQ_ID),
      .SKEW_CAL_LEN (SKEW_CAL_LEN),
      .ALT_CAL_LEN (ALT_CAL_LEN),
      .REF_CLK_FREQ_0 (REF_CLK_FREQ_0),
      .VCO_FREQ_0 (VCO_FREQ_0),
      .CORE_CLK_FREQ_0 (CORE_CLK_FREQ_0),
      .REF_CLK_IO_0 (REF_CLK_IO_0),
      .REF_CLK_IO_SHARE (REF_CLK_IO_SHARE),
      .REF_CLK_FREQ_1 (REF_CLK_FREQ_1),
      .VCO_FREQ_1 (VCO_FREQ_1),
      .CORE_CLK_FREQ_1 (CORE_CLK_FREQ_1),
      .REF_CLK_IO_1 (REF_CLK_IO_1),
      .BIT_RATE_0 (BIT_RATE_0),
      .BIT_RATE_1 (BIT_RATE_1),
      .BIT_RATE_2 (BIT_RATE_2),
      .BIT_RATE_3 (BIT_RATE_3),
      .BIT_RATE_4 (BIT_RATE_4),
      .BIT_RATE_5 (BIT_RATE_5),
      .BIT_RATE_6 (BIT_RATE_6),
      .BIT_RATE_7 (BIT_RATE_7),
      .LINK_USED (LINK_USED),
      .PPI_WIDTH_16 (PPI_WIDTH_16),
      .NUM_LANES (NUM_LANES),
      .BYTE_LOC (BYTE_LOC),
      .CONTINUOUS_CLK (CONTINUOUS_CLK),
      .SKEW_CAL_EN (SKEW_CAL_EN),
      .PREAMBLE_EN (PREAMBLE_EN),
      .TM_EN (TM_EN),
      .TM_LOOPBACK_MODE (TM_LOOPBACK_MODE),
      .LINK_PLL_SRC (LINK_PLL_SRC),
      .PER_SKEW_CAL_EN (PER_SKEW_CAL_EN),
      .ALT_CAL_EN (ALT_CAL_EN),
      .PRBS_INIT_0 (PRBS_INIT_0),
      .PRBS_INIT_1 (PRBS_INIT_1),
      .PRBS_INIT_2 (PRBS_INIT_2),
      .PRBS_INIT_3 (PRBS_INIT_3),
      .PRBS_INIT_4 (PRBS_INIT_4),
      .PRBS_INIT_5 (PRBS_INIT_5),
      .PRBS_INIT_6 (PRBS_INIT_6),
      .PRBS_INIT_7 (PRBS_INIT_7),
      .DPHY_RX_EN (DPHY_RX_EN),
      .RX_PPI_WIDTH_16_C2P (RX_PPI_WIDTH_16_C2P),
      .RX_AUTO_TYPE (RX_AUTO_TYPE),
      .RX_TIMING_REG_RW (RX_TIMING_REG_RW),
      .RX_CAP_EQ_MODE (RX_CAP_EQ_MODE),
      .RX_CLK_LOSS_DETECT (RX_CLK_LOSS_DETECT),
      .RX_CLK_SETTLE (RX_CLK_SETTLE),
      .RX_HS_SETTLE (RX_HS_SETTLE),
      .RX_INIT (RX_INIT),
      .RX_PREP_TIME_TM (RX_PREP_TIME_TM),
      .RX_TM_CONTROL_RX_TM_EN (RX_TM_CONTROL_RX_TM_EN),
      .RX_TM_CONTROL_RX_TM_LOOPBACK_MODE (RX_TM_CONTROL_RX_TM_LOOPBACK_MODE),
      .RX_BIT_RATE_MBPS_SEL (RX_BIT_RATE_MBPS_SEL),
      .RX_CLK_POST (RX_CLK_POST),
      .RX_DLANE_DESKEW_DELAY_0 (RX_DLANE_DESKEW_DELAY_0),
      .RX_DLANE_DESKEW_DELAY_1 (RX_DLANE_DESKEW_DELAY_1),
      .RX_DLANE_DESKEW_DELAY_2 (RX_DLANE_DESKEW_DELAY_2),
      .RX_DLANE_DESKEW_DELAY_3 (RX_DLANE_DESKEW_DELAY_3),
      .RX_DLANE_DESKEW_DELAY_4 (RX_DLANE_DESKEW_DELAY_4),
      .RX_DLANE_DESKEW_DELAY_5 (RX_DLANE_DESKEW_DELAY_5),
      .RX_DLANE_DESKEW_DELAY_6 (RX_DLANE_DESKEW_DELAY_6),
      .RX_DLANE_DESKEW_DELAY_7 (RX_DLANE_DESKEW_DELAY_7),
      .DPHY_TX_EN (DPHY_TX_EN),
      .TX_AUTO_TYPE (TX_AUTO_TYPE),
      .TX_TIMING_REG_RW (TX_TIMING_REG_RW),
      .TX_CAP_EQ_MODE (TX_CAP_EQ_MODE),
      .TX_CLK_LANE_PS (TX_CLK_LANE_PS),
      .TX_LPX (TX_LPX),
      .TX_HS_EXIT (TX_HS_EXIT),
      .TX_LP_EXIT (TX_LP_EXIT),
      .TX_CLK_PREPARE (TX_CLK_PREPARE),
      .TX_CLK_TRAIL (TX_CLK_TRAIL),
      .TX_CLK_ZERO (TX_CLK_ZERO),
      .TX_CLK_POST (TX_CLK_POST),
      .TX_CLK_PRE (TX_CLK_PRE),
      .TX_HS_PREPARE (TX_HS_PREPARE),
      .TX_HS_ZERO (TX_HS_ZERO),
      .TX_HS_TRAIL (TX_HS_TRAIL),
      .TX_INIT (TX_INIT),
      .TX_WAKE (TX_WAKE),
      .TX_HS_TM_DESKEW_P (TX_HS_TM_DESKEW_P),
      .TX_TM_CONTROL_TX_TM_EN (TX_TM_CONTROL_TX_TM_EN),
      .TX_TM_CONTROL_TX_TM_LOOPBACK_MODE (TX_TM_CONTROL_TX_TM_LOOPBACK_MODE),
      .TX_VCO_FREQ_MULT (TX_VCO_FREQ_MULT),
      .TX_PREAMBLE_LEN_PREAMLBE_LEN (TX_PREAMBLE_LEN_PREAMLBE_LEN),
      .TM_LOOPBACK_PAIR (TM_LOOPBACK_PAIR),
      .SPEED_GRADE (SPEED_GRADE),
      .DEV_FAMILY (DEV_FAMILY)
   ) dphy_inst (
      .ppi (ppi),
      .ref_clk_1_p (1'h0),
      .rzq (rzq),
      .ref_clk_0_p (ref_clk_0_p),
      .arst_n (arst_n),
      .link_core_clk (link_core_clk),
      .link_srst_n (link_srst_n),
      .link_arst_n (link_arst_n),
      .axil_clk (axil_clk),
      .srst_axil_n (srst_axil_n),
      .awaddr (awaddr),
      .awvalid (awvalid),
      .awready (awready),
      .wdata (wdata),
      .wstrb (wstrb),
      .wvalid (wvalid),
      .wready (wready),
      .bresp (bresp),
      .bvalid (bvalid),
      .bready (bready),
      .araddr (araddr),
      .arvalid (arvalid),
      .arready (arready),
      .rdata (rdata),
      .rresp (rresp),
      .rvalid (rvalid),
      .rready (rready),
      .arprot (arprot),
      .awprot (awprot),
      .dphy_link_dp (dphy_link_dp),
      .dphy_link_dn (dphy_link_dn),
      .dphy_link_cp (dphy_link_cp),
      .dphy_link_cn (dphy_link_cn),
      .reg_wr_en_o (reg_wr_en_o),
      .reg_rd_en_o (reg_rd_en_o),
      .reg_raddr_o (reg_raddr_o),
      .reg_waddr_o (reg_waddr_o),
      .reg_be_o (reg_be_o),
      .reg_din_o (reg_din_o),
      .reg_dout_i (reg_dout_i)
   );

    // system verilog signal mapping
    assign LINK0_link_core_clk = link_core_clk[0];
    assign LINK0_link_srst_n = link_srst_n[0];
    assign LINK0_link_arst_n = link_arst_n[0];
    assign LINK0_D0_RxWordClkHS = ppi[0].RxWordClkHS[0];
    assign LINK0_D1_RxWordClkHS = ppi[0].RxWordClkHS[1];
    assign LINK0_CK_RxWordClkHS = ppi[0].RxWordClkHS[2];
    assign LINK0_D0_RxSRst_n = ppi[0].RxSRst_n[0];
    assign LINK0_D1_RxSRst_n = ppi[0].RxSRst_n[1];
    assign LINK0_CK_RxSRst_n = ppi[0].RxSRst_n[2];
    assign LINK0_D0_RxDataHS[15:0] = ppi[0].RxDataHS[0][15:0];
    assign LINK0_D0_RxValidHS[1:0] = ppi[0].RxValidHS[0][1:0];
    assign LINK0_D0_RxActiveHS = ppi[0].RxActiveHS[0];
    assign LINK0_D0_RxSyncHS = ppi[0].RxSyncHS[0];
    assign LINK0_D0_RxClkActiveHS = ppi[0].RxClkActiveHS[0];
    assign LINK0_D0_RxDDRClkHS = ppi[0].RxDDRClkHS[0];
    assign LINK0_D0_RxSkewCalHS = ppi[0].RxSkewCalHS[0];
    assign LINK0_D0_RxAlternateCalHS = ppi[0].RxAlternateCalHS[0];
    assign LINK0_D0_RxErrorCalHS = ppi[0].RxErrorCalHS[0];
    assign ppi[0].RxDataWidthHS[0] = LINK0_D0_RxDataWidthHS;
    assign ppi[0].RxDetectEobHS[0] = LINK0_D0_RxDetectEobHS;
    assign LINK0_D1_RxDataHS[15:0] = ppi[0].RxDataHS[1][15:0];
    assign LINK0_D1_RxValidHS[1:0] = ppi[0].RxValidHS[1][1:0];
    assign LINK0_D1_RxActiveHS = ppi[0].RxActiveHS[1];
    assign LINK0_D1_RxSyncHS = ppi[0].RxSyncHS[1];
    assign LINK0_D1_RxClkActiveHS = ppi[0].RxClkActiveHS[1];
    assign LINK0_D1_RxDDRClkHS = ppi[0].RxDDRClkHS[1];
    assign LINK0_D1_RxSkewCalHS = ppi[0].RxSkewCalHS[1];
    assign LINK0_D1_RxAlternateCalHS = ppi[0].RxAlternateCalHS[1];
    assign LINK0_D1_RxErrorCalHS = ppi[0].RxErrorCalHS[1];
    assign ppi[0].RxDataWidthHS[1] = LINK0_D1_RxDataWidthHS;
    assign ppi[0].RxDetectEobHS[1] = LINK0_D1_RxDetectEobHS;
    assign LINK0_CK_RxDataHS[15:0] = ppi[0].RxDataHS[2][15:0];
    assign LINK0_CK_RxValidHS[1:0] = ppi[0].RxValidHS[2][1:0];
    assign LINK0_CK_RxActiveHS = ppi[0].RxActiveHS[2];
    assign LINK0_CK_RxSyncHS = ppi[0].RxSyncHS[2];
    assign LINK0_CK_RxClkActiveHS = ppi[0].RxClkActiveHS[2];
    assign LINK0_CK_RxDDRClkHS = ppi[0].RxDDRClkHS[2];
    assign LINK0_CK_RxSkewCalHS = ppi[0].RxSkewCalHS[2];
    assign LINK0_CK_RxAlternateCalHS = ppi[0].RxAlternateCalHS[2];
    assign LINK0_CK_RxErrorCalHS = ppi[0].RxErrorCalHS[2];
    assign ppi[0].RxDataWidthHS[2] = LINK0_CK_RxDataWidthHS;
    assign ppi[0].RxDetectEobHS[2] = LINK0_CK_RxDetectEobHS;
    assign LINK0_D0_RxClkEsc = ppi[0].RxClkEsc[0];
    assign LINK0_D0_RxLpdtEsc = ppi[0].RxLpdtEsc[0];
    assign LINK0_D0_RxUlpsEsc = ppi[0].RxUlpsEsc[0];
    assign LINK0_D0_RxTriggerEsc = ppi[0].RxTriggerEsc[0];
    assign LINK0_D0_RxWakeup = ppi[0].RxWakeup[0];
    assign LINK0_D0_RxDataEsc = ppi[0].RxDataEsc[0];
    assign LINK0_D0_RxValidEsc = ppi[0].RxValidEsc[0];
    assign LINK0_D1_RxClkEsc = ppi[0].RxClkEsc[1];
    assign LINK0_D1_RxLpdtEsc = ppi[0].RxLpdtEsc[1];
    assign LINK0_D1_RxUlpsEsc = ppi[0].RxUlpsEsc[1];
    assign LINK0_D1_RxTriggerEsc = ppi[0].RxTriggerEsc[1];
    assign LINK0_D1_RxWakeup = ppi[0].RxWakeup[1];
    assign LINK0_D1_RxDataEsc = ppi[0].RxDataEsc[1];
    assign LINK0_D1_RxValidEsc = ppi[0].RxValidEsc[1];
    assign LINK0_CK_RxClkEsc = ppi[0].RxClkEsc[2];
    assign LINK0_CK_RxLpdtEsc = ppi[0].RxLpdtEsc[2];
    assign LINK0_CK_RxUlpsEsc = ppi[0].RxUlpsEsc[2];
    assign LINK0_CK_RxTriggerEsc = ppi[0].RxTriggerEsc[2];
    assign LINK0_CK_RxWakeup = ppi[0].RxWakeup[2];
    assign LINK0_CK_RxDataEsc = ppi[0].RxDataEsc[2];
    assign LINK0_CK_RxValidEsc = ppi[0].RxValidEsc[2];
    assign LINK0_D0_Direction = ppi[0].Direction[0];
    assign LINK0_D0_Stopstate = ppi[0].Stopstate[0];
    assign LINK0_D0_RxUlpsClkNot = ppi[0].RxUlpsClkNot[0];
    assign LINK0_D0_UlpsActiveNot = ppi[0].UlpsActiveNot[0];
    assign LINK0_D0_TxHSIdleClkReadyHS = ppi[0].TxHSIdleClkReadyHS[0];
    assign ppi[0].TurnRequest[0] = LINK0_D0_TurnRequest;
    assign ppi[0].TurnDisable[0] = LINK0_D0_TurnDisable;
    assign ppi[0].ForceRxmode[0] = LINK0_D0_ForceRxmode;
    assign ppi[0].ForceTxStopmode[0] = LINK0_D0_ForceTxStopmode;
    assign ppi[0].Enable[0] = LINK0_D0_Enable;
    assign ppi[0].AlpMode[0] = LINK0_D0_AlpMode;
    assign ppi[0].TxUlpsClk[0] = LINK0_D0_TxUlpsClk;
    assign ppi[0].TxHSIdleClkHS[0] = LINK0_D0_TxHSIdleClkHS;
    assign LINK0_D1_Direction = ppi[0].Direction[1];
    assign LINK0_D1_Stopstate = ppi[0].Stopstate[1];
    assign LINK0_D1_RxUlpsClkNot = ppi[0].RxUlpsClkNot[1];
    assign LINK0_D1_UlpsActiveNot = ppi[0].UlpsActiveNot[1];
    assign LINK0_D1_TxHSIdleClkReadyHS = ppi[0].TxHSIdleClkReadyHS[1];
    assign ppi[0].TurnRequest[1] = LINK0_D1_TurnRequest;
    assign ppi[0].TurnDisable[1] = LINK0_D1_TurnDisable;
    assign ppi[0].ForceRxmode[1] = LINK0_D1_ForceRxmode;
    assign ppi[0].ForceTxStopmode[1] = LINK0_D1_ForceTxStopmode;
    assign ppi[0].Enable[1] = LINK0_D1_Enable;
    assign ppi[0].AlpMode[1] = LINK0_D1_AlpMode;
    assign ppi[0].TxUlpsClk[1] = LINK0_D1_TxUlpsClk;
    assign ppi[0].TxHSIdleClkHS[1] = LINK0_D1_TxHSIdleClkHS;
    assign LINK0_CK_Direction = ppi[0].Direction[2];
    assign LINK0_CK_Stopstate = ppi[0].Stopstate[2];
    assign LINK0_CK_RxUlpsClkNot = ppi[0].RxUlpsClkNot[2];
    assign LINK0_CK_UlpsActiveNot = ppi[0].UlpsActiveNot[2];
    assign LINK0_CK_TxHSIdleClkReadyHS = ppi[0].TxHSIdleClkReadyHS[2];
    assign ppi[0].TurnRequest[2] = LINK0_CK_TurnRequest;
    assign ppi[0].TurnDisable[2] = LINK0_CK_TurnDisable;
    assign ppi[0].ForceRxmode[2] = LINK0_CK_ForceRxmode;
    assign ppi[0].ForceTxStopmode[2] = LINK0_CK_ForceTxStopmode;
    assign ppi[0].Enable[2] = LINK0_CK_Enable;
    assign ppi[0].AlpMode[2] = LINK0_CK_AlpMode;
    assign ppi[0].TxUlpsClk[2] = LINK0_CK_TxUlpsClk;
    assign ppi[0].TxHSIdleClkHS[2] = LINK0_CK_TxHSIdleClkHS;
    assign LINK0_D0_ErrSotHS = ppi[0].ErrSotHS[0];
    assign LINK0_D0_ErrSotSyncHS = ppi[0].ErrSotSyncHS[0];
    assign LINK0_D0_ErrEsc = ppi[0].ErrEsc[0];
    assign LINK0_D0_ErrSyncEsc = ppi[0].ErrSyncEsc[0];
    assign LINK0_D0_ErrControl = ppi[0].ErrControl[0];
    assign LINK0_D0_ErrContentionLP0 = ppi[0].ErrContentionLP0[0];
    assign LINK0_D0_ErrContentionLP1 = ppi[0].ErrContentionLP1[0];
    assign LINK0_D1_ErrSotHS = ppi[0].ErrSotHS[1];
    assign LINK0_D1_ErrSotSyncHS = ppi[0].ErrSotSyncHS[1];
    assign LINK0_D1_ErrEsc = ppi[0].ErrEsc[1];
    assign LINK0_D1_ErrSyncEsc = ppi[0].ErrSyncEsc[1];
    assign LINK0_D1_ErrControl = ppi[0].ErrControl[1];
    assign LINK0_D1_ErrContentionLP0 = ppi[0].ErrContentionLP0[1];
    assign LINK0_D1_ErrContentionLP1 = ppi[0].ErrContentionLP1[1];
    assign LINK0_CK_ErrSotHS = ppi[0].ErrSotHS[2];
    assign LINK0_CK_ErrSotSyncHS = ppi[0].ErrSotSyncHS[2];
    assign LINK0_CK_ErrEsc = ppi[0].ErrEsc[2];
    assign LINK0_CK_ErrSyncEsc = ppi[0].ErrSyncEsc[2];
    assign LINK0_CK_ErrControl = ppi[0].ErrControl[2];
    assign LINK0_CK_ErrContentionLP0 = ppi[0].ErrContentionLP0[2];
    assign LINK0_CK_ErrContentionLP1 = ppi[0].ErrContentionLP1[2];
    assign dphy_link_dp[0][1:0] = LINK0_dphy_link_dp[1:0];
    assign dphy_link_dn[0][1:0] = LINK0_dphy_link_dn[1:0];
    assign dphy_link_cp[0] = LINK0_dphy_link_cp;
    assign dphy_link_cn[0] = LINK0_dphy_link_cn;

endmodule
