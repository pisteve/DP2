--Flip flop
--Reset is 1, output is 0
--When rising edge clock, output = input


Library IEEE;
use IEEE.std_logic_1164.all;


Entity FF is
    port(
        clk: in std_logic;
        reset: in std_logic;
        input: in std_logic;
        output: out std_logic
    );
end FF;

architecture behavioral of FF is
begin

process (clk, reset)
begin
    if reset = '1' then
        output <= '0';
    elsif(rising_edge(clk)) then
        output <= input;
    end if;

end process;
end behavioral;

