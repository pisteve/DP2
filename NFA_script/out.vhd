Library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity detector is
	port(
		clk: in std_logic;
		reset: in std_logic;
		data_in: in std_logic_vector(7 downto 0);
		output_0 : out std_logic;
		output_1 : out std_logic;
		output_2 : out std_logic;
		output_3 : out std_logic
	);
end detector;

architecture behavioral of detector is

component byte_compare	port(
		data_in : in std_logic_vector(7 downto 0);
		sig_in : in std_logic_vector(7 downto 0);
		is_valid : out std_logic
);
end component;

component FF	port(
		clk : in std_logic;
		reset : in std_logic;
		input : in std_logic;
		output : out std_logic
);
end component;

signal input : std_logic_vector(7 downto 0);
-- jay
signal cmp_s0_0x6a_0: std_logic;	--j
signal s0_ff_0: std_logic := '0';
signal out_and_s0_ff_0: std_logic := '0';

signal cmp_s0_0x61_1: std_logic;	--a
signal s0_ff_1: std_logic := '0';
signal out_and_s0_ff_1: std_logic := '0';

signal cmp_s0_0x79_2: std_logic;	--y
signal s0_ff_2: std_logic := '0';
signal out_and_s0_ff_2: std_logic := '0';


-- karri
signal cmp_s1_0x6b_0: std_logic;	--k
signal s1_ff_0: std_logic := '0';
signal out_and_s1_ff_0: std_logic := '0';

signal cmp_s1_0x61_1: std_logic;	--a
signal s1_ff_1: std_logic := '0';
signal out_and_s1_ff_1: std_logic := '0';

signal cmp_s1_0x72_2: std_logic;	--r
signal s1_ff_2: std_logic := '0';
signal out_and_s1_ff_2: std_logic := '0';

signal cmp_s1_0x72_3: std_logic;	--r
signal s1_ff_3: std_logic := '0';
signal out_and_s1_ff_3: std_logic := '0';

signal cmp_s1_0x69_4: std_logic;	--i
signal s1_ff_4: std_logic := '0';
signal out_and_s1_ff_4: std_logic := '0';


-- steven
signal cmp_s2_0x73_0: std_logic;	--s
signal s2_ff_0: std_logic := '0';
signal out_and_s2_ff_0: std_logic := '0';

signal cmp_s2_0x74_1: std_logic;	--t
signal s2_ff_1: std_logic := '0';
signal out_and_s2_ff_1: std_logic := '0';

signal cmp_s2_0x65_2: std_logic;	--e
signal s2_ff_2: std_logic := '0';
signal out_and_s2_ff_2: std_logic := '0';

signal cmp_s2_0x76_3: std_logic;	--v
signal s2_ff_3: std_logic := '0';
signal out_and_s2_ff_3: std_logic := '0';

signal cmp_s2_0x65_4: std_logic;	--e
signal s2_ff_4: std_logic := '0';
signal out_and_s2_ff_4: std_logic := '0';

signal cmp_s2_0x6e_5: std_logic;	--n
signal s2_ff_5: std_logic := '0';
signal out_and_s2_ff_5: std_logic := '0';


-- zhirong
signal cmp_s3_0x7a_0: std_logic;	--z
signal s3_ff_0: std_logic := '0';
signal out_and_s3_ff_0: std_logic := '0';

signal cmp_s3_0x68_1: std_logic;	--h
signal s3_ff_1: std_logic := '0';
signal out_and_s3_ff_1: std_logic := '0';

signal cmp_s3_0x69_2: std_logic;	--i
signal s3_ff_2: std_logic := '0';
signal out_and_s3_ff_2: std_logic := '0';

signal cmp_s3_0x72_3: std_logic;	--r
signal s3_ff_3: std_logic := '0';
signal out_and_s3_ff_3: std_logic := '0';

signal cmp_s3_0x6f_4: std_logic;	--o
signal s3_ff_4: std_logic := '0';
signal out_and_s3_ff_4: std_logic := '0';

signal cmp_s3_0x6e_5: std_logic;	--n
signal s3_ff_5: std_logic := '0';
signal out_and_s3_ff_5: std_logic := '0';

signal cmp_s3_0x67_6: std_logic;	--g
signal s3_ff_6: std_logic := '0';
signal out_and_s3_ff_6: std_logic := '0';


