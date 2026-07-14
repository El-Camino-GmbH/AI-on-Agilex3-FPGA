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




module toggle_synchronizer (
    clk_src,
    clk_dst,
    reset_n,    
    in_pulse,
    out_pulse
    
    );

    parameter depth = 3;        
    parameter rst_value = 0;    
        
    input   clk_src;
    input   clk_dst;
    input   reset_n;    
    input   in_pulse;
    output  out_pulse;

    logic in_level;
    logic in_level_ack;
    logic out_level;
    logic out_level_q;
    logic out_pulse;
    
    always @(posedge clk_src or negedge reset_n)
        if(reset_n == 1'b0)
            in_level <= 1'b0;
        else
            in_level <= ( ~(in_level ^ in_level_ack) & in_pulse ) ^ in_level;

    altera_std_synchronizer_nocut#(.depth(3), .rst_value(rst_value)) cdc_sync_ack (.clk(clk_src), .reset_n(reset_n), .din(out_level), .dout(in_level_ack));   
    altera_std_synchronizer_nocut#(.depth(3), .rst_value(rst_value)) cdc_sync (.clk(clk_dst), .reset_n(reset_n), .din(in_level), .dout(out_level));
    
    always @(posedge clk_dst)
        out_level_q <= out_level;

    assign out_pulse = out_level_q ^ out_level;
   
 endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oIXK+dkO9ZOrkGGJFsJ63qQ8SBxYT/RGcjNJayd8FOCczsZjC8O+XShgodHIKaqaMzE7BdwhYm/zuUznnuYmtSgQaq3a/CGGHOwjVHNBTap2EG38jQoH89x4XouRJaWHRZm5FwevlvkGskcagpKApp7MHsulmjNM5jEiEic+ar/X3h0x9dOUwUTSKjCE2+skWCANGccErL+JuhtL+0bRQoL6Kn0O1Ir+bwkTgqH+FCI6Rc+00QcNObRg2e7wqcvnvHXfwWXXMEZrenNQGFk3aVQXb5LtdtFoyt+XgbQj28OzLcuf1gCTcx2WcDjdsZ+XnLYsTvs3f2Hg/cyE3hkr0vy3JMXoP2IMYR49nIFlmeG1njuPZGSs4f01za+q8ltIoZct4+Buw4Ba31vvKffTB7EnMoOzloooQsUkIZwgUGVNbK3Luv27kwyZVvTQMBV+hDnj9OTQhWoFwNxScOI/+kXafJBsGXyza/ZAU0SX1NmxhrgGqoM2/7JIHDa/Cx20GyNYfEbjBq5qMH01/Tx9/4eOz4X1E5Wbt1aUI2Ke4Jo1Lijohb+FBrBuMC3BLfRw6ByORoYoDisC3K8ptgQalPW3U04V9rwZtbRbJM0ne2unSxviDfgcN5kh+nVplEyGvlQp/ZPpijOFKRIZZYZQixOQxN/rIfMbofs+nWEv4/l3T/4inYQSEzd6DgvNyymyvD2XsEo7fomPQYNwP6iKMV6WfDJpdHzvhwSp1YogYKp/+NvGnudD3FvYdFHGGu60rdu7f0Bu/xbHJHu7kZLIFDr"
`endif