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

entity LAB_5_top is
  
  generic (
    PWM_resolution : integer := 8 );
  port (
    sysclk, reset : IN std_logic;
    btn : IN std_logic_vector(3 downto 1);
    led4_r, led4_g, led4_b : OUT std_logic );
    
    type rgb_channel_t is (Red, Green, Blue);
    
end entity LAB_5_top;

architecture RTL of LAB_5_top is

    signal n_reset : std_logic;
    -- clock gen stuff for btn pulsers
    signal pulserClk : std_logic;
    -- btn pulser stuff
    signal pulserOutput : std_logic_vector(3 downto 1);
    signal channelSelectorState : rgb_channel_t := Red;
    --pwm system clock gen stuff
    signal pwmClk : std_logic;
    --pwm outputs
    signal PWM_redOut : std_logic;
    signal  PWM_greenOut : std_logic;
    signal PWM_blueOut : std_logic;
    --resigter bank stuff
    constant maxBrightness : std_logic_vector((PWM_resolution -1) downto 0) := (others => '1');
    constant minBrightness : std_logic_vector((PWM_resolution -1) downto 0) := (others => '0');
    
    signal redBrightness : std_logic_vector((PWM_resolution -1) downto 0) := B"0000_0000";
    signal greenBrightness : std_logic_vector((PWM_resolution -1) downto 0):= B"0000_0000";
    signal blueBrightness : std_logic_vector((PWM_resolution -1) downto 0):= B"0000_0000";
        
    
    -- clock for btn pulsers
    component ClockGen is
        
        generic ( 
            outputFreq : integer := 1000 );
        
        port (
            sysclk : in STD_LOGIC;    
            n_reset : in STD_LOGIC;
            clkout : out STD_LOGIC );
            
     end component ClockGen;
     
     --clock for PWM
     component PWM_SysClockGen is
     
        generic (
            PWM_resolution : integer := 8); -- Output resolution in bits
   
        port (
            sysclk, n_reset : IN std_logic;
            PWM_sysclk : OUT std_logic );        
        
     end component PWM_SysClockGen;
     
     -- btn pulser for changing RGB channel
     component ButtonPulser is
     
        generic (
            startRepeatDelay : integer := 4000;
            repeatInterval : integer := 1000 );
        port ( 
            pulserClkIn, n_reset, btn : IN std_logic;
            output : OUT std_logic );
            
      end component ButtonPulser;
      
      -- generates the PWM for brightness control of RGB LED
      component PWM is
      
        generic (
            PWM_resolution : integer := 8 );        
        port (
            n_reset : IN std_logic;
            clkInput : IN std_logic;
            ctrlInput : IN std_logic_vector((PWM_resolution - 1) downto 0); -- Control input it bits for defining the duty cycle
            PWM_output : OUT std_logic );
          
      end component PWM;

begin

    n_reset <= not reset;
            
    channelPulser: ButtonPulser
        generic map (
            startRepeatDelay => 2000,
            repeatInterval => 500 )
        port map (
            pulserClkIn => pulserClk,
            n_reset => n_reset,
            btn => btn(1),
            output => pulserOutput(1) );
            
--    upPulser: ButtonPulser
--        generic map (
--            startRepeatDelay => 1000,
--            repeatInterval => 250 )
--        port map (
--            pulserClkIn => pulserClk,
--            n_reset => n_reset,
--            btn => btn(3),
--            output => pulserOutput(3) );
            
--    downPulser: ButtonPulser
--         generic map (
--             startRepeatDelay => 1000,
--             repeatInterval => 250 )
--         port map (
--             pulserClkIn => pulserClk,
--             n_reset => n_reset,
--             btn => btn(2),
--             output => pulserOutput(2) );
             
   pulserGen: 
         for i in 2 to 3
            generate
                pulser : ButtonPulser
                    generic map (
                       startRepeatDelay => 1000,
                       repeatInterval => 250 ) 
                    port map(
                        pulserClkIn => pulserClk,
                        n_reset => n_reset,
                        btn => btn(i),
                        output => pulserOutput(i));
             end generate pulserGen;                                                              
            
    kiloClock: ClockGen
        generic map (
            outputFreq => 1000 )
        port map (
            sysclk => sysclk,
            n_reset => n_reset,
            clkout => pulserClk );           
            
    channelSelectorFSM : process (pulserClk, n_reset) begin
            
                if n_reset = '0' then
                    channelSelectorState <= Red;
                    
                elsif (pulserClk'event AND pulserClk = '1') then
                
                        case channelSelectorState is
                    
                            when Red => led4_r <= PWM_redOut;
                    
                            when Green => led4_g <= PWM_greenOut;
                    
                            when Blue => led4_b <= PWM_blueOut;
                    
                            when others => led4_r <= PWM_redOut;
                        end case;          
                
                        if (pulserOutput(1) = '1') then
                            case channelSelectorState is
                    
                                when Red => channelSelectorState <= Green; 
                                        
                                when Green => channelSelectorState <= Blue; 
                        
                                when Blue => channelSelectorState <= Red; 
                        
                                when others => channelSelectorState <= Red;
                            end case;
                        end if;         
                end if;            
            
        end process channelSelectorFSM;
    
    PWM_clk : PWM_SysClockGen
    
        generic map (
            PWM_resolution => 8 )
        port map (
            sysclk => sysclk,
            n_reset => n_reset,
            PWM_sysclk => pwmClk );
                    
    
    PWM_red : PWM
    
        generic map ( 
            PWM_resolution => 8 )
        port map (
            n_reset => n_reset,
            clkInput => pwmClk,
            ctrlInput => redBrightness,
            PWM_output => PWM_redOut );

    PWM_green : PWM
    
        generic map ( 
            PWM_resolution => 8 )
        port map (
            n_reset => n_reset,
            clkInput => pwmClk,
            ctrlInput => greenBrightness,
            PWM_output => PWM_greenOut );
            
    PWM_blue : PWM
            
         generic map ( 
             PWM_resolution => 8 )
         port map (
             n_reset => n_reset,
             clkInput => pwmClk,
             ctrlInput => blueBrightness,
             PWM_output => PWM_blueOut );                        
            
    registerSelect : process (pulserClk, n_reset) begin
    
        if n_reset = '0' then
            redBrightness <= (others => '0');
            greenBrightness <= (others => '0');
            blueBrightness <= (others => '0');
        elsif (pulserClk'event AND pulserClk = '1') then
            if (pulserOutput(3) = '1') then
                case channelSelectorState is
                    when Red =>
                        if redBrightness < maxBrightness then
                            redBrightness <= redBrightness + 5;
                        end if;
                    when Green =>
                        if greenBrightness < maxBrightness then 
                            greenBrightness <= greenBrightness + 5;
                        end if;
                    when Blue =>
                        if blueBrightness < maxBrightness then
                            blueBrightness <= blueBrightness + 5;
                        end if;
                end case;
            elsif (pulserOutput(2) = '1') then
                case channelSelectorState is
                    when Red =>
                        if redBrightness > minBrightness then
                            redBrightness <= redBrightness - 5;
                        end if;
                when Green =>
                    if greenBrightness > minBrightness then 
                        greenBrightness <= greenBrightness - 5;
                    end if;
                when Blue =>
                    if blueBrightness > minBrightness then
                        blueBrightness <= blueBrightness - 5;
                    end if;
                end case;             
            end if;
        end if;
    end process registerSelect;           
     
end RTL;