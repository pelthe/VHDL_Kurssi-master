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
 
entity LAB_2_top is
    Port (btn : in STD_LOGIC_VECTOR(2 downto 0);
    
          sysclk : in STD_LOGIC;
          
          sw : in STD_LOGIC_VECTOR(1 downto 0);
          
          led : out STD_LOGIC_VECTOR(3 downto 0);
          
          led4_r : out STD_LOGIC;
          led4_g : out STD_LOGIC;
          led4_b : out STD_LOGIC);
         
          
end entity LAB_2_top;
 
architecture rtl of LAB_2_top is

   --grouping rgb led 4 signals
signal RGB_LED_4: STD_LOGIC_VECTOR(0 to 2); --order R, G, B
   --making the reset signal
 signal n_Reset : STD_LOGIC;
 
begin

        led4_r <= RGB_LED_4(2);
        led4_g <= RGB_LED_4(1);
        led4_b <= RGB_LED_4(0);

  --making button 2 the reset button
   n_Reset <= btn(2);

led_ctrl_p: process (btn(1), btn(0), sw(1))
begin

    if sw(1) = '0' then
        case btn(1 downto 0) is
            when "00" => led <= "0001";
            when "01" => led <= "0010";
            when "10" => led <= "0100";
            when others => led <= "1000";
        end case;
    else
        led(0) <= btn(0) and btn(1);
        led(1) <= btn(0) xor btn(1);
        led(2) <= btn(0) or btn(1);
        led(3) <= btn(0) nand btn(1);
    end if; --sw(1)
    
end process led_ctrl_p;

rgb4_cntrlr: process(sysclk, n_Reset)
begin
    if n_Reset = '0' then
        RGB_LED_4 <= (others => '1');
            
    elsif rising_edge(sysclk) then
        case btn(1 downto 0) is
            when "00" => RGB_LED_4 <= "000"; --off
            when "01" => RGB_LED_4 <= "001"; --red
            when "10" => RGB_LED_4 <= "010"; --green
            when others => RGB_LED_4 <= "100"; --blue
        end case;
    end if;
    
end process rgb4_cntrlr;
 
end architecture rtl;