	component irq_pulse_counter_0 is
		port (
			clk         : in  std_logic                     := 'X'; -- clk
			reset       : in  std_logic                     := 'X'; -- reset
			irq         : in  std_logic                     := 'X'; -- irq
			count       : out std_logic_vector(31 downto 0);        -- count
			count_valid : out std_logic                             -- count_valid
		);
	end component irq_pulse_counter_0;

	u0 : component irq_pulse_counter_0
		port map (
			clk         => CONNECTED_TO_clk,         --   clk.clk
			reset       => CONNECTED_TO_reset,       -- reset.reset
			irq         => CONNECTED_TO_irq,         --   irq.irq
			count       => CONNECTED_TO_count,       -- count.count
			count_valid => CONNECTED_TO_count_valid  --      .count_valid
		);

