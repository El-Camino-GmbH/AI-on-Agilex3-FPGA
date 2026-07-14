	component csi2_dphy_sys_reset_release_0 is
		port (
			ninit_done : out std_logic   -- reset
		);
	end component csi2_dphy_sys_reset_release_0;

	u0 : component csi2_dphy_sys_reset_release_0
		port map (
			ninit_done => CONNECTED_TO_ninit_done  -- ninit_done.reset
		);

