library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ula is
    port(
        A,B : in unsigned(15 downto 0);
        ULA_sel: in unsigned(2 downto 0);
        ULA_out: out unsigned(15 downto 0);
        CarryOut, OverFlow: out std_logic
    );
end entity;

architecture a_ula of ula is
    signal saida: unsigned(15 downto 0);
    signal ovf: std_logic;
    signal tmp: unsigned(15  downto 0);
    signal soma: unsigned(15 downto 0);
    signal subt: unsigned(15 downto 0);
begin
    res_soma <= 
        "0000000000000000" when signed(A)>0 and signed(B)>0 and signed(res_soma)<0 else
        "0000000000000000" when signed(A)<0 and signed(B)<0 and signed(res_soma)>0 else
        soma;
    res_subt <=
        "0000000000000000" when signed(A)>0 and signed(B)>0 and res_soma<0 else
        "0000000000000000" when signed(A)<0 and signed(B)<0 and res_soma>0 else
    saida<= res_soma            when ULA_sel="000"           else
            A - B               when ULA_sel="001"           else
            A sll 1             when ULA_sel="010"           else
            A and B             when ULA_sel="011"           else
            A or B              when ULA_sel="100"           else
            A xor B             when ULA_sel="101"           else
            "0000000000000001"  when ULA_sel="110" and A>B   else
            "0000000000000000"  when ULA_sel="110" and A<B   else
            "0000000000000001"  when ULA_sel="111" and A=B   else
            "0000000000000000"  when ULA_sel="111" and A/=B  else
            "0000000000000000";
    
    ULA_out <= saida;
    tmp <= ('0' & A) + ('0' & B);
    CarryOut <= tmp(16);
end architecture;