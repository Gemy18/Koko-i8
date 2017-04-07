LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_2x1_1 IS
	PORT(	sel : IN std_logic;
            x1,x2  : IN std_logic;
			q : OUT std_logic);
END mux_2x1_1;

ARCHITECTURE a_mux_2x1_1 OF mux_2x1_1 IS
	BEGIN
		PROCESS(x1,x2,sel)
			BEGIN
			IF sel = '0' THEN
				q <= x1;
			ELSE
				q <= x2;
			END IF;
		END PROCESS;
END a_mux_2x1_1;

