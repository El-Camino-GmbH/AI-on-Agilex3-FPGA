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
`define BHV_IBUF 1
`endif

`ifdef BHV_IBUF
`define ibuf_name dphy_ibuf_bhv
`endif

`define SIM 1

// synthesis translate_on  

`ifndef ibuf_name
`define ibuf_name tennm_ph2_io_ibuf
`endif

`undef RZQ_SHARING

import dphy_pkg::*;


module dphy_clk_rst_blk #(
   parameter REF_CLK_BYTE_LOC_0                                 = 0,                    
   parameter REF_CLK_BYTE_LOC_1                                 = 0,                    
   parameter SPEED_GRADE                                        = 2,                    
   parameter NUM_PLL                                            = 1,                    
   parameter RZQ_ID                                             = "RZQ0",               
   parameter REF_CLK_FREQ_0                                     = 32'd30000000,         
   parameter VCO_FREQ_0                                         = 36'd1600000000,       
   parameter CORE_CLK_FREQ_0                                    = 36'd400000000,        
   parameter REF_CLK_IO_0                                       = 0,                    
   parameter REF_CLK_IO_SHARE                                   = 1,                    
   parameter REF_CLK_FREQ_1                                     = 32'd30000000,         
   parameter VCO_FREQ_1                                         = 36'd1600000000,       
   parameter CORE_CLK_FREQ_1                                    = 36'd400000000,        
   parameter REF_CLK_IO_1                                       = 0,                    
   parameter LINK_USED                                          = 8'b00000000,          
   parameter VCO_FREQ_MULT                                      = 64'h0101010101010101, 
   parameter LINK_PLL_SRC                                       = 8'b00000000           

    )
   (
`ifndef RZQ_SHARING
        input wire              rzq,
`endif
        input wire              ref_clk_0_p,
        input wire              ref_clk_0_n,
        input wire              ref_clk_1_p,
        input wire              ref_clk_1_n,
        input wire              arst_n,  
        dphy_dbg_common         dphy_dbg_common,
        input wire [7:0]        link_enable,
        output logic [7:0]      link_vco_clk,
        output logic [7:0]      link_phy_clk,
        output logic [7:0]      link_phy_clk_sync,
        output logic [7:0]      link_core_clk,
        output logic [7:0]      link_core_clk_1024,
        output logic [7:0]      link_pll_lock,
        output logic [7:0]      link_srst_n,
        output logic [7:0]      link_arst_n

    );
    
    localparam RESET_PIPE_DEPTH = 2;
    localparam VCO_DIV_0_INT = int'(VCO_FREQ_0 / CORE_CLK_FREQ_0);
    localparam VCO_DIV_1_INT = int'(VCO_FREQ_1 / CORE_CLK_FREQ_1);
    localparam VCO_EXP_0 = (VCO_DIV_0_INT == 8) ? 3 : 2;
    localparam VCO_EXP_1 = (VCO_DIV_1_INT == 8) ? 3 : 2;
    localparam PHY_DIV_0 = VCO_EXP_0 - 1;
    localparam PHY_DIV_1 = VCO_EXP_1 - 1;
 
 

    logic [NUM_PLL-1:0] phyclk;
    logic [NUM_PLL-1:0] phyclk_sync;
    logic [NUM_PLL-1:0] phy_clk;
    logic [NUM_PLL-1:0] phy_clk_sync;
    logic [NUM_PLL-1:0] core_clk_out;
    logic [NUM_PLL-1:0] core_clk_in;
    logic [NUM_PLL-1:0] core_clk_out_1024;
    logic [NUM_PLL*8-1:0] vco_clk;
    logic [NUM_PLL-1:0] ref_clk;
    logic [NUM_PLL-1:0] pll_lock;
    logic [NUM_PLL-1:0] lock;
    logic [NUM_PLL-1:0] pll_core_clk_1024;
    logic [NUM_PLL-1:0] srst_int_n;

    wire [NUM_PLL-1:0]      core_lock;                      
    wire [NUM_PLL-1:0]      ref_clk0;                       
    wire [NUM_PLL-1:0]      ref_clk1;                       
    wire [NUM_PLL-1:0]      ref_clk_switch_n;               
    wire [NUM_PLL*2-1:0]    ref_clk_bad;                    
    wire [NUM_PLL-1:0]      ref_clk_active;                 
    wire [NUM_PLL-1:0]      fb_clk_in;                      
    wire [NUM_PLL-1:0]      fb_clk_in_lvds;                 
    wire [NUM_PLL*7-1:0]    out_clk;                        
    wire [NUM_PLL-1:0]      out_clk_external0;              
    wire [NUM_PLL-1:0]      out_clk_external1;              
    wire [NUM_PLL-1:0]      out_clk_periph0;                
    wire [NUM_PLL-1:0]      out_clk_periph1;                
    wire [NUM_PLL-1:0]      out_clk_cascade;                
    wire [NUM_PLL-1:0]      fb_clk_out;                     
    wire [NUM_PLL*8-1:0]    vco8ph;                         
    wire [NUM_PLL-1:0]      vco_clk_periph;                 

 
    /*********************************************************
                        Clock Block
    **********************************************************/

    generate
    begin: ref_clk_0
      assign ref_clk[0] = ref_clk_0_p;
    end
    endgenerate
    if(REF_CLK_IO_SHARE == 0 && NUM_PLL > 1) 
    begin: ref_clk_1
      assign ref_clk[1] = ref_clk_1_p;
    end
    else
    begin : no_ref_clk_1
    end
    
