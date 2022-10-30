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
    0  =>  B"0000_000_00101_0_011", --carrega 5 no registrador D3
    1  =>  B"0000_000_01000_0_100", --carrega 8 no registrador D4
    2  =>  B"1101_011_100_000_101", --soma D3 com D4 e guarda em D5
    3  =>  B"0000_101_00001_1_101", --subtrai 1 de D5
    4  =>  B"1111_00010100_0000",   --salta para o endereço 20
    5  =>  B"0000_0000_0000_0000", 
    6  =>  B"0000_0000_0000_0000", 
    7  =>  B"0000_0000_0010_0000",
    8  =>  B"0000_0000_0010_0000",
    9  =>  B"0000_0000_0000_0000",
    10 =>  B"0000_0000_0000_0000",
    20 =>  B"1101_000_101_000_011", --copia D5 para D3
    21 =>  B"1111_00000010_0000",   --salta para o endereço 2
    -- abaixo: casos omissos => (zero em todos os bits)
    others => (others=>'0')
 );
 signal dado_s : unsigned(15 downto 0);
begin
    process(clock)
    begin
    if(rising_edge(clock) and readEnable='1') then
    dado_s <= conteudo_rom(to_integer(endereco));
    end if;
    end process;
    memoryOut<=dado_s;
end architecture;