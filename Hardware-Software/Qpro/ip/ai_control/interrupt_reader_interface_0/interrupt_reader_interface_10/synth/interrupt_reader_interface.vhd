library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interrupt_reader_interface is
    generic (
        TARGET_ADDR    : std_logic_vector(31 downto 0) := x"00070000";
        TIMEOUT_CYCLES : natural := 5000000
    );
    port (
        clk               : in  std_logic;
        reset             : in  std_logic;

        avm_address       : out std_logic_vector(31 downto 0);
        avm_read          : out std_logic;
        avm_readdata      : in  std_logic_vector(31 downto 0);
        avm_waitrequest   : in  std_logic;
        avm_readdatavalid : in  std_logic;

        irq               : in  std_logic;

        result_data       : out std_logic_vector(31 downto 0);
        result_valid      : out std_logic;
        cycle_count       : out std_logic_vector(31 downto 0);
        cycle_count_valid : out std_logic;

        -- Error ports
        error_timeout     : out std_logic;  -- Stays '1' until error_clear
        error_clear       : in  std_logic   -- Pulse '1' to recover from error
    );
end entity interrupt_reader_interface;

architecture rtl of interrupt_reader_interface is

    type t_state is (IDLE, READ_REQ, WAIT_DATA, CHECK_DATA, DONE, ERROR_STATE);
    signal state : t_state;

    signal counter         : unsigned(31 downto 0);
    signal timeout_counter : unsigned(31 downto 0);
    signal reg_cycle_count : unsigned(31 downto 0);

    signal irq_prev        : std_logic;
    signal irq_pending     : std_logic;

begin

    p_fsm : process(clk, reset)
    begin
        if reset = '1' then
            state             <= IDLE;
            avm_address       <= (others => '0');
            avm_read          <= '0';
            result_data       <= (others => '0');
            result_valid      <= '0';
            cycle_count       <= (others => '0');
            cycle_count_valid <= '0';
            error_timeout     <= '0';
            counter           <= (others => '0');
            timeout_counter   <= (others => '0');
            reg_cycle_count   <= (others => '0');
            irq_prev          <= '0';
            irq_pending       <= '0';

        elsif rising_edge(clk) then

            result_valid      <= '0';
            cycle_count_valid <= '0';

            -- Rising edge detection
            irq_prev <= irq;
            if irq = '1' and irq_prev = '0' then
                irq_pending <= '1';
            end if;

            case state is

                -- -------------------------------------------------
                when IDLE =>
                    avm_read        <= '0';
                    avm_address     <= (others => '0');
                    counter         <= (others => '0');
                    timeout_counter <= (others => '0');

                    if irq_pending = '1' then
                        irq_pending <= '0';
                        counter     <= to_unsigned(1, 32);
                        state       <= READ_REQ;
                    end if;

                -- -------------------------------------------------
                when READ_REQ =>
                    counter         <= counter + 1;
                    timeout_counter <= timeout_counter + 1;
                    avm_address     <= TARGET_ADDR;
                    avm_read        <= '1';

                    if timeout_counter >= to_unsigned(TIMEOUT_CYCLES, 32) then
                        avm_read <= '0';
                        state    <= ERROR_STATE;

                    elsif avm_waitrequest = '0' then
                        avm_read <= '0';
                        state    <= WAIT_DATA;
                    end if;

                -- -------------------------------------------------
                when WAIT_DATA =>
                    counter         <= counter + 1;
                    timeout_counter <= timeout_counter + 1;
                    avm_read        <= '0';

                    if timeout_counter >= to_unsigned(TIMEOUT_CYCLES, 32) then
                        state <= ERROR_STATE;

                    elsif avm_readdatavalid = '1' then
                        state <= CHECK_DATA;
                    end if;

                -- -------------------------------------------------
                when CHECK_DATA =>
                    counter         <= counter + 1;
                    timeout_counter <= timeout_counter + 1;
                    avm_read        <= '0';

                    if timeout_counter >= to_unsigned(TIMEOUT_CYCLES, 32) then
                        state <= ERROR_STATE;

                    elsif avm_readdata(0) = '1' then
                        result_data       <= avm_readdata;
                        result_valid      <= '1';
                        reg_cycle_count   <= counter;
                        cycle_count       <= std_logic_vector(counter);
                        cycle_count_valid <= '1';
                        state             <= DONE;
                    else
                        timeout_counter <= (others => '0');

                        cycle_count       <= std_logic_vector(counter);

                        state           <= READ_REQ;
                    end if;

                -- -------------------------------------------------
                when DONE =>
                    avm_read    <= '0';
                    cycle_count <= std_logic_vector(reg_cycle_count);
                    state       <= IDLE;


                when ERROR_STATE =>
                    avm_read        <= '0';      -- Bus released and held low
                    avm_address     <= (others => '0');
                    error_timeout   <= '1';      -- Held HIGH until cleared
                    counter         <= (others => '0');
                    timeout_counter <= (others => '0');
                    irq_pending     <= '0';      -- Discard any IRQs during error

                    if error_clear = '1' then
                        error_timeout <= '0';    -- De-assert error
                        state         <= IDLE;   -- Return to IDLE only on clear
                    end if;

            end case;
        end if;
    end process p_fsm;

end architecture rtl;