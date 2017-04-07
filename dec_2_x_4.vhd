LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity dec_2_x_4 is
    Port ( s  : in  STD_LOGIC_VECTOR (1 downto 0);  
           out_dec  : out STD_LOGIC_VECTOR (3 downto 0);
           en : in  STD_LOGIC );
end dec_2_x_4;




architecture a_dec_2_x_4 of dec_2_x_4 is
begin
process (s, en)
begin
    out_dec <= (others => '0');        -- default output value
    if (en = '1') then  -- active high enable pin
        case s is
            when "00" => out_dec(0) <= '1';
            when "01" => out_dec(1) <= '1';
            when "10" => out_dec(2) <= '1';
            when "11" => out_dec(3) <= '1';
           
            when others => out_dec <= (others => '0');
        end case;
    end if;
end process;
end a_dec_2_x_4;
