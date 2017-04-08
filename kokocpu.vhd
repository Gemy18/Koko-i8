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

Component mux_8x1_16 IS
	PORT(	sel : IN std_logic_vector(2 downto 0);
            x0,x1,x2,x3,x4,x5,x6,x7  : IN std_logic_vector(15 downto 0);
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

Component forwarding_unit IS
	PORT( id_opcode, ex_opcode, mem_opcode	     : in std_logic_vector(4 downto 0);
	      id_rs,id_rt,id_rd,mem_rd, mem_rs, ex_rd: in std_logic_vector(2 downto 0);
	      source_selector, mem_wb, ex_wb, mem_wb_select, ram_op : in std_logic;
	      mux_mem_s : out std_logic;
	      mux1_ex_s,mux2_ex_s: out std_logic_vector(1 downto 0));
END Component;

Component alu IS
	PORT(   a,b : IN std_logic_vector (15 downto 0); 	--Operands are a,b
		s : IN std_logic_vector (4 downto 0);		--S is the selector of the chips
		en,cin,nin,vin,zin : IN std_logic;  		--Input flags IN
		output : OUT std_logic_vector (15 downto 0);	--Output Value
		Cout,N,V,Z : OUT std_logic);			--Output flags
END Component;

Component REGFILE is 
port(clk , rst: in std_logic;
rsdata : out std_logic_vector(15 downto 0);
rtdata : out std_logic_vector(15 downto 0);
rdata, r0, r1, r2, r3, r4, r5, r6 : out std_logic_vector(15 downto 0);
write_en, r6_en: in std_logic ;
write_back_add: in std_logic_vector(2 downto 0);
write_back_data,  r6_d: in std_logic_vector(15 downto 0);
rs: in std_logic_vector(2 downto 0);
rt: in std_logic_vector(2 downto 0);
rd: in std_logic_vector(2 downto 0));
end Component REGFILE;

Component control_unit IS
	PORT(	op : IN std_logic_vector(4 DOWNTO 0);
		stall, IF_int, br_taken : IN std_logic;
		wb : OUT std_logic_vector(4 DOWNTO 0);
		ram : OUT std_logic_vector(3 DOWNTO 0);
		alu : OUT std_logic_vector(1 DOWNTO 0);
		read_en : OUT std_logic_vector(2 DOWNTO 0);
		in_en, out_en, sp_select, ld : OUT std_logic);
END Component control_unit;

Component stall_detector IS
	PORT(	rs, rt, rd, ID_rd, read_en, ex_mem_rd, id_ex_rd : IN std_logic_vector(2 DOWNTO 0);
		ID_load : IN std_logic;
		op_code, ex_mem_op, id_ex_op : IN std_logic_vector(4 DOWNTO 0);
		output : OUT std_logic);
END Component stall_detector;

-----------------------------------------------------------------------------------
-------------------------------END-Components--------------------------------------
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-------------------------------SIGNALS---------------------------------------------
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
----------------------------------------------------------------fetch Stage signals
SIGNAL zerovec1: std_logic_vector(86 DOWNTO 0);
SIGNAL zerovec2: std_logic_vector(98 DOWNTO 0);
SIGNAL pc_input, pc_output, pc_incremented : std_logic_vector(15 DOWNTO 0);
SIGNAL ir : std_logic_vector(31 DOWNTO 0);
SIGNAL stall_sig, pc_en : std_logic;

-----------------------------------------------------------------------------------
---------------------------------------------------------------decode Stage signals

SIGNAL IF_ID_reg_out, IF_ID_reg_in : std_logic_vector(49 DOWNTO 0);

SIGNAL rs_data, rt_data, rd_data, pc_signal, ea_imm_signal, r0, r1, r2, r3, r4, r5, r6 : std_logic_vector(15 downto 0);
SIGNAL read_en, rs_selected, rt, rd : std_logic_vector(2 downto 0);
SIGNAL br_taken, sp_select, out_en_signal, in_en_signal, ld_signal : std_logic;
SIGNAL alu_signals : std_logic_vector(1 downto 0);
SIGNAL op_signal, wb_signals : std_logic_vector(4 downto 0);
SIGNAL ram_signals : std_logic_vector(3 downto 0);

-----------------------------------------------------------------------------------
--------------------------------------------------------------Execute Stage signals

SIGNAL id_ex_reg_out, id_ex_reg_in : std_logic_vector(107 DOWNTO 0);

SIGNAL alu_br_taken, alu_br_taken_out, selector_output, rst_basedon_taken, br_opcode, ex_mem_reg_reset: std_logic;
SIGNAL rs_rd, alu_new_pc : std_logic_vector(15 DOWNTO 0);
SIGNAL rt_imm, alu_ex_out : std_logic_vector(15 DOWNTO 0);
SIGNAL mux_a, mux_b : std_logic_vector(1 DOWNTO 0);
SIGNAL a,b : std_logic_vector(15 DOWNTO 0);
SIGNAL flags_in, flags_out, flags_old_out, to_flags : std_logic_vector (3 DOWNTO 0);

SIGNAL ex_mem_reg_in : std_logic_vector(86 DOWNTO 0);
SIGNAL ex_mem_reg_in_or_rst : std_logic_vector(86 DOWNTO 0);
SIGNAL forwarded_e_to_e : std_logic_vector(15 DOWNTO 0);
SIGNAL forwarded_m_to_e : std_logic_vector(15 DOWNTO 0);
-----------------------------------------------------------------------------------
------------------------------------------------------------------Mem Stage signals

SIGNAL ex_mem_reg_out : std_logic_vector(86 DOWNTO 0);
SIGNAL mem_wb_reg_reset : std_logic;

-- ram signals
SIGNAL mem_ram_en, mux_mem_s : std_logic;
SIGNAL ram_address : std_logic_vector(15 DOWNTO 0);
SIGNAL ram_data_out: std_logic_vector(15 DOWNTO 0);
SIGNAL ram_data_in : std_logic_vector(15 DOWNTO 0);
SIGNAL mem_zero_vec: std_logic_vector(15 DOWNTO 0);

SIGNAL mem_new_pc : std_logic_vector(15 DOWNTO 0);
SIGNAL mem_br_taken_en_reg : std_logic;
SIGNAL mem_br_taken : std_logic;

-----------------------------------------------------------------------------------
-----------------------------------------------------------Write back Stage signals
SIGNAL mem_wb_reg_in : std_logic_vector(98 DOWNTO 0);
SIGNAL mem_wb_reg_in_or_rst : std_logic_vector(98 DOWNTO 0);
SIGNAL mem_wb_reg_out : std_logic_vector(98 DOWNTO 0);

SIGNAL wb_en : std_logic;
SIGNAL wb_data : std_logic_vector(15 DOWNTO 0);
SIGNAL wb_add: std_logic_vector(2 DOWNTO 0);
SIGNAL wb_r6_d : std_logic_vector(15 DOWNTO 0);
SIGNAL wb_r6_en : std_logic;

-- in and out buffers
SIGNAL in_port_en : std_logic;
SIGNAL out_port_en : std_logic;
SIGNAL in_port_buf_out : std_logic_vector(15 DOWNTO 0);
-----------------------------------------------------------------------------------
-------------------------------END-SIGNALS-----------------------------------------
-----------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------
-------------------------------Connections-----------------------------------------
-----------------------------------------------------------------------------------

Begin

zerovec1 <= (OTHERS => '0');
zerovec2 <= (OTHERS => '0');
-----------------------------------------------------------------------------------
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

br_taken <= (mem_br_taken or alu_br_taken_out);
op_signal <= IF_ID_reg_out(31 downto 27) when IF_ID_reg_out(49) = '0' else "10110";
pc_signal <= IF_ID_reg_out(47 downto 32);
ea_imm_signal <= IF_ID_reg_out(15 downto 0);
rs_selected <= "110" when sp_select = '1' else IF_ID_reg_out(26 downto 24);
rt <= IF_ID_reg_out(23 downto 21);
rd <= IF_ID_reg_out(20 downto 18);

stall_detector_port : stall_detector port map (rs_selected, rt, rd, id_ex_reg_out(82 downto 80), 
	read_en, ex_mem_reg_out(50 downto 48), id_ex_reg_out(82 downto 80), id_ex_reg_out(107), op_signal, ex_mem_reg_out(58 downto 54), id_ex_reg_out(94 downto 90), stall_sig);

REGFILE_port : REGFILE port map (clk_reg_file, reset, rs_data, rt_data, rd_data, r0, r1, r2, r3, r4, r5, r6, wb_en, wb_r6_en, wb_add,
 	wb_data, wb_r6_d, rs_selected, rt, rd);

control_unit_port : control_unit port map (op_signal, stall_sig, IF_ID_reg_out(49), 
	br_taken, wb_signals, ram_signals, alu_signals, read_en, in_en_signal, out_en_signal, 
	sp_select, ld_signal);


id_ex_reg_in(107) <= ld_signal;
id_ex_reg_in(106) <= out_en_signal;
id_ex_reg_in(105) <= in_en_signal;
id_ex_reg_in(104 downto 100) <= "01000" when op_signal = "01010" else wb_signals;
id_ex_reg_in(99 downto 96) <= ram_signals;
id_ex_reg_in(95) <= alu_signals(1);
id_ex_reg_in(94 downto 90) <= op_signal;
id_ex_reg_in(89) <= alu_signals(0);
id_ex_reg_in(88 downto 86) <= rs_selected;
id_ex_reg_in(85 downto 83) <= rt;
id_ex_reg_in(82 downto 80) <= rd when stall_sig = '0' else "111";
id_ex_reg_in(79 downto 64) <= rd_data when op_signal = "01010" else rs_data ;
id_ex_reg_in(63 downto 48) <= rt_data;
id_ex_reg_in(47 downto 32) <= rd_data when IF_ID_reg_out(49) = '0' else pc_signal;
id_ex_reg_in(31 downto 16) <= pc_signal;
id_ex_reg_in(15 downto 0) <= ea_imm_signal;

-----------------------------------------------------------------------------------
stage_id_ex_reg	: stage_reg generic map (108) port map (Clk, reset, '1', id_ex_reg_in, id_ex_reg_out);
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-----------------------------------------------------------Execute stage Connections
s_selector : source_selector port map(id_ex_reg_out(94 downto 90),selector_output);

forwarding : forwarding_unit port map (id_ex_reg_out(94 downto 90), ex_mem_reg_out(58 downto 54), mem_wb_reg_out(42 downto 38),id_ex_reg_out(88 downto 86), id_ex_reg_out(85 downto 83), id_ex_reg_out(82 downto 80), mem_wb_reg_out(34 downto 32), mem_wb_reg_out(37 downto 35), ex_mem_reg_out(50 downto 48), selector_output, mem_wb_reg_out(75), ex_mem_reg_out(79),mem_wb_reg_out(79), ex_mem_reg_out(76), mux_mem_s, mux_a,mux_b);

mux_rs_rd  : mux_2x1_16 port map(selector_output, id_ex_reg_out(79 downto 64), id_ex_reg_out(47 downto 32), rs_rd);
mux_rt_imm : mux_2x1_16 port map(selector_output, id_ex_reg_out(63 downto 48), id_ex_reg_out(15 downto 0), rt_imm);

forwarded_e_to_e <= ex_mem_reg_out (15 downto 0) when ex_mem_reg_out(58 downto 54) = "11011"
			 else ex_mem_reg_out(74 downto 59);

forwarded_m_to_e <= mem_wb_reg_out (15 downto 0) when mem_wb_reg_out(42 downto 38) = "11011"
			 else mem_wb_reg_out(74 downto 59);


muxa	   : mux_4x1_16 port map(mux_a, rs_rd, forwarded_e_to_e, forwarded_m_to_e, rs_rd, a);
muxb	   : mux_4x1_16 port map(mux_b, rt_imm,forwarded_e_to_e, forwarded_m_to_e, rt_imm, b);

alu_new_pc <= ex_mem_reg_out(31 downto 16);	--ask if this is correct and not id_ex_reg_out.
alu1	   : alu port map(a,b, id_ex_reg_out(94 downto 90), id_ex_reg_out(89), flags_out(3), flags_out(2), flags_out(1), flags_out(0), alu_ex_out, flags_in(3), flags_in(2), flags_in(1), flags_in(0));

flags_backup  : stage_reg generic map (4) port map (Clk, reset, id_ex_reg_out(95), flags_out, flags_old_out);
to_flags <= flags_old_out when id_ex_reg_out(94 downto 90) = "11010"	--when rti, get backup flags.
	    else flags_in;
flags_current : stage_reg generic map (4) port map (Clk, reset, '1', to_flags, flags_out);

br_opcode <= '1' when id_ex_reg_out(94 downto 90) = "10000" or id_ex_reg_out(94 downto 90) = "10001" or id_ex_reg_out(94 downto 90) = "10010" or id_ex_reg_out(94 downto 90) = "10011"
	     else '0';
alu_br_taken <= '1' when (br_opcode = '1' and alu_ex_out(0) = '1') or (id_ex_reg_out(94 downto 90) = "11000")
		else '0';
rst_basedon_taken <= '1' when (alu_br_taken_out = '1' or mem_br_taken = '1')
		     else '0';

ex_mem_reg_in(15 downto 0)  <= id_ex_reg_out(15 downto 0);
ex_mem_reg_in(31 downto 16) <= id_ex_reg_out(47 downto 32);
ex_mem_reg_in(47 downto 32) <= id_ex_reg_out(79 downto 64);
ex_mem_reg_in(50 downto 48) <= id_ex_reg_out(82 downto 80);
ex_mem_reg_in(53 downto 51) <= id_ex_reg_out(88 downto 86);
ex_mem_reg_in(58 downto 54) <= id_ex_reg_out(94 downto 90);
ex_mem_reg_in(74 downto 59) <= alu_ex_out;
ex_mem_reg_in(75) <= id_ex_reg_out(96);
ex_mem_reg_in(76) <= id_ex_reg_out(97);
ex_mem_reg_in(78 downto 77) <= id_ex_reg_out(99 downto 98);
ex_mem_reg_in(79) <= id_ex_reg_out(100);
ex_mem_reg_in(82 downto 80) <= id_ex_reg_out(103 downto 101);
ex_mem_reg_in(83) <= id_ex_reg_out(104);
ex_mem_reg_in(84) <= id_ex_reg_out(105);
ex_mem_reg_in(85) <= id_ex_reg_out(106);
ex_mem_reg_in(86) <= alu_br_taken;

alu_br_taken_out <= ex_mem_reg_out(86);

ex_mem_reg_in_or_rst <= ex_mem_reg_in when rst_basedon_taken = '0'
			else zerovec1; 

-----------------------------------------------------------------------------------
stage_ex_mem_reg	: stage_reg generic map (87) port map (Clk, reset, '1', ex_mem_reg_in_or_rst, ex_mem_reg_out);
-----------------------------------------------------------------------------------
--------------------------------------------------------------Mem stage Connections
mux_ram_address      : mux_4x1_16 port map(ex_mem_reg_out(78 DOWNTO 77),mem_zero_vec,ex_mem_reg_out(15 DOWNTO 0),ex_mem_reg_out(47 DOWNTO 32),ex_mem_reg_out(74 DOWNTO 59),ram_address);
ram_data_in <=  ex_mem_reg_out(31 DOWNTO 16) when mux_mem_s = '0'
		else wb_data;
mem_data_ram         : data_ram port map(clk_mem,mem_ram_en,ex_mem_reg_out(76),ram_address,ram_data_in,ram_data_out);

mem_br_taken_en_reg <= '1' when ex_mem_reg_out(58 DOWNTO 54) = "11001" or ex_mem_reg_out(58 DOWNTO 54) = "11010"
	   else '0';
mem_br_taken <= mem_wb_reg_out(82);
mem_new_pc <= mem_wb_reg_out(98 DOWNTO 83);
mem_wb_reg_reset <= '1' when mem_wb_reg_out(82) = '1'
		else reset;
mem_wb_reg_in_or_rst <= mem_wb_reg_in when mem_br_taken = '0'
			else zerovec2; 
mem_ram_en <= '0' when mem_wb_reg_out(82) = '1'
		else '1' when ex_mem_reg_out(76) = '0'
		else ex_mem_reg_out(75);

mem_wb_reg_in <= ram_data_out & mem_br_taken_en_reg & ex_mem_reg_out(85 DOWNTO 79) & ram_data_out & ex_mem_reg_out(74 DOWNTO 48) & ex_mem_reg_out(47 DOWNTO 32) & ex_mem_reg_out(15 DOWNTO 0);
-----------------------------------------------------------------------------------
stage_mem_wb_reg     : stage_reg generic map (99) port map (Clk, reset, '1', mem_wb_reg_in_or_rst , mem_wb_reg_out);
-----------------------------------------------------------------------------------
-------------------------------------------------------Write back stage connections
mux_wb               : mux_8x1_16 port map(mem_wb_reg_out(78 DOWNTO 76),mem_zero_vec,mem_wb_reg_out(74 DOWNTO 59),mem_wb_reg_out(58 DOWNTO 43),mem_wb_reg_out(15 DOWNTO 0),mem_wb_reg_out(31 DOWNTO 16),in_port_buf_out,mem_zero_vec,mem_zero_vec,wb_data);
wb_in_port_tri 	     : tri port map(mem_wb_reg_out(80),in_port,in_port_buf_out);
wb_out_port_tri      : tri port map(mem_wb_reg_out(81),wb_data,out_port);
mem_zero_vec <= "0000000000000000";
wb_en <= mem_wb_reg_out(75);
wb_add <=  mem_wb_reg_out(37 DOWNTO 35) when mem_wb_reg_out(79) = '0'
	else mem_wb_reg_out(34 DOWNTO 32) when mem_wb_reg_out(79) = '1'
	else "000";

wb_r6_d <= mem_wb_reg_out(58 DOWNTO 43);
wb_r6_en <= '1' when mem_wb_reg_out(42 DOWNTO 38) = "10111" else '0';



END a_koko_micro;
