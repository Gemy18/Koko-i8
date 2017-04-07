LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY source_selector IS
	PORT( opcode: in std_logic_vector(4 downto 0);
	      output: out std_logic);
END source_selector;

ARCHITECTURE a_source_selector OF source_selector IS
	BEGIN
	output <= '0' when opcode = "00000" or opcode = "00001" or opcode = "00010" or opcode ="00011" or opcode ="00100" or opcode ="00101" or opcode = "10110" or opcode = "10111" or opcode = "11000" or opcode = "11001" or opcode = "11010"
		  else '1';
END a_source_selector;