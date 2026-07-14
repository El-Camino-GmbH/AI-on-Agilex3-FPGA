module sys_id #(
		parameter MANUAL_ID = 35661072
	) (
		input  wire        clock,    //           clk.clk
		input  wire        reset_n,  //         reset.reset_n
		output wire [31:0] readdata, // control_slave.readdata
		input  wire        address   //              .address
	);
endmodule

