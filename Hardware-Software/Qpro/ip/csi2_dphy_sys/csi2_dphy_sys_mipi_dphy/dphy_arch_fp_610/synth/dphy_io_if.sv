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

interface dphy_io_if #(
    parameter NUM_LANES = 8,
    parameter IO_CONVERT_RATIO = 16,
    parameter BYTE_CNT = NUM_LANES > 4 ? 2 : 1
    ) ;
   
    logic [BYTE_CNT-1:0]                         rx_clk;         
    logic [NUM_LANES*IO_CONVERT_RATIO-1:0]       rx_rd_data; 
    logic [3:0]                                  rx_rd_valid;   
    logic                                        rx_clk_lp_p;
    logic                                        rx_clk_lp_n;
    logic [NUM_LANES-1:0]                        rx_data_lp_p;
    logic [NUM_LANES-1:0]                        rx_data_lp_n;
    logic [3:0]                                  rx_data_read_en;    
    logic                                        rx_clk_lp_hs_b;
    logic [NUM_LANES-1:0]                        rx_data_lp_hs_b;
    logic [16*NUM_LANES-1:0]                     rx_data_deskew_cntrl;
    logic                                        core_clk;
    logic                                        srst_n;

    logic [NUM_LANES*IO_CONVERT_RATIO-1:0]       tx_wr_data; 
    logic [IO_CONVERT_RATIO-1:0]                 tx_clk_data; 
    logic                                        tx_clk_lp_p;
    logic                                        tx_clk_lp_n;
    logic [NUM_LANES-1:0]                        tx_data_lp_p;
    logic [NUM_LANES-1:0]                        tx_data_lp_n;
    logic [NUM_LANES-1:0]                        tx_data_lp_hs_b;
    logic                                        tx_clk_lp_hs_b;

    logic                                        mnl_tx_en;
    logic                                        mnl_tx_clk_lp_hs_b;
    logic [NUM_LANES-1:0]                        mnl_tx_data_lp_hs_b;
    logic                                        mnl_tx_data_lp_p;
    logic                                        mnl_tx_data_lp_n;
    logic [1:0]                                  mnl_tx_data_hs;
    logic [1:0]                                  mnl_tx_clk_hs;


endinterface : dphy_io_if
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t/JKN2S7Qkdbf04yase7U3u3B+3ltC1YUv8Ex0pqfaAmEAodQBK8bKCOcAgnRW6Hvwkg5hbsowTGdekftlPOKCxePdVGN27HiuRoru0bGzoSGZHTqeG62ZwUdIXDlFWHsyf7c8oi08ixMgi5gj9vHQCoHEAzSQJ7RsTW3SqO0v9+b+1SKNyXFcxE4ft9PE5WVxwmc6xDh4dmnib9E/Umb2zt1Ut/+9N8iQmSiBAc9P8S9/ZgKcOClLd2DFO9yihuBpuXeiWTs1QtNlMH/TW/4iA5IU74tHhPsZZ2/+ciLKWvDy8/YrKkwIqFLKmckaTRsCVvxyUm0dOyfYI7KZ9RCceHfaf57YBeEpKSNQpoSP2mt46IUnp7Oqn8XGJ+ft9M2Qyg4Ev/MlCkq1AK4kpjTVOo1EyawDzSU/ILei+G+2iI8UXIIBXLf3sYDf10oXONghBE9hKMTfzvrFMhTO6/j0RRS4276tqudZp68nmKrzGYoO35i/IUYd8deGER12D8Hw4Pmi5cR9tBaQcVFIIjYFLKWZrdXHCK2og0ZFx7KZFNLhnbg43JgF2VG8PXbcraYQaa9dUVdgFG1qUFWqAIdzg1dnpCmIA7WFcBeBs3/KtCGZWy0Fn1exBhW8pRr9JTfNyqk9xQJqCR9SC+cPuu3ZYU3v4+uXCd7JLv54jYlqDGY2BNNMsOFYK6rJyOVNTV4ywSe4ILGHUK39mnZO65egiILs5U+j8VQ8e2x3TA/xZtG0/UirlKOBr8JRhJ2hMfAsEcj2AIf65BwtKBO35ciNP"
`endif