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
		sel : IN std_logic_vector(1 downto 0);
            	x0,x1,x2,x3  : IN std_logic_vector(15 downto 0);
		q : OUT std_logic_vector(15 downto 0));
END Component;

COMPONENT source_selector IS
	PORT( opcode: in std_logic_vector(4 downto 0);
	      output: out std_logic);
END COMPONENT;

Component pc_selector IS
	PORT(	inc_pc, alu_pc, mem_pc : IN std_logic_vector(15 DOWNTO 0);
		alu_br_taken, mem_br_taken, intR, IF_int : IN std_logic;
		output : OUT std_logic_vector(15 DOWNTO 0));
END Component;

Component pc_inc is
    Port ( pc_in  : in  STD_LOGIC_VECTOR (15 downto 0);  
           pc_out  : out STD_LOGIC_VECTOR (15 downto 0));
end Component;

Component instruction_mem IS
	PORT(
		address : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END Component instruction_mem;

Component reg IS
	PORT( clk,rst,en : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END Component reg;


-----------------------------------------------------------------------------------
-------------------------------END-Components--------------------------------------
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-------------------------------SIGNALS---------------------------------------------
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
----------------------------------------------------------------fetch Stage signals

SIGNAL pc_input, pc_output, pc_incremented : std_logic_vector(15 DOWNTO 0);
SIGNAL ir : std_logic_vector(31 DOWNTO 0);
SIGNAL stall_sig, pc_en : std_logic;

-----------------------------------------------------------------------------------
---------------------------------------------------------------decode Stage signals

SIGNAL IF_ID_reg_out, IF_ID_reg_in : std_logic_vector(49 DOWNTO 0);

-----------------------------------------------------------------------------------
--------------------------------------------------------------Execute Stage signals

SIGNAL id_ex_reg_out, id_ex_reg_in : std_logic_vector(108 DOWNTO 0);

SIGNAL selector_output: std_logic;
SIGNAL rs_rd : std_logic_vector(15 DOWNTO 0);
SIGNAL rt_imm : std_logic_vector(15 DOWNTO 0);

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
------------------------------------------------------------Fetch stage Connections
pc_en <= not stall_sig;
pc_reg	: reg port map (clk, reset, pc_en, pc_input, pc_output);
instruction_mem_port	: instruction_mem port map (pc_output, ir);
pc_inc_port : pc_inc port map (pc_output, pc_incremented);
pc_selector_port : pc_selector port map (pc_incremented, alu_new_pc, mem_new_pc, alu_br_taken, mem_br_taken, int_r, IF_ID_reg_out(48), pc_input);
IF_ID_reg_in <= IF_ID_reg_out(48) & (int_r and (not IF_ID_reg_out(48))) & pc_incremented & ir;

-----------------------------------------------------------------------------------
stage_IF_ID_reg	: stage_reg generic map (50) port map (Clk, reset, pc_en, IF_ID_reg_in, IF_ID_reg_out);
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-----------------------------------------------------------Decode stage Connections


-----------------------------------------------------------------------------------
stage_id_ex_reg	: stage_reg generic map (108) port map (Clk, reset, '1', id_ex_reg_in, id_ex_reg_out);
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-----------------------------------------------------------Execute stage Connections
s_selector : source_selector port map(id_ex_reg_out(94 downto 90),selector_output);
mux_rs_rd  : mux_2x1_16 port map(selector_output, id_ex_reg_out(79 downto 64), id_ex_reg_out(47 downto 32), rs_rd);
mux_rt_imm : mux_2x1_16 port map(selector_output, id_ex_reg_out(63 downto 48), id_ex_reg_out(15 downto 0), rt_imm);

-----------------------------------------------------------------------------------
--stage_ex_mem_reg	: stage_reg generic map (87) port map (Clk, , '1', ,ex_mem_reg_out);
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--------------------------------------------------------------Mem stage Connections
mux_ram_address      : mux_4x1_16 port map(ex_mem_reg_out(78 DOWNTO 77),mem_zero_vec,ex_mem_reg_out(15 DOWNTO 0),ex_mem_reg_out(47 DOWNTO 32),ex_mem_reg_out(74 DOWNTO 59),ram_address);
mem_data_ram         : data_ram port map(clk_mem,mem_ram_en,ex_mem_reg_out(76),ram_address,ex_mem_reg_out(31 DOWNTO 16),ram_data_out);
mem_new_pc_tri       : tri port map(mem_br_taken,ram_data_out,mem_new_pc);

mem_br_taken <= '1' when ex_mem_reg_out(58 DOWNTO 54) = "11001" or ex_mem_reg_out(58 DOWNTO 54) = "11010"
	   else '0';
mem_wb_reg_reset <= '1' when mem_wb_reg_out(82) = '1'
		else reset;
mem_ram_en <= '0' when mem_wb_reg_out(82) = '1'
		else '1' when ex_mem_reg_out(76) = '0'
		else ex_mem_reg_out(75);

-----------------------------------------------------------------------------------
--stage_mem_wb_reg	: stage_reg generic map (83) port map (Clk, mem_wb_reg_reset, '1', , mem_wb_reg_out);
-----------------------------------------------------------------------------------
-------------------------------------------------------Write back stage connections 



END a_koko_micro;
