library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rom is
    port( 
    clock : in std_logic;
    endereco : in unsigned(6 downto 0);
    readEnable: IN std_logic;
    memoryOut : out unsigned(15 downto 0)
 );
end entity;


architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
    -- caso endereco => conteudo
    0  =>  B"0000_0000_0010_0000",
    1  =>  B"1111_0000_0101_0000", --pula para a linha 5
    2  =>  B"0000_0000_0000_0000",
    3  =>  B"1111_0111_1111_0000", --pula para a linha 6
    4  =>  B"1000_0000_0000_0000",
    5  =>  B"0000_0000_0010_0000", 
    6  =>  B"1111_0000_0011_0000", --pula para a linha 127
    7  =>  B"0000_0000_0010_0000",
    8  =>  B"0000_0000_0010_0000",
    9  =>  B"0000_0000_0000_0000",
    10 =>  B"0000_0000_0000_0000",
    127 => B"1111_1000_0110_0000", -- pula para a linha 3
    -- abaixo: casos omissos => (zero em todos os bits)
    others => (others=>'0')
 );
 signal dado_s : unsigned(15 downto 0);
begin
    process(clock)
    begin
    if(rising_edge(clock) and read='1') then
    dado_s <= conteudo_rom(to_integer(endereco));
    end if;
    end process;
    dado<=dado_s;
end architecture;