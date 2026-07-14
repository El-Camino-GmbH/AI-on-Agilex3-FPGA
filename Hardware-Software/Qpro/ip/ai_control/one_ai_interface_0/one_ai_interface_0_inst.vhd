	component one_ai_interface_0 is
		generic (
			BUFFER_BASE_ADDR : std_logic_vector(31 downto 0) := "00000000000010000000000000000000"
		);
		port (
			clk               : in  std_logic                     := 'X';             -- clk
			reset_n           : in  std_logic                     := 'X';             -- reset_n
			avm_address       : out std_logic_vector(31 downto 0);                    -- address
			avm_read          : out std_logic;                                        -- read
			avm_readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avm_waitrequest   : in  std_logic                     := 'X';             -- waitrequest
			avm_readdatavalid : in  std_logic                     := 'X';             -- readdatavalid
			avm_burstcount    : out std_logic_vector(7 downto 0);                     -- burstcount
			avs_address       : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			avs_read          : in  std_logic                     := 'X';             -- read
			avs_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			avs_write         : in  std_logic                     := 'X';             -- write
			avs_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			frame_writer_irq  : in  std_logic                     := 'X'              -- irq
		);
	end component one_ai_interface_0;

	u0 : component one_ai_interface_0
		generic map (
			BUFFER_BASE_ADDR => STD_LOGIC_VECTOR_VALUE_FOR_BUFFER_BASE_ADDR
		)
		port map (
			clk               => CONNECTED_TO_clk,               --              clock.clk
			reset_n           => CONNECTED_TO_reset_n,           --              reset.reset_n
			avm_address       => CONNECTED_TO_avm_address,       --    avalon_master_0.address
			avm_read          => CONNECTED_TO_avm_read,          --                   .read
			avm_readdata      => CONNECTED_TO_avm_readdata,      --                   .readdata
			avm_waitrequest   => CONNECTED_TO_avm_waitrequest,   --                   .waitrequest
			avm_readdatavalid => CONNECTED_TO_avm_readdatavalid, --                   .readdatavalid
			avm_burstcount    => CONNECTED_TO_avm_burstcount,    --                   .burstcount
			avs_address       => CONNECTED_TO_avs_address,       --     avalon_slave_0.address
			avs_read          => CONNECTED_TO_avs_read,          --                   .read
			avs_readdata      => CONNECTED_TO_avs_readdata,      --                   .readdata
			avs_write         => CONNECTED_TO_avs_write,         --                   .write
			avs_writedata     => CONNECTED_TO_avs_writedata,     --                   .writedata
			frame_writer_irq  => CONNECTED_TO_frame_writer_irq   -- interrupt_receiver.irq
		);

