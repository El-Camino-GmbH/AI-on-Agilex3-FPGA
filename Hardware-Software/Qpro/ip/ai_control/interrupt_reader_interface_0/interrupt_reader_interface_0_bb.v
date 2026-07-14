module interrupt_reader_interface_0 (
		input  wire        clk,               //       clk.clk
		input  wire        reset,             //     reset.reset
		output wire [31:0] avm_address,       //    master.address
		output wire        avm_read,          //          .read
		input  wire [31:0] avm_readdata,      //          .readdata
		input  wire        avm_waitrequest,   //          .waitrequest
		input  wire        avm_readdatavalid, //          .readdatavalid
		input  wire        irq,               //       irq.irq
		output wire [31:0] result_data,       //    result.result_data
		output wire        result_valid,      //          .result_valid
		output wire [31:0] cycle_count,       // cycle_cnt.cycle_count
		output wire        cycle_count_valid, //          .cycle_count_valid
		output wire        error_timeout,     //     error.error_timeout
		input  wire        error_clear        //          .error_clear
	);
endmodule

