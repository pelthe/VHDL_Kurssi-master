----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2019 14:18:53
-- Design Name: 
-- Module Name: Register_8 - RTL
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

entity Register_8 is
  Port (
    clk, n_reset, load : IN std_logic;
    dataIn : IN std_logic_vector(7 downto 0);
    dataOut : OUT std_logic_vector(7 downto 0) );
end Register_8;

architecture RTL of Register_8 is

    signal D : std_logic_vector(7 downto 0);
    signal Q : std_logic_vector(7 downto 0);

begin
   
   D <= dataIn;
   
    process (clk, n_reset) begin
        
--    if n_reset = '0' then
--            Q <= B"1000_0000";
        
        if (clk'event AND clk = '1') then

            if (load = '1') then
                Q <= dataIn;
            end if;
        
        end if;
--    end if;
    
    end process; 

    dataOut <= Q;

end RTL;