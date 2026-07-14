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
`ifdef MIPI_RTL_SIM_BHV
import dphy_pkg_sim::*;
`endif

module dphy_cp_map #(
    parameter NUM_LANES = 4,                            
    parameter IO_CONVERT_RATIO = 16,                    
    parameter DPHY_RX_EN = 0,                           
    parameter DPHY_TX_EN = 0,                           
    parameter BYTE_CNT = NUM_LANES>4 ? 2 : 1            
    )
   (    

        input  [BYTE_CNT-1:0]           rx_fwd_clk,          
        input  [BYTE_CNT*96-1:0]        p2c,                 
        input  [BYTE_CNT*4-1:0]         p2c_ctrl,            
        input  [BYTE_CNT*12-1:0]        phy_gpio_din,        

        output logic [BYTE_CNT*96-1:0]  c2p,                 
        output logic [BYTE_CNT*20-1:0]  c2p_ctrl,            

        dphy_io_if                      dphy_io             
    );

    integer i, j, k;


    




    if (DPHY_RX_EN == 1)
    begin : dphy_rx_inf
        assign dphy_io.rx_clk[BYTE_CNT-1:0] = rx_fwd_clk[BYTE_CNT-1:0];
       
        always @(*)
        begin
            for(i = 0 ; i < BYTE_CNT*4; i++)
            begin
                k = (i>3) ? 1 : 0;
                j = (i%4) > 1 ? (i%4) + 1 : (i%4);
                if(i<NUM_LANES)
                begin
		    dphy_io.rx_rd_data[i*IO_CONVERT_RATIO +: IO_CONVERT_RATIO] <= p2c[k*96+j*16 +: IO_CONVERT_RATIO];
                    dphy_io.rx_data_lp_p[i] <= phy_gpio_din[k*12+2*j];
                    dphy_io.rx_data_lp_n[i] <= phy_gpio_din[k*12+2*j+1];
                    if(j < 2)
                        c2p_ctrl[k*20+18+j] <= dphy_io.rx_data_lp_hs_b[i];
                    else
                        c2p_ctrl[k*20+12+j-2] <= dphy_io.rx_data_lp_hs_b[i];
                    c2p[k*96+j*16 +: 16] <= dphy_io.rx_data_deskew_cntrl[i*16 +: 16];
                end
                else
                begin
                    if(j < 2)
                        c2p_ctrl[k*20+18+j] <= 1'b0;
                    else
                        c2p_ctrl[k*20+12+j-2] <= 1'b0;
                    c2p[k*96+j*16 +: 16] <= 16'h0;
                end
            end
        end
        
        always @(*)
        begin
            dphy_io.rx_rd_valid[3:0] = p2c_ctrl[3:0];
            for(i = 0 ; i < (NUM_LANES+3)/4; i++)
            begin
                c2p_ctrl[i*20+8 +: 4] <= dphy_io.rx_data_read_en;
                c2p[i*96+2*16 +: 16] <= 16'h0;
                c2p_ctrl[i*20+15] <= 1'b0;
                if(i == 0)
                begin
                    dphy_io.rx_clk_lp_p <= phy_gpio_din[4];
                    dphy_io.rx_clk_lp_n <= phy_gpio_din[5];
                    c2p_ctrl[12] <= dphy_io.rx_clk_lp_hs_b;
                end
                else
                begin
                   c2p_ctrl[32] <= 1'b0;
                end
            end
        end 

        always @(*)
        begin
            for(i = 0 ; i < (NUM_LANES+3)/4; i++)
            begin
	       c2p[i*96 + 80 +: 16] = {16{1'b0}};
	       c2p_ctrl[i*20 + 0  +: 8] = {8{1'b0}};
	       c2p_ctrl[i*20 + 16 +: 2] = {2{1'b0}};
	    end	     
        end   
   
    end
    else if (DPHY_TX_EN == 1)
    begin : dphy_tx_inf
        
        logic [IO_CONVERT_RATIO-1:0] mnl_hs_data;
        logic [IO_CONVERT_RATIO-1:0] mnl_hs_clk;
        
        assign mnl_hs_data = { (IO_CONVERT_RATIO/2) { dphy_io.mnl_tx_data_hs } };
        assign mnl_hs_clk = { (IO_CONVERT_RATIO/2) { dphy_io.mnl_tx_clk_hs } };
       
        always @(*)
        begin
            for(i = 0 ; i < BYTE_CNT*4; i++)
            begin
                k = (i>3) ? 1 : 0;
                j = (i%4) > 1 ? (i%4) + 1 : (i%4);
                if(i<NUM_LANES)
                begin
                    c2p[k*96+j*16 +: IO_CONVERT_RATIO] <= dphy_io.mnl_tx_en == 1'b1 ? mnl_hs_data : dphy_io.tx_wr_data[i*IO_CONVERT_RATIO +: IO_CONVERT_RATIO];
                    if(j==4) 
                    begin: gpio_dout_8_9
                        c2p_ctrl[k*20+16] <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_data_lp_p : dphy_io.tx_data_lp_p[i];
                        c2p_ctrl[k*20+17] <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_data_lp_n : dphy_io.tx_data_lp_n[i];
                    end
                    else
                    begin: gpio_dout_0_7
                        c2p_ctrl[k*20+2*j]   <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_data_lp_p : dphy_io.tx_data_lp_p[i];
                        c2p_ctrl[k*20+2*j+1] <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_data_lp_n : dphy_io.tx_data_lp_n[i];
                    end
                    if(j < 2)
                    begin: gpio_dout_sel_0_1
                        c2p_ctrl[k*20+18+j] <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_data_lp_hs_b[i] : dphy_io.tx_data_lp_hs_b[i];
                    end
                    else
                    begin: gpio_dout_sel_2_4
                        c2p_ctrl[k*20+12+j-2] <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_data_lp_hs_b[i] : dphy_io.tx_data_lp_hs_b[i];
                    end
                end
                else
                begin
                    c2p[k*96+j*16 +: IO_CONVERT_RATIO] <= {IO_CONVERT_RATIO{1'b0}};
                    if(j==4)
                    begin
                        c2p_ctrl[k*20+16] <= 1'b0;
                        c2p_ctrl[k*20+17] <= 1'b0;
                    end
                    else
                    begin
                        c2p_ctrl[k*20+2*j]   <= 1'b0;
                        c2p_ctrl[k*20+2*j+1] <= 1'b0;
                    end
                    if(j < 2)
                        c2p_ctrl[k*20+18+j] <= 1'b0;
                    else
                        c2p_ctrl[k*20+12+j-2] <= 1'b0;
                end
            end
        end
        always @(*)
        begin
            for(i = 0 ; i < (NUM_LANES+3)/4; i++)
            begin
                c2p_ctrl[i*20+8 +: 4] <= dphy_io.rx_data_read_en;
                c2p_ctrl[i*20+15] <= 1'b0;  
                if(i==0)
                begin
                    c2p[32 +: IO_CONVERT_RATIO] <=  dphy_io.mnl_tx_en == 1'b1 ? mnl_hs_clk : dphy_io.tx_clk_data[i*IO_CONVERT_RATIO +: IO_CONVERT_RATIO];
                    c2p_ctrl[4]  <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_data_lp_p : dphy_io.tx_clk_lp_p;
                    c2p_ctrl[5]  <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_data_lp_n : dphy_io.tx_clk_lp_n;                    
                    c2p_ctrl[12] <= dphy_io.mnl_tx_en == 1'b1 ? dphy_io.mnl_tx_clk_lp_hs_b : dphy_io.tx_clk_lp_hs_b;
                end
                else
                begin
                    c2p[96+32 +: IO_CONVERT_RATIO] <= {IO_CONVERT_RATIO{1'b0}};
                    c2p_ctrl[24]  <= 1'b0;
                    c2p_ctrl[25]  <= 1'b0;                    
                    c2p_ctrl[32] <= 1'b0;
                end
            end
        end

        always @(*)
        begin
            for(i = 0 ; i < (NUM_LANES+3)/4; i++)
            begin
	       c2p[i*96 + 80 +: 16] = {16{1'b0}};
	    end	     
        end 

    end

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oJFZIfzTOzVZICeNYIGXOarA/KN+ZVX0XJ+f9BXIN8aBjBDmzzE0PMkKSDAxIVuVvAJG+5mdTwebgJAZZpfd6HbJVIHYgiHCQyd0HvMa+o/0ylvDBi4h71rPBVbvEMS5uF2H/y0NW0WR6KtzptJZGi53PzAyQPchDjjD0pRca556b3cYTujVh/6Hkqo0vIlXExenhys3Va9tzSK/p8Z30eaBmJunMkVkh7PYnr6itpMYHtTJ/MHAnrg0ApNYZeh1hZrJRYaFur8i7aQ6MLfq9Hci0r9oTxXS+ftRFMoRoqxYh2L9MisquDWyTsbdKsU86x+JoZOfK508nz92RnIi8lOPReFf6UKpaqHZzZ2AsqxM0jGy4v96D61RzHOvwHe8yCphyw7LCt+8nPcTZPVU8MBsbBg2L9p4DQoAVbzAURf3G55MRZ/5FD3hVihji3yqMLl+ypzrdz4S0TovpHseVkLHq4tGgx0G7Pl7+47ik0+iWNo9PoQwe3IgAozbQ62uV8N8mUmBSgz3BuGKgmMIu2qIgaDru46b5HETa/deEuk19buvpHSmbU1afGWlkins/PbWURN/gCFaDCncOI62KlOx/kOuW6xilwbEwtpjctfEz8y25euhcA/fsiBs1sGFeNgubev9NXm5/cUPRLCu3U5Plry1ctwqR8ftFs+DAvuM1CZv1nk+n79XGk4JsSfEIvSkrECHPIQ/C3xOpeuZr9ouIy6B/b4GYSnhl0948opan+xzX03T2liq+7CJ8Ke1oVvFcrNEQ5DboZCG6MXCPej"
`endif