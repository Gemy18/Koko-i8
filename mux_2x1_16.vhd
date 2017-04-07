LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_2x1_16 IS
	PORT(	sel : IN std_logic;
            x1,x2  : IN std_logic_vector(15 downto 0);
			q : OUT std_logic_vector(15 DOWNTO 0));
END mux_2x1_16;

ARCHITECTURE a_mux_2x1_16 OF mux_2x1_16 IS
	BEGIN
		PROCESS(x1,x2,sel)
			BEGIN
			IF sel = '0' THEN
				q <= x1;
			ELSE
				q <= x2;
			END IF;
		END PROCESS;
END a_mux_2x1_16;

