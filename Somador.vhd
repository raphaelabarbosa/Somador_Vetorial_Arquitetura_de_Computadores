
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SomadorVetorial is
    Port ( A_i : in  STD_LOGIC_VECTOR (31 downto 0);
           B_i : in  STD_LOGIC_VECTOR (31 downto 0);
           vecSize_i : in  STD_LOGIC_VECTOR (1 downto 0); -- Tamanho: 00 -> 4,01 -> 8, 10 -> 16 e 11 -> 32
           mode_i : in  STD_LOGIC; -- Operação: Soma -> 0 e Subtração -> 1
           S_o : out  STD_LOGIC_VECTOR (31 downto 0));
end SomadorVetorial;

architecture arq_SomadorVetorial of SomadorVetorial is

signal c_G		: std_logic_vector (31 downto 0); -- Carry Generate
signal c_P		: std_logic_vector (31 downto 0); -- Carry Propagate
signal c_C		: std_logic_vector (31 downto 0); -- Carry
signal aux_B	: std_logic_vector (31 downto 0); -- B auxiliar
signal aux_Soma: std_logic_vector (31 downto 0); -- B auxiliar

begin

aux_B <= B_i 		when (mode_i = '0') else
			not(B_i) when (mode_i = '1');
			
generate_GP: for i in 0 to 31 GENERATE
	c_G(i) <= (A_i(i) and aux_B(i));
	c_P(i) <= (A_i(i) xor aux_B(i));
end GENERATE;

--Início do bloco 4,8,16,32
c_C(0) <= 	'0' when (mode_i = '0') else
				'1' when (mode_i = '1'); --4,8,16,32
			 
c_C(1) <= 	c_G(0) or (c_P(0) and c_C(0)); --4,8,16,32

c_C(2) <= 	c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))); --4,8,16,32

c_C(3) <= 	c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))); --4,8,16,32

--Início do bloco 4
c_C(4) <= 	'0' when (mode_i = '0' and vecSize_i = "00") else
				'1' when (mode_i = '1' and vecSize_i = "00") else -- 4
				c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))))); --8,16,32

c_C(5) <=	c_G(4) or (c_P(4) and c_C(4)) when(vecSize_i = "00") else	-- 4
				c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))))))); --8,16,32
				
c_C(6) <=	c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and c_C(4)))) when(vecSize_i = "00") else -- 4
				c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))))))))); --8,16,32
				
c_C(7) <=	c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and c_C(4)))))) when(vecSize_i = "00") else	--4
				c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))))))))))); --8,16,32

--Início do bloco 4,8
c_C(8) <= 	'0' when (mode_i = '0' and (vecSize_i = "00" or vecSize_i = "01")) else
				'1' when (mode_i = '1' and (vecSize_i = "00" or vecSize_i = "01")) else --4,8
				c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))))))))))))); --16,32

c_C(9) <= 	c_G(8) or (c_P(8) and c_C(8)) when (vecSize_i = "00" or vecSize_i = "01") else --4,8
				c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))))))))))))))); -- 16,32

c_C(10) <=	c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and c_C(8)))) when (vecSize_i = "00" or vecSize_i = "01") else --4,8
				c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))))))))))))))))); -- 16,32

c_C(11) <=	c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and c_C(8)))))) when (vecSize_i = "00" or vecSize_i = "01") else --4,8
				c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0)))))))))))))))))))))); -- 16,32

--Início do bloco 4
c_C(12) <= '0' when (mode_i = '0' and vecSize_i = "00") else
			  '1' when (mode_i = '1' and vecSize_i = "00") else-- 4
			  c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and c_C(8)))))))) when (vecSize_i = "01") else --8
			  c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))));--16,32


c_C(13) <= 	c_G(12) or (c_P(12) and c_C(12)) when(vecSize_i = "00") else	--4
				c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and c_C(8)))))))))) when (vecSize_i = "01") else--8
				c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))));--16,32

c_C(14) <= 	c_G(13) or(c_P(13) and(c_G(12) or (c_P(12) and c_C(12)))) when(vecSize_i = "00")else	--4
				c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and c_C(8)))))))))))) when (vecSize_i = "01") else--8
				c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))));--16,32

c_C(15) <= 	c_G(14) or(c_P(14) and(c_G(13) or(c_P(13) and(c_G(12) or (c_P(12) and c_C(12)))))) when(vecSize_i = "00") else	--4
				c_G(14) or(c_P(14) and(c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and c_C(8)))))))))))))) when (vecSize_i = "01") else--8
				c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))));--16,32

--Início do bloco 4,8,16
c_C(16) <= '0' when (mode_i = '0' and ((vecSize_i = "00" or vecSize_i = "01") or vecSize_i = "11" )) else
			 '1' when (mode_i = '1' and ((vecSize_i = "00" or vecSize_i = "01") or vecSize_i = "11" )) else --4,8,16
			 c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))));--32

c_C(17) <=	c_G(16) or (c_P(16) and c_C(16)) when(vecSize_i = "00" or (vecSize_i = "01" or vecSize_i = "10" )) else--4,8,16
				c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))));--32

c_C(18) <=	c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))) when(vecSize_i = "00" or (vecSize_i = "01" or vecSize_i = "10" )) else--4,8,16
				c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))));--32

c_C(19) <=	c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))) when(vecSize_i = "00" or (vecSize_i = "01" or vecSize_i = "10" )) else--4,8,16
				c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))));--32

--Início do bloco 4
c_C(20) <= '0' when (mode_i = '0' and vecSize_i = "00") else
			  '1' when (mode_i = '1' and vecSize_i = "00") else --4
			  c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))) when(vecSize_i = "01" or vecSize_i = "10" )else--8,16
			  c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))));--32

