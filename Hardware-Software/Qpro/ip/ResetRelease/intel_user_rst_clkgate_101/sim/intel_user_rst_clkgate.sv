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


`timescale 1 ns / 1 ns
module intel_user_rst_clkgate (
	output logic ninit_done
);

	localparam USER_RESET_DELAY = 0;
	
	initial begin
		#0 ninit_done = 1;
		#1 ninit_done = 0;
	end
					
	
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "wSEf6UPtfoAiPe4CJ6gysEI0zzEqQTl7rnjfXl6U1sUHDHwjG56TYcJp8oE7QFYgh13iErYahz7KfbT70K4Voeo1o6i3iBIEVFr4hgxQMQioG0ExlGqlOwqMgtZZw7/ifKvzzh2mszZFpiebp6He0UI3YfmL0gJShrAkSk35B5VccaNLci8QtYYe0DaudsxJe+uOXOKuwfTuSvkPDVgZTEXjtY4QQXv9A93T6k2XjcwCZJXyXtfNVeifSh6gRdH4JidgaGr0yuhwsApS5bKnE16vEnW9kDW6wOtu3TLORXmZVvoKIceApOGYAR0SyVkhX0UmKTrkBGtMY6IFEDrZh72LlAcMP0l83TQIcaqC+LLURvsuZNgUctFu8ASyZKXtnbWRT8OhZceKw0hgQB00UQVIsMN8acDrw5y5TMcB7TLJLInOosFjWds+G0sslH6oojHr7i/vqMsWfigiZ95x4kLmA8+08DpsAPjTmxJLBWRv+Jc8U3DvBuL5zNF6kCxzjSeFZdZfedUvKUF7Ufo2JGD6iPpS1p0VT40mVbHe4P2o3Vs5RhsOoUiOzyEFSt2Ll5qUFv/PdvY3+MXP+QoLnDGXuHrFiWIHiUtAsgJWLc0bTURWUQjmYtcwNH+jceju6P/ipTUxATCul2A23B0cZQLg+90NnLyml+jl2E3dG2GhM6fZWFwlGfzzq0sex/UPVhha/5zW2viLKMriMBTUePNqYgBkZQdocsPMTnb7crAqRbrpvPKatlwGv2LHRfp+mwsPPSs9gh04B7Vw3PYPZhPXhkBeT47bh/rRESTfO5m6uwwooTZAeMBTtoHoM1BVm2lhNvWNjXEjpvrJeaR7xNTOYVO404+GwnVcs+LX3QRxpur9XfLbg/0Hs+Z2rgaNgmYlm8kuBReZC3Ylp4dGCgSLRUsi9AU8wQ28/wHthD/V0MkxkustO/ODcdOUC4hoKz4QQ8nGTi0XSzwGREN6sWsDvjtQuD9zzaiExqrmQVvJpfeUzNYTCZjfBB6e5A0G"
`endif