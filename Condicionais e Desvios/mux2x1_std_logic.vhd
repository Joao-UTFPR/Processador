library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux2x1_std_logic is
    port(
        sel            : in std_logic;
        in0, in1       : in std_logic;
        saida          : out std_logic
    );
end entity;

architecture mux2x1_std_logic of mux2x1_std_logic is
    begin
        saida <=
                in0 when sel='0' else
                in1 when sel='1' else
                '0';
        
    end architecture;