begin
	input <= data_in;
	byte_comp_s0_6a_0: byte_compare port map( data_in => input, sig_in => x"6a" , is_valid => cmp_s0_0x6a_0);
	flipflop_s0_f0: FF port map( clk => clk, reset => reset, input => '1', output =>s0_ff_0);
	and_s0_ff_0: out_and_s0_ff_0 <= s0_ff_0 and cmp_s0_0x6a_0;
	byte_comp_s0_61_1: byte_compare port map( data_in => input, sig_in => x"61" , is_valid => cmp_s0_0x61_1);
	flipflop_s0_f1: FF port map( clk => clk, reset => reset, input => out_and_s0_ff_0, output => s0_ff_1);
	and_s0_ff_1: out_and_s0_ff_1 <= s0_ff_1 and cmp_s0_0x61_1;
	byte_comp_s0_79_2: byte_compare port map( data_in => input, sig_in => x"79" , is_valid => cmp_s0_0x79_2);
	flipflop_s0_f2: FF port map( clk => clk, reset => reset, input => out_and_s0_ff_1, output => s0_ff_2);
	and_s0_ff_2: out_and_s0_ff_2 <= s0_ff_2 and cmp_s0_0x79_2;
output_0 <= out_and_s0_ff_2;

	byte_comp_s1_6b_0: byte_compare port map( data_in => input, sig_in => x"6b" , is_valid => cmp_s1_0x6b_0);
	flipflop_s1_f0: FF port map( clk => clk, reset => reset, input => '1', output =>s1_ff_0);
	and_s1_ff_0: out_and_s1_ff_0 <= s1_ff_0 and cmp_s1_0x6b_0;
	byte_comp_s1_61_1: byte_compare port map( data_in => input, sig_in => x"61" , is_valid => cmp_s1_0x61_1);
	flipflop_s1_f1: FF port map( clk => clk, reset => reset, input => out_and_s1_ff_0, output => s1_ff_1);
	and_s1_ff_1: out_and_s1_ff_1 <= s1_ff_1 and cmp_s1_0x61_1;
	byte_comp_s1_72_2: byte_compare port map( data_in => input, sig_in => x"72" , is_valid => cmp_s1_0x72_2);
	flipflop_s1_f2: FF port map( clk => clk, reset => reset, input => out_and_s1_ff_1, output => s1_ff_2);
	and_s1_ff_2: out_and_s1_ff_2 <= s1_ff_2 and cmp_s1_0x72_2;
	byte_comp_s1_72_3: byte_compare port map( data_in => input, sig_in => x"72" , is_valid => cmp_s1_0x72_3);
	flipflop_s1_f3: FF port map( clk => clk, reset => reset, input => out_and_s1_ff_2, output => s1_ff_3);
	and_s1_ff_3: out_and_s1_ff_3 <= s1_ff_3 and cmp_s1_0x72_3;
	byte_comp_s1_69_4: byte_compare port map( data_in => input, sig_in => x"69" , is_valid => cmp_s1_0x69_4);
	flipflop_s1_f4: FF port map( clk => clk, reset => reset, input => out_and_s1_ff_3, output => s1_ff_4);
	and_s1_ff_4: out_and_s1_ff_4 <= s1_ff_4 and cmp_s1_0x69_4;
