library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stateMachine_tb is
end;

architecture a_stateMachine_tb of stateMachine_tb is
    component stateMachine is
        port(
            clock: in std_logic;
            reset : in std_logic;
            writeEnable : in std_logic;
            estado_o : out std_logic
        );
    end component;
    signal clock, reset, writeEnable : std_logic;
    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin
        uut : stateMachine port map(
            clock => clock,
            reset => reset,
            writeEnable => writeEnable
        );

        reset_global : process
        begin
          reset <= '1';
          wait for period_time * 50; -- espera 2 clocks, pra garantir
          reset <= '0';
          writeEnable <= '1';
          wait;
        end process;
      
        sim_time_proc : process
        begin
          wait for 10 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
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