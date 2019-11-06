library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Tb_FSM is
--  Port ( );
end entity Tb_FSM;

architecture RTL of Tb_FSM is

    component FSM_top is
        port (
            sysclk: IN std_logic;
            Reset : IN std_logic;
            btn : IN std_logic;
            led5_r : OUT std_logic;
            led5_g : OUT std_logic;
            led5_b : OUT std_logic );
    end component FSM_top;

    --Inputs
    signal sysclk : std_logic := '0';
    signal Reset : std_logic := '0';
    signal btn : std_logic := '0';
    --Outputs
    signal led5_r : std_logic := '1';
    signal led5_g : std_logic := '0';
    signal led5_b : std_logic := '0';
    signal rgb_led_5 : std_logic_vector(2 downto 0) := ("100");
    -- Clock period definitions
    constant sysclk_period : time := 8 ns;       

begin

    DUT_FSM: FSM_top
        port map (
           sysclk => sysclk,
           Reset => Reset,
           btn => btn,
           led5_r => led5_r,
           led5_g => led5_g,
           led5_b => led5_b );
           
           rgb_led_5(2) <= led5_r;
           rgb_led_5(1) <= led5_g;
           rgb_led_5(0) <= led5_b;

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
        wait for 100 ns;
        Reset <= '1';
        wait for 10 ns;
        Reset <= '0';
        
        btn <= '1';
        wait for 1 ms;
        btn <= '0';
        wait for 1 ms;
        
        btn <= '1';
        wait for 1 ms;
        btn <= '0';
        wait for 1 ms;
        
        btn <= '1';
        wait for 1 ms;
        btn <= '0';
        wait for 1 ms;
        
        btn <= '1';
        wait for 21 ms;
        btn <= '0';
        wait for 6 ms;
        
        btn <= '1';
        wait;
    end process stim_p;

end RTL;