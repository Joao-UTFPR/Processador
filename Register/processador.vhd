library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clock:                      IN std_logic;
        writeEnable:                IN std_logic;
        reset:                      IN std_logic;
        immediate:                  IN unsigned(15 downto 0);
        ULA_sel:                    IN unsigned(2 downto 0);
        selRegRead1, selRegRead2:   IN unsigned(2 downto 0);
        selRegWrite:                IN unsigned(2 downto 0);
        mux_select:                 IN std_logic;
        ULA_out:                    OUT unsigned(15 downto 0)
    );
end;

architecture a_processador of processador is
    component ula is
        port(
            A,B : in unsigned(15 downto 0);
            ULA_sel: in unsigned(2 downto 0);
            ULA_out: out unsigned(15 downto 0);
            OverFlow: out std_logic
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
    component mux2x1 is
        port(
            sel            : in std_logic;
            in0, in1       : in unsigned(15 downto 0);
            saida          : out unsigned(15 downto 0)
        );
    end component;
    signal mux1_out,Reg1Data,Reg2Data, write_data: unsigned(15 downto 0);
    signal overFlow: std_logic;
begin
    mux1: mux2x1 port map(in0=>Reg2Data,in1=>immediate,saida=>mux1_out, sel=>mux_select);
    banco: registerBank port map(selRegRead1=>selRegRead1,selRegRead2=>selRegRead2,selRegWrite=>selRegWrite,Reg2Data=>Reg2Data,Reg1Data=>Reg1Data,writeData=>write_data,clock=>clock,reset=>reset,writeEnable=>writeEnable);
    ALU: ula port map(A=>Reg1Data,B=>mux1_out,ULA_out=>write_data,overFlow=>overFlow, ULA_sel=>ULA_sel);
    
end architecture;