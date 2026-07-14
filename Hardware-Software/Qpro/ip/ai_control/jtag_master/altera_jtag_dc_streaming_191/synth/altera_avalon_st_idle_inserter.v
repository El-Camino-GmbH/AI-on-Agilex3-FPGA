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


// --------------------------------------------------------------------------------
//| Avalon ST Idle Inserter 
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_idle_inserter (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data,

      // Interface: ST out 
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data
);

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  received_esc;
   wire escape_char, idle_char;

   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign idle_char = (in_data == 8'h4a);
   assign escape_char = (in_data == 8'h4d);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         received_esc <= 0; 
      end else begin
         if (in_valid & out_ready) begin
            if ((idle_char | escape_char) & ~received_esc & out_ready) begin
                 received_esc <= 1;
            end else begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      //we are always valid
      out_valid = 1'b1;
      in_ready = out_ready & (~in_valid | ((~idle_char & ~escape_char) | received_esc));
      out_data = (~in_valid) ? 8'h4a :    //if input is not valid, insert idle
                 (received_esc) ? in_data ^ 8'h20 : //escaped once, send data XOR'd
                 (idle_char | escape_char) ? 8'h4d : //input needs escaping, send escape_char
                 in_data; //send data
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "23GpcXRjlhKNdmB7mDVrHg9OaOVw6CUgmg5OCXY5H+2T1XtKuPxTsd7vVGk1waxY7vQv4GUnvvtlEVGGPWvAQ98lkV/d6btzP5nuMMHbPUUc6ANrlcrrjoB6rxviueKVE6tnfDvONxPoKdRG7X8wc4n+6xonQu0+UpGzogY6gCuxHKk2T89JgwKb91YBGDo1yg56RD8R1LlKZILeyiB82kalz1hPbEEZ1fNhSTjsqilea9Z4DNj0YTHFcM/JbZKwQGg5zVAf+H68hLZDch5fQfk1V/X0kdTuNI3bQEn79cuTjyUSrycQWL1XSlvb9fegiNvD9Q3XTtMl2sArRz/07OyXp3be1kgnWD2vnCsz5pLgEYV1akYfbC/CelOzXwCrZ0n5xVHWP9KHeVDe6q42MYvV0TGo2BtvzV04WJGThATg7Fk0r7IeOWBA7wPGz+k6ddWUTaX3hWaQbNwSyEQe0j2x3zpdO3vWSUta95yqSkiy2sTG/zXYayICyamgsRL3tTSMMbgDVuwBbrsho38Ca3KNzaiuGRvDfmKzQcWwIicCaGUDIU5xJ5ji2/Abno4WpdTlwzESrDcqf/tDtDn1jyGf4vijfxGgltD8agemUW0bCsoPDkcTjFfXd33mNJhAAyFfaAHiVUHx9FXuieUd5NNc83+Jl9MzsZctPO/MSUn1y/yBAn9XcAy1jF/qRvWdK3abM9odiSXVEebgIqvTLByEaJiqVkv832aQrZWqSZxhMC+5+VYIJJBHapHb9Ikm5XecH/xSBwQKTY/xS7BT6asiaqaN2bynhrHL+9TOaojKY5vuAp/hbEmJR3ox9g3If+IY9/RCVaQ1Glq5uWpV/BsxybmMkvC6t01DLk54/P/YHYvrb5K8mSTPuUnnve8i1Y1MdLNcIsmWklDQP2MsS8sIUGo6J+I5cpBoNIVk6MbUEsrqLQpbkI6pT/nEq1N+Ef/AODsr+674yncraW9U4bmYxHkLm3voaR7AKNVYD9521azfHMRM9WHXv8PRx2Sc"
`endif