	component interrupt_reader_interface_0 is
		port (
			clk               : in  std_logic                     := 'X';             -- clk
			reset             : in  std_logic                     := 'X';             -- reset
			avm_address       : out std_logic_vector(31 downto 0);                    -- address
			avm_read          : out std_logic;                                        -- read
			avm_readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avm_waitrequest   : in  std_logic                     := 'X';             -- waitrequest
			avm_readdatavalid : in  std_logic                     := 'X';             -- readdatavalid
			irq               : in  std_logic                     := 'X';             -- irq
			result_data       : out std_logic_vector(31 downto 0);                    -- result_data
			result_valid      : out std_logic;                                        -- result_valid
			cycle_count       : out std_logic_vector(31 downto 0);                    -- cycle_count
			cycle_count_valid : out std_logic;                                        -- cycle_count_valid
			error_timeout     : out std_logic;                                        -- error_timeout
			error_clear       : in  std_logic                     := 'X'              -- error_clear
		);
	end component interrupt_reader_interface_0;

	u0 : component interrupt_reader_interface_0
		port map (
			clk               => CONNECTED_TO_clk,               --       clk.clk
			reset             => CONNECTED_TO_reset,             --     reset.reset
			avm_address       => CONNECTED_TO_avm_address,       --    master.address
			avm_read          => CONNECTED_TO_avm_read,          --          .read
			avm_readdata      => CONNECTED_TO_avm_readdata,      --          .readdata
			avm_waitrequest   => CONNECTED_TO_avm_waitrequest,   --          .waitrequest
			avm_readdatavalid => CONNECTED_TO_avm_readdatavalid, --          .readdatavalid
			irq               => CONNECTED_TO_irq,               --       irq.irq
			result_data       => CONNECTED_TO_result_data,       --    result.result_data
			result_valid      => CONNECTED_TO_result_valid,      --          .result_valid
			cycle_count       => CONNECTED_TO_cycle_count,       -- cycle_cnt.cycle_count
			cycle_count_valid => CONNECTED_TO_cycle_count_valid, --          .cycle_count_valid
			error_timeout     => CONNECTED_TO_error_timeout,     --     error.error_timeout
			error_clear       => CONNECTED_TO_error_clear        --          .error_clear
		);

