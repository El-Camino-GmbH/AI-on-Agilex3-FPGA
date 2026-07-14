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



import dphy_pkg::*;

`timescale 1ns / 10 ps

module dphy_pcs_esc_rx # (
        parameter LANE_ID = 0
    )
   (
        input wire   fr_clk, 
        input wire   srst_fr_n, 
        input wire   init_done,
        input wire   lp_p,
        input wire   lp_n,
        output logic is_hs_req,
        output logic is_hs,
        output logic is_lp_req,
        output logic is_lp,
        output logic is_stop,
        output logic is_ulps,
        output logic ulps_wake_cnt,
        input wire  ulps_wake_done,   
        output logic esc_entry_err_p,
        output logic lpdt_err_p, 
        output logic ctrl_err_p,
                     ppi_if ppi_rx
    );
   
    /*
    localparam ESC_IDLE      = 'b000;
    localparam HS_REQ        = 'b100;
    localparam HS_ACTIVE     = 'b001;
    localparam ESC_REQ       = 'b101;
    localparam ESC_REQ0      = 'b110;
    localparam ESC_REQ1      = 'b111;
    localparam ESC_CMD       = 'b010;
    localparam ESC_DATA      = 'b011;
        
    logic [2:0] esc_c_st;
    */
   
   typedef enum bit[3:0] {
                 ESC_IDLE,
                 HS_ACTIVE,
                 ESC_CMD,
                 ESC_DATA,
                 HS_REQ,
                 ESC_REQ,
                 ESC_REQ0,
                 ESC_REQ1,
                 ESC_ULPS_EXIT,
                 ESC_ULPS_WAKE
                 } rx_esc_sm_t;
             
   rx_esc_sm_t esc_c_st;

   typedef enum {
                 ULPS_IDLE,
                 ULPS,
                 ULPS_EXIT,
                 ULPS_WAKE
                 } esc_ulps_sm_t;

   esc_ulps_sm_t esc_ulps_st;
   
   logic [1:0]  lp_pn;
   logic        d_in;
   logic [7:0]  d_reg;
   logic [2:0]  cntr;
   logic        lp_xor, lp_xor_q;
   logic        is_pos, is_neg;
   logic        dout_valid;
   logic        exit_cmd;
   logic        exit_cmd_q;
   logic        exit_cmd_qq;
   logic [3:0]  trigger;
   logic        is_lpdt;
   logic        is_ulps_active;    
   logic        ErrEsc;
   logic        ErrSyncEsc;
   logic        ErrControl;
   
   logic        trigger_ext;
   
   logic        twake_cnt;

   assign ulps_wake_cnt = twake_cnt;   
   
   assign lp_xor = (lp_p ^ lp_n);
   assign lp_pn = { lp_p, lp_n };
   assign is_pos = ~esc_c_st[3] & ~esc_c_st[2] & esc_c_st[1] & ~lp_xor_q & lp_xor;
   assign is_neg = ~esc_c_st[3] & ~esc_c_st[2] & esc_c_st[1] & lp_xor_q & (~lp_p & ~lp_n);
   assign exit_cmd = (esc_c_st == ESC_CMD) ? is_neg & &cntr  : 1'b0;
   
    always @(posedge fr_clk)
    begin
        lp_xor_q <= lp_xor;
        d_in <= is_pos == 1'b1 ? lp_p : d_in;
        d_reg <= (is_neg == 1'b1 && ~trigger_ext)?  { d_in, d_reg[7:1] } : d_reg;
        exit_cmd_q <= exit_cmd;
        exit_cmd_qq <= exit_cmd_q;
    end
        
    always @(posedge fr_clk)
    begin
        if (esc_c_st == ESC_IDLE)
        begin
            cntr <= 'h0;
            dout_valid <= 'b0;
        end
        else
        begin
            cntr <= cntr + is_neg;
            dout_valid <= (esc_c_st == ESC_DATA && is_neg == 1'b1 && ~|trigger) ? &cntr : dout_valid;
        end
    end

    always @(posedge fr_clk)
    begin
        trigger[0] <= ( exit_cmd_q & ( d_reg == ESC_RESET_CMD ? 1'b1 : 1'b0 ) ) | (trigger[0] & ~&lp_pn );
        trigger[1] <= ( exit_cmd_q & ( d_reg == ESC_HS_TST_CMD ? 1'b1 : 1'b0 ) ) | (trigger[1] & ~&lp_pn );
        trigger[2] <= ( exit_cmd_q & ( d_reg == ESC_UNKNOW4_CMD ? 1'b1 : 1'b0 ) ) | (trigger[2] & ~&lp_pn );
        trigger[3] <= ( exit_cmd_q & ( d_reg == ESC_UNKNOW5_CMD ? 1'b1 : 1'b0 ) ) | (trigger[3] & ~&lp_pn );
        is_lpdt <= ( exit_cmd_q & ( d_reg == ESC_LPDT_CMD ? 1'b1 : 1'b0 ) ) | (is_lpdt & ~&lp_pn );
        is_ulps <= ( exit_cmd_q & ( d_reg == ESC_ULPS_CMD ? 1'b1 : 1'b0 ) ) | (is_ulps & (~&lp_pn | (esc_c_st == ESC_ULPS_EXIT)));
        is_ulps_active <= ( exit_cmd_q & ( d_reg == ESC_ULPS_CMD ? 1'b1 : 1'b0 ) ) | (is_ulps_active & ~lp_xor );
    end


     always @(posedge fr_clk)
       begin
          if (srst_fr_n == 1'b0 || lp_pn == LPCTRL_STOP || init_done == 1'b0)
            trigger_ext <= 1'b0;
          else
	        begin
	           if (trigger_ext == 1'b0)
		         begin
		            if (is_pos && (cntr == 'h0) && |trigger)
		              trigger_ext <= 1'b1;
		         end
	           else
		         if (is_stop)
		           trigger_ext <= 1'b0;
	        end
       end
   
   
     always @(posedge fr_clk)
     begin
         if (srst_fr_n == 1'b0 || init_done == 1'b0)
           begin
              esc_c_st <= ESC_IDLE;
              twake_cnt <= 1'b0;
           end
         else
           begin
              if (lp_pn == LPCTRL_STOP)
                begin
                   twake_cnt <= 1'b0;
                   if ((esc_c_st == ESC_ULPS_EXIT) && (~ulps_wake_done))
                     esc_c_st <= ESC_ULPS_EXIT;
                   else
                     esc_c_st <= ESC_IDLE;
                end
              else
                begin
                   case(esc_c_st)
                     ESC_IDLE   :
                       begin
                          if(lp_pn == LPCTRL_LP_RQST) esc_c_st <= ESC_REQ;
                          if(lp_pn == LPCTRL_HS_RQST) esc_c_st <= HS_REQ;
                       end
                     HS_REQ     :  if(lp_pn == LPCTRL_BRIDGE) esc_c_st <= HS_ACTIVE;
                     ESC_REQ    :  if(lp_pn == ESC_SPACE) esc_c_st <= ESC_REQ0;
                     ESC_REQ0   :  if(lp_pn == ESC_MARK_0) esc_c_st <= ESC_REQ1;
                     ESC_REQ1   :  if(lp_pn == ESC_SPACE) esc_c_st <= ESC_CMD;
                     ESC_CMD    :  if(exit_cmd == 1'b1) esc_c_st <= ESC_DATA; 
                     ESC_DATA   :
                       begin
                          if (is_ulps && (lp_pn == ESC_MARK_1))
                            esc_c_st <= ESC_ULPS_EXIT;                     
                       end
                     ESC_ULPS_EXIT :
                      if(ulps_wake_done)
                        begin
                           esc_c_st <= ESC_ULPS_WAKE;
                           twake_cnt <= 1'b0;
                        end
                      else
                        begin
                           esc_c_st <= ESC_ULPS_EXIT;
                           if (lp_pn == ESC_MARK_1)
                             twake_cnt <= 1'b1;
                           else
                             twake_cnt <= 1'b0;                        
                        end 
                     ESC_ULPS_WAKE, HS_ACTIVE   : ;
                     default    : esc_c_st <= ESC_IDLE;
                   endcase
                end 
           end   
     end 

/* integrated to esc_c_st
 
   always @(posedge fr_clk)
     begin
        if (srst_fr_n == 1'b0 || init_done == 1'b0)
          begin
             esc_ulps_st <= ULPS_IDLE;
          end
        else
          begin
             if (lp_pn == LPCTRL_STOP)
               begin
                  if ((esc_ulps_st == ULPS_EXIT) && (~ulps_wake_done))
                    esc_ulps_st <= ULPS_EXIT;
                  else
                    esc_ulps_st <= ULPS_IDLE;
               end
             else
               begin
                  case(esc_ulps_st)
                    ULPS_IDLE :
                      if ( (esc_c_st == ESC_DATA) && is_ulps)
                        esc_ulps_st <= ULPS;
                      else
                        esc_ulps_st <= ULPS_IDLE;
                    ULPS :
                      if(lp_pn == ESC_MARK_1)
                        begin
                           esc_ulps_st <= ULPS_EXIT;
                        end
                    ULPS_EXIT  : 
                      if(ulps_wake_done)
                        begin
                           esc_ulps_st <= ULPS_WAKE;
                        end
                      else
                        begin
                           esc_ulps_st <= ULPS_EXIT;
                           if (lp_pn == ESC_MARK_1)
                           else
                        end                 
                    ULPS_WAKE : ;
                    default : esc_ulps_st <= ULPS_IDLE;
                  endcase
               end 
          end 
     end 
 */ 
    
    assign is_hs_req = esc_c_st == HS_REQ;
    assign is_hs = esc_c_st == HS_ACTIVE;
    assign is_lp_req = esc_c_st == ESC_REQ;
    assign is_lp = (esc_c_st == ESC_CMD || esc_c_st == ESC_DATA);
    assign is_stop = lp_pn == LPCTRL_STOP;
    assign esc_entry_err_p = exit_cmd_qq & ~ ( |trigger | is_lpdt | is_ulps );
    assign lpdt_err_p = is_lp & is_stop & |cntr;
    assign ctrl_err_p = ( (esc_c_st == HS_REQ) & (( lp_pn == LPCTRL_HS_RQST || lp_pn == LPCTRL_BRIDGE ) ? 1'b0 : 1'b1 ) ) | 
                        ( (esc_c_st == ESC_REQ) & (( lp_pn == LPCTRL_LP_RQST || lp_pn == ESC_SPACE ) ? 1'b0 : 1'b1 ) ) | 
                        ( (esc_c_st == ESC_REQ0) & (( lp_pn == ESC_SPACE || lp_pn == ESC_MARK_0 ) ? 1'b0 : 1'b1 ) ) | 
                        ( (esc_c_st == ESC_REQ1) & (( lp_pn == ESC_MARK_0 || lp_pn == ESC_SPACE ) ? 1'b0 : 1'b1 ) );

    
    assign ppi_rx.RxClkEsc [LANE_ID]        = lp_xor & init_done;
    assign ppi_rx.RxLpdtEsc [LANE_ID]       = LANE_ID == 0 ? is_lpdt : 1'b0;
    assign ppi_rx.RxUlpsEsc [LANE_ID]       = is_ulps;
    assign ppi_rx.RxTriggerEsc [LANE_ID]    = LANE_ID == 0 ? trigger : 'h0;
    assign ppi_rx.RxWakeup [LANE_ID]        = 1'b0;
    assign ppi_rx.RxDataEsc [LANE_ID]       = LANE_ID == 0 ?  d_reg :'h0 ;
    assign ppi_rx.RxValidEsc [LANE_ID]      = LANE_ID == 0 ? is_lpdt & dout_valid : 'h0;
    assign ppi_rx.UlpsActiveNot[LANE_ID]    = ~is_ulps_active;

     always @(posedge fr_clk)
     begin
         if (srst_fr_n == 1'b0 || init_done == 1'b0)
         begin
            ErrEsc      <= 1'b0;
            ErrSyncEsc  <= 1'b0;
            ErrControl  <= 1'b0;
         end
         else
         begin
            ErrEsc      <= ( esc_entry_err_p | ErrEsc ) & ~ (esc_c_st == ESC_IDLE && (lp_pn == LPCTRL_LP_RQST || lp_pn == LPCTRL_HS_RQST) ) ;
            ErrSyncEsc  <= ( lpdt_err_p | ErrSyncEsc )  & ~ (esc_c_st == ESC_IDLE && (lp_pn == LPCTRL_LP_RQST || lp_pn == LPCTRL_HS_RQST) ) ;
            ErrControl  <= ( ctrl_err_p | ErrControl )  & ~ (esc_c_st == ESC_IDLE && (lp_pn == LPCTRL_LP_RQST || lp_pn == LPCTRL_HS_RQST) ) ;
         end
    end
    
    assign ppi_rx.ErrEsc[LANE_ID] = ErrEsc;
    assign ppi_rx.ErrSyncEsc[LANE_ID] = ErrSyncEsc;
    assign ppi_rx.ErrControl[LANE_ID] = ErrControl;

 

endmodule 


`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oJCTKvGN9GnOw9TQI99QCSqg1M98gsahqFy7hv9+A9aN+zbl5UzVq1ZWuO//YWJM8M6lAC9RsXLpos6b6oW3wpeG/rRR4yZUe6ZIyyUV9wKoEAOzfuUTI8VaxvY6FVBkB4crW996tpOcGybwX6Mlx8WrE2vK8iPFtUmJp9WvNfR9uvm161jqp1qsqzpSluZdB0I2vbQHrFiBF0uZgQVFsTG73GMilF9FHpyhLMxn9TwCgqhs5ltjCx1mHNquU2TleYqzpoXpeftd53qu4cGh9GdAMz8rcX77//v0F1YJ8RYBuPpq9mko5SFhy8qle1Au6bZyETiGQ6tVCmNx89NrB+GUp2iG5KnoGRyRcXFiXsqtjBDrAGfMVnIPta6nDl6AhTftuFcZMdjpkdhZUGygp2J+zv0fDlR4/vu/mWPgQWjmjW0DvmeYOa01jtsWKnNJkzUfiVygXFeN63uORae3y7a1gxX1l6vPRJYiiVpKhl+BdCdAIL23fXSKmkEhkbRhz9Lu/Mp/jpOnXbL8Y3h2ZeDem2uzwPnfbAJ7APgan7ezXTxq3dbCcCjGssEli2PJMrGKb0VNWcLInZmpJdSR28iOpVAHr1huBHTd+TnaJcbeZOys4/PgdRLjdUy5yHfGekudnpx7qkN5C9GF3hYX5ZlWj+eyea51OqoJg3SvHkR+SS63eYHT28+vxcAXg+mnZlVyU8uaGdafoQdRmmeHYOluXwg/L9TkgYMwSoFcz9X0213iiU08I79yQBdlBNG4zaF6jmtSV6wGIqzu8plln4k"
`endif