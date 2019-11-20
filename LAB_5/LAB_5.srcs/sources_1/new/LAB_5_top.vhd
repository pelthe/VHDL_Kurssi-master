-------------------------
-- Authors: Miikka S?teri & Heikki Peltom?ki
-- VHDL lab 5
-- Desc: Shows selected state in RGB LED 5
--      RGB LED 4 is brightness controlled
--      btn0 is reset, btn1 is colour select, btn2 is brightness down, btn3 is brightness up
-------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity LAB_5_top is
  
  generic (
    PWM_resolution : integer := 8 );
  port (
    sysclk, reset : IN std_logic;
    btn : IN std_logic_vector(3 downto 1);
    led4_r, led4_g, led4_b : OUT std_logic;
    led5_r, led5_g, led5_b : OUT std_logic );
    
    type rgb_channel_t is (Red, Green, Blue);
    type reg_t is array (0 to 2) of std_logic_vector((PWM_resolution - 1) downto 0);
    
end entity LAB_5_top;

architecture RTL of LAB_5_top is

    signal n_reset : std_logic;
    -- clock gen 1 kHz output for pulsers and state machines
    signal pulserClk : std_logic;
    -- btn pulser outputs
    signal pulserOutput : std_logic_vector(3 downto 1);
    signal channelSelectorState : rgb_channel_t := Red;
    --pwm system clock output
    signal pwmClk : std_logic;
    --pwm outputs
    signal rgbLed4 : std_logic_vector(0 to 2);
    --resigter banks
    constant maxBrightness : std_logic_vector((PWM_resolution -1) downto 0) := (others => '1');
    constant minBrightness : std_logic_vector((PWM_resolution -1) downto 0) := (others => '0');
    signal brightnessReg : reg_t;
       
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
     
     -- btn pulser
     component ButtonPulser is
     
        generic (
            startRepeatDelay : integer := 4000;
            repeatInterval : integer := 1000 );
        port ( 
            pulserClkIn, n_reset, btn : IN std_logic;
            output : OUT std_logic );
            
      end component ButtonPulser;
      
      -- PWM
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
    
    led4_r <= rgbLed4(0);
    led4_g <= rgbLed4(1);
    led4_b <= rgbLed4(2);
    
    -- btn pulser for changing colour channel        
    channelPulser: ButtonPulser
        generic map (
            startRepeatDelay => 2000,
            repeatInterval => 500 )
        port map (
            pulserClkIn => pulserClk,
            n_reset => n_reset,
            btn => btn(1),
            output => pulserOutput(1) );
   
   -- pulsers for changing brightness up and down          
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
   
   --1 kHz clk for button pulsers and state machines         
    kiloClock: ClockGen
        generic map (
            outputFreq => 1000 )
        port map (
            sysclk => sysclk,
            n_reset => n_reset,
            clkout => pulserClk );           
    
    --state machine for selecting colour        
    channelSelectorFSM : process (pulserClk, n_reset) begin
            
                if (n_reset = '0') then
                    channelSelectorState <= Red;
                    
                elsif (pulserClk'event AND pulserClk = '1') then
                
                        case channelSelectorState is
                    
                            when Red => led5_r <= '1';
                                        led5_g <= '0';
                                        led5_b <= '0';
                    
                            when Green => led5_r <= '0';
                                          led5_g <= '1';
                                          led5_b <= '0';
                    
                            when Blue => led5_r <= '0';
                                         led5_g <= '0';
                                         led5_b <= '1';
                    
                            when others => led5_r <= '1';
                                           led5_g <= '0';
                                           led5_b <= '0';
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
    
    --25,6 kHz clk for PWMs
    PWM_clk : PWM_SysClockGen
    
        generic map (
            PWM_resolution => 8 )
        port map (
            sysclk => sysclk,
            n_reset => n_reset,
            PWM_sysclk => pwmClk );
            
    -- gen for 3 PWMs        
    pwmGen :
        for i in 0 to 2
            generate
                rgbPWM : PWM
                    generic map ( 
                        PWM_resolution => 8 )
                    port map (
                        n_reset => n_reset,
                        clkInput => pwmClk,
                        ctrlInput => brightnessReg(i),
                        PWM_output => rgbLed4(i) );
            end generate pwmGen;                                  
    
    --state machine for changing brightness in registers        
    registerSelect : process (pulserClk, n_reset) begin
    
        if n_reset = '0' then
            brightnessReg(0) <= (others => '0');
            brightnessReg(1) <= (others => '0');
            brightnessReg(2) <= (others => '0');
        elsif (pulserClk'event AND pulserClk = '1') then
            if (pulserOutput(3) = '1') then
                case channelSelectorState is
                    when Red =>
                        if brightnessReg(0) < maxBrightness then
                            brightnessReg(0) <= brightnessReg(0) + 5; -- brightness icrement needs to divide 255 or the counter doesnt saturate
                        end if;
                    when Green =>
                        if brightnessReg(1) < maxBrightness then 
                            brightnessReg(1) <= brightnessReg(1) + 5;
                        end if;
                    when Blue =>
                        if brightnessReg(2) < maxBrightness then
                            brightnessReg(2) <= brightnessReg(2) + 5;
                        end if;
                    when others =>
                        brightnessReg(0) <= brightnessReg(0);
                        brightnessReg(1) <= brightnessReg(1);
                        brightnessReg(2) <= brightnessReg(2);
                end case;
            elsif (pulserOutput(2) = '1') then
                case channelSelectorState is
                    when Red =>
                        if brightnessReg(0) > minBrightness then
                            brightnessReg(0) <= brightnessReg(0) - 5;
                        end if;
                when Green =>
                    if brightnessReg(1) > minBrightness then 
                        brightnessReg(1) <= brightnessReg(1) - 5;
                    end if;
                when Blue =>
                    if brightnessReg(2) > minBrightness then
                        brightnessReg(2) <= brightnessReg(2) - 5;
                    end if;
                when others =>
                    brightnessReg(0) <= brightnessReg(0);
                    brightnessReg(1) <= brightnessReg(1);
                    brightnessReg(2) <= brightnessReg(2);                    
                end case;             
            end if;
        end if;
    end process registerSelect;           
     
end RTL;