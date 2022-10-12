library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_UC is
    port(
        clock:          IN std_logic;
        reset:          IN std_logic;
        instruction:    IN unsigned(11 downto 0);
        pc_prev:        IN unsigned(6 downto 0);
        pc_next:        OUT unsigned(6 downto 0);
        memory_read:    OUT std_logic
        );
end entity;

architecture a_proto_UC of proto_UC is
    component stateMachine is
        port(
            clock: in std_logic;
            reset : in std_logic;
            estado_o : out std_logic
        );
        end component;

    signal estado_s, jump_enable: std_logic;
begin
    maquina_de_estados: stateMachine port map(clock=>clock,reset=>reset,estado_o=>estado_s);

    jump_enable<=
            '1' when instruction(11 downto 8)="1111" else
            '0';

    pc_next <= 
            instruction(6 downto 0) when jump_enable='1' and estado_s='1' else
            pc_prev+"1"             when jump_enable='0' and estado_s='1' else
            pc_prev;
    
    memory_read <=
            '1' when estado_s='0' else
            '0';

end architecture;