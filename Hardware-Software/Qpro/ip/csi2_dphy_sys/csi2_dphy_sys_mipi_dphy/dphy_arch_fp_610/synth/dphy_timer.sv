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



module dphy_timer #(
        parameter WIDTH = 8
   ) 
   (
        input  wire                     clk,     
        input  wire                     srst_n,     
        
        input                           timer_en, 
        input                           ld_timer,   
        input [WIDTH-1:0]               ld_val, 
        output logic                    timer_out           

    );
    
    logic [WIDTH-1:0] cntr;
    logic [WIDTH-1:0] e_cntr;
    logic e_timeout;

    always @(posedge clk)
    begin
        if(srst_n == 1'b0)
            cntr <= {WIDTH{1'b1}};
        else if(ld_timer)
            cntr <= ld_val;
        else if(~&cntr)
            cntr <= e_cntr;
    end
    assign e_cntr = cntr - timer_en;
    assign timer_out = ~|cntr & ~ld_timer & timer_en;



endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oK9HnEAdXll5OFZ7y3z8A/+ONHwcmsq2UBlqmBlJUtqB9LEr8vOOKjTGFD2gJsPJPvuxDNOL8lPszccNFCIZ4RdClq3dRQTub9plLabmHT4scMmejNLXApSeC8HXLnne6MZrESFj05l4Bo2VJlEPdsKCTQgfKYt+9nSqe62et/2m4+c2WNcIDkMPeDJ9feRLbTGxwAW6oVs5t5BevVrfTNzYfOZEZ+Uy4Gehhsduc6xo6phtSwfmvMjrHULyE9ua7uM31Jj7EqYIS5aMJu1KHMHZK0RZV44eCnjS2vHyzGOgqmdCq4ZAFJTvzrR0CrSn5hAkBkH5nl/JorxtJ11FGClroBUBCD1B+Xq26KuIDCNXGZYCrKhUvyiUTdQU4Eo8ye4+AwAZ4MX4uAtcIrHSO7frjqPQAUkRbQybhu2W6TiCwb50SAl3ngsnL74G1r7LW+Aus+fiuXSrd1RWf3a5WZrEthb+BCUq60t/w5QYwjks+Rib8d7M5JkWX1L3F39xRFJRxFQwhSxusVfOJmiQThnbd90jt+7GmG9oAHyJcYSq0FahPMeLK0WYmKpraTS5o5B9NiVJBSxk+2F4bleFuv8opZRm6IEnvCiztMV/V+nTgABhWEmDsk7atw14xeEPF5M4I4KRsSbJERVt1RvYz2wXAA9qOWQbSpQG2Hv7aQxfYBuv/kOfCDokliB0PRUmOLSRG5WPrmW+Ixi4/sMYtwUtl7RPqPORtmUVm1tGFPJDB6jeoMXwlXUsEmTWW2qlV79bVwDfjleZs+Zpj51RdO1"
`endif