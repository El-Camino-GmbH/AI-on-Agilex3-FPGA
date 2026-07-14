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


`define C2P_HIPI \
      (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 225"} *)
`define C2P_CTRL_HIPI \
      (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 225"} *) (* preserve *)
`define RX_C2P_HIPI \
      (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 225"} *) (* preserve *)
`define P2C_HIPI \
      (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_PERIPHERY_CORE_TRANSFER ON"} *)

`define P2C_HIPI_1DOMAIN_RESTRICTION

`ifndef dphy_mipi_ff_name
`define dphy_mipi_ff_name tennm_ff
`endif

import dphy_pkg::*;
		   
module dphy_full_byte_hipi_intf
  #(
    parameter DPHY_RX_EN = 0,
    parameter DPHY_TX_EN = 0,
    parameter NUM_LANES = 1,
    parameter BYTE_CNT = 1
    )
   (

    input logic 		   link_core_clk, 
    input logic [BYTE_CNT-1:0] 	   rx_fwd_clk, 

    input logic [BYTE_CNT*96-1:0]  p2c, 
    input logic [BYTE_CNT*4-1:0]   p2c_ctrl, 
    input logic [BYTE_CNT*12-1:0]  phy_gpio_din, 
    
    input logic [BYTE_CNT*96-1:0]  c2p, 
    input logic [BYTE_CNT*20-1:0]  c2p_ctrl, 
    output logic [BYTE_CNT*96-1:0] c2p_hipi, 
    output logic [BYTE_CNT*96-1:0] p2c_hipi, 
    output logic [BYTE_CNT*20-1:0] c2p_ctrl_hipi, 
    output logic [BYTE_CNT*4-1:0]  p2c_ctrl_hipi, 
    output logic [BYTE_CNT*12-1:0] phy_gpio_din_hipi 
    );

   genvar 			   BYTE_N;
   genvar 			   i;
   integer 			   LANENUM;
   
   
   logic [BYTE_CNT-1:0] 	   core_clk;
   logic [BYTE_CNT-1:0] 	   srst_n;
  
   for(BYTE_N = 0; BYTE_N < BYTE_CNT; BYTE_N++)
     begin : byte_in_link
	
	assign core_clk[BYTE_N] = link_core_clk;
	
	if (DPHY_TX_EN == 1)
	  begin:drv0
	     assign p2c_hipi[BYTE_N*96 +: 96] = 96'd0;	     
	     assign p2c_ctrl_hipi[BYTE_N*4 +: 4] = 4'd0;
	     assign phy_gpio_din_hipi[BYTE_N*12 +: 12] = 12'd0;	     
	  end
	
`ifdef DPHY_BHV_SIM
	
// synthesis translate_off
	//power-up state on c2p_ctrl_hipi
	initial begin
	   c2p_ctrl_hipi[BYTE_N*20 +: 20] = $urandom();		   
	end
// synthesis translate_on
   
   always @(posedge core_clk[BYTE_N]) begin
      c2p_hipi[BYTE_N*96 +: 96] <= c2p[BYTE_N*96 +: 96];		   
   end
   
   always @(posedge core_clk[BYTE_N]) begin
      c2p_ctrl_hipi[BYTE_N*20 +: 20] <= c2p_ctrl[BYTE_N*20 +: 20];
   end
   
   if (DPHY_RX_EN == 1) begin : dphy_rx_hipi_intf
      
      always @(posedge rx_fwd_clk[BYTE_N]) begin
	 p2c_hipi[BYTE_N*96 +: 96] <= p2c[BYTE_N*96 +: 96];
	 p2c_ctrl_hipi[BYTE_N*4 +: 4] <= p2c_ctrl[BYTE_N*4 +: 4];
      end

      `ifndef P2C_HIPI_1DOMAIN_RESTRICTION
      always @(posedge core_clk[BYTE_N]) begin
         phy_gpio_din_hipi[BYTE_N*12 +: 12] <= phy_gpio_din[BYTE_N*12 +: 12];
      end
      `else
      assign phy_gpio_din_hipi[BYTE_N*12 +: 12] = phy_gpio_din[BYTE_N*12 +: 12];
      `endif   
   end 
   
`else 

   /*
   for (i = (0+BYTE_N*96); i < (96+BYTE_N*96); i++)
     begin : c2p_hipi_inst
	`C2P_HIPI `dphy_mipi_ff_name
	    c2p_hipi_ff
	    (
	     .clk (core_clk[BYTE_N]),
	     .d   (c2p[i]),
	     .q   (c2p_hipi[i])
	     );
     end
    */
   
   for (i = (0+BYTE_N*20); i < (20+BYTE_N*20); i++)
     begin : c2p_ctrl_hipi_inst
	`C2P_CTRL_HIPI `dphy_mipi_ff_name
	    // synthesis translate_off
	    #(
	      .power_up ("high")
	      )
	    // synthesis translate_on
	c2p_ctrl_hipi_ff (
			  .clk (core_clk[BYTE_N]),
			  .d   (c2p_ctrl[i]),
			  .q   (c2p_ctrl_hipi[i])
			  );
     end 

   if (DPHY_TX_EN == 1) begin : dphy_tx_hipi_intf
      for (i = (0+BYTE_N*96); i < (96+BYTE_N*96); i++)
	begin : c2p_hipi_inst
	   `C2P_HIPI `dphy_mipi_ff_name
	       c2p_hipi_ff
	       (
		.clk (core_clk[BYTE_N]),
		.d   (c2p[i]),
		.q   (c2p_hipi[i])
		);
	end
   end
   else begin
   if (DPHY_RX_EN == 1) begin : dphy_rx_hipi_intf

      for (i = (0+BYTE_N*96); i < (96+BYTE_N*96); i++)
	begin : rx_data_deskew
	   if (((i-BYTE_N*96) < 80) && (((i-BYTE_N*96)<32)||((i-BYTE_N*96)>47)) && 
	       ((((i-BYTE_N*96)/16) > 1 ? (((i-BYTE_N*96)/16) - 1) + BYTE_N*4 :  ((i-BYTE_N*96)/16) + BYTE_N*4) < NUM_LANES))
	     begin : c2p_hipi_inst
		`RX_C2P_HIPI `dphy_mipi_ff_name
		  c2p_hipi_ff
		    (
		     .clk (core_clk[BYTE_N]),
		     .d   (c2p[i]),
		     .q   (c2p_hipi[i])
		     );		 
	     end
	   else
	     begin : c2p_hipi_inst_drv0
		assign c2p_hipi[i] = 1'b0;		
	     end
	end
      
      for (i = (0+BYTE_N*96); i < (96+BYTE_N*96); i++)
	begin : p2c_hipi_inst	   
	   `P2C_HIPI `dphy_mipi_ff_name
	       p2c_hipi_ff
	       (
		.clk (rx_fwd_clk[BYTE_N]),
		.d   (p2c[i]),
		.q   (p2c_hipi[i])
		);
	end
      
      for (i = (0+BYTE_N*4); i < (4+BYTE_N*4); i++)
	begin : p2c_ctrl_hipi_inst
	   `dphy_mipi_ff_name
	       p2c_ctrl_hipi_ff
	       (
		.clk (rx_fwd_clk[BYTE_N]),
		.d   (p2c_ctrl[i]),
		.q   (p2c_ctrl_hipi[i])
		);	
	end
      
      for (i = (0+BYTE_N*12); i < (12+BYTE_N*12); i++)
	begin : phy_gpio_din_hipi_inst
	   `ifndef P2C_HIPI_1DOMAIN_RESTRICTION
	   `P2C_HIPI `dphy_mipi_ff_name
	       phy_gpio_din_hipi_ff
	       (
		.clk (core_clk[BYTE_N]),
		.d   (phy_gpio_din[i]),
		.q   (phy_gpio_din_hipi[i])
		);
	   `else
	       assign phy_gpio_din_hipi[i] = phy_gpio_din[i];
	   `endif
	end 
      
   end 
      
   end 
   
`endif
   
end 

endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oKBlGyeVolTQNgpCL+OTkgEVKnDrEJOabYnvnt1bM2SM+UrFxMX7Mw8KXd3LusPjQ0674BKIUQrf9UHy+59Y0Vxj/dVrRj75VyB/8GEA6it0NMp8JNpOKljblOwlDsuCp830uTrJgSmq2nT24LcWbPCfABj49rVamjWlWbywlcsEu4NK28LM/B62pl05oUAdf3LOF0KLXcCrz3bcSzkXFBGT7J6qhIngMZ+FtLphbERFZHNnZiSlOoTMEFFwGGBBdR9BX9AoU3+GA8IXNikrls/O8Wzt4+7ktIFcLV/XCM4ReXDoFr5Bq28+Eq2xiissbCqHr3lTRv7Tu49K/npAa4X9jjY7ZXdZYd6RcK2Yv6Vko0TJBIBWhok5xFUwwQMjm9vyxrlIDq1kFyTIXEla71Ldle9+6p3/4p1sr9pgCnfL7CiphPWVHVW9qilew5uA1ThBrtuPEBLFGWX1jxRbQ9LFl25xd+rZ0Q9du2w7fRELiIYbge4Y3VLh3vsgtmh7ZbOYs+a1sjhXAs/iIe5PT9ER9YkIH9LYhC8nGFomUu9WwmLKd+9TxlraeygomLqBcdCt7mnIANxylqzKhmVunltD+xG5RcAFnDO1q3tsc0EkRk5GvRq9YRB3crQA6InEG1YoblJtX1wU6YXilj4ZpHwGahqhfBEzUhl9XsSFxMgNI68Jqo3Q3VD+ZmQW9qPPpf4J28G6yWY5+QUh73QD+xLH6zjuWnmRZ5XgBD141JZFgGHeR5umQleDeLF6DIlIvnK3gc1R/S15NJFLt3kU/vX"
`endif