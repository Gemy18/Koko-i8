LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity dec_3_x_8 is
    Port ( s  : in  STD_LOGIC_VECTOR (2 downto 0);  
           out_dec  : out STD_LOGIC_VECTOR (7 downto 0);
           en : in  STD_LOGIC );
end dec_3_x_8;




architecture a_dec_3_x_8 of dec_3_x_8 is
begin
	out_dec <= "00000000" when en = '0'
		else "00000001" when en = '1' and s = "000"
		else "00000010" when en = '1' and s = "001"
		else "00000100" when en = '1' and s = "010"
		else "00001000" when en = '1' and s = "011"
		else "00010000" when en = '1' and s = "100"
		else "00100000" when en = '1' and s = "101"
		else "01000000" when en = '1' and s = "110"
		else "10000000";
end a_dec_3_x_8;