`ifndef RZQ_SHARING
     (* altera_attribute = "-name PRESERVE_FANOUT_FREE_WYSIWYG ON" *)
     `ibuf_name #(
        .buffer_usage( "REGULAR" ),
        .bus_hold( "BUS_HOLD_OFF" ),
        .io_standard( "IO_STANDARD_IOSTD_OFF" ),
        .equalization( "EQUALIZATION_OFF" ),
        .rzq_id( RZQ_ID == "RZQ0" ? "RZQ_ID_RZQ0" : "RZQ_ID_RZQ1" ),
        .schmitt_trigger( "SCHMITT_TRIGGER_OFF" ),
        .termination( "TERMINATION_RT_OFF" ),
        .usage_mode( "USAGE_MODE_RZQ" ),
        .vref( "VREF_OFF" ),
        .weak_pull_down( "WEAK_PULL_DOWN_OFF" ),
        .weak_pull_up( "WEAK_PULL_UP_OFF" ),
        .toggle_speed( "TOGGLE_SPEED_SLOW" )
    ) ibuf_inst (
        .i( rzq ),                                                  
        .ibar(),
        .o()                                                        
    );
`endif
 
 localparam PH_SW_WIDTH = 4;
   
    genvar pll;
    for(pll = 0; pll <NUM_PLL; pll = pll +1)
    begin : pll_gen
    
        logic [pll:pll]      lock;                              

        assign ref_clk0[pll] = ( pll == 0 || ( REF_CLK_IO_SHARE == 1 && NUM_PLL == 2) ) ? ref_clk[0] : ref_clk[1];
        assign ref_clk1[pll] = 1'b0;
        assign ref_clk_switch_n[pll] = 1'b1;
        assign fb_clk_in[pll] = phy_clk[pll];
        assign fb_clk_in_lvds[pll] = 1'b0;
        assign phy_clk[pll] = out_clk_periph0[pll];
        assign pll_lock[pll] = lock[pll];
        assign core_clk_in[pll] = core_clk_out[pll];
       
       logic       skewed_phyclk_sync;
       logic       sweep_phyclk_sync; 
       
// synthesis translate_off 
//https://hsdes.intel.com/appstore/article/#/14021553586
`ifdef MIPI_DPHY_SIM_FWFIX
   
       logic [7:0]           phyclk_sync_ph;
       logic [PH_SW_WIDTH-1:0] ph_sw_cnt;
       logic [2:0]             rand_ph;
       logic                   en_phy_clk_sync;
       logic [1:0]             pll_lock_shift;             
       logic                   pll_lock_pedge;               
       
       initial en_phy_clk_sync = 1'b1;
       always @(posedge phy_clk[pll])
         pll_lock_shift[1:0] <= {pll_lock_shift[0],pll_lock[pll]};

       assign pll_lock_pedge = pll_lock_shift[0] && (~pll_lock_shift[1]);       
       
       
       always @(posedge phy_clk[pll])
         if (pll_lock_pedge === 1'b1)
           begin
 `ifndef MIPI_DPHY_FWDCLK_NEGTEST            
              @(negedge phy_clk[pll]) en_phy_clk_sync = 1'b0;
 `endif
              $display ("\nMIPI Emulating PHY_CLK_SYNC workaround on REV-A device. PLL %d... EN_PHY_CLK_SYNC => %b\n", pll, en_phy_clk_sync);
           end
       
       assign sweep_phyclk_sync = 1'b1;
       
       always @(posedge phy_clk[pll])
         if (~pll_lock[pll])
           phyclk_sync_ph[7:0] <= 8'd0;
         else
           phyclk_sync_ph[7:0] <= {phyclk_sync_ph[6:0],out_clk_periph1[pll]};
       
       always @(posedge out_clk_periph1[pll])
         if (~pll_lock[pll])
           ph_sw_cnt <= 0;
         else
           ph_sw_cnt <= ph_sw_cnt + 1;
       
       always @(posedge core_clk_in[pll])
         if (&ph_sw_cnt)
           begin
              rand_ph = $urandom%8;
           end
       
       assign skewed_phyclk_sync = phyclk_sync_ph[rand_ph] & en_phy_clk_sync;
   
`else
// synthesis translate_on
   
       assign sweep_phyclk_sync = 1'b0;   
       assign skewed_phyclk_sync = out_clk_periph1[pll];   
       
// synthesis translate_off     
`endif
// synthesis translate_on
   
       assign phy_clk_sync[pll] = 1'b0
// synthesis translate_off
                             | sweep_phyclk_sync
// synthesis translate_on
                             ? skewed_phyclk_sync
                             : out_clk_periph1[pll] ;       

        `ifdef TEMP_SYNTH
            assign out_clk_periph0[pll] = ref_clk0[pll];
            assign out_clk_periph1[pll] = ref_clk0[pll];
            assign vco_clk[pll*8 +: 8] = 8'h0;
            assign vco_clk_periph[pll] = ref_clk0[pll];
            assign lock[pll] = 1'b0;
        `else


        dphy_iopll_wrap #(
            .PLL_ID(pll),
            .SPEED_GRADE( SPEED_GRADE ),
            .REF_CLK_FREQ( ( pll == 0 || REF_CLK_IO_SHARE == 1 ) ? REF_CLK_FREQ_0 : REF_CLK_FREQ_1 ),
            .VCO_FREQ( pll == 0 ? VCO_FREQ_0 : VCO_FREQ_1 )
        ) iopll_wrap_inst (
            .lock( lock[pll] ),                                        
            .ref_clk0( ref_clk0[pll] ),                                
            .ref_clk1( ),                                              
            .ref_clk_switch_n( 1'b1 ),                                     
            .ref_clk_bad( ref_clk_bad[pll*2 +: 2] ),                   
            .ref_clk_active( ref_clk_active[pll] ),                    
            .fb_clk_in(  ),                                            
            .fb_clk_in_lvds(  ),                                       
            .out_clk(  ),                                              
            .out_clk_external0(  ),                                    
            .out_clk_external1(  ),                                    
            .out_clk_periph0( out_clk_periph0[pll] ),                  
            .out_clk_periph1( out_clk_periph1[pll] ),                  
            .out_clk_cascade( ),                                       
            .fb_clk_out(  ),                                           
            .vco_clk( vco_clk[pll*8 +: 8] ),                           
            .vco_clk_periph( vco_clk_periph[pll] )                     
        );

    `endif
        
    end
    
    for(pll = 0; pll <NUM_PLL; pll = pll +1)
    begin : cpa_gen

        logic [pll:pll] lock;                           
        assign core_lock[pll] = lock[pll];
        assign vco8ph[pll*8 +: 8] = vco_clk[pll*8 +: 8];
        assign phyclk[pll] = phy_clk[pll];
        assign phyclk_sync[pll] = phy_clk_sync[pll];
    
        `ifdef TEMP_SYNTH
            assign lock[pll] = 1'b1;
            assign core_clk_out[pll] = phyclk[pll];
        `else
    
        dphy_cpa_wrap #(
            .CPA_ID(pll),
            .PHY_CLK_DIV(pll == 0 ? PHY_DIV_0 : PHY_DIV_1),
            .VCO_CLK_DIV_EXPONENT(pll == 0 ? VCO_EXP_0 : VCO_EXP_1),
            .VCO_CLK_FREQ(pll == 0 ? VCO_FREQ_0 : VCO_FREQ_1)
        ) cpa_wrap_inst (
            .i_core_clk_in( core_clk_in[pll] ),                        
            .i_phyclk( phyclk[pll] ),                                  
            .i_phyclk_sync( phyclk_sync[pll] ),                        
            .o_core_clk_out( core_clk_out[pll] ),                      
            .i_vco8ph( vco8ph[pll*8 +: 8] ),                           
            .o_lock( lock[pll] ),                                      
            .i_pll_lock( pll_lock[pll] )                               
        );
        `endif

        logic [9:0] cnt_1024;
        always @(posedge core_clk_out[pll])
        begin
            if(core_lock[pll] == 1'b0)
                cnt_1024 <= 'h0;
            else
                cnt_1024 <= cnt_1024 + 1'b1;
        end
        
        `ifdef QUICK_SIM
        assign core_clk_out_1024[pll] = &cnt_1024[1:0];
        `else
        assign core_clk_out_1024[pll] = &cnt_1024;
        `endif


    end
    
    genvar link;

    for(link = 0; link <8; link = link +1)
    begin: clk_rst_mux
        localparam ARST_COUNT_WIDTH = 8
// synthesis translate_off
                                    + 5
// synthesis translate_on
                                    ;

        logic                        core_lock_local;
        logic                        srst_nopipe_n;
        logic                        link_arst_n_raw;
        logic [ARST_COUNT_WIDTH-1:0] arst_count;
 
        assign link_vco_clk[link] = LINK_USED[link] == 1'b0 ? 1'b0 : ( LINK_PLL_SRC[link] == 1'b1 ? vco_clk_periph[1] :  vco_clk_periph[0] ) ;
        assign link_phy_clk[link] = LINK_USED[link] == 1'b0 ? 1'b0 : ( LINK_PLL_SRC[link] == 1'b1 ? phy_clk[1] :  phy_clk[0] ) ;
        assign link_phy_clk_sync[link] = LINK_USED[link] == 1'b0 ? 1'b0 : ( LINK_PLL_SRC[link] == 1'b1 ? phy_clk_sync[1] :  phy_clk_sync[0] ) ;
        assign link_core_clk[link] = LINK_USED[link] == 1'b0 ? 1'b0 : ( LINK_PLL_SRC[link] == 1'b1 ? core_clk_out[1] :  core_clk_out[0] ) ;
        assign link_core_clk_1024[link] = LINK_USED[link] == 1'b0 ? 1'b0 : ( LINK_PLL_SRC[link] == 1'b1 ? core_clk_out_1024[1] :  core_clk_out_1024[0] ) ;
        assign link_pll_lock[link] = LINK_USED[link] == 1'b0 ? 1'b0 : ( LINK_PLL_SRC[link] == 1'b1 ? pll_lock[1] :  pll_lock[0] ) ;

        assign core_lock_local = LINK_USED[link] == 1'b0 ? 1'b0 : ( LINK_PLL_SRC[link] == 1'b1 ? core_lock[1] :  core_lock[0] ) ;

        altera_std_synchronizer_nocut # ( .depth(3) ) cdc_async_rst (
            .clk(link_core_clk[link]), .reset_n(arst_n & core_lock_local & link_enable[link]), .din(1'b1), .dout(link_arst_n_raw) );           
        altera_std_synchronizer_nocut # ( .depth(3) ) cdc_sync_rst (
            .clk(link_core_clk[link]), .reset_n(1'b1), .din(link_arst_n[link]), .dout(srst_nopipe_n) );
        hyperpipe # ( .WIDTH(1), .CYCLES(RESET_PIPE_DEPTH) ) sync_rst_pipe (
            .clk(link_core_clk[link]), .din( srst_nopipe_n ), .dout( link_srst_n[link] ) );

        always_ff @(posedge link_core_clk[link] or negedge link_arst_n_raw) begin
            if (~link_arst_n_raw) begin
               arst_count <= '0;
            end else if (~arst_count[ARST_COUNT_WIDTH - 1]) begin
               arst_count <= ARST_COUNT_WIDTH'(arst_count + 1); 
            end
        end
 
       assign link_arst_n[link] = arst_count[ARST_COUNT_WIDTH - 1];
    end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oKFtCPbSrMO+yhwzOxZ51HWKKfDkQpv1Wb9aSDB/FG+hocIMs1wqIs7H+B+hH6LfWdoEozIACfYfCFdetv06hxvRqXUwSvtuWqFUV/i2kOuAXWIpX84VWeAZvX0OufRrHfC04MN+tt9ke8k9PMxXmCTxOwTBzpRZrLOBWksj6m/Xe3AvRYg9/UFjeDZHx4323wmw0AJjZlFuI3rCXNI/rI4Tlsqh1MIyZB7Wfe1VIKLsjxLPRodGWwLAMhTeU9mXmBx5WSpkE+HpJIPfaW1/+HMLbAQrUFhMiXtuoNPfSHbpsEXNe9gEkzE5K+1sMb5UC0ta9JQKeO6nUdqvWhCQFQId92YGGQUGZQNmqTqOmhHsVQ3fkmg9yJC2ed/s+h5dgROjym2aLJt4knKT4a31YJwNIGlVZbdOKfokJ20Sd8FzCCW7oLUZA25l6SynQfqqwi57IFGdBw5QWcVPqtJFCWbqCt8QG/3C8kdoBlc7yed5H23ZxELUX2y+Tf91YMxEKgdRowdQCbmpv4pP20YfCfGP0U+a3ykLlAbjLQBrNZ8FQ8CCDsKrbEf98SaU5XWLpUdSAjNGHEdhYi2hhhVRj64XNZKIpsFz8KEPGblcO5kpbKyYqBECrwHeVw6dQIZP5NJSq/lQObTHzAEPqbVf3nW4I6yahLXK3EFwAT8qUqpv9xyUWQB33hfjCOs8U7+xzILPr7YK8xjuQ06Lw1jOoWmqLIIw+jGCa6oxy4KghG9DHRT5JB8MNsRw9spX9EdN1wqObrfdivXRJrXbkSFKe0s"
`endif
