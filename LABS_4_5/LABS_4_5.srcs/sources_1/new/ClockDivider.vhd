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
    output_freq: integer := 1000);
    Port (
    sysclk : in std_logic;
    Reset : in std_logic;
    clk_out : out std_logic);
    
end ClockDivider;

architecture rtl of ClockDivider is

constant clk_out_ticks : integer := (125e6/output_freq);
constant half_clk_out_ticks : integer := (125e6/output_freq/2);

signal clk_div_int : integer range 0 to half_clk_out_ticks;
signal tempClk : std_logic := '0';
signal n_Reset : std_logic;

begin

    n_Reset <= Reset;

process (sysclk, n_Reset)
begin
    if(n_Reset = '1') then
        clk_div_int <= 0;
        tempClk <= '0';
    elsif(sysclk'event and sysclk = '1') then
        clk_div_int <= clk_div_int + 1;
    if (clk_div_int = half_clk_out_ticks) then
        tempClk <= NOT tempClk;
        clk_div_int <= 1;
    end if;
    end if;
    clk_out <= tempClk;
end process;

end rtl;
