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
    signal tmp: unsigned(16  downto 0);
begin
    process(A, B, ULA_sel) is
    begin
        case (ULA_sel) is
            when "000" => -- Adição overflow
                if signed(A)>0 and signed(B)>0 and signed(A+B)<0 then
                    saida<="0000000000000000";
                    ovf <= '1';
                elsif signed(A)<0 and signed(B)<0 and signed(A)+signed(B)>0 then
                    saida<="0000000000000000";
                    ovf<= '1';
                else
                    saida<=A+B;
                    ovf<='0';
                end if;
            when "001" => -- Subtração
                if signed(A)>0 and signed(B)<0 and signed(A)-signed(B) < 0 then
                    saida<="0000000000000000";
                    ovf<='1';
                elsif signed(A)<0 and signed(B)>0 and signed(A)-signed(B)>0 then
                    saida<="0000000000000000";
                    ovf<='1';
                else
                    saida <= A - B;
                    ovf<='0';
                end if;
            when "010" => -- Shift Left
                saida <= A sll 1;
                ovf<='0';
            when "011" => -- And
                saida <= A and B;
                ovf<='0';
            when "100" => -- Or
                saida <= A or B;
                ovf<='0';
            when "101" => -- Xor
                saida <= A xor B;
                ovf<='0';
            when "110" => -- Comparação maior
                if(A>B) then
                    saida <= "0000000000000001";
                    ovf<='0';
                else
                    saida <= "0000000000000000";
                    ovf<='0';
                end if;
            when "111" => -- Comparação igual
                if(A=B) then
                    saida <= "0000000000000001";
                    ovf<='0';
                else
                    saida <= "0000000000000000";
                    ovf<='0';
                end if;
            when others => 
                saida <= "0000000000000000";
                ovf<='0';
        end case;
    end process;
    OverFlow<=ovf;
    ULA_out <= saida;
    tmp <= ('0' & A) + ('0' & B);
    CarryOut <= tmp(16);
end architecture;