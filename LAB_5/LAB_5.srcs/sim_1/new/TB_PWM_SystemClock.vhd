library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_PWM_SystemClock is
--  Port ( );
end entity TB_PWM_SystemClock;

architecture RTL of TB_PWM_SystemClock is

    component PWM_SysClockGen is
        generic (
            PWM_Resolution : integer ); --Output resolution in bits
  
        port (
            sysclk: IN std_logic;
            reset : IN std_logic;
            PWM_sysclk : OUT std_logic);
            
    end component PWM_SysClockGen;

    --Inputs
    signal sysclk : std_logic := '0';
    signal reset : std_logic := '0';
    
    --Outputs
    signal PWM_sysclk : std_logic := '0';

    -- Clock period definitions
    constant sysclk_period : time := 8 ns;
    
    signal n_reset : std_logic;

begin

    n_reset <= not reset;

    DUT_PWM_SysClockGen: PWM_SysClockGen
        generic map (
            PWM_Resolution => 8 )
        port map (
           sysclk => sysclk,
           reset => reset,
           PWM_sysclk => PWM_sysclk );

        -- Clock process
    sysclk_p: process
        begin
        sysclk <= '0';
        wait for sysclk_period/2;
        sysclk <= '1';
        wait for sysclk_period/2;
    end process sysclk_p;
     
    -- Stimulus process
    stim_p: process
        begin
            wait;
    end process stim_p;

end RTL;