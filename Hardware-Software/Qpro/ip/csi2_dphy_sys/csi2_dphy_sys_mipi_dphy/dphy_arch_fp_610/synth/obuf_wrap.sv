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
`define BHV_OBUF 1
`endif

`ifdef BHV_OBUF
`define obuf_name dphy_obuf_bhv
`endif

`define SIM 1

// synthesis translate_on  


`ifndef obuf_name
`define obuf_name tennm_ph2_io_obuf
`endif

module dphy_obuf_wrap #(
    parameter BYTE_LOC = 0,
    parameter PIN_ID = 0,
    parameter RZQ_ID = "RZQ0",
    parameter TX_CAP_EQ_MODE = 0,
    parameter BIT_RATE = 36'd3200000000, 
    parameter TOGGLE_SPEED = "TOGGLE_SPEED_SLOW"                   
) ( 
    input wire 	inp, 
    input wire 	negbuf_in,
    input wire 	oe, 
    output wire obar,
    output wire posbuf_out,
    output wire outp                            
);

   `obuf_name #(
                .buffer_usage( "REGULAR" ),
                .io_standard( "IO_STANDARD_IOSTD_DPHY" ),
                .usage_mode( "USAGE_MODE_DPHY" ),
                .termination( "TERMINATION_SERIES_45_OHM_CAL" ),
                .rzq_id( RZQ_ID == "RZQ0" ? "RZQ_ID_RZQ0" : "RZQ_ID_RZQ1" ),
                .slew_rate( BIT_RATE < 1500000000 ? "SLEW_RATE_FAST" : "SLEW_RATE_FASTEST"),
                .equalization( TX_CAP_EQ_MODE == 1 ? "EQUALIZATION_2TAPS_MEDIUM_LP" : 
                               TX_CAP_EQ_MODE == 2 ? "EQUALIZATION_2TAPS_HIGH_LP"   :
                               TX_CAP_EQ_MODE == 3 ? "EQUALIZATION_2TAPS_MEDIUM_CZ" : "EQUALIZATION_OFF"),
                .open_drain( "OPEN_DRAIN_OFF" ),
                .toggle_speed( TOGGLE_SPEED ),
                .dynamic_pull_up_enabled( "FALSE" )
    ) obuf_inst (
                 .i( inp ),                                                    
                 .negbuf_in (negbuf_in),
                 .oe( oe ),                                                    
                 .obar(obar),
                 .posbuf_out(posbuf_out),
                 .o( outp )                                                    
                 );
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t/PwafzjHF4GVcu+O7darRaCR8Xyvb0ZA7eEyMjXzC4spchpcZbh7MJ3rRc1/fgzPfvyPm5o7myz98/xvz/FBa8FXlStvUmzDovxwxJvvZ1wcB+j0odaaMDk4nJgy0XSOUU2FMFLt3uZAheIJPUNj+ZevNyVyOdQ1jvXhznS1PsOoCzxaRWidDstyONUEFsFreTZn1knF2QyjMahInfLeZDzc/IqZ+e8cCt65c9dS+M98Uli7uInyF2v5b3TAkg3kwWaNlb105B82azstjezAJ15mTteRie4uhfYsZaQthPDcpPVRgnYx3Z8uoSnVx3WcIHMBBwU7qTXYavnSa39hENUEsVhFB/MVwxRcFgF4Y3hfRUqOnN1A96I5ij4UBNzHW5zkSgDrtznHH+RKxAtrrVZjtcdFZLK28lctdAKvgdnboKMCZvgrbWSqXyr/VezJ6gAIp6w4BjarfdlKz/D0oc0wM+cLdg2kqCfkPgH6j6VZG4mpFqYesOt5FPlQFQiGP92osqbxTQ5W1D3U1js3TdXDPgDWIUdHlbkeZBeF3Q0yIQm5yr8yhTA4X5Mvmi1tm5qrocbLyNY7ZUK6KGz0ek6iDSneWuWC7YCYplCPpb5GdbIFe1Oo8kNOMiMZKX+kuPLwVMc484ZBFuPV3Oo/AAGhzN1Cw0wnzxNR1e3vBIFyFf0b5qEqTxR2s1P8RdMiL5ELLpbVITnjBm+8Vd+MIlA9zwp/cLeb/qG8pTovCeD8SH339WpRj+gpUOTgbx1igzuTC3kHr7mma2gJuj1eef"
`endif