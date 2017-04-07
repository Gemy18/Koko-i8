LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_8x1_16 IS
	PORT(	sel : IN std_logic_vector(2 downto 0);
            x0,x1,x2,x3,x4,x5,x6,x7  : IN std_logic_vector(15 downto 0);
		    q : OUT std_logic_vector(15 downto 0));
END mux_8x1_16;

ARCHITECTURE a_mux_8x1_16 OF mux_8x1_16 IS
	BEGIN
		PROCESS(x0,x1,x2,x3,x4,x5,x6,x7,sel)
			BEGIN
			IF      sel(2) = '0' AND sel(1) = '0' AND sel(0) = '0' THEN
				        q <= x0;
			ELSIF   sel(2) = '0' AND sel(1) = '0' AND sel(0) = '1' THEN
				        q <= x1;
            ELSIF   sel(2) = '0' AND sel(1) = '1' AND sel(0) = '0' THEN
				        q <= x2;
            ELSIF   sel(2) = '0' AND sel(1) = '1' AND sel(0) = '1' THEN
				        q <= x3;
            ELSIF   sel(2) = '1' AND sel(1) = '0' AND sel(0) = '0' THEN
				        q <= x4;
            ELSIF   sel(2) = '1' AND sel(1) = '0' AND sel(0) = '1' THEN
				        q <= x5;
            ELSIF   sel(2) = '1' AND sel(1) = '1' AND sel(0) = '0' THEN
				        q <= x6;
            ELSIF   sel(2) = '1' AND sel(1) = '1' AND sel(0) = '1' THEN
				        q <= x7;
			END IF;
		END PROCESS;
END a_mux_8x1_16;

