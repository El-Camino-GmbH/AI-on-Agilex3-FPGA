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




(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION off" *) module hyperpipe # ( 
  parameter WIDTH = 1,
  parameter CYCLES = 3
) (
  input clk,
  input [WIDTH-1:0] din,
  output [WIDTH-1:0] dout
);

generate
  if (CYCLES==0) begin : GEN_COMB_INPUT
    assign dout = din;
  end 
  else begin : GEN_REG_INPUT  
    integer i;
    reg [WIDTH-1:0] R_data_preserve [CYCLES-1:0];
    
    always @(posedge clk) begin   
      R_data_preserve[0] <= din;      
      for(i=1;i<CYCLES;i=i+1) R_data_preserve[i] <= R_data_preserve[i-1];
    end
    assign dout = R_data_preserve[CYCLES-1];
  end
endgenerate  
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oLiRemo9QDKMeOEaEeCogy0Tnjw3DdIlUEaYfNIWqMAiDAqFwnlBzHekb/iZ4RHK07t3xJJHE32LsEBctSQBQdhriYOjUGX/c964qP4fopVJUianFAZVytSjM2pCpn1Uvxq7aE/QGCrn8JbTChzQnz0lhDgutH2YlHY8hiSEWTWiKFJLP65x+rin7srev0mwxlg38eC8KF+n6JYtSTUK/4VZpiii/LPgdmDdBa1358WFgVG2a6MWwkZX4Frlx0M7vRh5xKVbdckiwCPtNcfkfdE7vukjhs5F/7Pv1PMmKrfvYMTgiND742LMP5cwh+x5T+wUGO5qTVxoDS60/W4QQUs8BU4MqCRguS716ICgnCDPQS4f2h7/om8V6+t2bYUOPncOeRHUMq9cJHWG+Jav4xGT1NzFkrjG7taCyfPZX0t7RMepoxUeoqWUqFV2fj8+FWa8Ppq2p1GvwGQbilfNGbeoC7CM7EWHNApdrZ3dMz7n0HSUoE84aOPhrfbWXfE4Ea0BggCMuRP6Q8CIohRDk/B51+Fepzbvpedb28sS9er2diEBVLO3GNTrRSKm8bmAV5OTewPEHT7chp2TT/LxTCnRLs1Y9FXGmqSDTaLoWKS2sBJXSxgbqKeYiOUKysOVWWQbE7eheSEyyFpS/y5JRSagcj9hcKvxfNnNuc7SMNe5SDrULX1VzD9UM7jFruURKH/4oLi7pLL3CR0YlO26ghTWoMQjm+A1EVXRExT/ICS13S4OWRJrN460egSZhO0HkU74maz7zQcMOR280/xo5c+"
`endif