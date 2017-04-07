LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY forwarding_unit IS
	PORT( rs,rt,rd,mem_rd,ex_rd: in std_logic_vector(3 downto 0);
	      source_selector, mem_wb, ex_wb: in std_logic;
	      mux1_s,mux2_s: out std_logic_vector(1 downto 0));
END forwarding_unit;

ARCHITECTURE a_forwarding_unit OF forwarding_unit IS
	BEGIN
	mux1_s <= "10" when (source_selector ='0' and rs = mem_rd) or (source_selector ='1' and rd = mem_rd)
		  else "01" when (source_selector='0' and rs = ex_rd) or (source_selector ='1' and rd = ex_rd) 
		  else "00";
	
	mux2_s <= "10" when (source_selector ='0' and rt = mem_rd)
		  else "01" when (source_selector='0' and rt = ex_rd)
		  else "00";
END a_forwarding_unit;
