library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        clock:  IN std_logic;
        reset:  IN std_logic;
        data:   OUT unsigned(11 downto 0)
    );
end;

architecture a_top_level of top_level is
    component PC is 
        port(
            clock: in std_logic;
            reset : in std_logic;
            writeEnable : in std_logic;
            data_in : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    component proto_UC is
        port(
            clock:          IN std_logic;
            reset:          IN std_logic;
            instruction:    IN unsigned(11 downto 0);
            pc_prev:        IN unsigned(6 downto 0);
            pc_next:        OUT unsigned(6 downto 0);
            memory_read:    OUT std_logic
        );
    end component;

    component rom is
        port( 
            clk : in std_logic;
            endereco : in unsigned(6 downto 0);
            read: IN std_logic;
            dado : out unsigned(11 downto 0)
         );
    end component;

    signal pc_in_s, pc_out_s: unsigned(6 downto 0);
    signal data_s : unsigned(11 downto 0);
    signal memory_read_s: std_logic;


begin
    memoria:    rom port map(clk=>clock,endereco=>pc_out_s,dado=>data_s,read=>memory_read_s);
    uc:         proto_UC port map(reset=>reset,clock=>clock,memory_read=>memory_read_s,pc_prev=>pc_out_s, pc_next=>pc_in_s,instruction=>data_s);
    counter:    PC port map(reset=>reset,clock=>clock,writeEnable=>'1',data_in=>pc_in_s,data_out=>pc_out_s);
    
    data <= data_s;
end architecture;