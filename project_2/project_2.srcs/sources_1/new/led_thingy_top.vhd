----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2019 08:30:49
-- Design Name: 
-- Module Name: led_thingy_top - rtl
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

entity led_thingy_top is
    Port ( btn : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0);
           led4_r : out std_logic;
           led4_g : out std_logic;
           led4_b : out std_logic;
           led5_r : out std_logic;
           led5_g : out std_logic;
           led5_b : out std_logic
           );
end led_thingy_top;

architecture rtl of led_thingy_top is

    -- group of RGB led signals
    signal RGB_Led_4: std_logic_vector(0 to 2); -- order R, G, B

begin

    -- some "housekeeping" first
    -- map signal "RGB_Led_4" to actual output ports
    led4_r <= RGB_Led_4(2);
    led4_g <= RGB_Led_4(1);
    led4_b <= RGB_Led_4(0);
    
    led <= btn; -- this handles the red leds
    
    -- Control of RGB LED 4
    with btn(3 downto 0) select
        RGB_Led_4 <=    "001" when "0001", --red
                        "010" when "0010", --green
                        "100" when "0100", --blue
                        "000" when others, --off
    
--    led(3) <= btn(3);
--    led(2) <= btn(2);
--    led(1) <= btn(1);
--    led(0) <= btn(0);
    
end architecture rtl;
