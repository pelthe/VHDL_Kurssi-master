library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity LABS_4_5 is

    Port (btn : in STD_LOGIC_VECTOR(3 downto 1);
          
          Reset: in STD_LOGIC;
   
          sysclk : in STD_LOGIC;
          
          clkDiv : out STD_LOGIC;
         
          led : out STD_LOGIC_VECTOR(3 downto 0);
         
          led4_r : out STD_LOGIC;
          led4_g : out STD_LOGIC;
          led4_b : out STD_LOGIC;
          
          led5_r : out STD_LOGIC;
          led5_g : out STD_LOGIC;
          led5_b : out STD_LOGIC
          );

end LABS_4_5;

architecture rtl of LABS_4_5 is

signal RGB_LED_4: STD_LOGIC_VECTOR(0 to 2); --order R, G, B

signal RGB_LED_5: STD_LOGIC_VECTOR(0 to 2); --order R, G, B

signal n_Reset: STD_LOGIC;

COMPONENT clockDivider PORT( sysclk : IN STD_LOGIC;
                             Reset : IN STD_LOGIC;
                             clkDiv : OUT STD_LOGIC);
END COMPONENT;

begin

        led4_r <= RGB_LED_4(2);
        led4_g <= RGB_LED_4(1);
        led4_b <= RGB_LED_4(0);
        led5_r <= RGB_LED_5(2);
        led5_g <= RGB_LED_5(1);
        led5_b <= RGB_LED_5(0);
        
        n_Reset <= not Reset;
        

end rtl;
