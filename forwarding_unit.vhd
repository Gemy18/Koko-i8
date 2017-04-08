LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY forwarding_unit IS
	PORT( id_opcode, ex_opcode, mem_opcode	     : in std_logic_vector(4 downto 0);
	      id_rs,id_rt,id_rd,mem_rd, mem_rs, ex_rd: in std_logic_vector(2 downto 0);
	      source_selector, mem_wb, ex_wb, mem_wb_select, ram_op : in std_logic;
	      mux_mem_s : out std_logic;
	      mux1_ex_s,mux2_ex_s: out std_logic_vector(1 downto 0));
END forwarding_unit;

ARCHITECTURE a_forwarding_unit OF forwarding_unit IS
	signal stack_pointer_needed_ex, stack_pointer_needed_mem : std_logic;
	BEGIN

	--Stack pointer cases forwarding.
	stack_pointer_needed_ex <= (id_opcode = "10110" or id_opcode = "10111" or id_opcode = "11000") and (ex_opcode = "10110" or ex_opcode = "10111" or ex_opcode = "11000");
	stack_pointer_needed_mem <= (id_opcode = "10110" or id_opcode = "10111" or id_opcode = "11000") and (mem_opcode = "10110" or mem_opcode = "10111" or mem_opcode = "11000");

	--Execute stage forwarding.
	mux1_ex_s <= "01" when (ex_wb = '1' and((source_selector='0' and id_rs = ex_rd) or (source_selector ='1' and id_rd = ex_rd))) or stack_pointer_needed_ex   --priority is to execute stage
		  else "10" when (mem_wb = '1' and ((source_selector ='0' and id_rs = mem_rd) or (source_selector ='1' and id_rd = mem_rd))) or stack_pointer_needed_mem
		  else "00";
	
	mux2_ex_s <= "01" when ex_wb = '1' and (source_selector='0' and id_rt = ex_rd)
		  else "10" when  mem_wb = '1' and (source_selector ='0' and id_rt = mem_rd)
		  else "00";

	--Memory stage forwarding.
	mux_mem_s <= '1' when ((mem_wb_select ='0' and mem_rs = ex_rd) or (mem_wb_select ='1' and mem_rd = ex_rd)) and ram_op = '1'
		     else '0';

END a_forwarding_unit;
