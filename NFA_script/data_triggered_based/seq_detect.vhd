Library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity detector is
	port(
		reset: in std_logic;
		data_in: in std_logic_vector(7 downto 0);
		output_0 : out std_logic;
		output_1 : out std_logic;
		output_2 : out std_logic;
		output_3 : out std_logic;
		output_4 : out std_logic
	);
end detector;

architecture behavioral of detector is

component byte_compare	port(
		reset : std_logic;
		enable :  std_logic;
		data_in : in std_logic_vector(7 downto 0);
		sig_in : in std_logic_vector(7 downto 0);
		is_valid : out std_logic
);
end component;

component pull_up_module
	port(
		enable :  std_logic;
		reset :  std_logic;
		isMatching : in std_logic;
		out_isMatching : out std_logic
);
end component;

signal enable: std_logic;
signal input : std_logic_vector(7 downto 0);
-- at
signal en_and_cmp_s0_0: std_logic;
signal cmp_s0_0x61_0: std_logic;	--a
signal en_and_cmp_s0_1: std_logic;
signal cmp_s0_0x74_1: std_logic;	--t
signal out_s0: std_logic := '0';

-- bat
signal en_and_cmp_s1_0: std_logic;
signal cmp_s1_0x62_0: std_logic;	--b
signal en_and_cmp_s1_1: std_logic;
signal cmp_s1_0x61_1: std_logic;	--a
signal en_and_cmp_s1_2: std_logic;
signal cmp_s1_0x74_2: std_logic;	--t
signal out_s1: std_logic := '0';

-- cat
signal en_and_cmp_s2_0: std_logic;
signal cmp_s2_0x63_0: std_logic;	--c
signal en_and_cmp_s2_1: std_logic;
signal cmp_s2_0x61_1: std_logic;	--a
signal en_and_cmp_s2_2: std_logic;
signal cmp_s2_0x74_2: std_logic;	--t
signal out_s2: std_logic := '0';

-- cater
signal en_and_cmp_s3_0: std_logic;
signal cmp_s3_0x63_0: std_logic;	--c
signal en_and_cmp_s3_1: std_logic;
signal cmp_s3_0x61_1: std_logic;	--a
signal en_and_cmp_s3_2: std_logic;
signal cmp_s3_0x74_2: std_logic;	--t
signal en_and_cmp_s3_3: std_logic;
signal cmp_s3_0x65_3: std_logic;	--e
signal en_and_cmp_s3_4: std_logic;
signal cmp_s3_0x72_4: std_logic;	--r
signal out_s3: std_logic := '0';

-- ter
signal en_and_cmp_s4_0: std_logic;
signal cmp_s4_0x74_0: std_logic;	--t
signal en_and_cmp_s4_1: std_logic;
signal cmp_s4_0x65_1: std_logic;	--e
signal en_and_cmp_s4_2: std_logic;
signal cmp_s4_0x72_2: std_logic;	--r
signal out_s4: std_logic := '0';

signal isMatching_0: std_logic;
signal isMatching_1: std_logic;
signal isMatching_2: std_logic;
signal isMatching_3: std_logic;
signal isMatching_4: std_logic;

begin
	with data_in select 
	enable <=
		'0' when "00000000",
		'1' when others;

	input <= data_in;
	byte_comp_s0_61_0: byte_compare port map(reset => reset, enable => enable, data_in => input, sig_in => x"61" , is_valid => cmp_s0_0x61_0);
	and_s0_0: en_and_cmp_s0_0<= enable and cmp_s0_0x61_0;
	byte_comp_s0_74_1: byte_compare port map(reset => reset, enable => en_and_cmp_s0_0, data_in => input, sig_in => x"74", is_valid => cmp_s0_0x74_1);
	and_s0_1: en_and_cmp_s0_1<= enable and cmp_s0_0x74_1;
	
with reset select
	isMatching_0 <=
	cmp_s0_0x74_1 when '0',
	'0' when others;

	byte_comp_s1_62_0: byte_compare port map(reset => reset, enable => enable, data_in => input, sig_in => x"62" , is_valid => cmp_s1_0x62_0);
	and_s1_0: en_and_cmp_s1_0<= enable and cmp_s1_0x62_0;
	byte_comp_s1_61_1: byte_compare port map(reset => reset, enable => en_and_cmp_s1_0, data_in => input, sig_in => x"61", is_valid => cmp_s1_0x61_1);
	and_s1_1: en_and_cmp_s1_1<= enable and cmp_s1_0x61_1;
	byte_comp_s1_74_2: byte_compare port map(reset => reset, enable => en_and_cmp_s1_1, data_in => input, sig_in => x"74", is_valid => cmp_s1_0x74_2);
	and_s1_2: en_and_cmp_s1_2<= enable and cmp_s1_0x74_2;
	
