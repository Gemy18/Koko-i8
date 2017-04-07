library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity REGFILE is 
port(clk , rst: in std_logic;
rsdata : out std_logic_vector(15 downto 0);
rtdata : out std_logic_vector(15 downto 0);
rdata : out std_logic_vector(15 downto 0);
write_en: in std_logic ;
write_back_add:  std_logic_vector(2 downto 0);
write_back_data: std_logic_vector(15 downto 0);
rs:  std_logic_vector(2 downto 0);
rt:  std_logic_vector(2 downto 0);
rd:  std_logic_vector(2 downto 0));

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
signal out_reg1,out_reg2,out_reg3,out_reg4,out_reg5,out_reg6: STD_LOGIC_VECTOR (15 downto 0);

begin



decoder:   dec_3_x_8  port map (write_back_add,out_dec,write_en);
reg1:   reg  port map (clk,rst,out_dec(0),write_back_data,out_reg1);
reg2:   reg  port map (clk,rst,out_dec(1),write_back_data,out_reg2);
reg3:   reg  port map (clk,rst,out_dec(2),write_back_data,out_reg3);
reg4:   reg  port map (clk,rst,out_dec(3),write_back_data,out_reg4);
reg5:   reg  port map (clk,rst,out_dec(4),write_back_data,out_reg5);
reg6:   reg  port map (clk,rst,out_dec(5),write_back_data,out_reg6);



rsdata <= out_reg1 when rs = "000"
else out_reg2 when rs ="001"
else out_reg3 when rs ="010"
else out_reg4 when rs ="011"
else out_reg5 when rs ="100"
else out_reg6 when rs ="101"
else "0000000000000000" ;


rtdata <= out_reg1 when rt = "000"
else out_reg2 when rt ="001"
else out_reg3 when rt ="010"
else out_reg4 when rt ="011"
else out_reg5 when rt ="100"
else out_reg6 when rt ="101"
else "0000000000000000" ; 

rdata <= out_reg1 when rd = "000"
else out_reg2 when rd ="001"
else out_reg3 when rd ="010"
else out_reg4 when rd ="011"
else out_reg5 when rd ="100"
else out_reg6 when rd ="101"
else "0000000000000000" ;

end a_REGFILE;
