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

module dphy_pcx_data_mux_tx # (
        parameter IO_CONVERT_RATIO = 16,
        parameter NUM_LANES = 4,
        parameter SKEW_CAL_EN = 1,                                  
        parameter ALT_CAL_EN = 1,                                   
        parameter PREAMBLE_EN = 0,
        parameter TM_EN = 0,
        parameter TM_LOOPBACK_MODE = 0,
        parameter LANE_ID = 0,
        parameter VCO_FREQ_MULT = 1     
   ) (
        input  wire             core_clk,          
        input  wire             srst_core_n,
        
        input wire              in_hs,
        input wire              in_zero,
        input wire              in_preamble,
        input wire              in_sync,
        input wire              in_sync2,
        input wire              in_alt_cal,
        input wire              in_skew_cal,
        input wire              in_active,
        input wire              in_trail,
        input wire              hs_ready,
        input wire              in_tm,
        input wire              in_tm_loopback,
        input wire [7:0]        cal_prbs_init,
        input wire              reg_preamble_en,
        input [IO_CONVERT_RATIO-1:0]    loopback_in,
        input wire                      word_cnt_rst,
        output logic [31:0]             word_cnt,   
        input wire                      auto_cal_done,
        input wire                      auto_skew_cal,
        input wire                      auto_alt_cal,
        output logic                    data_next_en,
        dphy_io_if              dphy_port,            
        ppi_if                  ppi_tx
    );

    localparam SKEW_PATTERN = IO_CONVERT_RATIO == 16 ? 16'hAAAA : 8'hAA;
    localparam PREAMBLE_PATTERN = IO_CONVERT_RATIO == 16 ? SYNC_PREAMBLE : SYNC_PREAMBLE[7:0];

    logic is_skew_cal;
    logic is_alt_cal;
    logic [IO_CONVERT_RATIO-1:0] e_data_out;
    logic [IO_CONVERT_RATIO-1:0] data_out;
    logic [IO_CONVERT_RATIO-1:0] data_out_q;
    logic drive_0;
    logic drive_1;
    logic [IO_CONVERT_RATIO-1:0] alt_data_out;
    logic alt_trail_bit;
    logic [IO_CONVERT_RATIO-1:0] ppi_data_out;
    logic [IO_CONVERT_RATIO-1:0] data_mux_o;
    logic [IO_CONVERT_RATIO/8-1:0] ppi_data_out_en;
    logic [IO_CONVERT_RATIO-1:0] e_ppi_data_out;
    logic [IO_CONVERT_RATIO/8-1:0] e_ppi_data_out_en, e_ppi_data_out_en_comb;
    logic ppi_hs_ready;
    logic e_ppi_data_valid;   
    logic ppi_trail_bit;
    logic in_trail_q;
    logic [IO_CONVERT_RATIO-1:0] sync_pat;
    logic [IO_CONVERT_RATIO-1:0] sync_pat2;
    logic trail0, trail1;
    logic in_loopback;
    logic data_next_en_q;
    logic was_skew_cal;
    logic was_alt_cal;
    logic prbs_en;
    logic in_tm_sync, in_tm_loopback_sync;
    logic [7:0] cal_prbs_init_sync;
   
   altera_std_synchronizer_nocut#(.depth(3)) in_tm_cdc (.clk(core_clk), .reset_n(1'b1), .din(in_tm), .dout(in_tm_sync));
   altera_std_synchronizer_nocut#(.depth(3)) in_tm_lb_cdc (.clk(core_clk), .reset_n(1'b1), .din(in_tm_loopback), .dout(in_tm_loopback_sync));

   genvar 	i;
   for(i=0; i<8; i++)
     begin: prbs_init 
	altera_std_synchronizer_nocut#(.depth(3)) inst_cdc (.clk(core_clk), .reset_n(1'b1), .din(cal_prbs_init[i]), .dout(cal_prbs_init_sync[i]));
     end
	

    assign e_ppi_data_out = ppi_tx.TxDataHS[LANE_ID][0 +: IO_CONVERT_RATIO];
    assign e_ppi_data_out_en = ppi_tx.TxWordValidHS[LANE_ID][0 +: IO_CONVERT_RATIO/8];
    assign e_ppi_data_valid = |e_ppi_data_out_en & ppi_tx.TxDataTransferEnHS[LANE_ID];
   
    assign ppi_hs_ready = data_next_en & hs_ready;
    assign ppi_tx.TxReadyHS[LANE_ID] = auto_cal_done & (ppi_hs_ready | in_skew_cal | in_alt_cal);
    assign is_skew_cal = ppi_tx.TxSkewCalHS[LANE_ID] | auto_skew_cal;
    assign is_alt_cal = ((ALT_CAL_EN == 1) && (ppi_tx.TxAlternateCalHS[LANE_ID] | auto_alt_cal));
    assign in_prbs = in_alt_cal | (in_tm_sync & ~in_tm_loopback_sync);
    assign in_loopback = in_tm_sync & in_tm_loopback_sync;

    always @(posedge core_clk)
    begin
        in_trail_q <= in_trail;
        was_skew_cal <= in_trail == 1'b0 ? in_skew_cal : was_skew_cal;
        was_alt_cal <= in_trail == 1'b0 ? in_alt_cal : was_alt_cal;
    end
    
    if(IO_CONVERT_RATIO == 16)
    begin: hs_data_path
        always @(posedge core_clk)
            if( (ppi_hs_ready & e_ppi_data_valid) == 1'b1)
                ppi_trail_bit = e_ppi_data_out_en[1] ? ~e_ppi_data_out[15] : ~e_ppi_data_out[7];

        always @(*)
            begin
                ppi_data_out[7:0] <= e_ppi_data_out[7:0];
                ppi_data_out[15:8] <= e_ppi_data_out_en[1] ? e_ppi_data_out[15:8] : {8 {~e_ppi_data_out[7]}};
            end

        always @(*)
        begin
            sync_pat <= is_skew_cal ? SYNC_SKEW_CAL :
                        is_alt_cal ? { SYNC_ALT_CAL , 8'h0} :
                        reg_preamble_en ? SYNC_HS_DATA_PRE : { SYNC_HS_DATA, 8'h0 };
                        
        end

        assign sync_pat2 =  'h0;
        
    end
    else
    begin: hs_data_path
        always @(posedge core_clk)
            if(ppi_hs_ready & e_ppi_data_valid == 1'b1)
                ppi_trail_bit = ~e_ppi_data_out[7];

        always @(*)
                ppi_data_out[7:0] <= e_ppi_data_out[7:0];


        always @(*)
        begin
            sync_pat <= is_skew_cal ? SYNC_SKEW_CAL[7:0] :
                        is_alt_cal ? SYNC_ALT_CAL :
                        reg_preamble_en ? SYNC_HS_DATA_PRE[7:0] : SYNC_HS_DATA;
                        
        end

        assign sync_pat2 =  is_skew_cal == 1'b1 ? SYNC_SKEW_CAL[15:8] : 
                            SYNC_HS_DATA_PRE[15:8];

    end
    
    always @(*)
    begin: trail_bit
        case( { in_trail, was_alt_cal, was_skew_cal } )
            3'b110:
                begin
                    trail0 <= ~alt_trail_bit;
                    trail1 <= alt_trail_bit;
                end
            3'b100:
                begin
                    trail0 <= ~ppi_trail_bit;
                    trail1 <= ppi_trail_bit;
                end
            3'b101:
                begin
                    trail0 <= 1'b1;
                    trail1 <= 1'b0;
                end
            default:
                begin
                    trail0 <= ~in_hs;
                    trail1 <= 1'b0;
                end
        endcase
    end
    
    assign drive_0 = in_zero | trail0;
    assign drive_1 = trail1;
    
    assign e_data_out = (   ( { IO_CONVERT_RATIO{in_prbs} } & alt_data_out ) |
                            ( { IO_CONVERT_RATIO{in_skew_cal} } & SKEW_PATTERN ) |
                            ( { IO_CONVERT_RATIO{in_preamble} } & PREAMBLE_PATTERN ) |
                            ( { IO_CONVERT_RATIO{in_sync} } & sync_pat ) |
                            ( { IO_CONVERT_RATIO{in_sync2} } & sync_pat2 ) |
                            ( { IO_CONVERT_RATIO{in_active} } & ppi_data_out ) );
                            
    always @(posedge core_clk) 
    begin
        if( ( data_next_en | ~in_hs ) == 1'b1)
            data_out <= e_data_out;
        data_next_en_q <= data_next_en | ~in_hs;
        if(data_next_en_q == 1'b1)
            data_out_q <= { IO_CONVERT_RATIO{~drive_0} } & ( { IO_CONVERT_RATIO{drive_1} } | data_out );
    end

    assign prbs_en = data_next_en & ( in_prbs | (in_sync & is_alt_cal) );

   if(ALT_CAL_EN == 1)
    begin: alt_cal_drv
        dphy_prbs9 # (
        .WIDTH(IO_CONVERT_RATIO) 
        ) prbs9_gen (
            .clk(core_clk),
            .srst_n(srst_core_n),
            .enable(prbs_en),
            .skip(1'b0),
            .pause(1'b0),
            .init_val({cal_prbs_init_sync, 1'b0}),
            .out_valid(),
            .prbs_next(),
            .prbs_out(alt_data_out)
        );
        
        always @(posedge core_clk)
            alt_trail_bit <= data_next_en & in_prbs ? ~alt_data_out[IO_CONVERT_RATIO-1] : alt_trail_bit;
        
    end
    else
    begin: no_alt_cal_drv
        assign alt_data_out = 'h0;
        assign alt_trail_bit = 1'b0;
    end


   if(TM_EN == 1)
     begin: tx_word_cnt
        always @(posedge core_clk)
          if( (srst_core_n & ~word_cnt_rst) == 1'b0)
            word_cnt <= 'h0;
          else
            word_cnt <= word_cnt + in_hs;
     end
   else
     begin: drv0
	assign word_cnt = 'h0;	
     end

     
    if( VCO_FREQ_MULT > 1 )
    begin: tx_data_mux
        localparam SEL_WIDTH = $clog2(VCO_FREQ_MULT);
        localparam WIDTH_SELECTED = IO_CONVERT_RATIO / VCO_FREQ_MULT;
        logic [IO_CONVERT_RATIO-1:0] dmux_i;
        logic [IO_CONVERT_RATIO-1:0] dmux_o;
        logic [WIDTH_SELECTED-1:0] dmux_int;
        logic [SEL_WIDTH - 1 : 0] sel;
        logic [SEL_WIDTH - 1 : 0] sel_q;
        int j, i;
        
        assign dmux_i = data_out_q;
        
        always @(posedge core_clk)
        begin
            if(in_hs == 1'b0)
                sel <= 'h0;
            else
                sel <= sel + 1'b1;
        end

        always @(posedge core_clk)
            sel_q <= sel;
        
        assign data_next_en = &sel;

     


        if ( VCO_FREQ_MULT == 2 )
	  begin: by_2
	     always @(*)
	       begin
		  case (sel_q)
		    1'b0 : dmux_int = dmux_i[0*WIDTH_SELECTED +: WIDTH_SELECTED];
		    1'b1 : dmux_int = dmux_i[1*WIDTH_SELECTED +: WIDTH_SELECTED];
		  endcase
	       end
          end
 
        else if ( VCO_FREQ_MULT == 4 )
	  begin: by_4
	     always @(*)
	       begin
		  case (sel_q)
		    2'b00 : dmux_int = dmux_i[0*WIDTH_SELECTED +: WIDTH_SELECTED];
		    2'b01 : dmux_int = dmux_i[1*WIDTH_SELECTED +: WIDTH_SELECTED];
		    2'b10 : dmux_int = dmux_i[2*WIDTH_SELECTED +: WIDTH_SELECTED];
		    2'b11 : dmux_int = dmux_i[3*WIDTH_SELECTED +: WIDTH_SELECTED];
		  endcase
	       end
          end
 
        else if ( VCO_FREQ_MULT == 8 )
	  begin: by_8
	     always @(*)
	       begin
		  case (sel_q)
		    3'b000 : dmux_int = dmux_i[0*WIDTH_SELECTED +: WIDTH_SELECTED];
		    3'b001 : dmux_int = dmux_i[1*WIDTH_SELECTED +: WIDTH_SELECTED];
		    3'b010 : dmux_int = dmux_i[2*WIDTH_SELECTED +: WIDTH_SELECTED];
		    3'b011 : dmux_int = dmux_i[3*WIDTH_SELECTED +: WIDTH_SELECTED];
		    3'b100 : dmux_int = dmux_i[4*WIDTH_SELECTED +: WIDTH_SELECTED];
		    3'b101 : dmux_int = dmux_i[5*WIDTH_SELECTED +: WIDTH_SELECTED];
		    3'b110 : dmux_int = dmux_i[6*WIDTH_SELECTED +: WIDTH_SELECTED];
		    3'b111 : dmux_int = dmux_i[7*WIDTH_SELECTED +: WIDTH_SELECTED];
		  endcase
	       end
          end   
        
        always @(*)
        begin
            for(i = 0 ; i < WIDTH_SELECTED; i++)
            begin
                dmux_o[i*VCO_FREQ_MULT +: VCO_FREQ_MULT] <= { VCO_FREQ_MULT { dmux_int[i] } };
            end
        end
        
        assign data_mux_o = dmux_o;
        
    end
    else
    begin: tx_data_mux
        assign data_mux_o = data_out_q;
        assign data_next_en = 1'b1;
    end
         
    assign dphy_port.tx_wr_data[LANE_ID*IO_CONVERT_RATIO +: IO_CONVERT_RATIO] = in_loopback ? loopback_in : data_mux_o;

endmodule 



`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oK69ytwj8533N3AFyome0FszEtzqqP5C+ODP+oGsRwEOwhMJr8Q2cwVQm1ZVUwND/PhSVHm6ni++Yi7vwwwSFbQUMEXDQqnv516E0mCsMnRuDGyf/n2VygVL5kOPwuzWafw3qBXoL3sALnGuY2TBV0D6BRazjM9i5WHgiI1WB1X9YmOclv6O6rO1bmsyfiPfmHBYw79x/HUPinMOZnaWhx9hvI+DgdY6F1lmNGDzbjCmp6ZAz+Iu83+Dwq7qi1/UfzilEFvDSYpL2H7JqH2RYEGHoNkTEWXGXlxe76r86KmDVVnpN8Sy2kmLwzNrNkg9tKzMlHxH2anmB/NS2QK19QBLXqHrAnkymh908eZlkNgD1b48BSahAsfWP+O1VOhA09R9qbDvRVK4mmuU9MaH6nPA3ThReBc/kSdbfXopjHtZYOJlSSz/NSNWmxMLazI4a3S/L6mshaf9GRIFokJCMCBFwFsyRbRT4eAsWL6RJowAUUF0hkCIWntA/zlgWZoVmVm9iG64g2A6az94teVQ84qwo8h+kXeYrPNYux0jVJTVBkwiKjKUp5dyaOf0Qo1NB5h1rM7ixDk43jUq1DSsB5Aqi3TXIUNJ2ucaM4gFG+uAVjWmkU7pjtNY4l2JZQbp7iF56cv9Z8lwENFCuqV0IEGYd8wb8VTH0pTyctRL7l55Uc5SDBfQz+tIY4ZacQtWIOTF3HYYiSLtRlzH3+glKHUFzOMfXrCKHLYnuFuMDjNwCB2i4+9hmvOH8NFKO9jhMwxG0rSb0kIzWTIYcprbj6L"
`endif