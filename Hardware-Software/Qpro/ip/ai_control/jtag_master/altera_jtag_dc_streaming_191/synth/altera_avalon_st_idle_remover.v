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
//| Avalon ST Idle Remover 
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_idle_remover (

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
         if (in_valid & in_ready) begin
            if (escape_char & ~received_esc) begin
                 received_esc <= 1;
            end else if (out_valid) begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      in_ready = out_ready;
      //out valid when in_valid.  Except when we get idle or escape
      //however, if we have received an escape character, then we are valid
      out_valid = in_valid & ~idle_char & (received_esc | ~escape_char);
      out_data = received_esc ? (in_data ^ 8'h20) : in_data;
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "23GpcXRjlhKNdmB7mDVrHg9OaOVw6CUgmg5OCXY5H+2T1XtKuPxTsd7vVGk1waxY7vQv4GUnvvtlEVGGPWvAQ98lkV/d6btzP5nuMMHbPUUc6ANrlcrrjoB6rxviueKVE6tnfDvONxPoKdRG7X8wc4n+6xonQu0+UpGzogY6gCuxHKk2T89JgwKb91YBGDo1yg56RD8R1LlKZILeyiB82kalz1hPbEEZ1fNhSTjsqinWnTSZ8bGgEPa0RtywVyDilFsVfohBg9DVmY9dRiRFM9ekSvwNa7lH6mhUfxxfRBYtU1KnrHHMiP59jSzLG+u8Ps/vrtb3KkAx2osK+BRQGZv5jBHDKPCkWoBcEXAEuO1IUVtbHkPbRpJTh4cJ8ojOn5eNtJrgEh9mZV6sV719n9Nn+gUHPmW+clGgEM2/1ZeE7SlbP5kde8Ri1VcAhT7/bR+vvhrm37DDxNXzcx8QZ+2WZELy652CDwOy14arvE+JxvZmfjQMos6ApIWiIDVoNx2EpOckm3V2AHuoM+v8xLbHQ1HsTJB4ppgh7NWhhT3k8xyVCFnt1nuxzNsF3Fl07CXGjVH0ksDZ9l3xoh7UCNOCqagLZCIE7lFGkQvkWsYz748ABNPz6DtMukW3iIzh4XILWTkKS/rs7ihZ5zVXdtx+FR8uNhcaeMIJhZMxNWVyajHm9VoyEGcqXzijbpyzY+ufWRUsicCP+My9JIfHOHQW+I4zbnwuvk/DOQ4WyqHj3D2bV5jLJGigl9ialGEPNuS4fwpB3shlViG7spqG4HZaKP7oTfAJV01k6x8Z9sdSobP6f6KRff1WRSZeIYMn9b+2VAxxg684c876ENVbj603ih9BuzJerRzsKul4rqDQ/1qHhVbZgX4ux1hCj7Di+XyTNyanWVwDFS1Ax+wfB7UV6FhQ+WU/7pdIhXmGZM8TUoUNZXmWElvlKz3myfL/JaVfP4oz+X71/d33qP57PRoQ19S0MtuufNl7FngscVkroZRd13tNyLsF85V6toia"
`endif