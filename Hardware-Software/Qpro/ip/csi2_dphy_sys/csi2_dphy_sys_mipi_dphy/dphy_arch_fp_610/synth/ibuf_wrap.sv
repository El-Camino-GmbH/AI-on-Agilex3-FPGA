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

module dphy_ibuf_wrap #(
    parameter BYTE_LOC = 0,
    parameter PIN_ID = 0,
    parameter IO_STANDARD = "IO_STANDARD_IOSTD_OFF",
    parameter RZQ_ID = "RZQ0",
    parameter USAGE_MODE = "USAGE_MODE_UNUSED",
    parameter RX_CAP_EQ_MODE = 0,
    parameter TOGGLE_SPEED = "TOGGLE_SPEED_SLOW"
) ( 
    input  wire            inp,                            
    output wire            outp                            
);

    `ibuf_name #(
        .buffer_usage( "REGULAR" ),
        .bus_hold( "BUS_HOLD_OFF" ),
        .io_standard( IO_STANDARD ),
        .equalization( RX_CAP_EQ_MODE == 1 ? "EQUALIZATION_SMALL" : 
                       RX_CAP_EQ_MODE == 2 ? "EQUALIZATION_MEDIUM"   :
                       RX_CAP_EQ_MODE == 3 ? "EQUALIZATION_LARGE" : "EQUALIZATION_OFF" ),
        .rzq_id( RZQ_ID == "RZQ0" ? "RZQ_ID_RZQ0" : "RZQ_ID_RZQ1" ),
        .schmitt_trigger( "SCHMITT_TRIGGER_OFF" ),
        .termination( "TERMINATION_RT_DIFF" ),
        .usage_mode( USAGE_MODE ),
        .vref( "VREF_OFF" ),
        .weak_pull_down( "WEAK_PULL_DOWN_OFF" ),
        .weak_pull_up( "WEAK_PULL_UP_OFF" ),
        .toggle_speed( TOGGLE_SPEED )
    ) ibuf_inst (
        .i( inp ),                                                  
        .ibar(),
        .o( outp )                                                  
    );

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t+Ldw6fP7XkER55BdOIJBgNa1A351brA0Tx6+OTzskBLEoetwQVoGP+uK8WanmZt6hdy+YbPkksPt7PkWEjHC81IwlLv3Z9hrfqovwYiSLyIM7AAQJIASa06lnQxmrAJZIreule3XVE9rNeCKOGeRfaEFbofRsJ39SYrohYHQY+21WBG6UCeH5mn10Kk2vEElTFr5n7X/Z70BVl70DaYrJyGJaSkJOQY8GZsvEP5m/D+ownVyGZ3U0Hge/fhq2a+LIrnYMLPyHtVOPLIQafUfainsJ1z21yjZ5/Lwj4PyD/8fY4KWhQY3KoPTYR4WY4ezTMWkTCI5Qr+48IlN75m6iThZBhRMvifRQrh+hh31KWAjxM9yW0VmcUVQ5zdg+jgEDhbRXEBJbZuUH/X9CAI/jw4CkDG8hsqj0sRkNG/A4Tv7EemlnO/qfeZQgxSrXYBR9xI6+9eTi28K4noKWAwRSnAH21rwudnr50tnHwsvLhbsV51e9fDX/HlRTcPQdwdi7wU3U1fD3yTCuZnvviKnVGql94Bi6OiRSpNtBVpl8LnXRFUK5+xdsGos5k8y9iMsMPYXSY/ki9pL8vloQs+wdR7VrPv+r+R67LVk8KFrBL0o6fuT85YdoOj5pfTrszF9ZquRBWqC+WENbTWMV1GrMZHZyi3cGC1pXXfIeqtiEXaIuBwbaZmazQbJoQiG3U5GskGyn2dEGIckusLMvo6vVGRMYfBlqgr/uOzGWOgqTF5Xr9DUK+514kEVxlQNbJk/7z1Z5Pgt/u1UiNGxWgi/hY"
`endif