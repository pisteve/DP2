--Byte comparison
--data_in a byte of data being checked with a byte of signature


library IEEE;
use IEEE.std_logic_1164.all;

entity byte_compare is
	PORT(
		data_in : IN std_logic_vector(7 downto 0);
		sig_in: IN std_logic_vector(7 downto 0);          
		is_valid : OUT std_logic
		);
end byte_compare;

architecture Behavioral of byte_compare is
Begin

process(data_in, sig_in)
	begin  
		if (data_in = sig_in ) then  
				is_valid <= '1';
			else  
				is_valid <= '0';
		end if;
end process;
END Behavioral;