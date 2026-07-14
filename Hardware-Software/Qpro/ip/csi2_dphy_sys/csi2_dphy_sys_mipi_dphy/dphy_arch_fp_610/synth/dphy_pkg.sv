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



package dphy_pkg;

    timeunit 1ns;
    timeprecision 1ps;
    
    `ifdef VIP
    typedef struct { logic dp, dn; } dpdn_t;
    `else
    typedef enum int { LP_00, LP_01, LP_10, LP_11, HS_0, HS_1, UNKNOWN, HS_UNKNOWN } dpdn_t;
    `endif
    localparam IP_ID = 8'h0;
    localparam RX_DATA_RESET_PIPE_DEPTH = 2;
    localparam RX_CLK_RESET_PIPE_DEPTH = 2;
    localparam TX_DATA_RESET_PIPE_DEPTH = 2;
    localparam TX_CLK_RESET_PIPE_DEPTH = 2;

    localparam SYNC_ALT_CAL = 8'h0f;
    localparam SYNC_HS_DATA = 8'hb8;  
    localparam SYNC_HS_DATA_PRE = 16'hb8ff;
    localparam SYNC_ALP = 8'h49;  
    localparam SYNC_EXTEND = 8'hff;
    localparam SYNC_SKEW_CAL = 16'hffff;
    localparam SYNC_SKEW_CAL_RX = 16'hfffc;  
    localparam SYNC_PREAMBLE = 16'h5555;

    localparam SYNC_SWAP_EN = 1;

    localparam LPCTRL_DIFF = 2'b00;
    localparam LPCTRL_HS_RQST = 2'b01;
    localparam LPCTRL_LP_RQST = 2'b10;
    localparam LPCTRL_STOP = 2'b11;
    localparam LPCTRL_BRIDGE = 2'b00;
    localparam ESC_SPACE = 2'b00;
    localparam ESC_MARK_0 = 2'b01;
    localparam ESC_MARK_1 = 2'b10;

    
    localparam ESC_LPDT_CMD = 8'h87;  
    localparam ESC_ULPS_CMD = 8'h78; 
    localparam ESC_UNDEFINED1_CMD = 8'hf9; 
    localparam ESC_UNDEFINED2_CMD = 8'h7b;  
    localparam ESC_RESET_CMD = 8'h46;    
    localparam ESC_HS_TST_CMD = 8'hba;   
    localparam ESC_UNKNOW4_CMD = 8'h84 ; 
    localparam ESC_UNKNOW5_CMD = 8'h05; 
    
    localparam CAL_IP_DELAY_CHANGE_PIPE_DEFAULT = 2;                     
    
    localparam CAL_DESKEW_CTRL_BITS = 16;                        
    localparam CAL_IO_DESKEW_CTRL_REG_BITS = 8;                  
    localparam CAL_IO_FA_PIPE_DEPTH = 3;                         

    localparam CAL_IO_RX_PIPE_DEPTH_16 = 2;                  
    localparam CAL_IO_RX_PIPE_DEPTH_8 = 2;                   

    localparam IO_RX_PIPE_DEPTH_16 = CAL_IO_RX_PIPE_DEPTH_16;    
    localparam IO_RX_PIPE_DEPTH_8 = CAL_IO_RX_PIPE_DEPTH_8;      
    localparam IO_TX_PIPE_DEPTH_16 = 3;                          
    localparam IO_TX_PIPE_DEPTH_8 = 5;                           
    
    localparam CAL_IO_RX_VAR_DEPTH_16 = 0;       
    localparam CAL_IO_RX_VAR_DEPTH_8 = 0;        

    localparam CAL_DESKEW_CTRL_BIT_WEN = CAL_DESKEW_CTRL_BITS-1; 
    
    localparam RX_PCS_DATA_HYPERPIPE_DEPTH_DEFAULT = 0;                   
    localparam RX_PCS_DATA_SYNC_PAT = 4;                                  
    
    localparam CAL_IP_FA_PIPE_DEPTH_16 = CAL_IO_FA_PIPE_DEPTH + 1;       
    localparam CAL_IP_FA_PIPE_DEPTH_8 = CAL_IP_FA_PIPE_DEPTH_16 + 1;     
    localparam CAL_IP_RX_PIPE_DEPTH_16 = CAL_IO_RX_PIPE_DEPTH_16 + CAL_IO_RX_VAR_DEPTH_16 + RX_PCS_DATA_SYNC_PAT;       
    localparam CAL_IP_RX_PIPE_DEPTH_8 = CAL_IO_RX_PIPE_DEPTH_8 + CAL_IO_RX_VAR_DEPTH_8+ RX_PCS_DATA_SYNC_PAT;  
    localparam CAL_IP_RX_CYCLE_DURATION_BASE_16 = CAL_IP_RX_PIPE_DEPTH_16;                    
    localparam CAL_IP_RX_CYCLE_DURATION_BASE_8 = CAL_IP_RX_PIPE_DEPTH_8;                     
    localparam CAL_IP_RX_EXTEND_CMP_SKEW_16 = 3;                         
    localparam CAL_IP_RX_EXTEND_CMP_SKEW_8 = 3;                          
    localparam CAL_IP_RX_EXTEND_CMP_ALT_16 = 10;                          
    localparam CAL_IP_RX_EXTEND_CMP_ALT_8 = 10;                           
    localparam CAL_IP_RX_CYCLE_DURATION_16 = CAL_IP_RX_CYCLE_DURATION_BASE_16 + CAL_IP_RX_EXTEND_CMP_SKEW_16;                       
    localparam CAL_IP_RX_CYCLE_DURATION_8 = CAL_IP_RX_CYCLE_DURATION_BASE_8 + CAL_IP_RX_EXTEND_CMP_SKEW_8 ;                         
    localparam CAL_IP_RX_CYCLE_DURATION_ALT_16 = CAL_IP_RX_CYCLE_DURATION_BASE_16 + CAL_IP_RX_EXTEND_CMP_ALT_16;                    
    localparam CAL_IP_RX_CYCLE_DURATION_ALT_8 = CAL_IP_RX_CYCLE_DURATION_BASE_8 + CAL_IP_RX_EXTEND_CMP_ALT_8 ;                      
     localparam CAL_IP_FULL_SWEEP = 80;                                  
     
     localparam CAL_CLK_GATE_WIDTH = 4;                                 
     
endpackage
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t/0r7WSYg3n2q5efoc4LUjNtI98k4fw3PJa7MTpxhoaB1f0GjJtkN9wLSUbGhRV7yihEdVs1aFRr4KvwLo0KU8owfMzQPbpSBkprQUqt/dbfD0nZ1nl2Wj8cgsu5MdTlNSSEPL8LiXB8/KNB2ANBt1UcVScmMWgYoXoaPfE0roNsmbJoCcdXkj02rBLcuaSjHNBuQ6ILMlomBDzXHxUu55SXSy6UYxq/rzV85N2Uz0eE5/N6IuiO05m3a/nfkKzR+rlLsxQaz+XXZc1u/BfHZ2AKpxdoMWJhHTXGHzPwao0U/K8gDf2TncriLKYiF6waTAK4/CWTxvhwqwJ/Z34H6/QUzF2X1hn7imvzlavr4NxMIxrUHx2ocBnD3JfF3by/QfdSRHiWAHAgrctrLC9KizCwDQyVPPazL8c4naeGm0HJnXLsASx7XQCeF8ucafxaUadoBBMYl1DhFyfzHk9ZaMnJULuCkNn+oLeW66MY25+FT7wk3BrfsgCp+TBflT6o2DKvhyA08/fnLZeV6VDxffX8HXvcPsdnRfSLCvZ7RofjZndrB33hht3rFB30FfK3v4f7ix4/O0GUh8MW0G4M4ov9kRwT2Z809CXkyJVJ9OCq+CW2TXehoov7SX9UKEpqr/gogYJx6iOAGYXTlrgBnmLA4t9t0XtkEOTVEkdib80aPRHHH6bSvvwowNWi7x8hUB1yP2PixpUYHhdqDo8IRM+FL9vmzaWxuf3lRVbjLoeu//RJ7SqJf7beHMBi54xllNj3kSQ1eBPGnEu1fqB1Kpm"
`endif