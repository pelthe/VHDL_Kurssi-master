library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PWM is
  Port (
    sysclk, reset : IN STD_LOGIC;
    PWM_output : OUT STD_LOGIC;
    ctrlInput : integer
   );
end PWM;

architecture RTL of PWM is

    signal n_reset : STD_LOGIC;
    signal PWM_sysclk : STD_LOGIC;
    
    component PWM_SysClockGen is
        generic (
            PWM_resolution : integer);
        port (
            sysclk, reset : IN STD_LOGIC;
            PWM_sysclk : OUT STD_LOGIC);
            
    end component PWM_SysClockGen;

begin

    PWM_clock : PWM_SysClockGen
    generic map (
        PWM_resolution => 8)
    port map (
        sysclk => sysclk,
        reset => reset,
        PWM_sysclk => PWM_output );

end RTL;
