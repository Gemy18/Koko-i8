LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity koko_micro IS
	PORT(           clk     : IN std_logic;
		 	clk_mem : IN std_logic;
			clk_reg_file : IN std_logic;
			reset 	: IN std_logic;
			int_r   : IN std_logic;
			in_port : IN std_logic_vector(15 DOWNTO 0);
			out_port: OUT std_logic_vector(15 DOWNTO 0));
END koko_micro;

ARCHITECTURE a_koko_micro OF koko_micro IS

-----------------------------------------------------------------------------------
-------------------------------Components------------------------------------------
-----------------------------------------------------------------------------------

COMPONENT stage_reg IS
	GENERIC (n : integer := 16);
	PORT( Clk,Rst : IN std_logic;
		  WE : IN std_logic;
		  d : IN  std_logic_vector(n-1 DOWNTO 0);
		  q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

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

Component mux_2x1_16 IS
	PORT(	
		sel : IN std_logic;
            	x1,x2  : IN std_logic_vector(15 downto 0);
		q : OUT std_logic_vector(15 DOWNTO 0));
END Component;

Component mux_4x1_16 IS
	PORT(	
		sel : IN std_logic_vector(2 downto 0);
            	x0,x1,x2,x3  : IN std_logic_vector(15 downto 0);
		q : OUT std_logic_vector(15 downto 0));
END Component;

-----------------------------------------------------------------------------------
-------------------------------END-Components--------------------------------------
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-------------------------------SIGNALS---------------------------------------------
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
------------------------------------------------------------------Mem Stage signals

SIGNAL ex_mem_reg_out : std_logic_vector(86 DOWNTO 0);
SIGNAL mem_wb_reg_reset : std_logic;

SIGNAL mem_wb_en : std_logic;
-- SIGNAL mem_wb_op
SIGNAL mem_pc : std_logic;
SIGNAL mem_rs_d : std_logic;
SIGNAL mem_rd_d : std_logic;
SIGNAL mem_rd : std_logic;
SIGNAL mem_ea : std_logic;
SIGNAL mem_alu_out : std_logic;
-- ram signals
SIGNAL mem_ram_en : std_logic;
SIGNAL mem_ram_wr : std_logic;
-- SIGNAL ram_op
SIGNAL ram_address : std_logic_vector(15 DOWNTO 0);
SIGNAL ram_data_in : std_logic_vector(15 DOWNTO 0);
SIGNAL ram_data_out: std_logic_vector(15 DOWNTO 0);
SIGNAL mem_zero_vec: std_logic_vector(15 DOWNTO 0);

SIGNAL mem_new_pc : std_logic_vector(15 DOWNTO 0);
SIGNAL mem_br_taken : std_logic;

-----------------------------------------------------------------------------------
-----------------------------------------------------------Write back Stage signals
SIGNAL mem_wb_reg_out : std_logic_vector(86 DOWNTO 0);

SIGNAL wb_wb_en : std_logic;
-- SIGNAL wb_wb_op : std_logic;

SIGNAL wb_data_out : std_logic_vector(15 DOWNTO 0);
SIGNAL wb_alu_out : std_logic_vector(15 DOWNTO 0);
SIGNAL wb_imm : std_logic_vector(15 DOWNTO 0);
SIGNAL wb_rs_d : std_logic_vector(15 DOWNTO 0);
SIGNAL wb_in_d : std_logic_vector(15 DOWNTO 0);

-- in and out buffers
SIGNAL in_port_en : std_logic;
SIGNAL out_port_en : std_logic;
-----------------------------------------------------------------------------------
-------------------------------END-SIGNALS-----------------------------------------
-----------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------
-------------------------------Connections-----------------------------------------
-----------------------------------------------------------------------------------
Begin

-----------------------------------------------------------------------------------
--stage_ex_mem_reg	: stage_reg generic map (87) port map (Clk, , '1', ,ex_mem_reg_out);
-----------------------------------------------------------------------------------
--------------------------------------------------------------Mem stage Connections
-- mux_ram_address      : mux_4x1_16 port map(ram_address,mem_zero_vec,mem_ea,mem_rs_d,mem_alu_out,ram_address);
-- mem_data_ram         : data_ram port map(clk_mem,en,wr,address,datain,dataout)
mem_new_pc_tri       : tri port map(mem_br_taken,ram_data_out,mem_new_pc);

mem_br_taken <= '1' when ex_mem_reg_out(58 DOWNTO 54) = "11001" or ex_mem_reg_out(58 DOWNTO 54) = "11010"
	   else '0';
mem_wb_reg_reset <= '1' when mem_wb_reg_out(82) = '1'
		else reset;
mem_ram_en <= '0' when mem_wb_reg_out(82) = '1'
		else ex_mem_reg_out(75);

-----------------------------------------------------------------------------------
--stage_mem_wb_reg	: stage_reg generic map (83) port map (Clk, mem_wb_reg_reset, '1', , mem_wb_reg_out);
-----------------------------------------------------------------------------------
-------------------------------------------------------Write back stage connections 



END a_koko_micro;
