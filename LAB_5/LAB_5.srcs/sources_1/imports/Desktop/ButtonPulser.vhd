library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ButtonPulser is

    generic (
        startRepeatDelay : integer := 20; --delay in clock cycles from ClockGen before repeating starts
        repeatInterval : integer := 5 ); --interval between pulses in pulsetrain in clock cycles from ClockGen
 
    port (
        pulserClkIn : in STD_LOGIC;
        n_reset : in STD_LOGIC;
        btn : in STD_LOGIC;
        output : out STD_LOGIC );

    type pulser_state_t is (Waiting, Pressed, Repeat);

end entity ButtonPulser;

architecture RTL of ButtonPulser is

    --signal n_Reset : STD_LOGIC;
    
--    signal clk : STD_LOGIC;
    
    signal pulser_state : pulser_state_t;
    signal longPress : STD_LOGIC := '0';
    signal allowRepeat : STD_LOGIC := '0';
    signal startRepeatDelayInt : integer range 1 to startRepeatDelay;
    signal repeatIntervalInt : integer range 0 to repeatInterval;
    
--    component ClockGen is
        
--        generic ( outputFreq : integer := 1000 );
--            port (
--                sysclk : in STD_LOGIC;    
--                Reset : in STD_LOGIC;
--                clkout : out STD_LOGIC );
            
--     end component ClockGen;
    
begin

    --n_Reset <= not Reset;
    
--    buttonPulserClock: ClockGen
--        port map (
--            sysclk => sysclk,
--            Reset => Reset,
--            clkout => clk );

    button_pulser_p : process (pulserClkIn, n_reset) begin
    
        if n_reset = '0' then
            output <= '0';
            pulser_state <= Waiting;

        elsif (pulserClkIn'event AND pulserClkIn = '1') then
            case pulser_state is
                when Waiting => if (btn = '1') then
                                    output <= '1';
                                    pulser_state <= Pressed;
                                end if;
                
                when Pressed => output <= '0';
                                if (longPress = '1') then 
                                    pulser_state <= Repeat;
                                elsif (btn = '0') then
                                    pulser_state <= Waiting;
                                end if;
                
                when Repeat => if (longPress = '0') then 
                                    pulser_state <= Waiting;
                               elsif (longPress = '1' AND allowRepeat = '1') then
                                    output <= '1';
                                    pulser_state <= Pressed;
                               end if;
                
                when others =>  pulser_state <= Waiting;                                
             end case;
        end if;
    end process button_pulser_p; 
    
    clock_cycle_counter_p : process (pulserClkIn, n_Reset) begin
    
        if n_Reset = '0' then
            longPress <= '0';
            allowRepeat <= '0';
            startRepeatDelayInt <= 1;
            repeatIntervalInt <= 0;
            
        elsif (pulserClkIn'event AND pulserClkIn = '1') then   
            if (btn = '1') then
                startRepeatDelayInt <= startRepeatDelayInt + 1;
            end if;
            if (longPress = '1') then
                repeatIntervalInt <= repeatIntervalInt + 1;
            end if;                 
        --end if;

        --if (clk'event AND clk = '1') then        
        if (startRepeatDelayInt >= (startRepeatDelay - repeatInterval)) then
            longPress <= '1';
            startRepeatDelayInt <= 1;
        end if;
        --end if;
        
        --if (clk'event AND clk = '1') then
        if (repeatIntervalInt = repeatInterval) then
            allowRepeat <= '1';
            repeatIntervalInt <= 0;
        elsif (repeatIntervalInt /= repeatInterval) then
            allowRepeat <= '0';
        end if; 
        --end if;
        
        --if (clk'event AND clk = '1') then
            if (btn = '0' AND longPress = '1') then
                longPress <= '0';
                allowRepeat <= '0';
                startRepeatDelayInt <= 1;
                repeatIntervalInt <= 0;
             end if; 
        end if;
        
    end process clock_cycle_counter_p;
      
end architecture RTL;