with reset select
	isMatching_1 <=
	cmp_s1_0x74_2 when '0',
	'0' when others;

	byte_comp_s2_63_0: byte_compare port map(reset => reset, enable => enable, data_in => input, sig_in => x"63" , is_valid => cmp_s2_0x63_0);
	and_s2_0: en_and_cmp_s2_0<= enable and cmp_s2_0x63_0;
	byte_comp_s2_61_1: byte_compare port map(reset => reset, enable => en_and_cmp_s2_0, data_in => input, sig_in => x"61", is_valid => cmp_s2_0x61_1);
	and_s2_1: en_and_cmp_s2_1<= enable and cmp_s2_0x61_1;
	byte_comp_s2_74_2: byte_compare port map(reset => reset, enable => en_and_cmp_s2_1, data_in => input, sig_in => x"74", is_valid => cmp_s2_0x74_2);
	and_s2_2: en_and_cmp_s2_2<= enable and cmp_s2_0x74_2;
	
with reset select
	isMatching_2 <=
	cmp_s2_0x74_2 when '0',
	'0' when others;

	byte_comp_s3_63_0: byte_compare port map(reset => reset, enable => enable, data_in => input, sig_in => x"63" , is_valid => cmp_s3_0x63_0);
	and_s3_0: en_and_cmp_s3_0<= enable and cmp_s3_0x63_0;
	byte_comp_s3_61_1: byte_compare port map(reset => reset, enable => en_and_cmp_s3_0, data_in => input, sig_in => x"61", is_valid => cmp_s3_0x61_1);
	and_s3_1: en_and_cmp_s3_1<= enable and cmp_s3_0x61_1;
	byte_comp_s3_74_2: byte_compare port map(reset => reset, enable => en_and_cmp_s3_1, data_in => input, sig_in => x"74", is_valid => cmp_s3_0x74_2);
	and_s3_2: en_and_cmp_s3_2<= enable and cmp_s3_0x74_2;
	byte_comp_s3_65_3: byte_compare port map(reset => reset, enable => en_and_cmp_s3_2, data_in => input, sig_in => x"65", is_valid => cmp_s3_0x65_3);
	and_s3_3: en_and_cmp_s3_3<= enable and cmp_s3_0x65_3;
	byte_comp_s3_72_4: byte_compare port map(reset => reset, enable => en_and_cmp_s3_3, data_in => input, sig_in => x"72", is_valid => cmp_s3_0x72_4);
	and_s3_4: en_and_cmp_s3_4<= enable and cmp_s3_0x72_4;
	
with reset select
	isMatching_3 <=
	cmp_s3_0x72_4 when '0',
	'0' when others;

	byte_comp_s4_74_0: byte_compare port map(reset => reset, enable => enable, data_in => input, sig_in => x"74" , is_valid => cmp_s4_0x74_0);
	and_s4_0: en_and_cmp_s4_0<= enable and cmp_s4_0x74_0;
	byte_comp_s4_65_1: byte_compare port map(reset => reset, enable => en_and_cmp_s4_0, data_in => input, sig_in => x"65", is_valid => cmp_s4_0x65_1);
	and_s4_1: en_and_cmp_s4_1<= enable and cmp_s4_0x65_1;
	byte_comp_s4_72_2: byte_compare port map(reset => reset, enable => en_and_cmp_s4_1, data_in => input, sig_in => x"72", is_valid => cmp_s4_0x72_2);
	and_s4_2: en_and_cmp_s4_2<= enable and cmp_s4_0x72_2;
	
with reset select
	isMatching_4 <=
	cmp_s4_0x72_2 when '0',
	'0' when others;

	pull_0: pull_up_module port map(enable => enable, reset => reset, isMatching => isMatching_0, out_isMatching => output_0);
	pull_1: pull_up_module port map(enable => enable, reset => reset, isMatching => isMatching_1, out_isMatching => output_1);
	pull_2: pull_up_module port map(enable => enable, reset => reset, isMatching => isMatching_2, out_isMatching => output_2);
	pull_3: pull_up_module port map(enable => enable, reset => reset, isMatching => isMatching_3, out_isMatching => output_3);
	pull_4: pull_up_module port map(enable => enable, reset => reset, isMatching => isMatching_4, out_isMatching => output_4);
end behavioral;
