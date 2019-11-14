library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity PWM_SysClockGen is

    generic (
        PWM_resolution : integer := 8); -- Output resolution in bits
  
    port (
        sysclk, n_reset : IN std_logic;
        PWM_sysclk : OUT std_logic );


end entity PWM_SysClockGen;

architecture RTL of PWM_SysClockGen is

    
    constant temp_PWM_sysclk : integer := ((2**PWM_resolution) * 100);
    constant clockOutTicks : integer := (125e6 / temp_PWM_sysclk);
    constant halfClockOutTicks : integer := (125e6 / temp_PWM_sysclk / 2);
    
    --signal PWM_resolution : integer := 8;
    signal clockDividerInt : integer range 0 to clockOutTicks;
    signal tempClk : STD_LOGIC := '0';
    
    --signal n_reset : std_logic;

begin


    Clock_divider_p : process(sysclk, n_reset)
    begin
        
        if(n_reset='0') then
            clockDividerInt <= 0;
            tempClk <= '0';
        elsif(sysclk'event and sysclk='1') then

            if (clockDividerInt = halfClockOutTicks) then
                tempClk <= NOT tempClk;
                ClockDividerInt <= 1;
            else
               clockDividerInt <= clockDividerInt + 1; 
            
            end if;
        end if;
    
    end process Clock_Divider_p;

    PWM_sysclk <= tempClk;
            
end architecture RTL;