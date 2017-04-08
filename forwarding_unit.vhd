LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY forwarding_unit IS
	PORT( id_rs,id_rt,id_rd,mem_rd, mem_rs, ex_rd: in std_logic_vector(2 downto 0);
	      source_selector, mem_wb, ex_wb, mem_wb_select, ram_op : in std_logic;
	      mux_mem_s : out std_logic;
	      mux1_ex_s,mux2_ex_s: out std_logic_vector(1 downto 0));
END forwarding_unit;

ARCHITECTURE a_forwarding_unit OF forwarding_unit IS
	BEGIN

	--Execute stage forwarding.
	mux1_ex_s <= "10" when mem_wb = '1' and ((source_selector ='0' and id_rs = mem_rd) or (source_selector ='1' and id_rd = mem_rd))
		  else "01" when ex_wb = '1' and((source_selector='0' and id_rs = ex_rd) or (source_selector ='1' and id_rd = ex_rd))
		  else "00";
	
	mux2_ex_s <= "10" when  mem_wb = '1' and (source_selector ='0' and id_rt = mem_rd)
		  else "01" when ex_wb = '1' and (source_selector='0' and id_rt = ex_rd)
		  else "00";

	--Memory stage forwarding.
	mux_mem_s <= '1' when ((mem_wb_select ='0' and mem_rs = ex_rd) or (mem_wb_select ='1' and mem_rd = ex_rd)) and ram_op = '1'
		     else '0';
END a_forwarding_unit;
