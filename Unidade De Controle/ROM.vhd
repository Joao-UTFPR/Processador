library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rom is
    port( 
    clk : in std_logic;
    endereco : in unsigned(6 downto 0);
    read: IN std_logic;
    dado : out unsigned(11 downto 0)
 );
end entity;


architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(11 downto 0);
    constant conteudo_rom : mem := (
    -- caso endereco => conteudo
    0  =>  "000000000010",
    1  =>  "111100000101", --pula para a linha 5
    2  =>  "000000000000",
    3  =>  "111101111111", --pula para a linha 6
    4  =>  "100000000000",
    5  =>  "000000000010", 
    6  =>  "111100000011", --pula para a linha 127
    7  =>  "000000000010",
    8  =>  "000000000010",
    9  =>  "000000000000",
    10 =>  "000000000000",
    127 => "111110000110", -- pula para a linha 3
    -- abaixo: casos omissos => (zero em todos os bits)
    others => (others=>'0')
 );
 signal dado_s : unsigned(11 downto 0);
begin
    process(clk)
    begin
    if(rising_edge(clk) and read='1') then
    dado_s <= conteudo_rom(to_integer(endereco));
    end if;
    end process;
    dado<=dado_s;
end architecture;