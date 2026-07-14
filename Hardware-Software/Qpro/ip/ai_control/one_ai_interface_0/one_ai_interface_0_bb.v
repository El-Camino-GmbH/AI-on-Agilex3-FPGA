module one_ai_interface_0 #(
		parameter[31:0] BUFFER_BASE_ADDR = 32'b00000000000010000000000000000000
	) (
		input  wire        clk,               //              clock.clk
		input  wire        reset_n,           //              reset.reset_n
		output wire [31:0] avm_address,       //    avalon_master_0.address
		output wire        avm_read,          //                   .read
		input  wire [31:0] avm_readdata,      //                   .readdata
		input  wire        avm_waitrequest,   //                   .waitrequest
		input  wire        avm_readdatavalid, //                   .readdatavalid
		output wire [7:0]  avm_burstcount,    //                   .burstcount
		input  wire [7:0]  avs_address,       //     avalon_slave_0.address
		input  wire        avs_read,          //                   .read
		output wire [31:0] avs_readdata,      //                   .readdata
		input  wire        avs_write,         //                   .write
		input  wire [31:0] avs_writedata,     //                   .writedata
		input  wire        frame_writer_irq   // interrupt_receiver.irq
	);
endmodule

