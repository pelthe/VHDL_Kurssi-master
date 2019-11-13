library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_PWM is
--  Port ( );
end TB_PWM;

architecture RTL of TB_PWM is

    component PWM is
        generic (
            PWM_resolution : integer );
        port (
            sysclk, reset : IN std_logic;
            ctrlInput : IN std_logic_vector((PWM_resolution - 1) downto 0) := (others => '0');
            PWM_output : OUT std_logic );
    end component PWM;

    --Inputs
    signal sysclk : std_logic := '0';
    signal reset : std_logic := '0';
    signal ctrlInput : std_logic_vector := (others => '0');
    --Outputs
    signal PWM_output : std_logic := '0';
    -- Clock period definitions
    constant sysclk_period : time := 8 ns;       
    
    signal n_reset : std_logic;

begin

    n_reset <= not reset;
    
    DUT2 : PWM
        generic map (
            PWM_resolution => 8)
        port map (
            sysclk => sysclk,
            reset => reset );
    
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