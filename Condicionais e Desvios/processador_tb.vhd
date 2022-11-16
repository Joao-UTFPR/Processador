library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador is
      port(
        clock:          IN std_logic;
        reset:          IN std_logic;
        clock_o:        OUT std_logic;
        reset_o:        OUT std_logic;
        estado_o:       OUT unsigned(1 downto 0);
        pc_o:           OUT unsigned(6 downto 0);
        instruction_o:  OUT unsigned(15 downto 0);
        reg1_o:         OUT unsigned(15 downto 0);
        reg2_o:         OUT unsigned(15 downto 0);
        ula_o:          OUT unsigned(15 downto 0)
    );
    end component;

    constant period_time:                     time := 100 ns;
    signal finished:                          std_logic := '0';
    signal clock, reset:                      std_logic;
    signal data:                              unsigned(11 downto 0);
    signal clock_s:                           std_logic;
    signal reset_s:                           std_logic;
    signal estado_s:                          unsigned(1 downto 0);
    signal pc_s:                              unsigned(6 downto 0);
    signal instruction_s, reg1_s,reg2_s,ula_s:unsigned(15 downto 0);

begin
    uut : processador port map(
        clock => clock,
        reset => reset,
        clock_o=> clock_s,
        reset_o=> reset_s,
        estado_o=> estado_s,
        pc_o=> pc_s,
        instruction_o=> instruction_s,
        reg1_o=>  reg1_s,
        reg2_o=>  reg2_s,
        ula_o=> ula_s
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
      wait for 50 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
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