library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ClockGen is

    generic (
        outputFreq : integer := 1000 ); -- Output refquency in Hertzes
  
    port (
        sysclk : in STD_LOGIC;    
        Reset : in STD_LOGIC;
        clkout : out STD_LOGIC );


end entity ClockGen;

architecture RTL of ClockGen is

    constant clockOutTicks : integer := (125e6 / outputFreq);
    constant halfClockOutTicks : integer := (125e6 / outputFreq / 2);
    
    signal clockDividerInt : integer range 0 to clockOutTicks;
    signal tempClk : STD_LOGIC := '0';
    signal n_Reset : STD_LOGIC;
    

begin

    n_Reset <= not Reset;

    Clock_divider_p : process(sysclk, n_Reset)
    begin
        
        if(n_Reset='0') then
            clockDividerInt <= 0;
            tempClk <= '0';
        elsif(sysclk'event and sysclk='1') then
            clockDividerInt <= clockDividerInt + 1; 
        end if;
        
        if (clockDividerInt = halfClockOutTicks) then
             tempClk <= NOT tempClk;
             ClockDividerInt <= 1; 
        end if;
    
    clkout <= tempClk;
    
    end process Clock_Divider_p;

            
end architecture RTL;
