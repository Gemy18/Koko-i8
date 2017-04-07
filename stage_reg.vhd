LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY stage_reg IS
	GENERIC (n : integer := 16);
	PORT( Clk,Rst : IN std_logic;
		  WE : IN std_logic;
		  d : IN  std_logic_vector(n-1 DOWNTO 0);
		  q : OUT std_logic_vector(n-1 DOWNTO 0));
END stage_reg;

ARCHITECTURE a_stage_reg OF stage_reg IS
	BEGIN
		PROCESS (Clk,Rst)
			BEGIN
				IF Rst = '1' THEN
					q <= (OTHERS=>'0');
				ELSIF WE = '1' AND rising_edge(Clk) THEN
					q <= d;
				END IF;
		END PROCESS;
END a_stage_reg;
