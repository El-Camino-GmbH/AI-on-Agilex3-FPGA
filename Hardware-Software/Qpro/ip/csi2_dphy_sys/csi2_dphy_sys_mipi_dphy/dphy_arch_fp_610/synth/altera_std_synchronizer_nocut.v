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





`timescale 1ns / 1ns

module altera_std_synchronizer_nocut (
                                clk, 
                                reset_n, 
                                din, 
                                dout
                                );

   parameter depth = 3; 
   parameter rst_value = 0;     
     
   input   clk;
   input   reset_n;    
   input   din;
   output  dout;
   

   (* altera_attribute = {"-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name SYNCHRONIZER_IDENTIFICATION FORCED; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON  "} *) reg din_s1;

   (* altera_attribute = {"-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg [depth-2:0] dreg;    
   
   // synthesis translate_off
   `ifndef QUARTUS_CDC
   initial begin
      if (depth <2) begin
         $display("%m: Error: synchronizer length: %0d less than 2.", depth);
      end
   end
   `endif

   
`ifdef __ALTERA_STD__METASTABLE_SIM

   reg[31:0]  RANDOM_SEED = 123456;      
   wire  next_din_s1;
   wire  dout;
   reg   din_last;
   reg          random;
   event metastable_event; 

   
   always @(posedge clk) begin
      if (reset_n == 0)
        random <= $random(RANDOM_SEED);
      else
        random <= $random;
   end

   assign next_din_s1 = (din_last ^ din) ? random : din;   

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
         din_last <= (rst_value == 0)? 1'b0 : 1'b1;
       else
         din_last <= din;
   end

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
         din_s1 <= (rst_value == 0)? 1'b0 : 1'b1;
       else
         din_s1 <= next_din_s1;
   end
   
`else 

   // synthesis translate_on   
   generate if (rst_value == 0)
       always @(posedge clk or negedge reset_n) begin
           if (reset_n == 0) 
             din_s1 <= 1'b0;
           else
             din_s1 <= din;
       end
   endgenerate
   
   generate if (rst_value == 1)
       always @(posedge clk or negedge reset_n) begin
           if (reset_n == 0) 
             din_s1 <= 1'b1;
           else
             din_s1 <= din;
       end
   endgenerate
   // synthesis translate_off      

`endif

`ifdef __ALTERA_STD__METASTABLE_SIM_VERBOSE
   always @(*) begin
      if (reset_n && (din_last != din) && (random != din)) begin
         $display("%m: Verbose Info: metastable event @ time %t", $time);
         ->metastable_event;
      end
   end      
`endif

   // synthesis translate_on

   generate if (rst_value == 0)
      if (depth < 3) begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b0}};            
            else
              dreg <= din_s1;
         end         
      end else begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b0}};
            else
              dreg <= {dreg[depth-3:0], din_s1};
         end
      end
   endgenerate
   
   generate if (rst_value == 1)
      if (depth < 3) begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b1}};            
            else
              dreg <= din_s1;
         end         
      end else begin
         always @(posedge clk or negedge reset_n) begin
            if (reset_n == 0) 
              dreg <= {depth-1{1'b1}};
            else
              dreg <= {dreg[depth-3:0], din_s1};
         end
      end
   endgenerate

   assign dout = dreg[depth-2];
   
endmodule 


                        
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oItVodmvRZJs4hGHKtGZQJE4BXa7wLG/BqV0X5+ng/rbJ/WV+WeuggPPkIBLDTOL83QgmttmQWF+4sjJ1Rb1hvYA7w01OMari7A0upGx7cL9BjKDAvQQ+K/X8Dtfb0ddIYPlKzBO4+1qOafAIBpcwxbKx5S/lJpi12NUau9PJGKYi2hp5Ju3akI3aLEPsZp0OymE3n9H3jpPoBtaen/J1j7vEEsJr+1hJBJEZfFbFISRimJnkOHBQSO8BD+Ah4zdnuhFtr2opwsafseGfrcqzZtFa62sFwg7vVTpbl1bFNtfLeQU679rLnrlYHP6Wv7yWE2KK2edxh+94qxLPUgpY13p3l0ffzVcBFXJHFfiEtDs50R+13wESAAx3m31ZMDvBIAJtXBtshY6DYoTv3qiQKj129MRx6WIPPiCl3NtF1mNVHaQnF3QnX7hiyhA8+EmwvnagcdO72ZmuXC9cpVcdHS92D5KivMsma+ArLNJm85MbPCkpHeTkUmd6SH/aB3seuB6iSuSksLd2AzOhdU7LKnj6QmNQlk6b5LG8I+VI/VOA945uMHoMTLi23zRpp0GPyEkmuncHHM4AiN3L4BSSGKveghOPDlUeqhPSFqYSCEQpWEt0Ugigxa6nyaYJ3VIpT1HU+tJQlshBC2lNSIDgboeBVbO2IsACqMIel1LKQcxjhbNpSMhwTUoWGOh9fLNMKbd/CIhibBFc6kzr4d4iXLSEGVQB5DICcq9PQoq2lsLUuZZgOvjQeYq3trfeOeXePMi/YxKyxjUaO2dp9dTsZt"
`endif