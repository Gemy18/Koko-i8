LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY full_adder IS
	PORT (a,b,cin : IN  std_logic;
		  s, cout : OUT std_logic );
END full_adder;

ARCHITECTURE my_adder OF full_adder IS
	BEGIN
		s <= '0' when (a = 'Z' or b = 'Z') else (a XOR b XOR cin);
		cout <= '0' when (a = 'Z' or b = 'Z') else ((a AND b) OR (cin AND (a XOR b)));
END my_adder;