library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branchFlag is
    port(
        clock: in std_logic;
        reset : in std_logic;
        writeEnable : in std_logic;
        data_in : in std_logic;
        data_out : out std_logic
    );
end entity;

architecture a_branchFlag of branchFlag is
    signal registro: std_logic;
begin
    process(clock, reset, writeEnable)
    begin
        if reset = '1' then
            registro <= '0';
        elsif writeEnable = '1' then
            if rising_edge(clock) then
                if data_in='1' then
                    registro <= '1';
                else
                    registro <= '0';
                end if;
            end if;
        end if;
    end process;
    data_out <= registro;
end architecture;