LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Tb_clock_divider IS
END ENTITY Tb_clock_divider;
 
ARCHITECTURE RTL OF Tb_clock_divider IS
 
-- Component Declaration for the Device Under Test (DUT)
 
    COMPONENT ClockGen
        GENERIC (
            longPressState : STD_LOGIC := '0' );
        PORT(
            sysclk : IN std_logic;
            Reset : IN std_logic;
            clkout : OUT std_logic;
            btn : IN std_logic_vector(3 downto 1);
            output : OUT std_logic );
    END COMPONENT ClockGen;
 
--Inputs
    signal sysclk : std_logic := '0';
    signal Reset : std_logic := '0';
    signal btn : std_logic_vector(3 downto 1) := (others => '0');
 
--Outputs
    signal clkout : std_logic;
    signal output : std_logic;
    signal longPress : std_logic;
 
-- Clock period definitions
    constant sysclk_period : time := 8 ns;
 
BEGIN
 
    -- Instantiate the Device Under Test (DUT)
    DUT: ClockGen 
        GENERIC MAP (
            longPressState => longPress )
        PORT MAP (
            sysclk => sysclk,
            Reset => Reset,
            clkout => clkout,
            btn => btn,
            output => output );
     
    -- Clock process
    sysclk_p :process
        begin
        sysclk <= '0';
        wait for sysclk_period/2;
        sysclk <= '1';
        wait for sysclk_period/2;
    end process sysclk_p;
     
    -- Stimulus process
    stim_p: process
        begin
        wait for 100 ns;
        Reset <= '1';
        wait for 5 ms;
        Reset <= '0';
        btn(1) <= '1';
        wait for 200 ns;
        btn(1) <= '0';
        wait;
    end process stim_p;
 
END ARCHITECTURE RTL;