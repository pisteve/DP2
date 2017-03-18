----------------------------------------------------------------------------------
-- Create Date:    17:29:37 03/15/2017 
-- Designer: 	 Zhirong Chen
-- Module Name:    SequenceFinderController - SFC 
-- Project Name:   NYU Tandon School of Engineering - Computer Engineering Senior Design Project
-- Target Devices: NEXYS 4 DDR Artix-7
-- Description: This controll data flows for sequence finder
-- Revision: 
	-- Revision 0.01 @ 05:00 03/17/2017 - Module completed with minimal testing and no optimization.	
-- Instructions: 
	-- (1) Connect SFC_clk to the system clk
	-- (2) Make sure the switch for SFC_Mode is set to 0 initially
	-- (3) Load data into SFC_Register_Zero and SFC_Register_One simultaneously
	-- (4) Set the switch for SFC_Mode to 1
	-- (5) Only load data into SFC_Register_Zero, and make sure the 1-byte data is on the left-most (most significant bits) and fill the remaining 24 bits with zeros
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SequenceFinderController is
Port(SFC_clk : in std_logic;
	  SFC_Register_Zero : in std_logic_vector(31 downto 0);
	  SFC_Register_One : in std_logic_vector(31 downto 0);
	  SFC_Mode : in std_logic; --SFC_Mode = 0 means Target Sequence Mode; SFC_Mode = 1 means Data Mode 
	  SFC_Sequence_Found : out std_logic
	  );

end SequenceFinderController;

architecture SFC of SequenceFinderController is

COMPONENT SequenceFinder
PORT(
	SF_clk : IN std_logic;
	SF_Reset : IN std_logic;
	SF_User_Data : IN std_logic_vector(7 downto 0);
	SF_User_Sequence : IN std_logic_vector(63 downto 0);          
	SF_Sequence_Found : OUT std_logic
	);
END COMPONENT;

signal SFC_User_Data : std_logic_vector(7 downto 0);
signal SFC_User_Sequence : std_logic_vector(63 downto 0);
signal SFC_Reset : std_logic;

begin

Inst_SequenceFinder: SequenceFinder PORT MAP(
	SF_clk => SFC_clk,
	SF_Reset => SFC_Reset,
	SF_User_Data => SFC_User_Data,
	SF_User_Sequence => SFC_User_Sequence,
	SF_Sequence_Found => SFC_Sequence_Found
);

Process(SFC_Register_Zero)
begin
	if(SFC_Mode = '0') then
		SFC_User_Sequence(63 downto 32) <= SFC_Register_Zero;	
	else
		SFC_User_Data <= SFC_Register_Zero(31 downto 24);
	end if;
end Process;

Process(SFC_Register_One)
begin
	if(SFC_Mode = '0') then
		SFC_User_Sequence(31 downto 0) <= SFC_Register_One;	
	end if;
end Process;

Process(SFC_Mode)
begin
	if(SFC_Mode = '0') then
		SFC_Reset <= '1';
	else
		SFC_Reset <= '0';
	end if;
end Process;

end SFC;

