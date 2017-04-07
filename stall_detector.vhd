LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pc_selector IS
	PORT(	rs, rt, rd, ID_rd, read_en : IN std_logic_vector(2 DOWNTO 0);
		ID_load : IN std_logic;
		output : OUT std_logic);
END pc_selector;

ARCHITECTURE a_pc_selector OF pc_selector IS
	BEGIN

		output <= '1' when ID_load = '1' and ((read_en = "001" and rs = ID_rd) 
							or (read_en = "010" and (rs = ID_rd or rt = ID_rd))
							or (read_en = "011" and rd = ID_rd) 
							or (read_en = "100" and (rs = ID_rd or rd = ID_rd)))
		else '0';

END a_pc_selector;

-- read_en:
--	000: no read
--	001: rs
--	010: rs & rt
--	011: rd
--	100: rs & rd