library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador is
        port(
            clock:                      IN std_logic;
            writeEnable:                IN std_logic;
            reset:                      IN std_logic;
            immediate:                  IN unsigned(15 downto 0);
            ULA_sel:                    IN unsigned(2 downto 0);
            selRegRead1, selRegRead2:   IN unsigned(2 downto 0);
            selRegWrite:                IN unsigned(2 downto 0);
            mux_select:                 IN std_logic;
            ULA_out:                    OUT unsigned(15 downto 0)
        );
    end component;
    constant period_time:              time := 500 ns;
    signal finished:                   std_logic := '0';
    signal clock, reset:               std_logic;

    signal writeEnable, mux_select: std_logic;
    signal ULA_sel,selRegWrite,selRegRead1,selRegRead2: unsigned(2 downto 0);
    signal immediate, ULA_out: unsigned(15 downto 0);
begin
    uut : processador port map(
        clock => clock,
        writeEnable => writeEnable,
        reset => reset,
        immediate => immediate,
        ULA_sel => ULA_sel,
        selRegRead1 => selRegRead1,
        selRegRead2 => selRegRead2,
        selRegWrite => selRegWrite,
        mux_select => mux_select,
        ULA_out => ULA_out
    );

    process
    begin
        wait for 250 ns;
        ULA_sel<="000";

        writeEnable<='1';
        selRegRead1<="000";
        selRegWrite<="001";   -- essa seção atribui o valor 4 ao registrador 1; como se fosse um addi $1,$zero,4
        mux_select<='1';
        immediate<="0000000000000100";
        wait for 800 ns;

        immediate<="0000000000001010";
        selRegWrite<="010";    -- essa seção atribui o valor 10 ao registrador 2; como se fosse um addi $2,$zero,10
        wait for 800 ns;

        mux_select<='0';
        selRegWrite<="011";
        selRegRead1<="001";  -- essa seção atribui o valor da soma dos registradores 1 e 2 ao registrador 6; AKA: add $3,$2,$1
        selRegRead2<="010";
        
        wait for 800 ns;

        reset<='1';
        writeEnable<='0'; 
        wait;
    end process;

    reset_global : process
    begin
      reset <= '1';
      wait for period_time * 2; -- espera 2 clocks, pra garantir
      reset <= '0';
      wait;
    end process;

    sim_time_proc : process
    begin
      wait for 30 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
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