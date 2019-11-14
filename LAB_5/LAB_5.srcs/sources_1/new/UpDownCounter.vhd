library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity UpDownCounter is
    Port (
        counterClkIn, increase, decrease : IN std_logic;
        n_reset : IN std_logic;
        ctrlDataInput : IN std_logic_vector(7 downto 0);
        ctrlOutput : OUT std_logic_vector(7 downto 0) );
end UpDownCounter;

architecture RTL of UpDownCounter is

    signal tmpCtrlOutput : std_logic_vector(7 downto 0) := B"1000_0000";
    signal max : std_logic_vector(7 downto 0) := (others => '1');
    signal min : std_logic_vector(7 downto 0) := (others => '0');

begin

    tmpCtrlOutput <= ctrlDataInput;

    UpDownCounter : process (counterClkIn, n_reset) begin
    
        if n_reset = '0' then
            tmpCtrlOutput <= B"1000_0000";
            
        elsif (counterClkIn'event AND counterClkIn = '1') then
            if (increase = '1' AND tmpCtrlOutput < max) then
                tmpCtrlOutput <= tmpCtrlOutput + B"1010";
            elsif (decrease = '1' AND tmpCtrlOutput > min) then
                tmpCtrlOutput <= tmpCtrlOutput - B"1010";
            else
                tmpCtrlOutput <= tmpCtrlOutput;
            end if;
        end if;
        
    end process UpDownCounter;
    
    ctrlOutput <= tmpCtrlOutput;

end RTL;