----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2017 11:30:17 PM
-- Design Name: 
-- Module Name: on_off - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity on_off is
  Port (
    switch : in std_logic;
    output : out std_logic
   );
end on_off;

architecture Behavioral of on_off is
begin
    process(switch)
    begin
    if(switch = '1') then
        output<='1';
     else
        output<='0';
     end if;
    end process;

end Behavioral;
