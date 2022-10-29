library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instructionRegister is
    port(
        clock: in std_logic;
        reset : in std_logic;
        writeEnable : in std_logic;
        instruction_in : in unsigned(15 downto 0);
        instruction_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_instructionRegister of instructionRegister is
    signal instruction_s: unsigned(15 downto 0);
begin
    process(clock, reset, writeEnable)
    begin
        if reset = '1' then
            instruction_s <= B"0000_0000_0000_0000";
        elsif writeEnable = '1' then
            if rising_edge(clock) then
                instruction_s <= instruction_in;
            end if;
        end if;
    end process;
    instruction_out <= instruction_s;
end architecture;