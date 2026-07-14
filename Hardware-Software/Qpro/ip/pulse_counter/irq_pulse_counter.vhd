library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity irq_pulse_counter is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        irq          : in  std_logic;
        count        : out std_logic_vector(31 downto 0);
        count_valid  : out std_logic
    );
end entity;

architecture rtl of irq_pulse_counter is

    type t_state is (IDLE, COUNTING, DONE);
    signal state     : t_state;
    signal irq_prev  : std_logic;
    signal counter   : unsigned(31 downto 0);
    signal div_count : integer range 0 to 2;

    attribute keep : boolean;
    attribute keep of counter : signal is true;

begin

count <= std_logic_vector(counter);

    process(clk, reset)
    begin
        if reset = '1' then
            state       <= IDLE;
            irq_prev    <= '0';
            counter     <= (others => '0');
            count_valid <= '0';
            div_count   <= 0;

        elsif rising_edge(clk) then
            irq_prev    <= irq;
            count_valid <= '0';

            case state is

                when IDLE =>
                    counter   <= (others => '0');
                    div_count <= 0;
                    if irq = '1' and irq_prev = '0' then
                        counter <= to_unsigned(1, 32);  -- start at 1
                        state <= COUNTING;
                    end if;

                when COUNTING =>
                    if div_count = 2 then
                        div_count <= 0;
                        counter   <= counter + 3;  -- add 3 every 3 cycles
                    else
                        div_count <= div_count + 1;
                    end if;

                    if irq = '0' and irq_prev = '1' then
                        count_valid <= '1';
                        state       <= DONE;
                    end if;

                when DONE =>
                    counter   <= (others => '0');
                    state     <= IDLE;

            end case;
        end if;
    end process;

end architecture rtl;