----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 11.09.2019 09:58:14
-- Design Name:
-- Module Name: LAB_1_top - RTL
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
 
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity LAB_1_top is
    Port (btn : in STD_LOGIC_VECTOR(1 downto 0);
          led : out STD_LOGIC_VECTOR(3 downto 0);
         
          led4_r : out STD_LOGIC;
          led4_g : out STD_LOGIC;
          led4_b : out STD_LOGIC;
         
          led5_r : out STD_LOGIC;
          led5_g : out STD_LOGIC;
          led5_b : out STD_LOGIC;
                   
          sw : in STD_LOGIC_VECTOR(1 downto 0));
          
end entity LAB_1_top;
 
architecture RTL of LAB_1_top is
 
--grouping rgb led 4 signals
signal RGB_LED_4: STD_LOGIC_VECTOR(0 to 2); --order R, G, B
signal RGB_LED_5: STD_LOGIC_VECTOR(0 to 2); --order R, G, B
--signal led_logic: STD_LOGIC_VECTOR(3 downto 0); --3,2,1,0
--signal led_logic2: STD_LOGIC_VECTOR(3 downto 0); --3,2,1,0
 
begin
 
    --mapping signal "RGB_LED_4" to actual output ports
        led4_r <= RGB_LED_4(2);
        led4_g <= RGB_LED_4(1);
        led4_b <= RGB_LED_4(0);
        led5_r <= RGB_LED_5(2);
        led5_g <= RGB_LED_5(1);
        led5_b <= RGB_LED_5(0);
      
       
--     --controlling LEDs 0-3 (2to4 decored)
--        with btn(1 downto 0) select
--        led(3 downto 0) <= "0001" when "00", --red
--                                "0010" when "01", --green
--                                "0100" when "10", --blue
--                                "1000" when others; --off
                                
--     --controlling LEDs 0-3 (led logic)                       
--        led(3) <= btn(1) nand btn(0);
--        led(2) <= btn(1) or btn(0);
--        led(1) <= btn(1) xor btn(0);
--        led(0) <= btn(1) and btn(0);
        
      -- Creating a process for buttons to change the activity from changing the switches positions  
      process (sw, btn) is -- switch and button acting as inputs
         begin
            if (sw = "00" or sw = "01") -- Switches off or switch 0 is on
            then
                if (btn = "00") then led(3 downto 0) <= "0001";
                elsif (btn = "01") then led(3 downto 0) <= "0010";
                elsif (btn = "10") then led(3 downto 0) <= "0100";
                elsif (btn = "11") then led(3 downto 0) <= "1000";
                end if;
            elsif (sw = "10" or sw = "11") -- Switch 1 or both are on
            then
                if (btn = "00") then led(3 downto 0) <= "1000";
                elsif (btn = "01" or btn = "10") then led(3 downto 0) <= "1110";
                elsif (btn = "11") then led(3 downto 0) <= "0101";
                end if;
            end if;
        end process;
                                   
    --controlling RGB LED 4
        with btn(1 downto 0) select
        RGB_LED_4 <=    "001" when "01", --red
                        "010" when "10", --green
                        "100" when "11", --blue
                        "000" when others; --off
   
    --controlling RGB LED 5 with switch 0 and 1 and using RGB_LED_4 as input in certain scenarios                   
   mux : process (RGB_LED_4, sw) is
   begin
    case sw is
        when "00" => RGB_LED_5 <= "000";
        when "01" => RGB_LED_5 <= RGB_LED_4;
        when others => RGB_LED_5 <= "111";
    end case;
  end process mux;
                       

 
end architecture RTL;