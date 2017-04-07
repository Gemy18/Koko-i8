LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY alu IS
	PORT(   a,b : IN std_logic_vector (15 downto 0); 	--Operands are a,b
		s : IN std_logic_vector (4 downto 0);		--S is the selector of the chips
		en,cin,nin,vin,zin : IN std_logic;  		--Input flags IN
		output : OUT std_logic_vector (15 downto 0);	--Output Value
		Cout,N,V,Z : OUT std_logic);			--Output flags
END ENTITY alu;

ARCHITECTURE struct OF alu IS

	COMPONENT generic_nadder IS
		GENERIC (n : integer := 16);
		PORT(	 a,b  : IN std_logic_vector(n-1  DOWNTO 0);
            		 cin  : IN std_logic;  
           		 s    : OUT std_logic_vector(n-1 DOWNTO 0);    
             		 cout : OUT std_logic);
        END COMPONENT;

	signal f, a_in, b_in, notb, zerovec, onevec, result,true_val 	     : std_logic_vector (15 downto 0);
	signal cino, coutb, notcoutb, overflow_add, overflow_sub    : std_logic;
begin
	--Signals
	notb <= not b;
	notcoutb <= not coutb; 
	zerovec <= (OTHERS => '0');
	onevec <= (OTHERS => '1');
	true_val <= "0000000000000001";

	overflow_add <= '1' when (a(15) ='0' and b(15) ='0' and result(15) = '1') or (a(15) ='1' and b(15) ='1' and result(15) = '0') else '0';
	overflow_sub <= '1' when (a(15) ='0' and b(15) ='1' and result(15) = '1') or (a(15) ='1' and b(15) ='0' and result(15) = '0') else '0';

	--Adder and subtractor
	a_in <= (not a) when s="01101"
		else a;
	b_in <= b when s = "00010"		--add
		else notb when s="00011"	--subtract
		else zerovec when s="01110" or s="10111" or s="01101" or s="11001" or s="11010"	--inc or pop or neg or ret or rti
		else onevec when s="01111" or s="10110" or s="11000";	--dec or push
	
	cino <= '1' when s="01110" or s="00011" or s="10111" or s="01101" or s="11001" or s="11010"
		else '0' when s="01111" or s="10110" or s="11000"
		else cin;
	
	u1: generic_nadder generic map (16) port map (a_in,b_in,cino,f,coutb);

	--Result
	result <= zerovec when en='0'
		  else f when en='1' and (s="00010" or s="00011" or s="01110" or s="01111" or s="10110" or s="10111" or s="11000" or s="01101" or s="11001" or s="11010")
		  else a and b when en='1' and s="00100"		--and
		  else a or b when en='1' and s="00101"			--or
		  else a(14 downto 0) & cin when en='1' and s="00110"	--rlc
		  else cin & a(15 downto 1) when en='1' and s="00111"	--rrc
		  else std_logic_vector(shift_left(unsigned(a), to_integer(unsigned(b)))) when en='1' and s="01000"	--shl
		  else std_logic_vector(shift_right(unsigned(a), to_integer(unsigned(b)))) when en='1' and s="01001"	--shr
		  else (not a) when en='1' and s="01100"		--not
		  else true_val when (en='1' and s="10000" and zin='1') or (en='1' and s="10001" and nin='1') or (en='1' and s="10010" and cin='1') or (en='1' and s="10011")
		  else zerovec;

	output <= result;

	--Flags
	Cout <= coutb when en='1' and (s="00010" or s="01110")
		else notcoutb when s="00011" or s="01111"
		else a(15) when s="00110"
		else a(0) when s="00111"
		else '1' when s="10100"			--setc
		else '0' when s="10101"			--clrc
		else cin when en='0' or s="10110" or s="10111" or s="11000" or s="11001" or s="11010" or s="10000" or s="10001" or s="10010" or s="10011"	--push, pop, ret, rti, jmp, and call
		else '0';
	N <= nin when en='0' or s="10100" or s="10101" or s="10110" or s="10111" or s="11000" or s="11001" or s="11010" or s="10000" or s="10001" or s="10010" or s="10011"
	     else result(15);
	Z <= zin when en='0' or s="10100" or s="10101" or s="10110" or s="10111" or s="11000" or s="11001" or s="11010" or s="10000" or s="10001" or s="10010" or s="10011"
	     else '1' when result = zerovec else '0';
	V <= vin when en='0' or s="10100" or s="10101" or s="10110" or s="10111" or s="11000" or s="11001" or s="11010" or s="10000" or s="10001" or s="10010" or s="10011"
	     else overflow_add when s = "00010" or s = "01110"
	     else overflow_sub when s = "00011" or s = "01111"
	     else '0';

END struct;