LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity dec_5_x_32 is
    Port ( s  : in  STD_LOGIC_VECTOR (4 downto 0);  
           out_dec  : out STD_LOGIC_VECTOR (31 downto 0);
           en : in  STD_LOGIC );
end dec_5_x_32;




architecture a_dec_5_x_32 of dec_5_x_32 is
begin
process (s, en)
begin
    out_dec <= (others => '0');        -- default output value
    if (en = '1') then  -- active high enable pin
        case s is
            when "00000" => out_dec(0) <= '1';
			when "00001" => out_dec(1) <= '1';
			when "00010" => out_dec(2) <= '1';
			when "00011" => out_dec(3) <= '1';
			when "00100" => out_dec(4) <= '1';
			when "00101" => out_dec(5) <= '1';
			when "00110" => out_dec(6) <= '1';
			when "00111" => out_dec(7) <= '1';
			when "01000" => out_dec(8) <= '1';
			when "01001" => out_dec(9) <= '1';
			when "01010" => out_dec(10) <= '1';
			when "01011" => out_dec(11) <= '1';
			when "01100" => out_dec(12) <= '1';
			when "01101" => out_dec(13) <= '1';
			when "01110" => out_dec(14) <= '1';
			when "01111" => out_dec(15) <= '1';
			when "10000" => out_dec(16) <= '1';
			when "10001" => out_dec(17) <= '1';
			when "10010" => out_dec(18) <= '1';
			when "10011" => out_dec(19) <= '1';
			when "10100" => out_dec(20) <= '1';
			when "10101" => out_dec(21) <= '1';
			when "10110" => out_dec(22) <= '1';
			when "10111" => out_dec(23) <= '1';
			when "11000" => out_dec(24) <= '1';
			when "11001" => out_dec(25) <= '1';
			when "11010" => out_dec(26) <= '1';
			when "11011" => out_dec(27) <= '1';
			when "11100" => out_dec(28) <= '1';
			when "11101" => out_dec(29) <= '1';
			when "11110" => out_dec(30) <= '1';
			when "11111" => out_dec(31) <= '1';
            when others => out_dec <= (others => '0');
        end case;
    end if;
end process;
end a_dec_5_x_32;