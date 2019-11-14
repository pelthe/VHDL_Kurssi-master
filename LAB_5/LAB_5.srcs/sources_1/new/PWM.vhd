library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM is
    generic (
        PWM_resolution : integer := 8 );        
    port (
        n_reset : IN std_logic;
        clkInput : IN std_logic;
        ctrlInput : IN std_logic_vector((PWM_resolution - 1) downto 0); -- Control input it bits for defining the duty cycle
        PWM_output : OUT std_logic );
end PWM;

architecture RTL of PWM is

    --signal n_reset : std_logic;
    signal PWM_sysclk : std_logic; -- sysclk for PWM
    
    signal PWM_count : std_logic_vector((PWM_resolution -1) downto 0) := (others => '0'); 
    signal PWM_maxCount : std_logic_vector((PWM_resolution -1) downto 0) := (others => '1'); 
    signal dutyCycle : std_logic_vector((PWM_resolution - 1) downto 0) := ctrlInput; -- Mapping the control input into a signal
    
--    component PWM_SysClockGen is
--        generic ( 
--            PWM_resolution : integer );
--        port (
--            sysclk, reset : IN std_logic;
--            PWM_sysclk : OUT std_logic );
--    end component PWM_SysClockGen;

begin

    dutyCycle <= ctrlInput;

    -- Instantiating the sysclk generator
--    PWM_clock :  PWM_SysClockGen 
--        generic map (
--            PWM_resolution => 8)
--        port map (
--            sysclk => sysclk,
--            reset => reset,
--            PWM_sysclk => PWM_sysclk );
    
    -- Counter that wraps over whenever max value is reached based on PWM resolution        
    PWM_counter : process(clkInput, n_reset)
    begin
    
        if n_reset = '0' then
           PWM_count <= (others => '0');
           
        elsif (clkInput'event AND clkInput ='1') then
            
            if (PWM_count <= PWM_maxCount) then
                PWM_count <= PWM_count + '1';
            else
                PWM_count <= (others => '0');
            end if;
        end if; 
    end process PWM_counter;           
   
   -- Output logic outputs '1' while above counter is under value given in the control input
    PWM_outputLogic : process(clkInput, n_reset)
    begin
        
        if n_reset = '0' then
            PWM_output <= '0';
            
        elsif (clkInput'event AND clkInput = '1') then
            if (PWM_count < dutyCycle) then
                PWM_output <= '1';
            else 
                PWM_output <= '0';
            end if;
        end if;
    end process PWM_outputLogic;

end architecture RTL;