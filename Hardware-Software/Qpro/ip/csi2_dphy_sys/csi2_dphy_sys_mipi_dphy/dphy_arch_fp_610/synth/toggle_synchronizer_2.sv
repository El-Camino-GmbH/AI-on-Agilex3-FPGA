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




module toggle_synchronizer_2 (
    clk_src,
    clk_dst,
    reset_n_src,
    reset_n_dst,
    in_pulse,
    out_pulse
    
    );

    parameter depth = 3;        
    parameter rst_value = 0;    
        
    input   clk_src;
    input   clk_dst;
    input   reset_n_src;
    input   reset_n_dst;        
    input   in_pulse;
    output  out_pulse;

    logic in_level;
    logic in_level_ack;
    logic out_level;
    logic out_level_q;
    logic out_pulse;
    
    always @(posedge clk_src or negedge reset_n_src)
        if(reset_n_src == 1'b0)
            in_level <= 1'b0;
        else
            in_level <= ( ~(in_level ^ in_level_ack) & in_pulse ) ^ in_level;

    altera_std_synchronizer_nocut#(.depth(3), .rst_value(rst_value)) cdc_sync_ack (.clk(clk_src), .reset_n(reset_n_src), .din(out_level), .dout(in_level_ack));   
    altera_std_synchronizer_nocut#(.depth(3), .rst_value(rst_value)) cdc_sync (.clk(clk_dst), .reset_n(reset_n_dst), .din(in_level), .dout(out_level));
    
    always @(posedge clk_dst)
        out_level_q <= out_level;

    assign out_pulse = out_level_q ^ out_level;
   
 endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "mee/gkV9zeKLvGqNntLTSsObQ14wNSIHwecTPHvpjCmsnnk0ZTGlHC9OJ2J7QtOlYKo2Bc2VVDqOZoN51yloE5tY0a0/Y/RVN0fm/CU2oP6/dvCD+ss5w+WhSKVRWbbV3uCzU3e1heptSc2fi9jvNXQmD1Bn9cDRf7CXSebhPv5vfKL8eLlrpemzQLBQeCmvpGlylP/A/8fOufmAzy3w7MC/jmSYwdMjhC8qIri/+oKkf4RyxzdwgPAt7TT4AXbdAfGUj/JsQ2DX5S8HAloXt/w3MCeeW0bar1hWoUOBapGsrFssOhhic1aba0EIORiIvFJc6e7KEqBMm/T8LuGxQEibSPOLeVlUrkVXLALkcsK+1pLReIgb2f7SvbVW4q+AbfHZ6F4ciMVy+zBIWcCk96DzDSzLqpkyOxJIn7kZtFN0EYkl7Fyulr0lAi+64A+qH9rui42M/CK2bhiW/X/S//tAYdpMW8EXQIlvpJBtfCSV2BAQY6eDXQCpE6WWL8yMA4Eq/eKjlIBmAHz0Eig52Jte5KzOX688zOpEs9ps5FUyk7o0hiO/ZLkuxin941xc23Arqtxo5KHkxj6DHqMfGBJfT+UdLExJWd5vOymldap9tVoG7hGGUGWuqEIyAAB8T2DZz7bLw9+lYq0anas3ZqqJmxvFYgGrolzxxtX15VMjer7qR9DRylskOV5Hxdvg+N1XLIt0VLsOhFBG/nVNUtzAIYPnVe8n6G38KLnEJkdUC7eNbhrPdCC2ayNN2JrjebWeb+yXV7PsP4hwBuBink+56LOTeTc8nTPFGWNxRxZP5F6YncWbDwxpKw1RvqbMCe5+MW3avVo59BXWYBOXUNJhFWAAlFjNRxZfyxOwBZ/Dev5lgvPlEQrAFh7sbweE0XUWFzuiuTrx31yXTBOtZytGA6Ngr26IM2slVqkfvi+ehepMMv17h5jvbfEI8cPfx7VxI/6d+3nobbbyHG7MZylDqCtsylyFquO/fsJyxHt3+imA8OlR9DvLPPhy4ekB"
`endif