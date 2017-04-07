LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity koko_micro IS
	PORT(           clk     : IN std_logic;
		 	clk_mem : IN std_logic;
			clk_reg : IN std_logic;
			reset 	: IN std_logic;
			int_r   : IN std_logic;
			in_port : IN std_logic_vector(15 DOWNTO 0);
			out_port: OUT std_logic_vector(15 DOWNTO 0));
END koko_micro;

ARCHITECTURE a_koko_micro OF koko_micro IS

-----------------------------------------------------------------------------------
-------------------------------Components------------------------------------------
-----------------------------------------------------------------------------------

Component data_ram IS
	PORT(
		clk : IN std_logic;
		en  : IN std_logic;
		wr  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END Component;

Component tri IS
	PORT(
		  en: IN std_logic;
		  input: IN std_logic_vector(15 DOWNTO 0);
		  output: OUT std_logic_vector(15 DOWNTO 0));
END Component;

-----------------------------------------------------------------------------------
-------------------------------END-Components--------------------------------------
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-------------------------------SIGNALS---------------------------------------------
-----------------------------------------------------------------------------------

--Mem Stage signals
SIGNAL mem_wb_en : std_logic;
-- SIGNAL mem_wb_op
SIGNAL mem_pc : std_logic;
SIGNAL mem_rs_d : std_logic;
SIGNAL mem_rd_d : std_logic;
SIGNAL mem_rd : std_logic;
SIGNAL mem_ea : std_logic;
SIGNAL mem_alu_out : std_logic;
-- ram signals
SIGNAL ram_en : std_logic;
SIGNAL ram_wr : std_logic;
-- SIGNAL ram_op
SIGNAL ram_address : std_logic_vector(15 DOWNTO 0);
SIGNAL ram_data_in : std_logic_vector(15 DOWNTO 0);
SIGNAL ram_data_out: std_logic_vector(15 DOWNTO 0);
-- signal for address mux
-- signal for datain mux

-----------------------------------------------------------------------------------
-------------------------------END-SIGNALS-----------------------------------------
-----------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------
-------------------------------Connections-----------------------------------------
-----------------------------------------------------------------------------------
Begin


END a_koko_micro;
