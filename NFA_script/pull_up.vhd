Library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pull_up is
	port(
		clk: in std_logic;
		reset: in std_logic;
		isMatching_0: in std_logic;
		isMatching_1: in std_logic;
		isMatching_2: in std_logic;
		isMatching_3: in std_logic;
		pull_up_0: out std_logic;
		pull_up_1: out std_logic;
		pull_up_2: out std_logic;
		pull_up_3 : out std_logic
	);
end pull_up;

architecture behavioral of pull_up is

component pull_up_module	port(
		clk :  std_logic;
		reset :  std_logic;
		isMatching : in std_logic;
		out_isMatching : out std_logic);
end component;

component FF	port(
		clk : in std_logic;
		reset : in std_logic;
		input : in std_logic;
		output : out std_logic
);
end component;

signal hold_0: std_logic;
signal hold_1: std_logic;
signal hold_2: std_logic;
signal hold_3: std_logic;
signal release_0: std_logic;
signal release_1: std_logic;
signal release_2: std_logic;
signal release_3: std_logic;
begin
	pull_0: pull_up_module port map(clk => clk, reset => reset, isMatching => isMatching_0 out_isMatching => hold_0);
	pull_1: pull_up_module port map(clk => clk, reset => reset, isMatching => isMatching_1 out_isMatching => hold_1);
	pull_2: pull_up_module port map(clk => clk, reset => reset, isMatching => isMatching_2 out_isMatching => hold_2);
	pull_3: pull_up_module port map(clk => clk, reset => reset, isMatching => isMatching_3 out_isMatching => hold_3);
	FF_out_0: FF port map(clk => clk, reset => reset, input => release_0 output => pull_up_0);
	FF_out_1: FF port map(clk => clk, reset => reset, input => release_1 output => pull_up_1);
	FF_out_2: FF port map(clk => clk, reset => reset, input => release_2 output => pull_up_2);
	FF_out_3: FF port map(clk => clk, reset => reset, input => release_3 output => pull_up_3);
	release_0 <= hold_0;
	release_1 <= hold_1;
	release_2 <= hold_2;
	release_3 <= hold_3;
end behavioral;
