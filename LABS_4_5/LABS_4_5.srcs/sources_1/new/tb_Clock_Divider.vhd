LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Tb_clock_divider IS
END Tb_clock_divider;
 
ARCHITECTURE behavior OF Tb_clock_divider IS
 
-- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ClockDivider
        PORT(
            sysclk : IN std_logic;
            Reset : IN std_logic;
            clk_out : OUT std_logic );
    END COMPONENT;
 
--Inputs
    signal sysclk : std_logic := '0';
    signal Reset : std_logic := '0';
 
--Outputs
    signal clk_out : std_logic;
 
-- Clock period definitions
    constant clk_period : time := 8 ns;
 
BEGIN
 
-- Instantiate the Device Under Test (DUT)
    DUT: ClockDivider PORT MAP (
        sysclk => sysclk,
        Reset => Reset,
        clk_out => clk_out );
     
    -- Clock process definitions
    clk_process :process
        begin
        sysclk <= '0';
        wait for clk_period/2;
        sysclk <= '1';
        wait for clk_period/2;
    end process clk_process;
     
    -- Stimulus process
    stim_p: process
        begin
        wait for 100 ns;
        Reset <= '1';
        wait for 100 ns;
        Reset <= '0';
        wait;
    end process stim_p;
 
END;