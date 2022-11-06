library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBank is
    port(
        selRegRead1, selRegRead2:   IN unsigned(2 downto 0);
        writeData:                  IN unsigned(15 downto 0);
        selRegWrite:                IN unsigned(2 downto 0);
        writeEnable:                IN std_logic;
        clock:                      IN std_logic;
        reset:                      IN std_logic;
        Reg1Data, Reg2Data:         OUT unsigned(15 downto 0)
    );
end entity;

architecture a_registerBank of registerBank is
component register16bits is port(
        clock:          in std_logic;
        reset :         in std_logic;
        writeEnable :   in std_logic;
        data_in :       in unsigned(15 downto 0);
        data_out :      out unsigned(15 downto 0)
);
end component;
signal data1, data2:                                        unsigned(15 downto 0);
signal we1,we2,we3,we4,we5,we6,we7:                         std_logic;
signal D1Data,D2Data,D3Data,D4Data,D5Data,D6Data,D7Data:    unsigned(15 downto 0);
begin
    we1<=
        writeEnable when selRegWrite="001" else
        '0';
    we2<=
        writeEnable when selRegWrite="010" else
        '0';
    we3<=
        writeEnable when selRegWrite="011" else
        '0';
    we4<=
        writeEnable when selRegWrite="100" else
        '0';
    we5<=
        writeEnable when selRegWrite="101" else
        '0';
    we6<=
        writeEnable when selRegWrite="110" else
        '0';
    we7<=
        writeEnable when selRegWrite="111" else
        '0';
    D1: register16bits port map (clock=>clock,reset=>reset,writeEnable=>we1,data_in=>writeData,data_out=>D1Data);
    D2: register16bits port map (clock=>clock,reset=>reset,writeEnable=>we2,data_in=>writeData,data_out=>D2Data);
    D3: register16bits port map (clock=>clock,reset=>reset,writeEnable=>we3,data_in=>writeData,data_out=>D3Data);
    D4: register16bits port map (clock=>clock,reset=>reset,writeEnable=>we4,data_in=>writeData,data_out=>D4Data); 
    D5: register16bits port map (clock=>clock,reset=>reset,writeEnable=>we5,data_in=>writeData,data_out=>D5Data); 
    D6: register16bits port map (clock=>clock,reset=>reset,writeEnable=>we6,data_in=>writeData,data_out=>D6Data); 
    D7: register16bits port map (clock=>clock,reset=>reset,writeEnable=>we7,data_in=>writeData,data_out=>D7Data);

    data1<=
            x"0000"     when selRegRead1="000" else
            D1Data      when selRegRead1="001" else
            D2Data      when selRegRead1="010" else
            D3Data      when selRegRead1="011" else
            D4Data      when selRegRead1="100" else
            D5Data      when selRegRead1="101" else
            D6Data      when selRegRead1="110" else
            D7Data;
    data2<=
            x"0000"     when selRegRead2="000" else
            D1Data      when selRegRead2="001" else
            D2Data      when selRegRead2="010" else
            D3Data      when selRegRead2="011" else
            D4Data      when selRegRead2="100" else
            D5Data      when selRegRead2="101" else
            D6Data      when selRegRead2="110" else
            D7Data;
    Reg1Data <= data1;
    Reg2Data <= data2;
end architecture;