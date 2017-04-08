LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity pc_inc is
    Port ( pc_in  : in  STD_LOGIC_VECTOR (15 downto 0);  
           pc_out  : out STD_LOGIC_VECTOR (15 downto 0));
end pc_inc;




architecture a_pc_inc of pc_inc is

	COMPONENT generic_nadder IS
		GENERIC (n : integer := 16);
		PORT(	 a,b  : IN std_logic_vector(n-1  DOWNTO 0);
            		 cin  : IN std_logic;  
           		 s    : OUT std_logic_vector(n-1 DOWNTO 0);    
             		 cout : OUT std_logic);
        END COMPONENT;


signal cout,cin:std_logic;
signal new_pc,add_value :std_logic_vector(15 downto 0);

begin
cin<='0';
add_value(15 downto 2)<=(OTHERS => '0');
add_value(1)<='1';add_value(0)<='0';
u1: generic_nadder generic map (16) port map (pc_in,add_value,cin,pc_out,cout);

end a_pc_inc;
