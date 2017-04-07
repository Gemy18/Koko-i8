LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY tri IS
	PORT(
		  en: IN std_logic;
		  input: IN std_logic_vector(15 DOWNTO 0);
		  output: OUT std_logic_vector(15 DOWNTO 0));
END tri;

ARCHITECTURE a_tri OF tri IS
	BEGIN
		   output <= input when en = '1'
		   ELSE (others=>'Z');
END a_tri;

