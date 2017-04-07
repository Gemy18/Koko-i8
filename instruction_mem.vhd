LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY instruction_mem IS
	PORT(
		address : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY instruction_mem;

ARCHITECTURE a_instruction_mem OF instruction_mem IS

	TYPE ram_type IS ARRAY(0 TO 2000) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL instruction_mem : ram_type;
	
	BEGIN
		dataout <= instruction_mem(to_integer(unsigned(address))) & instruction_mem(to_integer(unsigned(address or "0000000000000001")));

END a_instruction_mem;