c_C(21) <=	c_G(20) or (c_P(20) and c_C(20)) when(vecSize_i = "00") else--4
				c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))) when(vecSize_i = "01" or vecSize_i = "10" )else--8,16
				c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))));--32

c_C(22) <=	c_G(21) or(c_P(21) and(c_G(20) or (c_P(20) and c_C(20)))) when(vecSize_i = "00") else--4
				c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))) when(vecSize_i = "01" or vecSize_i = "10" )else--8,16
				c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))));--32

c_C(23) <=	c_G(22) or(c_P(22) and(c_G(21) or(c_P(21) and(c_G(20) or (c_P(20) and c_C(20)))))) when(vecSize_i = "00") else--4
				c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))) when(vecSize_i = "01" or vecSize_i = "10" )else--8,16
				c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))));--32

--Início do bloco 4,8
c_C(24) <= '0' when (mode_i = '0' and (vecSize_i = "00" or vecSize_i = "01")) else
			 '1' when (mode_i = '1' and (vecSize_i = "00" or vecSize_i = "01")) else --4,8
			 c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))))) when(vecSize_i = "10" )else--16
			 c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))))));--32

c_C(25) <=	c_G(24) or(c_P(24) and(c_C(24)))when(vecSize_i = "00" or vecSize_i = "01")else--4,8
				c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))))))) when(vecSize_i = "10" )else--16
				c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))))))));--32

c_C(26) <=	c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(c_C(24)))))when(vecSize_i = "00" or vecSize_i = "01")else--4,8
				c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))))))))) when(vecSize_i = "10" )else--16
				c_G(25) or(c_P(25) and(	c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))))))))));--32

c_C(27) <=	c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(c_C(24)))))))when(vecSize_i = "00" or vecSize_i = "01")else--4,8
				c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))))))))))) when(vecSize_i = "10" )else--16
				c_G(26) or(c_P(26) and(	c_G(25) or(c_P(25) and(	c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))))))))))));--32

--Início do bloco 4
c_C(28) <= '0' when (mode_i = '0' and vecSize_i = "00") else
			  '1' when (mode_i = '1' and vecSize_i ="00") else --4
			  c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(c_C(24)))))))))when(vecSize_i = "01" )else--8
			  c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))))))))))))) when(vecSize_i = "10" )else--16
			  c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(	c_G(25) or(c_P(25) and(	c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))))))))))))));--32

c_C(29) <= 	c_G(28) or(c_P(28) and(c_C(28)))when(vecSize_i = "00" )else--4
				c_G(28) or(c_P(28) and(c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(c_C(24)))))))))))when(vecSize_i = "01" )else--8
				c_G(28) or(c_P(28) and(c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))))))))))))))) when(vecSize_i = "10" )else--16
				c_G(28) or(c_P(28) and(	c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(	c_G(25) or(c_P(25) and(	c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))))))))))))))));--32


c_C(30) <= 	c_G(29) or(c_P(29) and(c_G(28) or(c_P(28) and(c_C(28)))))when(vecSize_i = "00" )else--4
				c_G(29) or(c_P(29) and(c_G(28) or(c_P(28) and(c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(c_C(24)))))))))))))when(vecSize_i = "01" )else--8
				c_G(29) or(c_P(29) and(c_G(28) or(c_P(28) and(c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))))))))))))))))) when(vecSize_i = "10" )else--16
				c_G(29) or(c_P(29) and(c_G(28) or(c_P(28) and(	c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(	c_G(25) or(c_P(25) and(	c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));--32

c_C(31) <= 	c_G(30) or(c_P(30) and(c_G(29) or(c_P(29) and(c_G(28) or(c_P(28) and(c_C(28)))))))when(vecSize_i = "00" )else--4
				c_G(30) or(c_P(30) and(c_G(29) or(c_P(29) and(c_G(28) or(c_P(28) and(c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(c_C(24)))))))))))))))when(vecSize_i = "01" )else--8
				c_G(30) or(c_P(30) and(c_G(29) or(c_P(29) and(c_G(28) or(c_P(28) and(c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(c_G(25) or(c_P(25) and(c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(c_G(17) or(c_P(17) and(c_G(16) or (c_P(16) and c_C(16)))))))))))))))))))))))))))))) when(vecSize_i = "10" )else--16
				c_G(30) or(c_P(30) and(c_G(29) or(c_P(29) and(c_G(28) or(c_P(28) and(	c_G(27) or(c_P(27) and(c_G(26) or(c_P(26) and(	c_G(25) or(c_P(25) and(	c_G(24) or(c_P(24) and(	c_G(23) or(c_P(23) and(c_G(22) or(c_P(22) and(	c_G(21) or(c_P(21) and(	c_G(20) or(c_P(20) and(	c_G(19) or(c_P(19) and(c_G(18) or(c_P(18) and(	c_G(17) or(c_P(17) and(	c_G(16) or(c_P(16) and(c_G(15) or(c_P(15) and(c_G(14) or(c_P(14) and(	c_G(13) or(c_P(13) and(c_G(12) or(c_P(12) and(c_G(11) or(c_P(11) and(c_G(10) or(c_P(10) and(c_G(9) or (c_P(9) and(c_G(8) or (c_P(8) and (c_G(7) or(c_P(7) and(c_G(6) or(c_P(6) and(c_G(5) or(c_P(5) and(c_G(4) or (c_P(4) and (c_G(3) or (c_P(3) and (c_G(2) or(c_P(2) and (c_G(1) or (c_P(1) and (c_G(0) or (c_P(0) and c_C(0))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));--32

generate_soma: for j in 0 to 31 GENERATE
	aux_soma(j) <= ((A_i(j) xor aux_B(j))xor c_C(j));
end GENERATE;

S_o <= aux_soma;

end arq_SomadorVetorial;

