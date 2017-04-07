LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity dec_3_x_8 is
    Port ( s  : in  STD_LOGIC_VECTOR (2 downto 0);  
           out_dec  : out STD_LOGIC_VECTOR (7 downto 0);
           en : in  STD_LOGIC );
end dec_3_x_8;




architecture a_dec_3_x_8 of dec_3_x_8 is
begin
process (s, en)
begin
    out_dec <= (others => '0');        -- default output value
    if (en = '1') then  -- active high enable pin
        case s is
            when "000" => out_dec(0) <= '1';
            when "001" => out_dec(1) <= '1';
            when "010" => out_dec(2) <= '1';
            when "011" => out_dec(3) <= '1';
            when "100" => out_dec(4) <= '1';
            when "101" => out_dec(5) <= '1';
            when "110" => out_dec(6) <= '1';
            when "111" => out_dec(7) <= '1';
            when others => out_dec <= (others => '0');
        end case;
    end if;
end process;
end a_dec_3_x_8;
