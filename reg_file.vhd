library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity REGFILE is 
port(clk, clk2 , rst: in std_logic;
rsdata : out std_logic_vector(15 downto 0);
rtdata : out std_logic_vector(15 downto 0);
rdata, r0, r1, r2, r3, r4, r5, r6 : out std_logic_vector(15 downto 0);
write_en, r6_en: in std_logic ;
write_back_add: in std_logic_vector(2 downto 0);
write_back_data,  r6_d: in std_logic_vector(15 downto 0);
rs: in std_logic_vector(2 downto 0);
rt: in std_logic_vector(2 downto 0);
rd: in std_logic_vector(2 downto 0));

end REGFILE;


architecture a_REGFILE  of REGFILE is
COMPONENT dec_3_x_8 IS 
    Port ( s  : in  STD_LOGIC_VECTOR (2 downto 0);  
           out_dec  : out STD_LOGIC_VECTOR (7 downto 0);
           en : in  STD_LOGIC );
END COMPONENT;

COMPONENT reg IS
	PORT( clk,rst,en : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

signal out_dec: STD_LOGIC_VECTOR (7 downto 0);
signal out_reg1,out_reg2,out_reg3,out_reg4,out_reg5,out_reg6, out_reg7, wb_d, sp_data: STD_LOGIC_VECTOR (15 downto 0);
signal sp_select, sp_rst : std_logic;

begin

sp_select <= out_dec(6) or rst or r6_en;
wb_d <= write_back_data when rst = '0' else "0000001111111111";
sp_data <= wb_d when r6_en = '0' else r6_d;
sp_rst <= clk and clk2 and rst;

decoder:   dec_3_x_8  port map (write_back_add,out_dec,write_en);
reg1:   reg  port map (clk,rst,out_dec(0),wb_d,out_reg1);
reg2:   reg  port map (clk,rst,out_dec(1),wb_d,out_reg2);
reg3:   reg  port map (clk,rst,out_dec(2),wb_d,out_reg3);
reg4:   reg  port map (clk,rst,out_dec(3),wb_d,out_reg4);
reg5:   reg  port map (clk,rst,out_dec(4),wb_d,out_reg5);
reg6:   reg  port map (clk,rst,out_dec(5),wb_d,out_reg6);
reg7:   reg  port map (clk,'0',sp_select,sp_data,out_reg7);



rsdata <= out_reg1 when rs = "000"
else out_reg2 when rs ="001"
else out_reg3 when rs ="010"
else out_reg4 when rs ="011"
else out_reg5 when rs ="100"
else out_reg6 when rs ="101"
else out_reg7 when rs ="110"
else "0000000000000000" ;


rtdata <= out_reg1 when rt = "000"
else out_reg2 when rt ="001"
else out_reg3 when rt ="010"
else out_reg4 when rt ="011"
else out_reg5 when rt ="100"
else out_reg6 when rt ="101"
else out_reg7 when rt ="110"
else "0000000000000000" ; 

rdata <= out_reg1 when rd = "000"
else out_reg2 when rd ="001"
else out_reg3 when rd ="010"
else out_reg4 when rd ="011"
else out_reg5 when rd ="100"
else out_reg6 when rd ="101"
else out_reg7 when rd ="110"
else "0000000000000000" ;

r0 <= out_reg1;
r1 <= out_reg2;
r2 <= out_reg3;
r3 <= out_reg4;
r4 <= out_reg5;
r5 <= out_reg6;
r6 <= out_reg7;


end a_REGFILE;
