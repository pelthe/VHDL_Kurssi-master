library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ClockGen is

    generic (
        outputFreq : integer := 1000; -- Output refquency in Hertzes
        repeatDelay : integer := 100; --delay in ns until repeating of button starts
        longPressState : STD_LOGIC ); 
  
    port (
        sysclk : in STD_LOGIC;
        
        Reset : in STD_LOGIC;
        
        clkout : out STD_LOGIC;
        
        btn : in STD_LOGIC_VECTOR(3 downto 1);
        output : out STD_LOGIC );

    type pulser_state_t is (Waiting, Pressed, Repeat);

end entity ClockGen;

architecture RTL of ClockGen is

    constant clockOutTicks : integer := (125e6 / outputFreq);
    constant halfClockOutTicks : integer := (125e6 / outputFreq / 2);
    
    constant sysclkTicksRepeatDelay : integer := (repeatDelay / 8);
    
    signal clockDividerInt : integer range 0 to clockOutTicks;
    signal tempClk : STD_LOGIC := '0';
    signal n_Reset : STD_LOGIC;
    
    signal pulser_state : pulser_state_t;
    signal longPress : STD_LOGIC;
    signal repeatDelayInt : integer range 0 to sysclkTicksRepeatDelay;
    
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

    button_pulser_p : process (sysclk, n_Reset) begin
    
        if n_Reset = '0' then
            output <= '0';
            pulser_state <= Waiting;

        elsif (sysclk'event AND sysclk = '1') then
            case pulser_state is
                when Waiting => if (btn(1) = '1') then
                                    output <= '1';
                                    pulser_state <= Pressed;
                                end if;
                
                when Pressed => output <= '0';
                                if (longPress = '1') then pulser_state <= Repeat;
                                end if;             
                
                when Repeat => if (longPress = '0') then pulser_state <= Waiting;
                               end if;
                               output <= '1';
                               pulser_state <= Pressed;
                
                when others =>  pulser_state <= Waiting;                                
             end case;
        end if;
    end process button_pulser_p; 
    
    repeat_delay_p : process (sysclk, n_Reset) begin
    
        if n_Reset = '0' then
            longPress <= '0';
            
        elsif (sysclk'event AND sysclk = '1') then   
            if (btn(1) = '1') then
                repeatDelayInt <= repeatDelayInt + 1;
            end if;              
        end if;
        
        if (repeatDelayInt >= sysclkTicksRepeatDelay) then
            longPress <= '1';
            repeatDelayInt <= 0;
        end if;
        
        if (sysclk'event AND sysclk = '1') then   
            if (btn(1) = '0' AND longPress = '1') then
                longPress <= '0';
            end if;              
        end if;
    
    end process repeat_delay_p;
            
end architecture RTL;