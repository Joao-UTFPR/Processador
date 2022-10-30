library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador is
        port(
            clock:  IN std_logic;
            reset:  IN std_logic;
            data:   OUT unsigned(11 downto 0)
        );
    end component;

    constant period_time:              time := 500 ns;
    signal finished:                   std_logic := '0';
    signal clock, reset:               std_logic;
    signal data:                       unsigned(11 downto 0);

begin
    uut : processador port map(
        clock => clock,
        reset => reset,
        data=>data
    );



    reset_global : process
    begin
      reset <= '1';
      wait for period_time * 2; -- espera 2 clocks, pra garantir
      reset <= '0';
      wait;
    end process;

    sim_time_proc : process
    begin
      wait for 40 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
      finished <= '1';
      wait;
    end process sim_time_proc;

    clock_proc : process
    begin
      while finished /= '1' loop
        clock <= '0';
        wait for period_time/2;
        clock <= '1';
        wait for period_time/2;
      end loop;
      wait;
    end process;

end architecture;