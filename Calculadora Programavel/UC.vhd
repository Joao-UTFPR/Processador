library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port(
        clock:                          IN std_logic;
        reset:                          IN std_logic;
        instruction:                    IN unsigned(15 downto 0);
        pcPrevious:                     IN unsigned(6 downto 0);
        pcNext:                         OUT unsigned(6 downto 0);
        memoryReadEnable:               OUT std_logic;
        instructionRegisterWriteEnable: OUT std_logic;
        ulaSel:                         OUT unsigned(2 downto 0);
        muxUlaBSel:                     OUT std_logic;
        registerBankWriteEnable:        OUT std_logic
        );
end entity;

architecture a_UC of UC is
    component stateMachine is
        port(
            clock: in std_logic;
            reset : in std_logic;
            estado_o : out unsigned(1 downto 0)
        );
        end component;

    signal fetch, decode, execute, jump_enable: std_logic;
    signal instruction_s: unsigned(15 downto 0);
    signal estado_s: unsigned(1 downto 0);
begin
    maquina_de_estados: stateMachine port map(clock=>clock,reset=>reset,estado_o=>estado_s); 

    fetch<=
            '1' when estado_s="00" else
            '0';
    decode<=
            '1' when estado_s="01" else
            '0';
    execute<=
            '1' when estado_s="10" else
            '0';

    instruction_s<=
            instruction when decode='1' else
            instruction_s;

    jump_enable<=
            '1' when instruction_s(15 downto 12)="1111" and decode='1' else
            '0' when decode='1' else
            jump_enable;

    pcNext <= 
            instruction(6 downto 0)     when jump_enable='1' and execute='1' else
            pcPrevious+1                when jump_enable='0' and execute='1' else
            pcPrevious;
    
    memoryReadEnable <=
            '1' when fetch='0' else
            '0';

    instructionRegisterWriteEnable<=
            '1' when fetch='0' else
            '0';
    ulaSel <=
        "000" when instruction_s(15 downto 12) ="0001" else
        "001" when instruction_s(15 downto 12) ="0010" else
        "010" when instruction_s(15 downto 12) ="0011" else
        "011" when instruction_s(15 downto 12) ="0100" else
        "100" when instruction_s(15 downto 12) ="0101" else
        "101" when instruction_s(15 downto 12) ="0110" else
        "110" when instruction_s(15 downto 12) ="0111" else
        "111" when instruction_s(15 downto 12) ="1000" else
        "uuu";

     muxUlaBSel <=
        '0' when instruction_s(15 downto 12) ="0000" else
        '1';
        
     registerBankWriteEnable <=
        '1' when execute='1' else
        '0';

end architecture;