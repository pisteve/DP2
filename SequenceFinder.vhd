----------------------------------------------------------------------------------
-- Create Date:    00:39:22 02/28/2017 
-- Designer: 	 Zhirong Chen
-- Module Name:    SequenceFinder - SF 
-- Project Name:   NYU Tandon School of Engineering - Computer Engineering Senior Design Project
-- Target Devices: NEXYS 4 DDR Artix-7
-- Description: This module checks for a user defined sequence.
-- Revision: 
	-- Revision 0.01 @ 04:47 03/14/2017 - Module completed with minimal testing and no optimization.
	-- Revision 0.02 @ 05:22 03/15/2017 - Removed User_Sequence_Length requirement, and corect output generated 2 clock cycles after the last data entry. 
	--												  Module completed with minimal testing and no optimization. 
-- Instructions: 
	-- (1) User_Sequence must be provided prior to Reset
	-- (2) Reset must be applied prior to User_Data entry
	-- (3) Sequence_Found indicates whether the target sequence is detected; 1 = Detected, 0 = Not Found. 
	-- (4) User must apply Reset for every new sequence detection!
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SequenceFinder is
port(clk : in std_logic;
	  Reset : in std_logic;
	  User_Data : in std_logic_vector(7 downto 0); --Assumed to be arrive at every clock period
	  User_Sequence : in std_logic_vector(63 downto 0); --Must be supplied prior to the start of sequence checking
	  Sequence_Found : out std_logic);
end SequenceFinder;

architecture SF of SequenceFinder is

signal Data : std_logic_vector(7 downto 0);
signal Sequence : std_logic_vector(63 downto 0);
signal Previous_Data : std_logic_vector(7 downto 0);
signal Mismatch_Occurred : std_logic;
signal End_Of_Sequence: std_logic;

begin
 
Data <= User_Data;

Process(clk, Reset) --Mismatch_Occurred Register
begin
	if(Reset = '1') then
		Mismatch_Occurred <= '0';
	elsif(clk = '1' and clk'event) then
		if(Mismatch_Occurred = '1') then --Special Case
			if(User_Sequence(55 downto 48) = "00000000") then --Handling Sequence that only has 1 byte of data, and check if it's the end of target sequence
				if(Data = User_Sequence(63 downto 56)) then
					Mismatch_Occurred <= '0';
				else
					Mismatch_Occurred <= '1';
				end if;
			else
				if((Previous_Data = User_Sequence(63 downto 56)) and (Data = User_Sequence(55 downto 48))) then 
					Mismatch_Occurred <= '0';
				else
					Mismatch_Occurred <= '1';
				end if;
			end if;
		else --Normal Case
			if(Sequence(63 downto 56) = "00000000") then --Check if it's the end of target sequence
				End_Of_Sequence <= '1';
			else
				End_Of_Sequence <= '0';
				if(Data = Sequence(63 downto 56)) then 
					Mismatch_Occurred <= '0'; 
				else
					Mismatch_Occurred <= '1'; 
				end if;
			end if;
		end if;
	end if;
end Process;

Process(clk, Reset) --Previous_Data Register
begin
	if(Reset = '1') then
		Previous_Data <= Previous_Data; -- Modified
	elsif(clk = '1' and clk'event) then
		if(Mismatch_Occurred = '1') then --Special Case
			if(User_Sequence(55 downto 48) = "00") then --Handling Sequence that only has 1 byte of data, and check if it's the end of target sequence
				if(Data = User_Sequence(63 downto 56)) then --For synthax integrity
					Previous_Data <= Previous_Data;  --For synthax integrity
				else  --For synthax integrity
					Previous_Data <= User_Data;  --For synthax integrity
				end if;  --For synthax integrity
			else
				if((Previous_Data = User_Sequence(63 downto 56)) and (Data = User_Sequence(55 downto 48))) then 
					Previous_Data <= Previous_Data;
				else
					Previous_Data <= User_Data;
				end if;
			end if;
		else --Normal Case
			if(Sequence(63 downto 56) = "00000000") then --Check if it's the end of target sequence
				End_Of_Sequence <= '1';
			else
				End_Of_Sequence <= '0';
				if(Data = Sequence(63 downto 56)) then 
					Previous_Data <= Previous_Data;
				else
					Previous_Data <= User_Data; 
				end if;
			end if;
		end if;
	end if;	
end Process;

Process(clk, Reset, Mismatch_Occurred) --Sequence Register
begin
	if(Reset = '1') then
		Sequence <= User_Sequence;
	elsif(clk = '1' and clk'event) then
		if(Mismatch_Occurred = '1') then --Special Case
			if(User_Sequence(55 downto 48) = "00000000") then --Handling Sequence that only has 1 byte of data, and check if it's the end of target sequence
				if(Data = User_Sequence(63 downto 56)) then
					Sequence <= Sequence(55 downto 0) & "00000000"; 
				else
					Sequence <= User_Sequence;
				end if;
			else
				if((Previous_Data = User_Sequence(63 downto 56)) and (Data = User_Sequence(55 downto 48))) then 
					Sequence <= User_Sequence(47 downto 0) & "0000000000000000";
				else
					Sequence <= User_Sequence;
				end if;
			end if;
		else --Normal Case
			if(Sequence(63 downto 56) = "00000000") then --Check if it's the end of target sequence
				End_Of_Sequence <= '1';
			else
				End_Of_Sequence <= '0';
				if(Data = Sequence(63 downto 56)) then 
					Sequence <= Sequence(55 downto 0) & "00000000"; 
				else
					Sequence <= User_Sequence;
				end if;
			end if;
		end if;
	end if;	
end Process;

Process(clk, Reset) --Sequence_Found Register
begin
	if(Reset = '1') then
		Sequence_Found <= '0';
	elsif(clk = '1' and clk'event) then
		if(End_Of_Sequence = '1') then
			Sequence_Found <= '1';
		else
			Sequence_Found <= '0';
		end if;
	end if;
end Process;

end SF;