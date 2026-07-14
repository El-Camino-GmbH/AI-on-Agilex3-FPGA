	component csi2_dphy_sys_tx_axi4s_clk_bridge is
		port (
			in_clk  : in  std_logic := 'X'; -- clk
			out_clk : out std_logic         -- clk
		);
	end component csi2_dphy_sys_tx_axi4s_clk_bridge;

	u0 : component csi2_dphy_sys_tx_axi4s_clk_bridge
		port map (
			in_clk  => CONNECTED_TO_in_clk,  --  in_clk.clk
			out_clk => CONNECTED_TO_out_clk  -- out_clk.clk
		);

