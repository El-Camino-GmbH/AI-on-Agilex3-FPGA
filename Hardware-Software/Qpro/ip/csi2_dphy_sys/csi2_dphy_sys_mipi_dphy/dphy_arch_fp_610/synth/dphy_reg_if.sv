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



import dphy_pkg::*;

interface dphy_reg_if #(
    parameter DWIDTH = 32,
    parameter AWIDTH = 8
    ) ;
    logic                   reg_clk;
    logic                   reg_srst_n;
    logic                   reg_wr_en;
    logic [(DWIDTH/8)-1:0]  reg_be;
    logic                   reg_rd_en;
    logic [AWIDTH-1:0]      reg_waddr;
    logic [AWIDTH-1:0]      reg_raddr;
    logic [DWIDTH-1:0]      reg_din;
    logic [DWIDTH-1:0]      reg_dout;

endinterface : dphy_reg_if

interface a_reg_if # (
    parameter AWIDTH = 12,              
    parameter DWIDTH = 32,
    parameter TYPE = 0                 
    ) ;

    logic                       clk; 
    logic                       srst_n;
    logic                       awvalid;
    logic   [AWIDTH-1:0]        awaddr;        
    logic                       awready;
    logic                       wvalid;
    logic   [(DWIDTH/8)-1:0]    wstrb;
    logic   [DWIDTH-1:0]        wdata;
    logic                       wready;
    logic                       bready;
    logic [1:0]                 bresp;
    logic                       bvalid;
    logic   [AWIDTH-1:0]        araddr;
    logic                       arvalid;
    logic                       arready;
    logic                       rready;
    logic  [DWIDTH-1:0]         rdata;
    logic  [1:0]                rresp;
    logic                       rvalid;
    
  	logic  [11:0]               avl_s_address;  
	logic                       avl_s_read;
	logic                       avl_s_write;
	logic  [31:0]               avl_s_writedata;
	logic  [3:0]                avl_s_byteenable;
	logic  [31:0]               avl_s_readdata;
	logic                       avl_s_waitrequest;
	logic                       avl_s_readdatavalid;
    
    
    // synthesis translate_off

    localparam LINKS = 8;
    localparam UPPER_ADDR = $clog2(LINKS);
    localparam BASE_ADDR = 0;
    localparam LOCAL_ADDR_WIDTH = AWIDTH - UPPER_ADDR;

    
    typedef struct {
        logic [DWIDTH-1:0] data;
        logic [LOCAL_ADDR_WIDTH-1:0] addr;  
        logic [DWIDTH/4 -1 : 0] strobe;     
        logic cmd;                          
        int   link_id;                      
        logic post;                         
    } cmd_info;
     
    cmd_info cmd_queue [$];
    logic [DWIDTH-1:0] response [7:0][$];
 
    
    initial
    begin
        awvalid <= 1'b0;
        wvalid <= 1'b0;
        bready <= 1'b0;
        arvalid <= 1'b0;
        rready <= 1'b0;
        avl_s_read <= 1'b0;
        avl_s_write <= 1'b0;
        if(TYPE==0)
            $display("Reg bhv bus is AXI-LITE");
        if(TYPE==1)
            $display("Reg bhv bus is AVALON_MM");
    end

    task reg_access(input cmd_info cmd);
        if(TYPE==0) reg_access_axi_lite(cmd);
        if(TYPE==1) reg_access_avl_mm(cmd);
    endtask

    task reg_access_avl_mm(input cmd_info cmd);
        if(cmd.cmd == 1) 
        begin: wr_data
            repeat($random %10) @(negedge clk);
            avl_s_address <=  BASE_ADDR | (cmd.link_id << LOCAL_ADDR_WIDTH) | cmd.addr;
            avl_s_writedata <= cmd.data;
            avl_s_byteenable <= cmd.strobe;
            avl_s_write <= 1'b1;
            @(posedge clk);
            while(avl_s_waitrequest == 1'b1)
                @(posedge clk);
            if (cmd.post == 0)
                response[cmd.link_id].push_back(0);
            @(negedge clk) avl_s_write <= 1'b0;

        end
        else
        begin
            repeat($random %10) @(negedge clk);
            avl_s_address <= BASE_ADDR | (cmd.link_id << LOCAL_ADDR_WIDTH) | cmd.addr;
            avl_s_read <= 1'b1;
            @(posedge clk);
            while(avl_s_waitrequest == 1'b1)
                @(posedge clk);
            @(negedge clk) avl_s_read <= 1'b0;
            while(avl_s_readdatavalid == 1'b0)
            begin
                @(posedge clk);
                if(avl_s_readdatavalid == 1'b1)
                    response[cmd.link_id].push_back(avl_s_readdata);
            end    
        end
    endtask
 
    
    task reg_access_axi_lite(input cmd_info cmd);
        if(cmd.cmd == 1) 
        begin
            fork
                begin : wr_addr
                    repeat($random %10) @(negedge clk);
                    awaddr <= BASE_ADDR | (cmd.link_id << LOCAL_ADDR_WIDTH) | cmd.addr;
                    awvalid <= 1'b1;
                    @(posedge clk);
                    while(awready == 1'b0)
                        @(posedge clk);
                    @(negedge clk) awvalid <= 1'b0;
                end    
                begin : wr_data
                    repeat($random %3) @(negedge clk);
                    wdata <= cmd.data;
                    wstrb <= cmd.strobe;
                    wvalid <= 1'b1;
                    @(posedge clk);
                    while(wready == 1'b0)
                        @(posedge clk);
                    @(negedge clk) wvalid <= 1'b0;
                end    
            join
            fork
                begin : wr_resp_ready
                    repeat($random %10) @(negedge clk);
                    bready <= 1'b1;
                end    
                begin : wr_resp
                    @(posedge clk);
                    while(bready == 1'b0 || bvalid == 1'b0)
                        @(posedge clk);
                    if (cmd.post == 0)
                        response[cmd.link_id].push_back(0);
                    @(negedge clk) bready <= 1'b0;
                end
            join
        end
        else
        begin
            begin : rd_addr
                repeat($random %10) @(negedge clk);
                araddr <= BASE_ADDR | (cmd.link_id << LOCAL_ADDR_WIDTH) | cmd.addr;
                arvalid <= 1'b1;
                @(posedge clk);
                while(arready == 1'b0)
                    @(posedge clk);
                @(negedge clk) arvalid <= 1'b0;
            end    
            fork
                begin : rd_resp_ready
                    repeat($random %10) @(negedge clk);
                    rready <= 1'b1;
                end    
                begin : rd_resp
                    @(posedge clk);
                    while(~rready | ~rvalid)
                    begin
                        @(posedge clk);
                        if( rready & rvalid )
                            response[cmd.link_id].push_back(rdata);
                    end
                    @(negedge clk) rready <= 1'b0;
                end
            join            
        end
    endtask
 
    int csize;
    always @(*)
        csize <= cmd_queue.size();


    cmd_info c_cmd;
    initial
    begin
        forever
        begin
            @(posedge clk);
            if(cmd_queue.size() > 0)
            begin
                c_cmd = cmd_queue.pop_front();
                reg_access(c_cmd);
            end
        end
    end
 
    task read_reg_32_gen (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, output [31:0] dout);
        cmd_info cmd;
        cmd.addr = { addr[LOCAL_ADDR_WIDTH-1:2], 2'b00 };
        cmd.strobe = 4'h0;
        cmd.link_id = link_id;
        cmd.cmd = 0;
        cmd.post = 0;
        cmd_queue.push_back(cmd);
        while(response[link_id].size() == 0)
            @(posedge clk);
        dout = response[link_id].pop_front();
    endtask

    task read_reg_32 (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, output [31:0] dout);
        read_reg_32_gen(link_id, addr, dout);
    endtask

    task read_reg_8 (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, output [31:0] dout);
        logic [31:0] dout_32;
        read_reg_32_gen(link_id, addr, dout_32);
        case (addr[1:0])
            2'b00 : dout = dout_32[7:0];
            2'b01 : dout = dout_32[15:0];
            2'b10 : dout = dout_32[23:0];
            2'b11 : dout = dout_32[31:0];
        endcase
    endtask


    task write_reg_32_gen (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, input [31:0] din, input[DWIDTH/8-1:0] strobe, input post);
        logic [31:0] dout;
        cmd_info cmd;
        cmd.data = din;
        cmd.addr = { addr[LOCAL_ADDR_WIDTH-1:2], 2'b00 };
        cmd.strobe = strobe;
        cmd.link_id = link_id;
        cmd.cmd = 1;
        cmd.post = post;
        cmd_queue.push_back(cmd);
        if(post == 0)
        begin
            while(response[link_id].size() == 0)
                @(posedge clk);
            dout = response[link_id].pop_front();
        end
    endtask

    task write_reg_32_post (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, input [31:0] din);
        write_reg_32_gen (link_id, addr, din, { (DWIDTH/8){1'b1} }, 1);
    endtask

    task write_reg_32_wait (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, input [31:0] din);
        write_reg_32_gen (link_id, addr, din, { (DWIDTH/8){1'b1} }, 0);
    endtask

    task write_reg_32 (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, input [31:0] din);
        write_reg_32_post(link_id, addr, din);
    endtask

    task write_reg_8_post (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, input [7:0] din);
        write_reg_32_gen (link_id, addr, din << (8 * addr[1:0]), 1 << addr[1:0], 1);
    endtask

    task write_reg_8_wait (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, input [7:0] din);
        write_reg_32_gen (link_id, addr, din << (8 * addr[1:0]), 1 << addr[1:0], 0);
    endtask

    task write_reg_8 (input [UPPER_ADDR-1:0] link_id, input [LOCAL_ADDR_WIDTH-1:0] addr, input [7:0] din);
        write_reg_8_post(link_id, addr, din);
    endtask

    // synthesis translate_on
    
endinterface : a_reg_if



interface dphy_dbg_dlane;


endinterface

interface dphy_dbg_clane;



endinterface


interface dphy_dbg_link;
    dphy_dbg_dlane dlane [7:0] ();
    dphy_dbg_clane clane();


endinterface

interface dphy_dbg_common;


endinterface


interface dphy_dbg_bus;
    dphy_dbg_link link [7:0] ();
    dphy_dbg_common common();
endinterface
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "60+GolBF4e0rvdeG/kIwDjQE8YQaMEf9cB77u5eoEPi+os0BRm+rCGEK2A1bynYoItBfSieViOAv4oB/JBRU+AJ2r1o752Un8eBHcDcOjw99DeQKgMgO9Xy7rhYRJoTunu2j3fSlgA3aTbhDW63+KkrlHI5JnPn7AUjHCre9m07ArQiacCy1U7t5UdtwqvYvRShv68C/oXPCqv4t0VW3TN7GIrto8WtDVb8oKvFM0t9eIJduXNtLCry4K/oUQolDo8C96jzOp0BzOF2KLOMWZqUPniB5Zy/kNAzyHoNIoSrTcNWyxrtbY4rEidWgDH2gt2KCMcqUIVlLonSvoa3rAjmKepsHxQ0+xEIkCJLjZ5ZDHggq3In3Lh3mAljUiZetpXsMmaRYaAetOpXNUsZOyajTS/hT2CFa079I5GtSbnIVV7BJBZBMvwmgnBo//zyELwZTZL+k+bu1Sf30SuXeZ9NqM0hyNNowWjRD008pAHDWVdrK+eqrBfj82oIoJr2mKwc/RyUSekOuwQsAlBVXAaRvkApoLev0S9NUEVTjH5EVNriLRH2cPsUB1/34IWZwJWUjme9DOza8NnWPMsRVLGWCfkXa/P6GXVis05vDWzW8E+ZM4bsWOrGJHWKG7IzhdizXMhHWFZgNovnUAYjF+rsYp3ryUEKKeXzcm2bIDMFQ2z0rWPEkI0Ao7llu1IWN4DFzWja/jHWxZVQJkvofkhjcQZEKR1BUZddNM9kFetCXjLOAxjB0RzTpRf+ofidloyIDo8s4zdnDBn6Ty36X8UDIxO1dY3eNkwhxNNuAg61c3Zj1ehRHLypWG7b5+rQTgQfoSsj75by/IVeD6bPRK7up10hVntJ2ODM/yLSx0nuN3h4zPh0Lm7QPAib3TrTxi5UDd/TNAOh8CgvTnJOTOsx449uAg0rzZr1SRH1ydhsQAIK4Bc85zJGAikQetCZyZ3g4scA5oGuX/VPv29Yymi2ZtJ0H6oID/yXFeTSO4e9Q4my4pYWaqRISaaUg3Pk8"
`endif