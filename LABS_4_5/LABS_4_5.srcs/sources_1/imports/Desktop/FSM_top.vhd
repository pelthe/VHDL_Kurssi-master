library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity FSM_top is
    Port (
        sysclk: IN std_logic;
        Reset : IN std_logic;
        btn : IN std_logic;
        led5_r : OUT std_logic;
        led5_g : OUT std_logic;
        led5_b : OUT std_logic );

    type rgb_channel_t is (Red, Green, Blue);

end FSM_top;

architecture RTL of FSM_top is
    
    signal n_Reset : std_logic;
    signal rgb_led_5 : std_logic_vector(2 downto 0);
    signal pulserClk : std_logic;
    signal pulserOutput : std_logic;
    signal channelSelectorState : rgb_channel_t := Red;
    
    component ClockGen is
        
        generic ( outputFreq : integer := 1000 );
            port (
                sysclk : in STD_LOGIC;    
                Reset : in STD_LOGIC;
                clkout : out STD_LOGIC );
            
     end component ClockGen;
     
     component ButtonPulser is
     
        generic (
            startRepeatDelay : integer := 2000;
            repeatInterval : integer := 500 );
        port ( 
            sysclk, Reset, btn : IN std_logic;
            output : OUT std_logic );
            
      end component ButtonPulser;

begin

    n_Reset <= not Reset;
    
    led5_r <= rgb_led_5(2);
    led5_g <= rgb_led_5(1);
    led5_b <= rgb_led_5(0);
            
    pulser: ButtonPulser
        port map (
            sysclk => sysclk,
            Reset => Reset,
            btn => btn,
            output => pulserOutput );
            
    channelSelectorClock: ClockGen
        port map (
            sysclk => sysclk,
            Reset => Reset,
            clkout => pulserClk );           
            
    channelSelectorFSM : process (pulserClk, n_Reset) begin
    
        if n_Reset = '0' then
            channelSelectorState <= Red;
            
        elsif (pulserClk'event AND pulserClk = '1') then
            case channelSelectorState is
            
                when Red => rgb_led_5 <= "100";
                    if pulserOutput = '1' then channelSelectorState <= Blue; 
                    end if;
                
                when Blue => rgb_led_5 <= "010";
                    if pulserOutput = '1' then channelSelectorState <= Green; 
                    end if;
                
                when Green => rgb_led_5 <= "001";
                    if pulserOutput = '1' then channelSelectorState <= Red; 
                    end if;
                
                when others => channelSelectorState <= Red;
                
             end case;
                        
        end if;            
    
    end process channelSelectorFSM;          
                        
     --led5_r <= pulserOutput;       

end RTL;
