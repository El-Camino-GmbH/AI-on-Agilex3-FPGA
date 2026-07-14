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
`define BHV_IBUF_DIFF 1
`endif

`ifdef BHV_IBUF_DIFF
`define ibuf_diff_name dphy_ibuf_diff_bhv
`endif

`define SIM 1

// synthesis translate_on  


`ifndef ibuf_diff_name
`define ibuf_diff_name tennm_ph2_io_ibuf
`endif

module dphy_ibuf_diff_wrap #(
    parameter BYTE_LOC = 0,
    parameter PIN_ID = 0,
    parameter IO_STANDARD = "IO_STANDARD_IOSTD_OFF",
    parameter RZQ_ID = "RZQ0",
    parameter TERMINATION = "TERMINATION_RT_OFF",
    parameter USAGE_MODE = "USAGE_MODE_UNUSED"
) ( 
    input  wire            inp,                            
    input  wire            inpbar,                         
    output wire            outp,                           
    output wire            outbar                          
);

    `ibuf_diff_name #(
        .bus_hold( "BUS_HOLD_FALSE" ),
        .io_standard( IO_STANDARD ),
        .equalization( "EQUALIZATION_OFF" ),
        .rzq_id( RZQ_ID == "RZQ0" ? "RZQ_ID_RZQ0" : "RZQ_ID_RZQ1" ),
        .schmitt_trigger( "SCHMITT_TRIGGER_OFF" ),
        .termination( TERMINATION ),
        .usage_mode( USAGE_MODE ),
        .vref( "VREF_OFF" ),
        .weak_pull_down( "WEAK_PULL_DOWN_OFF" ),
        .weak_pull_up( "WEAK_PULL_UP_OFF" )
    ) ibuf_diff_inst (
        .i( inp ),                                                  
        .ibar( inpbar ),                                            
        .o( outp )                                                  
    );
    assign outbar = ~outp;


endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t+T44SKMotd5x8hjV1hfw+naZQY6dI3TKKGC3gw6o2hqVrpCPkMs/Q6vMgE7uKgAacyYnVTJU9SdNg3MyfBB1qNQEvnejR8kr9znMzqvfOm9p6wAqhS8/oqHZ1EP4tdmEZRCaOtiEkNrl6tI25BOWKR4MdfNXJomzXxuOLImBCzrf3sacCTE5OM+Yv02ugrunP8fUKmmqVEjfONieEnO2yfDwPraMX2BCARGgyxo4EUCr7jxnn82ExTCOE+5J53W2PLC75FSyj5IV8DgJmQi7Z+JgND89nWOrHY3boRTnrXSgCkqIG0/red7d4wvonUKrkcp6pShDFNOQ7WUKkloCUj6jQfnSaykElN79vSxHy7lZEPbumh+2R1GS0FJicLkPzfmvBzWmqoiclAb0j/CHXOW2Wttedhcnlj4XrwnJIZc8W8NXTBWYrmqRKfExXb/cm4Kl5brnvOTSskk+qIPlkGBgg6CNxMRtbTbeImEaZ6oysLW/vu8plO7yKONd/lvFaP3UO8MRHtY9Ixr9VjP259vMg5kim0qabnydKisYT8ovuQXuRLXihDoQSXBM/op8TtDTOrSTxMdU6imm+ArRHUVkv6BFuM2nRwgKNyU9pgUCJG2ZqeBt2FKZVPfa1yxqcsStZV3Yy9dr6bF4wseC9Sef1TfK7y6R0AS6SUQuJAgf7GJd6VbmMdnqDpocpjGBFNhtrJT0vlz4u6bqQEr1qraB9KKZfTbwVDCeegdn/ZELBNMI3kJRp0LIbofRJ1hfIRNejMiepCYVqAHOq5ULgo"
`endif