LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity dec_4_x_16 is
    Port ( s  : in  STD_LOGIC_VECTOR (3 downto 0);  
           out_dec  : out STD_LOGIC_VECTOR (15 downto 0);
           en : in  STD_LOGIC );
end dec_4_x_16;




architecture a_dec_4_x_16 of dec_4_x_16 is
begin
process (s, en)
begin
    out_dec <= (others => '0');        -- default output value
    if (en = '1') then  -- active high enable pin
        case s is
            when "0000" => out_dec(0) <= '1';
            when "0001" => out_dec(1) <= '1';
            when "0010" => out_dec(2) <= '1';
            when "0011" => out_dec(3) <= '1';
            when "0100" => out_dec(4) <= '1';
            when "0101" => out_dec(5) <= '1';
            when "0110" => out_dec(6) <= '1';
            when "0111" => out_dec(7) <= '1';
			when "1000" => out_dec(8) <= '1';
            when "1001" => out_dec(9) <= '1';
            when "1010" => out_dec(10) <= '1';
            when "1011" => out_dec(11) <= '1';
            when "1100" => out_dec(12) <= '1';
            when "1101" => out_dec(13) <= '1';
            when "1110" => out_dec(14) <= '1';
            when "1111" => out_dec(15) <= '1';

            when others => out_dec <= (others => '0');
        end case;
    end if;
end process;
end a_dec_4_x_16;