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

entity TB_Register is
--  Port ( );
    type rgb_channel_t is (Red, Green, Blue);
end TB_Register;

architecture RTL of TB_Register is

    signal sysclk : std_logic := '0';
    signal reset : std_logic := '0';
    signal n_reset : std_logic;
    constant PWM_resolution : integer := 8;
    
    signal pulserClk : std_logic;
    signal pwmClk : std_logic := '0';
    signal btn : std_logic_vector(3 downto 1) := "000";
    
    signal pulserOutput : std_logic_vector(3 downto 1) := "000";
    signal channelSelectorState : rgb_channel_t := Red;    

    --resigter bank stuff
    constant maxBrightness : std_logic_vector((PWM_resolution -1) downto 0) := (others => '1');
    constant minBrightness : std_logic_vector((PWM_resolution -1) downto 0) := (others => '0');
    
    signal redBrightness : std_logic_vector((PWM_resolution -1) downto 0) := B"0000_0000";
    signal greenBrightness : std_logic_vector((PWM_resolution -1) downto 0):= B"0000_0000";
    signal blueBrightness : std_logic_vector((PWM_resolution -1) downto 0):= B"0000_0000";
  
    --pwm outputs
    signal PWM_redOut : std_logic;
    signal  PWM_greenOut : std_logic;
    signal PWM_blueOut : std_logic;
    
    --rgb led 4
    signal led4_r : std_logic := '0';
    signal led4_g : std_logic := '0';
    signal led4_b : std_logic := '0';  
    
    -- Clock period definitions
    constant sysclk_period : time := 8 ns;

     component ButtonPulser is
     
        generic (
            startRepeatDelay : integer := 4000;
            repeatInterval : integer := 1000 );
        port ( 
            pulserClkIn, n_reset, btn : IN std_logic;
            output : OUT std_logic );
            
     end component ButtonPulser;
   
     component PWM_SysClockGen is
     
        generic (
            PWM_resolution : integer := 8); -- Output resolution in bits
   
        port (
            sysclk, n_reset : IN std_logic;
            PWM_sysclk : OUT std_logic );        
        
     end component PWM_SysClockGen;   
     
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

        -- Clock process
    sysclk_p: process
        begin
        sysclk <= '0';
        wait for sysclk_period/2;
        sysclk <= '1';
        wait for sysclk_period/2;
    end process sysclk_p;
    
    --pulserclk process
    pulserclk_p : process
        begin
            pulserClk <= '0';
            wait for 500 us;
            pulserClk <= '1';
            wait for 500 us;
        end process pulserclk_p;
        
--    pwmclk_p : process
--            begin
--                pwmClk <= '0';
--                wait for 19530 ns;
--                pwmClk <= '1';
--                wait for 19530 ns;
--            end process pwmclk_p;        
     
    -- Stimulus process
    stim_p: process
        begin
            btn(1) <= '1';
            wait for 1 ms;
            btn(1) <= '0';
            btn(3) <= '1';
            wait for 30 ms;
            btn(3) <= '0';
            wait for 3 ms;
            btn(1) <= '1';
            wait for 1 ms;
            btn(1) <= '0';
            btn(3) <= '1';
            wait for 20 ms;
            btn(3) <= '0';
            btn(1) <= '1';
            wait for 1 ms;
            btn(1) <= '0';
            wait for 1 ms;
            btn(1) <= '1';
            wait for 1 ms;
            btn(1) <= '0';
            wait;
    end process stim_p;

    channelPulser: ButtonPulser
        generic map (
            startRepeatDelay => 20,
            repeatInterval => 5 )
        port map (
            pulserClkIn => pulserClk,
            n_reset => n_reset,
            btn => btn(1),
            output => pulserOutput(1) );
            
--    upPulser: ButtonPulser
--        generic map (
--            startRepeatDelay => 10,
--            repeatInterval => 2 )
--        port map (
--            pulserClkIn => pulserClk,
--            n_reset => n_reset,
--            btn => btn(3),
--            output => pulserOutput(3) );
            
--    downPulser: ButtonPulser
--         generic map (
--             startRepeatDelay => 10,
--             repeatInterval => 2 )
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
                       startRepeatDelay => 10,
                       repeatInterval => 2 ) 
                    port map(
                        pulserClkIn => pulserClk,
                        n_reset => n_reset,
                        btn => btn(i),
                        output => pulserOutput(i));
             end generate pulserGen;                                                                      
            
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

--         elsif (pulserClk'event AND pulserClk = '1') then
--                case channelSelectorState is
                    
--                    when Red => led4_r <= PWM_redOut;
                    
--                    when Green => led4_g <= PWM_greenOut;
                    
--                    when Blue => led4_b <= PWM_blueOut;
                    
--                    when others => led4_r <= PWM_redOut;
--                end case;              
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
                            redBrightness <= redBrightness + 15;
                        end if;
                    when Green =>
                        if greenBrightness < maxBrightness then 
                            greenBrightness <= greenBrightness + 15;
                        end if;
                    when Blue =>
                        if blueBrightness < maxBrightness then
                            blueBrightness <= blueBrightness + 15;
                        end if;
                end case;
            elsif (pulserOutput(2) = '1') then
                case channelSelectorState is
                    when Red =>
                        if redBrightness > minBrightness then
                            redBrightness <= redBrightness - 15;
                        end if;
                when Green =>
                    if greenBrightness > minBrightness then 
                        greenBrightness <= greenBrightness - 15;
                    end if;
                when Blue =>
                    if blueBrightness > minBrightness then
                        blueBrightness <= blueBrightness - 15;
                    end if;
                end case;             
            end if;
        end if;
    end process registerSelect;
    
end RTL;