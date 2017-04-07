LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY or_1 IS
	PORT( a,b : IN std_logic;
		  z : OUT std_logic);
END or_1;

ARCHITECTURE a_or_1 OF or_1 IS
	BEGIN
		z <= a OR b;
END a_or_1;