output_1 <= out_and_s1_ff_4;

	byte_comp_s2_73_0: byte_compare port map( data_in => input, sig_in => x"73" , is_valid => cmp_s2_0x73_0);
	flipflop_s2_f0: FF port map( clk => clk, reset => reset, input => '1', output =>s2_ff_0);
	and_s2_ff_0: out_and_s2_ff_0 <= s2_ff_0 and cmp_s2_0x73_0;
	byte_comp_s2_74_1: byte_compare port map( data_in => input, sig_in => x"74" , is_valid => cmp_s2_0x74_1);
	flipflop_s2_f1: FF port map( clk => clk, reset => reset, input => out_and_s2_ff_0, output => s2_ff_1);
	and_s2_ff_1: out_and_s2_ff_1 <= s2_ff_1 and cmp_s2_0x74_1;
	byte_comp_s2_65_2: byte_compare port map( data_in => input, sig_in => x"65" , is_valid => cmp_s2_0x65_2);
	flipflop_s2_f2: FF port map( clk => clk, reset => reset, input => out_and_s2_ff_1, output => s2_ff_2);
	and_s2_ff_2: out_and_s2_ff_2 <= s2_ff_2 and cmp_s2_0x65_2;
	byte_comp_s2_76_3: byte_compare port map( data_in => input, sig_in => x"76" , is_valid => cmp_s2_0x76_3);
	flipflop_s2_f3: FF port map( clk => clk, reset => reset, input => out_and_s2_ff_2, output => s2_ff_3);
	and_s2_ff_3: out_and_s2_ff_3 <= s2_ff_3 and cmp_s2_0x76_3;
	byte_comp_s2_65_4: byte_compare port map( data_in => input, sig_in => x"65" , is_valid => cmp_s2_0x65_4);
	flipflop_s2_f4: FF port map( clk => clk, reset => reset, input => out_and_s2_ff_3, output => s2_ff_4);
	and_s2_ff_4: out_and_s2_ff_4 <= s2_ff_4 and cmp_s2_0x65_4;
	byte_comp_s2_6e_5: byte_compare port map( data_in => input, sig_in => x"6e" , is_valid => cmp_s2_0x6e_5);
	flipflop_s2_f5: FF port map( clk => clk, reset => reset, input => out_and_s2_ff_4, output => s2_ff_5);
	and_s2_ff_5: out_and_s2_ff_5 <= s2_ff_5 and cmp_s2_0x6e_5;
output_2 <= out_and_s2_ff_5;

	byte_comp_s3_7a_0: byte_compare port map( data_in => input, sig_in => x"7a" , is_valid => cmp_s3_0x7a_0);
	flipflop_s3_f0: FF port map( clk => clk, reset => reset, input => '1', output =>s3_ff_0);
	and_s3_ff_0: out_and_s3_ff_0 <= s3_ff_0 and cmp_s3_0x7a_0;
	byte_comp_s3_68_1: byte_compare port map( data_in => input, sig_in => x"68" , is_valid => cmp_s3_0x68_1);
	flipflop_s3_f1: FF port map( clk => clk, reset => reset, input => out_and_s3_ff_0, output => s3_ff_1);
	and_s3_ff_1: out_and_s3_ff_1 <= s3_ff_1 and cmp_s3_0x68_1;
	byte_comp_s3_69_2: byte_compare port map( data_in => input, sig_in => x"69" , is_valid => cmp_s3_0x69_2);
	flipflop_s3_f2: FF port map( clk => clk, reset => reset, input => out_and_s3_ff_1, output => s3_ff_2);
	and_s3_ff_2: out_and_s3_ff_2 <= s3_ff_2 and cmp_s3_0x69_2;
	byte_comp_s3_72_3: byte_compare port map( data_in => input, sig_in => x"72" , is_valid => cmp_s3_0x72_3);
	flipflop_s3_f3: FF port map( clk => clk, reset => reset, input => out_and_s3_ff_2, output => s3_ff_3);
	and_s3_ff_3: out_and_s3_ff_3 <= s3_ff_3 and cmp_s3_0x72_3;
	byte_comp_s3_6f_4: byte_compare port map( data_in => input, sig_in => x"6f" , is_valid => cmp_s3_0x6f_4);
	flipflop_s3_f4: FF port map( clk => clk, reset => reset, input => out_and_s3_ff_3, output => s3_ff_4);
	and_s3_ff_4: out_and_s3_ff_4 <= s3_ff_4 and cmp_s3_0x6f_4;
	byte_comp_s3_6e_5: byte_compare port map( data_in => input, sig_in => x"6e" , is_valid => cmp_s3_0x6e_5);
	flipflop_s3_f5: FF port map( clk => clk, reset => reset, input => out_and_s3_ff_4, output => s3_ff_5);
	and_s3_ff_5: out_and_s3_ff_5 <= s3_ff_5 and cmp_s3_0x6e_5;
	byte_comp_s3_67_6: byte_compare port map( data_in => input, sig_in => x"67" , is_valid => cmp_s3_0x67_6);
	flipflop_s3_f6: FF port map( clk => clk, reset => reset, input => out_and_s3_ff_5, output => s3_ff_6);
	and_s3_ff_6: out_and_s3_ff_6 <= s3_ff_6 and cmp_s3_0x67_6;
output_3 <= out_and_s3_ff_6;

end behavioral;
