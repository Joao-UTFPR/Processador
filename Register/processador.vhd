library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clock: std_logic
    );
end;

architecture a_processador of processador is
    component ula is
        port(
            A,B : in unsigned(15 downto 0);
            ULA_sel: in unsigned(2 downto 0);
            ULA_out: out unsigned(15 downto 0);
            CarryOut, OverFlow: out std_logic
        );
    end component;
    component registerBank is
        port(
            selRegRead1, selRegRead2:   IN unsigned(2 downto 0);
            writeData:                  IN unsigned(15 downto 0);
            selRegWrite:                IN unsigned(2 downto 0);
            writeEnable:                IN std_logic;
            clock:                      IN std_logic;
            reset:                      IN std_logic;
            Reg1Data, Reg2Data:         OUT unsigned(15 downto 0)
        );
    end component;
    signal
begin
    
