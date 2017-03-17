----------------------------------------------------------------------------------
-- Create Date:    00:39:22 02/28/2017 
-- Designer: 	 Zhirong Chen
-- Module Name:    SequenceFinder - SF 
-- Project Name:   NYU Tandon School of Engineering - Computer Engineering Senior Design Project
-- Target Devices: NEXYS 4 DDR Artix-7
-- Description: This module checks for a user defined sequence.
-- Revision: 
	-- Revision 0.01 @ 04:47PM 03/14/2017 - Module completed with minimal testing and no optimization.
	-- Revision 0.02 @ 05:22PM 03/15/2017 - Removed SF_User_Sequence_Length requirement, and correct output generated 2 clock cycles after the last SF_User_Data entry. 
	--												    Module completed with minimal testing and no optimization. 
	-- Revision 0.03 @ 02:35PM 03/17/2017 - Slightly optimized, and removed some redundant signals. 
-- Instructions: 
	-- ***Asssume the SF_User_Sequence (Target Sequence) to be a valid sequence, meaning that it must be character(s) between ASCII Hex values 20 to 126, inclusively. 
	-- (1) SF_User_Sequence must be provided prior to SF_Reset
	-- (2) SF_Reset must be applied prior to SF_User_Data entry
	-- (3) SF_Sequence_Found indicates whether the target sequence is detected; 1 = Detected, 0 = Not Found. 
	-- (4) User must apply SF_Reset for every new sequence detection!
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SequenceFinder is
port(SF_clk : in std_logic;
	  SF_Reset : in std_logic;
	  SF_User_Data : in std_logic_vector(7 downto 0); 
	  SF_User_Sequence : in std_logic_vector(63 downto 0); 
	  SF_Sequence_Found : out std_logic);
end SequenceFinder;

architecture SF of SequenceFinder is

signal Sequence : std_logic_vector(63 downto 0);
signal Previous_Data : std_logic_vector(7 downto 0);
signal Mismatch_Occurred : std_logic;
signal End_Of_Sequence: std_logic;

begin

Process(SF_clk, SF_Reset) --Mismatch_Occurred Register
begin
	if(SF_Reset = '1') then
		Mismatch_Occurred <= '0';
	elsif(SF_clk = '1' and SF_clk'event) then
		if(Mismatch_Occurred = '1') then --Special Case
			if(SF_User_Sequence(55 downto 48) = "00000000") then --Handling Sequence that only has 1 byte of SF_User_Data, and check if it's the end of target sequence
				if(SF_User_Data = SF_User_Sequence(63 downto 56)) then
					Mismatch_Occurred <= '0';
				else
					Mismatch_Occurred <= '1';
				end if;
			else
				if((Previous_Data = SF_User_Sequence(63 downto 56)) and (SF_User_Data = SF_User_Sequence(55 downto 48))) then 
					Mismatch_Occurred <= '0';
				else
					Mismatch_Occurred <= '1';
				end if;
			end if;
		else --Normal Case
			if(SF_User_Data = Sequence(63 downto 56)) then 
				Mismatch_Occurred <= '0'; 
			else
				Mismatch_Occurred <= '1'; 
			end if;
		end if;
	end if;
end Process;

Process(SF_clk, SF_Reset) --End_Of_Sequence Register
begin
	if(SF_Reset = '1') then
		End_Of_Sequence <= '0';
	elsif(SF_clk = '1' and SF_clk'event) then
		if(Sequence(63 downto 56) = "00000000") then --Check if it's the end of target sequence
			End_Of_Sequence <= '1';
		else
			End_Of_Sequence <= '0';
		end if;
	end if;
end Process;

Process(SF_clk, SF_Reset) --Previous_Data Register
begin
	if(SF_Reset = '1') then
		Previous_Data <= (others => '0');
	elsif(SF_clk = '1' and SF_clk'event) then
		if(Mismatch_Occurred = '1') then --Special Case
			if(SF_User_Sequence(55 downto 48) = "00000000") then --Handling Sequence that only has 1 byte of SF_User_Data, and check if it's the end of target sequence
				if(SF_User_Data = SF_User_Sequence(63 downto 56)) then 
					Previous_Data <= Previous_Data;  
				else  
					Previous_Data <= SF_User_Data;  
				end if;  
			else
				if((Previous_Data = SF_User_Sequence(63 downto 56)) and (SF_User_Data = SF_User_Sequence(55 downto 48))) then 
					Previous_Data <= Previous_Data;
				else
					Previous_Data <= SF_User_Data;
				end if;
			end if;
		else --Normal Case
			if(SF_User_Data = Sequence(63 downto 56)) then 
				Previous_Data <= Previous_Data;
			else
				Previous_Data <= SF_User_Data; 
			end if;
		end if;
	end if;	
end Process;

Process(SF_clk, SF_Reset, Mismatch_Occurred) --Sequence Register
begin
	if(SF_Reset = '1') then
		Sequence <= SF_User_Sequence;
	elsif(SF_clk = '1' and SF_clk'event) then
		if(Mismatch_Occurred = '1') then --Special Case
			if(SF_User_Sequence(55 downto 48) = "00000000") then --Handling Sequence that only has 1 byte of SF_User_Data, and check if it's the end of target sequence
				if(SF_User_Data = SF_User_Sequence(63 downto 56)) then
					Sequence <= Sequence(55 downto 0) & "00000000"; 
				else
					Sequence <= SF_User_Sequence;
				end if;
			else
				if((Previous_Data = SF_User_Sequence(63 downto 56)) and (SF_User_Data = SF_User_Sequence(55 downto 48))) then 
					Sequence <= SF_User_Sequence(47 downto 0) & "0000000000000000";
				else
					Sequence <= SF_User_Sequence;
				end if;
			end if;
		else --Normal Case
			if(SF_User_Data = Sequence(63 downto 56)) then 
				Sequence <= Sequence(55 downto 0) & "00000000"; 
			else
				Sequence <= SF_User_Sequence;
			end if;
		end if;
	end if;	
end Process;

Process(SF_clk, SF_Reset) --SF_Sequence_Found Register
begin
	if(SF_Reset = '1') then
		SF_Sequence_Found <= '0';
	elsif(SF_clk = '1' and SF_clk'event) then
		if(End_Of_Sequence = '1') then
			SF_Sequence_Found <= '1';
		else
			SF_Sequence_Found <= '0';
		end if;
	end if;
end Process;

end SF;