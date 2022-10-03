library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register16bits_tb is
end;

architecture a_register16bits_tb of register16bits_tb is
  component register16bits is
    port (
      clock : in std_logic;
      reset : in std_logic;
      writeEnable : in std_logic;
      data_in : in unsigned(15 downto 0);
      data_out : out unsigned(15 downto 0)
    );
  end component;
  constant period_time : time := 100 ns;
  signal finished : std_logic := '0';
  signal clock, reset, writeEnable : std_logic;
  signal data_in : unsigned(15 downto 0);
  
begin
  uut : register16bits port map(
    clock => clock,
    reset => reset,
    data_in => data_in,
    writeEnable => writeEnable
  );
  reset_global : process
  begin
    reset <= '1';
    wait for period_time * 50; -- espera 2 clocks, pra garantir
    reset <= '0';
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

  process
  begin
    wait for 200 ns;
    writeEnable <= '1';
    data_in <= "1111111111111111";
    wait for 100 ns;
    data_in <= "0000000010001101";
    wait for 100 ns;
    data_in <= "0000000000000001";
    wait for 100 ns;
    data_in <= "0000000000000010";
    wait for 2000 ns;
    data_in <= "0000000000000011";
    wait;
  end process;
end architecture a_register16bits_tb;