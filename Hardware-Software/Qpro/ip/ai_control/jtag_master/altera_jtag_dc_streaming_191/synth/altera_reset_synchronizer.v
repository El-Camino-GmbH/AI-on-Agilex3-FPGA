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


// $Id: //acds/rel/25.3/ip/iconnect/merlin/altera_reset_controller/altera_reset_synchronizer.v#1 $
// $Revision: #1 $
// $Date: 2025/08/01 $

// -----------------------------------------------
// Reset Synchronizer
// -----------------------------------------------
`timescale 1 ns / 1 ns

module altera_reset_synchronizer
#(
    parameter ASYNC_RESET = 1,
    parameter DEPTH       = 2
)
(
    input   reset_in /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R101" */,

    input   clk,
    output  reset_out
);

    // -----------------------------------------------
    // Synchronizer register chain. We cannot reuse the
    // standard synchronizer in this implementation 
    // because our timing constraints are different.
    //
    // Instead of cutting the timing path to the d-input 
    // on the first flop we need to cut the aclr input.
    // 
    // We omit the "preserve" attribute on the final
    // output register, so that the synthesis tool can
    // duplicate it where needed.
    // -----------------------------------------------
    (*preserve*) reg [DEPTH-1:0] altera_reset_synchronizer_int_chain;
    reg altera_reset_synchronizer_int_chain_out;

    generate if (ASYNC_RESET) begin

        // -----------------------------------------------
        // Assert asynchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk or posedge reset_in) begin
            if (reset_in) begin
                altera_reset_synchronizer_int_chain <= {DEPTH{1'b1}};
                altera_reset_synchronizer_int_chain_out <= 1'b1;
            end
            else begin
                altera_reset_synchronizer_int_chain[DEPTH-2:0] <= altera_reset_synchronizer_int_chain[DEPTH-1:1];
                altera_reset_synchronizer_int_chain[DEPTH-1] <= 0;
                altera_reset_synchronizer_int_chain_out <= altera_reset_synchronizer_int_chain[0];
            end
        end

        assign reset_out = altera_reset_synchronizer_int_chain_out;
     
    end else begin

        // -----------------------------------------------
        // Assert synchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk) begin
            altera_reset_synchronizer_int_chain[DEPTH-2:0] <= altera_reset_synchronizer_int_chain[DEPTH-1:1];
            altera_reset_synchronizer_int_chain[DEPTH-1] <= reset_in;
            altera_reset_synchronizer_int_chain_out <= altera_reset_synchronizer_int_chain[0];
        end

        assign reset_out = altera_reset_synchronizer_int_chain_out;
 
    end
    endgenerate

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "23GpcXRjlhKNdmB7mDVrHg9OaOVw6CUgmg5OCXY5H+2T1XtKuPxTsd7vVGk1waxY7vQv4GUnvvtlEVGGPWvAQ98lkV/d6btzP5nuMMHbPUUc6ANrlcrrjoB6rxviueKVE6tnfDvONxPoKdRG7X8wc4n+6xonQu0+UpGzogY6gCuxHKk2T89JgwKb91YBGDo1yg56RD8R1LlKZILeyiB82kalz1hPbEEZ1fNhSTjsqilLQjMfHmjQs49DpbBs5ITKAQcMlzHHL0ljxTCQnw6aJDr3YpJ4SN+gDQtg1IpqeCuwNJHOHC4R8WDUQGDpGTZZfaatRRZ4U0KhXdn/llJrYy8F5g9DxgMay5NKP6gPizINS17y3cuf8F+nTF+txqciRY2nBN9wP4BZAPL7M944TISqOqo4+ywz1QddYoqFSclHwJCTR4+wCVZTSnoYoGyilNmM6423WtLuQwWczFSVmDK2OF3m7S9AmS4fXTufN1yQRKE3A0ymUHc7nnsGt7aPfFzkqEd+w3IpFzHWdUk9i6gd7UiQnQsqZeiBCr68bGEeLI2QLYc89yMLVgHXPLG1AjZm8EUNdvZTarhAbforq/Jfk+m+UkdaZBT9jB49fYR0CKfNHvVxoixtUtnb/YNx0gGakbyLdFJ4S+FY7FUiDXRKYBQt+V1EpkGGq+nV5IllhzA2xWlAycjkecCYD57s0PMIbkJfdjDm7SGxJrjxcHWrEp9xBoxWohLNynyZV3Y+jmpBXy7QOexlAX7BHuwvRxp8eKFGQ+Tz7faUfi08D5Uvqyf+cNP5yNV6P3DV/bpbFnnt/jRhm3SZHpEqEwKeUb+v1Jv//l+jxvUSGSxBz76u8ihvOStwYTgvwvzPbC+Qi30QHJjprf7xNeHbXztqqYEQjI0ZCRHeiJfgBf9O7R/uHMMf0OWu03cv/l9CCa8B7LeXNj91kzonovCOSKI2IEOO6+Yp0cq+We7e3qFt38DxljsjyZsD4U/eVsUWBDHnROeEeqVuHl0gI7N0jyJi"
`endif