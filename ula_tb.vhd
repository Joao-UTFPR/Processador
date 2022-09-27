library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula is
        port
        (
            A        : IN unsigned (15 downto 0);
            B        : IN unsigned (15 downto 0);
            ULA_sel  : IN unsigned (2 downto 0);
            ULA_out  : OUT unsigned (15 downto 0);
            CarryOut : OUT std_logic
        );
    end component;
    signal A, B : unsigned(15 downto 0) := (others => '0');
    signal ULA_sel : unsigned(2 downto 0) := (others => '0');
    signal ULA_out : unsigned(15 downto 0);
    signal CarryOut: std_logic;
    signal i:integer;
begin
    uut: ula port map(
        A => A,
        B => B,
        ULA_sel => ULA_sel,
        ULA_out => ULA_out,
        CarryOut => CarryOut
    );
    
    stim_proc: process
    begin
      -- hold reset state for 100 ns.
        A <=  "0000000000000010";
        B <=  "0000000000000001";
        ULA_sel <= "000";
        
        for i in 0 to 7 loop
            ULA_sel <= ULA_sel + "001";
            wait for 50 ns;
        end loop;
        wait;
    end process;
end architecture a_ula_tb;

