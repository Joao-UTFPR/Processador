library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stateMachine is
    port(
        clock: in std_logic;
        reset : in std_logic;
        estado_o : out std_logic
    );
end entity;

architecture a_stateMachine of stateMachine is
    signal estado_s: std_logic;
begin
    process(clock, reset)
    begin
        if reset = '1' then
            estado_s <= '0';
        elsif rising_edge(clock) then
            estado_s <= not estado_s;
        end if;
    end process;
    estado_o <= estado_s;
end architecture;