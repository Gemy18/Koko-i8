LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY data_ram IS
	PORT(
		clk : IN std_logic;
		en  : IN std_logic;
		wr  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout, int_addr : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY data_ram;

ARCHITECTURE a_data_ram OF data_ram IS

TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(15 DOWNTO 0);
SIGNAL ram : ram_type;
SIGNAL int_add : std_logic_vector(15 DOWNTO 0);

BEGIN
	PROCESS(clk) IS
		BEGIN
			IF rising_edge(clk) THEN  
				IF wr = '1' THEN
					ram(to_integer(unsigned(address))) <= datain;
				END IF;
			END IF;
	END PROCESS;
	dataout <= ram(to_integer(unsigned(address)));
	int_add <= "0000000000000001";
	int_addr <= ram(to_integer(unsigned(int_add)));
END a_data_ram;
