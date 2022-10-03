library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register16bits is
    port(
        clock: in std_logic;
        reset : in std_logic;
        writeEnable : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_register16bits of register16bits is
    signal registro: unsigned(15 downto 0);
begin
    process(clock, reset, writeEnable)
    begin
        if reset = '1' then
            registro <= x"0000";
        elsif writeEnable = '1' then
            if rising_edge(clock) then
                registro <= data_in;
            end if;
        end if;
    end process;
    data_out <= registro;
end architecture;