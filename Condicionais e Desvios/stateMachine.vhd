library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stateMachine is
    port(
        clock: in std_logic;
        reset : in std_logic;
        estado_o : out unsigned(1 downto 0)
    );
end entity;

architecture a_stateMachine of stateMachine is
    signal estado_s: unsigned(1 downto 0);
begin
    process(clock, reset)
    begin
        if reset = '1' then
            estado_s <= "00";
        elsif rising_edge(clock) then
            if estado_s="10" then
                estado_s <= "00";
            else
                estado_s <= estado_s+1;
            end if;
        end if;
    end process;
    estado_o <= estado_s;
end architecture;