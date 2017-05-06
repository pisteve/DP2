library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pull_up_module is
port (
        clk: in std_logic;
        reset: in std_logic;
        isMatching: in std_logic;
        out_isMatching: out std_logic
	 );  
end pull_up_module;

architecture behavioral of pull_up_module is
begin

    process(clk, reset, isMatching)
    begin  
        if(reset = '1') then    
            out_isMatching <= '0';
        elsif (rising_edge(clk)) then
            if (isMatching = '1') then
                out_isMatching <= '1';
            end if;
        end if;
    end process;
end behavioral;