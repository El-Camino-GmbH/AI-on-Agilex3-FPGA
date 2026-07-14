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


module dphy_pcs_clk_timing_rx #(
    parameter NUM_LANES = 4,                           
    parameter CONTINUOUS_CLK = 0,
    parameter IDLE_CLK_COUNTER_WIDTH = 3
   )
   (
        input wire [1:0]   arst_rx_n, 
        input wire [1:0]   rx_clk, 
        input wire         fr_clk,
        input wire         fr_clk_1024,
        input wire [1:0]   srst_rx_n, 
        input wire         srst_fr_n, 
        input wire         enable,
        
        input wire         in_cal,
                
        input wire         lpctrl_hs_req_fr,
        input wire         lpctrl_hs_stop_fr,
        input wire         lpctrl_hs_diff_fr,
        input wire         lpctrl_ulps_fr,
        input wire         twake_cnt, 
        input [7:0]        t_clk_settle, 
        input [7:0]        t_clk_miss, 
        input [7:0]        t_init,
        input [7:0]        t_wake_ulps,
        output logic [1:0] alt_skip_en,
        output logic       init_done,
        output logic       clk_active, 
        output logic       clk_valid, 

        output logic       twake_done

    );
    
    localparam FR_TIMER_WIDTH = 16;
    localparam IDLE_SEARCH_DELAY = 8'h08;
    
    logic fr_ld_timer, fr_timer_en;   
    logic [FR_TIMER_WIDTH-1:0] fr_ld_val; 
    logic fr_timer_out;
    logic clk_valid_fr, clk_active_fr;
    logic clk_valid_rx;
    logic tog_en;
    logic clk_start, clk_idle, search_idle_en;
    logic disable_clk_idle;


   
    logic [IDLE_CLK_COUNTER_WIDTH-1:0] bin_cnt;
    logic [IDLE_CLK_COUNTER_WIDTH-1:0] grey_cnt;
    logic [IDLE_CLK_COUNTER_WIDTH-1:0] grey_cnt_fr;
    logic [IDLE_CLK_COUNTER_WIDTH-1:0] grey_cnt_fr_q;
    integer i;
    logic rx_en_fr;

    assign disable_clk_idle = CONTINUOUS_CLK == 1 ? 1'b1 : in_cal;

    always @(posedge fr_clk)
    begin
       if( (srst_fr_n | enable) == 1'b0)
       begin
            clk_active_fr <= 1'b0;
            clk_valid_fr <= 1'b0;
            search_idle_en <= 1'b0;
            init_done <= 1'b0;
       end
        else 
        begin
            clk_active_fr <= lpctrl_hs_req_fr | ( clk_active_fr & ~lpctrl_hs_stop_fr );
            clk_valid_fr <= clk_start | (clk_valid_fr & ~clk_idle & clk_active_fr);
            search_idle_en <= tog_en | (search_idle_en & ~clk_idle & clk_active_fr);
            init_done <= init_done | fr_timer_out ;
        end
    end
   
    assign clk_start = clk_active_fr & fr_timer_out & ~search_idle_en;
    assign clk_idle = search_idle_en & fr_timer_out;
    assign clk_active = search_idle_en;
    assign twake_done = lpctrl_ulps_fr & fr_timer_out;

    always @(*)
    begin
       casez( { init_done, clk_valid_fr, search_idle_en, lpctrl_ulps_fr } )
         4'b1000 :
           begin
              fr_timer_en <= clk_active_fr & lpctrl_hs_diff_fr;
              fr_ld_timer <= lpctrl_hs_req_fr;
              fr_ld_val <= { 8'h0, t_clk_settle };
           end
         4'b1110 :
           begin
              fr_timer_en <= clk_active_fr & ~tog_en;
              fr_ld_timer <= tog_en | ~rx_en_fr | disable_clk_idle;
              fr_ld_val <= { 8'h0, t_clk_miss };
           end
         4'b1??1 :
           begin
              fr_timer_en <= fr_clk_1024 & twake_cnt;
              fr_ld_timer <= ~twake_cnt;
              fr_ld_val <= { 8'h0, t_wake_ulps };
           end 
         4'b0??? : 
           begin
              fr_timer_en <= fr_clk_1024;
              fr_ld_timer <= lpctrl_hs_stop_fr === 1'b1 && enable === 1'b1 ? 1'b0 : 1'b1;
              fr_ld_val <= { 8'h0, t_init };
           end            
         default : 
           begin
              fr_timer_en <= 1'b0;
              fr_ld_timer <= 1'b1;
              fr_ld_val <= 'hffff;
           end
       endcase
    end
 

    dphy_timer #(
        .WIDTH(FR_TIMER_WIDTH)
   ) rx_timer_fr
   (
        .clk(fr_clk),     
        .srst_n(srst_fr_n),     
        .timer_en(fr_timer_en), 
        .ld_timer(fr_ld_timer),   
        .ld_val(fr_ld_val), 
        .timer_out(fr_timer_out)   
    );

    assign clk_valid = clk_valid_fr;
    
    
    assign tog_en = grey_cnt_fr_q == grey_cnt_fr ? 1'b0 : clk_valid_fr;

    always @(posedge fr_clk)
    begin
        if(srst_fr_n == 1'b0)
            grey_cnt_fr_q <= 3'h0;
        else
            grey_cnt_fr_q <= grey_cnt_fr;
    end

    logic arst_rx_n0_fr;
    
    altera_std_synchronizer_nocut # ( .depth(3) ) cdc_async_rst_rx_fr (
            .clk(fr_clk), .reset_n(arst_rx_n[0]), .din(1'b1), .dout(arst_rx_n0_fr) );     
   
    genvar j;
    for(j=0; j<3; j++)
    begin : grey_cnt_sync
        altera_std_synchronizer_nocut  # (
            .depth(3)
        ) cdc_sync_clk_valid_fr (
            .clk(fr_clk),
	    .reset_n(arst_rx_n0_fr),
            .din(grey_cnt[j]),
            .dout(grey_cnt_fr[j])
        );
    end

    logic [3:0] skip_cnt_fr;
    logic [3:0] skip_cnt_rx [1:0];
    logic tog_en_q;
    logic tog_en_pos;
    logic tog_en_neg;
    logic req_fr, reg_fr_q; 
    logic ack_fr_q;         
    logic [1:0] ack_fr; 
    logic [1:0] req_rx, req_rx_q;
    logic [1:0] ack_rx; 
    logic req_pending;
    logic [1:0] req_load;
    logic mask_cnt_1;
    
    always @(posedge fr_clk)
    begin
        if(srst_fr_n == 1'b0)
        begin
            skip_cnt_fr <= 3'h0;
            tog_en_q <= 1'b0;
            req_fr <= 1'b0;
            mask_cnt_1 <= 1'b0;
        end
        else
        begin
            skip_cnt_fr <= req_pending == 1'b1 ? skip_cnt_fr :                          
                           ( (mask_cnt_1 & ~tog_en) ? 3'h2 :                            
                            skip_cnt_fr + (~tog_en & clk_valid_fr) ) ;                  
            tog_en_q <= tog_en;
            req_fr <= (tog_en_pos & ~req_pending ) ^ req_fr;
            mask_cnt_1 <= tog_en_neg;
        end
    end
    assign req_pending = ack_fr_q ^ req_fr;                        
    assign tog_en_pos = ~tog_en_q &  tog_en & ~mask_cnt_1;
    assign tog_en_neg =  tog_en_q & ~tog_en;

    altera_std_synchronizer_nocut  # (
         .depth(3)
     ) cdc_sync_rx_en_fr (
         .clk(fr_clk),
         .reset_n(srst_fr_n),
         .din(srst_rx_n[0]),
         .dout(rx_en_fr)
     );
     
    altera_std_synchronizer_nocut  # (
         .depth(3)
     ) cdc_ack_fr (
         .clk(fr_clk),
         .reset_n(srst_fr_n),
         .din(ack_rx[0]),       
         .dout(ack_fr[0])       
     );

     
    altera_std_synchronizer_nocut  # (
         .depth(3)
     ) cdc_req_rx (
         .clk(rx_clk[0]),
         .reset_n(arst_rx_n[0]),
         .din(req_fr),
         .dout(req_rx[0])
     );

    always @(posedge rx_clk[0] or negedge arst_rx_n[0])
        if(arst_rx_n[0] == 1'b0)
        begin
            req_rx_q[0] <= 1'b0;
            ack_rx[0] <= 1'b0;      
            skip_cnt_rx[0] <= 3'h0;
        end
        else
        begin
            req_rx_q[0] <= req_rx[0];
            ack_rx[0] <=  req_load[0] ^ ack_rx[0];      
            skip_cnt_rx[0] <= req_load[0] ? skip_cnt_fr : skip_cnt_rx[0] - |skip_cnt_rx[0]; 
        end

    assign req_load[0] = req_rx_q[0] ^ req_rx[0];

   
if (NUM_LANES == 8)
  begin : byte1_skip
   
   altera_std_synchronizer_nocut  # ( 
        .depth(3)                     
   ) cdc_ack_fr_1 (                  
        .clk(fr_clk),                 
        .reset_n(srst_fr_n),          
        .din(ack_rx[1]),              
        .dout(ack_fr[1])              
   );

   altera_std_synchronizer_nocut  # (
        .depth(3)
   ) cdc_req_rx_1 (
        .clk(rx_clk[1]),
        .reset_n(arst_rx_n[1]),
        .din(req_fr),
        .dout(req_rx[1])
   );
     
   always @(posedge fr_clk)                                                                     
     begin                                                                                      
        if(srst_fr_n == 1'b0)                                                                   
          ack_fr_q <= 1'b0;                                                                     
        else                                                                                    
          ack_fr_q <= ack_fr_q == 1'b0 ? &ack_fr :                
                      ack_fr_q == 1'b1 ? |ack_fr : ack_fr_q;      
     end  
     
   always @(posedge rx_clk[1] or negedge arst_rx_n[1])
     if(arst_rx_n[1] == 1'b0)
       begin
          req_rx_q[1] <= 1'b0;
          ack_rx[1] <= 1'b0;      
          skip_cnt_rx[1] <= 3'h0;
       end
     else
       begin
          req_rx_q[1] <= req_rx[1];
          ack_rx[1] <=  req_load[1] ^ ack_rx[1];      
          skip_cnt_rx[1] <= req_load[1] ? skip_cnt_fr : skip_cnt_rx[1] - |skip_cnt_rx[1]; 
       end
   
   assign req_load[1] = req_rx_q[1] ^ req_rx[1];
   
  end 
else
  begin : byte1_stub

   always @(posedge fr_clk)                                                                     
     begin                                                                                      
        if(srst_fr_n == 1'b0)                                                                   
          ack_fr_q <= 1'b0;                                                                     
        else                                                                                    
          ack_fr_q <= ack_fr[0];        
     end  

   assign skip_cnt_rx[1] = 3'hx;
   
  end
   
    always @(posedge rx_clk[0] or negedge arst_rx_n[0])
    begin
        if(arst_rx_n[0] == 1'b0)
        begin
            bin_cnt  <= { IDLE_CLK_COUNTER_WIDTH{1'b0} };
            grey_cnt <= { IDLE_CLK_COUNTER_WIDTH{1'b0} };
        end
        else
        begin
            bin_cnt <= bin_cnt + 1'b1;
            for(i=0; i< IDLE_CLK_COUNTER_WIDTH; i++)
            begin
                if(i == IDLE_CLK_COUNTER_WIDTH-1)
                    grey_cnt[i] <= bin_cnt[i];
                else
                    grey_cnt[i] <=   bin_cnt[i+1] ^ bin_cnt[i];
            end
        end
    end
    
    assign alt_skip_en[0] = |skip_cnt_rx[0];
    assign alt_skip_en[1] = |skip_cnt_rx[1];

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oLBMUoA5NO7xbFRJzyis3JW8ttcenK5eejk94DiQoCh6q6n/MrcLfV+y+emJHNvcM3IHiTaqLjQqDl3V2YCHWTP9E+QY42IoO3NvSZCxn/5XSsvmDFhUjdqhodXJR7pTST9wh4uviEZxcmc/131lxvTtkwMHAVLvSZ3LiJF0saGw2+gDuRErXYaKOJ/YnRwlJhB535GBJbW3FBIj2g8xEEF2vWOe6O1AIEuU7ede0gbzDZPQicWTm4YX0Ru7rC2Ga1RAdAxrMy+X1eVR01mI2A4kphTaM7wOqiFnKEmSDoOg8TigXaRgq4z1u2/kez1jVnGbx0WlTrTnLU1yQ19hTU7jC6ROieusCR3YUxcb/1E+ODj3i42EquX8DUhP18Hdn0+76Ex7FHzdpMYMY6wgpnNs9GcoGFmi2Z/fe9SqFBjHDLU3Qr6RFm1PgSIlas1OXfAg4AVux6pVPdJyl1pOM8nnhTFe8FGSTn2BUr23zjW/vhwWAvceq3le6unhASlsv3gH2TDRpQAz1rYUvNCRsRzKRAEaw064U1s2IqmQtDIO2YIMYRekZRqUwSzYhqicKW/JbpsF6ovb0mxyva/oxj+0Yzw/WJhomE63IUpg1YTUz3jJ9d8jkL8ypST+B3CvhD96lP8Wm2Ajv/7oD3iTX6HDNP27novUspn8KpxYkNat8/nJo2kuFbK0pnqvNajpwf9eX5+GIKxzwYsO0NuiysuxoZEu6mQW340BWJgiuSbGz3v3WuPOnqe/fpnGjpa/GjB9n6lrZX6p970CB2IfWAm"
`endif