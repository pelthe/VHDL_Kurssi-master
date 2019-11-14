library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LAB_5_top is
  
  Port (
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
    --pwm stuff
    signal PWM_signal : std_logic;
    --resigter bank stuff
    signal redLoad, greenLoad, blueLoad : std_logic;
    signal tmpRegDataIn : std_logic_vector(7 downto 0);
    signal tmpRegDataOut : std_logic_vector(7 downto 0);
    
--    signal redRegDataIn : std_logic_vector(7 downto 0);
--    signal redRegDataOut : std_logic_vector(7 downto 0);
    
--    signal blueRegDataIn : std_logic_vector(7 downto 0);
--    signal blueRegDataOut : std_logic_vector(7 downto 0);
    
--    signal greenRegDataIn : std_logic_vector(7 downto 0);
--    signal greenRegDataOut : std_logic_vector(7 downto 0);
        
    
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
      
      component UpDownCounter is
            Port (
                counterClkIn, increase, decrease : IN std_logic;
                n_reset : IN std_logic;
                ctrlDataInput : IN std_logic_vector(7 downto 0);
                ctrlOutput : OUT std_logic_vector(7 downto 0) );
       end component UpDownCounter;
      
      component Register_8 is
          port (
            clk, n_reset, load : IN std_logic;
            dataIn : IN std_logic_vector(7 downto 0);
            dataOut : OUT std_logic_vector(7 downto 0) );
      end component;

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
            
    upPulser: ButtonPulser
        generic map (
            startRepeatDelay => 1000,
            repeatInterval => 250 )
        port map (
            pulserClkIn => pulserClk,
            n_reset => n_reset,
            btn => btn(3),
            output => pulserOutput(3) );
            
    downPulser: ButtonPulser
         generic map (
             startRepeatDelay => 1000,
             repeatInterval => 250 )
         port map (
             pulserClkIn => pulserClk,
             n_reset => n_reset,
             btn => btn(2),
             output => pulserOutput(2) );
             
--   pulserGen: 
--         for i in 2 to 3
--            generate
--                pulser : ButtonPulser
--                    generic map (
--                       startRepeatDelay => 1000,
--                       repeatInterval => 250 ) 
--                    port map(
--                        pulserClkIn => pulserClk,
--                        n_reset => n_reset,
--                        btn => btn(i),
--                        output => pulserOutput(i));
--             end generate pulserGen;                                                              
            
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
            
                when Red => 
                            led4_r <= PWM_signal;
                            led4_g <= '0';
                            led4_b <= '0';
                    if pulserOutput(1) = '1' then channelSelectorState <= Green; 
                    end if;
                
                when Green => 
                              led4_r <= '0';
                              led4_g <= PWM_signal;
                              led4_b <= '0';
                    if pulserOutput(1) = '1' then channelSelectorState <= Blue; 
                    end if;
                
                when Blue => 
                             led4_r <= '0';
                             led4_g <= '0';
                             led4_b <= PWM_signal;
                    if pulserOutput(1) = '1' then channelSelectorState <= Red; 
                    end if;
                
                when others => channelSelectorState <= Red;
                
             end case;
                        
        end if;            
    
    end process channelSelectorFSM;
    
    redRegister : Register_8
    
        port map (
            clk => pulserClk,
            n_reset => n_reset,
            load => redLoad,
            dataIn => tmpRegDataIn,
            dataOut => tmpRegDataOut );
            
    greenRegister : Register_8
            
         port map (
             clk => pulserClk,
             n_reset => n_reset,
             load => greenLoad,
             dataIn => tmpRegDataIn,
             dataOut => tmpRegDataOut );
                    
    blueRegister : Register_8
                    
          port map (
              clk => pulserClk,
              n_reset => n_reset,
              load => blueLoad,
              dataIn => tmpRegDataIn,
              dataOut => tmpRegDataOut );                                            
    
    PWM_clk : PWM_SysClockGen
    
        generic map (
            PWM_resolution => 8 )
        port map (
            sysclk => sysclk,
            n_reset => n_reset,
            PWM_sysclk => pwmClk );
                    
    
    PWM_0 : PWM
    
        generic map ( 
            PWM_resolution => 8 )
        port map (
            n_reset => n_reset,
            clkInput => pwmClk,
            ctrlInput => tmpRegDataOut,
            PWM_output => PWM_signal );
            
    brightnessCtrl : UpDownCounter
    
        port map (
            counterClkIn => pulserClk,
            increase => pulserOutput(3),
            decrease => pulserOutput(2),
            n_reset => n_reset,
            ctrlDataInput => tmpRegDataOut,
            ctrlOutput => tmpRegDataIn );
            
    registerSelect : process (pulserClk, n_reset) begin
    
        if n_reset = '0' then
            redLoad <= '1';
        elsif (pulserClk'event AND pulserClk = '1') then
            if channelSelectorState = Red then
                redLoad <= '1';
                greenLoad <= '0';
                blueLoad <= '0';
            elsif channelSelectorState = Green then
                redLoad <= '0';
                greenLoad <= '1';
                blueLoad <= '0';
            elsif channelSelectorState = Blue then
                redLoad <= '0';
                greenLoad <= '0';
                blueLoad <= '1';
            end if;                  
        end if;
    end process registerSelect;           
     
end RTL;