library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockDivider is

generic (
    OUTPUT_FREQ: integer := 1000);
    Port (
    sysclk : in std_logic;
    Reset : in std_logic;
    clk_out : out std_logic);
    
end ClockDivider;

architecture rtl of ClockDivider is

constant clk_out_ticks : integer := (125e6/output_freq);
constant half_clk_out_ticks : integer := (125e6/output_freq/2);

signal clk_div_int : integer range 0 to clk_out_ticks;

begin


end rtl;
