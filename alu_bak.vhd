LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY alu IS
	PORT( a,b : IN std_logic_vector (15 downto 0);
	s : IN std_logic_vector (4 downto 0);
	f : OUT std_logic_vector (15 downto 0);
	flags_in : IN std_logic_vector (4 downto 0);
	flags_out : OUT std_logic_vector(4 downto 0));
END ENTITY alu;


ARCHITECTURE struct OF alu IS
	
COMPONENT my_nadder IS 
     PORT(a,b : IN std_logic_vector(15  DOWNTO 0);
          cin : IN std_logic;  
            s : OUT std_logic_vector(15 DOWNTO 0);    
         cout : OUT std_logic);
END COMPONENT;


signal not_a,y1,y2,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,tmp_out :std_logic_vector(15  DOWNTO 0);
signal flags_tmp :std_logic_vector(4  DOWNTO 0);
signal not_cf,car1,car2,car3,car6,car7,car8,car9,car10,car11,car12,car13,car14,cary1,cary2: std_logic;
BEGIN
conva: not_a <= NOT a;	
notcf: not_cf <= NOT flags_in(0);
adding:	my_nadder  port map (a,b,'0',x1,car1); -- a+b
subba :  my_nadder  port map (b,not_a,'1',x2,car2);-- b-a
	
addingC:   my_nadder  port map (a,b,flags_in(0),x6,car6);	-- a+b+c
subbaC:    my_nadder  port map (b,not_a,not_cf,x7,car7); --b-a-c(when Cin=1 it will pass 0 so the result will be b-a-1 and vice versa)
incy:		 my_nadder  port map (b,"0000000000000001",'0',y1,cary1); -- b+1
decy:      my_nadder  port map (b,"1111111111111110",'1',y2,cary2);-- b-1

	
logcar: car3 <=flags_in(0);	
anding: x3 <= a and b; 
oring: x4<= a or b;
xoring: x5<= a xor b; 

LSR1:x8(15)<='0' ;
LSR2:x8(14 downto 0)<=b(15 downto 1);
LSR3: car8<= b(0);

ROR1: x9(15)<=b(0);
ROR2: x9(14 downto 0)<=b(15 downto 1);
ROR3: car9<=flags_in(0);

RRC1: car10<=b(0);
RRC2: x10(15)<=flags_in(0);
RRC3: x10(14 downto 0)<=b(15 downto 1);

ASR1: x11(15)<=b(15);
ASR2: x11(14 downto 0)<=b(15 downto 1);
ASR3: car11<= b(0);

LSL1: x12(0)<='0';
LSL2: x12(15 downto 1)<=b(14 downto 0);
LSL3: car12<= b(15);

ROL1: x13(0)<=b(0);
ROL2: x13(15 downto 1)<=b(14 downto 0);
ROL3: car13<=flags_in(0);

RLC1: x14(0)<=flags_in(0);
RLC2: x14(15 downto 1)<=b(14 downto 0);
RLC3: car14<=b(15);


out_alu:tmp_out <= "0000000000000000" when s="00000" or s="01101"
else NOT b when s="01110"
else std_logic_vector(to_signed(to_integer(signed(a)) + 1 ,tmp_out'length)) WHEN s = "00010" --a+1 
else std_logic_vector(to_signed(to_integer(signed(a)) - 1 ,tmp_out'length)) WHEN s = "00011" --a-1
--else std_logic_vector(to_signed(to_integer(signed(b)) + 1 ,tmp_out'length)) WHEN s = "01011" --b+1 
--else std_logic_vector(to_signed(to_integer(signed(b)) - 1 ,tmp_out'length)) WHEN s = "01100" --b-1
else x1 when s="00100" or s ="00001"
else x2 when s="00110"
else x3 when s="01000" 
else x4 when s="01001" 
else x5 when s="01010"
else x6 when s="00101"
else x7 when s="00111"
else y1 when s="01011"
else y2 when s="01100"

else x8 when s="01111"
else x9 when s="10000" 
else x10 when s="10001" 
else x11 when s="10010"
else x12 when s="10011"
else x13 when s="10100"
else x14 when s="10101";


Cflag: flags_tmp(0)<=flags_in(0) when s="00001" or s="00010" or s="00011" or s="00000" or s="01011" or s="01100"--No flag in inc and dec
else car1 when s="00100"
else car2 when s="00110"
else car3 when s="01000" or s="01001" or s="01010" --Logic operations
else car6 when s="00101"
else car7 when s="00111"
--else cary1 when  --b+1
--else cary2 when  --b-1

else car8 when s="01111"
else car9 when s="10000" 
else car10 when s="10001" 
else car11 when s="10010"
else car12 when s="10011"
else car13 when s="10100"
else car14 when s="10101"

else '0' when s="01101";


	
Zflag: flags_tmp(1)<= flags_in(1) when s="00001" or s="00010" or s="00011" or s="00000"	
else '1' when tmp_out="0000000000000000"
else '0';
	
Nflag:  flags_tmp(2)<=flags_in(2) when s="00001" or s="00010" or s="00011" or s="00000"
else tmp_out(15);
	
Pflag: flags_tmp(3)<= flags_in(3) when s="00001" or s="00010" or s="00011" or s="00000"
else tmp_out (0) xor tmp_out(1)xor tmp_out(2) xor tmp_out(3) xor tmp_out(4) xor tmp_out(5) xor tmp_out(6) xor tmp_out(7) xor tmp_out(8) xor tmp_out(9) xor tmp_out(10) xor tmp_out(11) xor tmp_out(12) xor tmp_out(13) xor tmp_out(14) xor tmp_out(15);
	
	
Oflag:flags_tmp(4) <= flags_in(4) when s="00001" or s="00010" or s="00011" or s="00000"
else '1' when (           (a(15)='0' and b(15)='0' and tmp_out(15)='1' and (s = "00100" or s="00101" ))  --a+b (a&b positive => out negative) || a+b+c
			   		   or (a(15)='1' and b(15)='1' and tmp_out(15)='0' and (s = "00100" or s="00101" ))  --a+b (a&b negative => out negative) || a+b+c
					   or (b(15)='1' and a(15)='0' and tmp_out(15)='0' and (s = "00110" or s="00111" ))  --b-a (b neg & a pos => out pos) || b-a-c
					   or (b(15)='0' and a(15)='1' and tmp_out(15)='1' and (s = "00110" or s="00111" ))  --b-a (b pos & a neg => out neg) || b-a-c
					   or (b(15)='0' and tmp_out(15)='1' and s = "01011") -- b+1
					   or (b(15)='1' and tmp_out(15)='0' and s = "01100") -- b-1
   )	
else ( flags_tmp(0) xor flags_tmp (2)) when (s="01111"  or s="10000"  or  s="10001"   or s="10010" or s="10011" or s="10100"  or s="10101" )
else '0';
								

setf: f<=tmp_out;
setflags: flags_out<=flags_tmp	;


END struct;
