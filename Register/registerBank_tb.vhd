library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBank_tb is
end;

architecture a_registerBank_tb of registerBank_tb is
    component registerBank is
        port(
            selRegRead1, selRegRead2:   IN unsigned(2 downto 0);
            writeData:                  IN unsigned(15 downto 0);
            selRegWrite:                IN unsigned(2 downto 0);
            writeEnable:                IN std_logic;
            clock:                      IN std_logic;
            reset:                      IN std_logic;
            Reg1Data, Reg2Data:         OUT unsigned(15 downto 0)
        );
    end component;
    constant period_time:              time := 100 ns;
    signal finished:                   std_logic := '0';
    signal clock, reset:               std_logic;
    signal writeData:                  unsigned(15 downto 0);
    signal selRegRead1, selRegRead2:   unsigned(2 downto 0);
    signal selRegWrite:                unsigned(2 downto 0);
    signal writeEnable:                std_logic;
    signal Reg1Data, Reg2Data:         unsigned(15 downto 0);
begin
    uut : registerBank port map(
      selRegRead1 => selRegRead1,
      selRegRead2 => selRegRead2,
      writeData => writeData,
      selRegWrite => selRegWrite,
      writeEnable => writeEnable,
      clock => clock,
      reset => reset,
      Reg1Data => Reg1Data,
      Reg2Data => Reg2Data
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
      wait for 20 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
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

    process
    begin
        wait for 200 ns;
        writeEnable<='1';
        writeData <= x"0001";
        selRegWrite <= "000";
        for i in 0 to 7 loop
            selRegWrite <= selRegWrite + "001";
            writeData <= writeData + x"0001";
            wait for 25 ns;
        end loop;
        wait;
    end process;

end architecture a_registerBank_tb;