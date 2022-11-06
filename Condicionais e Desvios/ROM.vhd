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
    0  =>  B"0000_000_00000_0_011", --ADDI D0,0,D3
    1  =>  B"0000_000_00000_0_100", --ADDI D0,0,D4
    2  =>  B"1101_011_100_000_100", --ADD D3,D4,D4
    3  =>  B"0000_011_00001_0_011", --ADDI D3,1,D3
    4  =>  B"0000_000_11110_0_001", --ADDI D0,30,D1
    5  =>  B"0110_001_011_1_10011", --BCC GT,D1,D3,-3
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