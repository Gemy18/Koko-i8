LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
-- n-bit adder
ENTITY generic_nadder IS 
	GENERIC (n : integer := 16);
	PORT(a,b  : IN std_logic_vector(n-1  DOWNTO 0);
             cin  : IN std_logic;  
             s    : OUT std_logic_vector(n-1 DOWNTO 0);    
             cout : OUT std_logic);
END generic_nadder;

ARCHITECTURE a_my_nadder OF generic_nadder IS
      COMPONENT full_adder IS
              PORT( a,b,cin : IN std_logic; 
                    s,cout  : OUT std_logic);
        END COMPONENT;
SIGNAL temp : std_logic_vector(n-1 DOWNTO 0);

BEGIN
loop1: FOR i IN 0 TO n-1 GENERATE
        g0: IF i = 0 GENERATE
                f0: full_adder PORT MAP (a(i) ,b(i), cin, s(i), temp(i));
         END GENERATE g0;
         gx: IF i > 0 GENERATE
                fx: full_adder PORT MAP  (a(i), b(i), temp(i-1), s(i), temp(i));
          END GENERATE gx;
    END GENERATE;
    cout <= temp(n-1);
END a_my_nadder;