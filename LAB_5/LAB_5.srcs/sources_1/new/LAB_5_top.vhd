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
            startRepeatDelay : integer := 4000;
            repeatInterval : integer := 1000 );
        port ( 
            sysclk, Reset, btn : IN std_logic;
            output : OUT std_logic );
            
      end component ButtonPulser;

begin

    n_Reset <= not Reset;
            
    pulser: ButtonPulser
        port map (
            sysclk => sysclk,
            Reset => Reset,
            btn => btn(1),
            output => pulserOutput );
            
    channelSelectorClock: ClockGen
        port map (
            sysclk => sysclk,
            Reset => Reset,
            clkout => pulserClk );           
            
    channelSelectorFSM : process (pulserOutput, n_Reset) begin
    
        if n_Reset = '0' then
            channelSelectorState <= Red;
            
        elsif (pulserOutput'event AND pulserOutput = '1') then
            case channelSelectorState is
            
                when Red => led4_r <= '1';
                            led4_g <= '0';
                            led4_b <= '0';
                    if pulserOutput = '1' then channelSelectorState <= Blue; 
                    end if;
                
                when Blue => led4_r <= '0';
                             led4_g <= '1';
                             led4_b <= '0';
                    if pulserOutput = '1' then channelSelectorState <= Green; 
                    end if;
                
                when Green => led4_r <= '0';
                              led4_g <= '0';
                              led4_b <= '1';
                    if pulserOutput = '1' then channelSelectorState <= Red; 
                    end if;
                
                when others => channelSelectorState <= Red;
                
             end case;
                        
        end if;            
    
    end process channelSelectorFSM;


end RTL;