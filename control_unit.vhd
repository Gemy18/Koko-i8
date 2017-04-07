LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY control_unit IS
	PORT(	op : IN std_logic_vector(4 DOWNTO 0);
		stall, IF_int, br_taken : IN std_logic;
		wb : OUT std_logic_vector(4 DOWNTO 0);
		ram : OUT std_logic_vector(3 DOWNTO 0);
		alu : OUT std_logic_vector(1 DOWNTO 0);
		read_en : OUT std_logic_vector(2 DOWNTO 0);
		in_en, out_en, sp_select, ld : OUT std_logic);
END control_unit;

ARCHITECTURE a_control_unit OF control_unit IS
	BEGIN

		PROCESS(op)
			BEGIN
			IF op = "00000" or stall = '1' or br_taken = '1' THEN
				wb <= "00000";
				ram <= "0000";
				alu <= "00";
				read_en <= "000";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ELSIF IF_int = '1' then
				wb <= "00101";
				ram <= "1011";
				alu <= "11";
				read_en <= "100";
				sp_select <= '1';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "00001" then		-- mov
				wb <= "11001";
				ram <= "0000";
				alu <= "00";
				read_en <= "001";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "00010" or op = "00011" or op = "00100" or op = "00101" then
				wb <= "10101";
				ram <= "0000";
				alu <= "01";
				read_en <= "010";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "00110" or op = "00111" then	
				wb <= "10101";
				ram <= "0000";
				alu <= "01";
				read_en <= "011";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "01000" or op = "01001" then	
				wb <= "10101";
				ram <= "0000";
				alu <= "01";
				read_en <= "011";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "01010" then	
				wb <= "00000";
				ram <= "0000";
				alu <= "00";
				read_en <= "011";
				sp_select <= '0';
				in_en <= '0';	out_en <= '1';	ld <= '0';

			ElSIF op = "01011" then	
				wb <= "11011";
				ram <= "0000";
				alu <= "00";
				read_en <= "000";
				sp_select <= '0';
				in_en <= '1';	out_en <= '0';	ld <= '0';

			ElSIF op = "01100" or op = "01101" or op = "01110" or op = "01111" then	
				wb <= "10101";
				ram <= "0000";
				alu <= "01";
				read_en <= "011";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "10000" or op = "10001" or op = "10010" or op = "10011" then	
				wb <= "00000";
				ram <= "0000";
				alu <= "01";
				read_en <= "011";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "10100" or op = "10101" then	
				wb <= "00000";
				ram <= "0000";
				alu <= "01";
				read_en <= "000";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "10110" then	
				wb <= "00101";
				ram <= "1011";
				alu <= "01";
				read_en <= "100";
				sp_select <= '1';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "10111" then	
				wb <= "00101";
				ram <= "1101";
				alu <= "01";
				read_en <= "001";
				sp_select <= '1';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "11000" then	
				wb <= "00000";
				ram <= "1011";
				alu <= "01";
				read_en <= "100";
				sp_select <= '1';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "11001" or op = "11010" then	
				wb <= "00101";
				ram <= "1101";
				alu <= "01";
				read_en <= "001";
				sp_select <= '1';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "11011" then	
				wb <= "10111";
				ram <= "0000";
				alu <= "00";
				read_en <= "000";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '0';

			ElSIF op = "11100" then	
				wb <= "10101";
				ram <= "0101";
				alu <= "00";
				read_en <= "000";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0';	ld <= '1';

			ElSE 	
				wb <= "00000";
				ram <= "0111";
				alu <= "00";
				read_en <= "001";
				sp_select <= '0';
				in_en <= '0';	out_en <= '0'; 	ld <= '0';
			END IF;
		END PROCESS;

END a_control_unit;

