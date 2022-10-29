library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux2x1 is
    port(
        sel            : in std_logic;
        in0, in1       : in unsigned(15 downto 0);
        saida          : out unsigned(15 downto 0)
    );
end entity;

architecture a_mux2x1 of mux2x1 is
    begin
        saida <=
                in0 when sel='0' else
                in1 when sel='1' else
                x"0000";
        
    end architecture;