LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY stall_detector IS
	PORT(	rs, rt, rd, ID_rd, read_en, ex_mem_rd, id_ex_rd : IN std_logic_vector(2 DOWNTO 0);
		ID_load : IN std_logic;
		op_code, ex_mem_op, id_ex_op : IN std_logic_vector(4 DOWNTO 0);
		output : OUT std_logic);
END stall_detector;

ARCHITECTURE a_stall_detector OF stall_detector IS
	BEGIN

		output <= '1' when (ID_load = '1' and ((read_en = "001" and rs = ID_rd) 
							or (read_en = "010" and (rs = ID_rd or rt = ID_rd))
							or (read_en = "011" and rd = ID_rd) 
							or (read_en = "100" and (rs = ID_rd or rd = ID_rd))))
				or (op_code = "11101" and ex_mem_op = "11011" and rd = ex_mem_rd)
				or (op_code = "01010" and (rd = ex_mem_rd or rd = id_ex_rd))
				or (ex_mem_op = "00001" and ((read_en = "001" and rs = ex_mem_rd) 
							or (read_en = "010" and (rs = ex_mem_rd or rt = ex_mem_rd))
							or (read_en = "011" and rd = ex_mem_rd) 
							or (read_en = "100" and (rs = ex_mem_rd or rd = ex_mem_rd))))
				or (id_ex_op = "00001" and ((read_en = "001" and rs = id_ex_rd) 
							or (read_en = "010" and (rs = id_ex_rd or rt = id_ex_rd))
							or (read_en = "011" and rd = id_ex_rd) 
							or (read_en = "100" and (rs = id_ex_rd or rd = id_ex_rd))))

		else '0';

END a_stall_detector;

-- read_en:
--	000: no read
--	001: rs
--	010: rs & rt
--	011: rd
--	100: rs & rd