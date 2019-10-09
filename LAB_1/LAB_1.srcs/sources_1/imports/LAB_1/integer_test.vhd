library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity integer_test is
    Port ( sysclk : in std_logic;
           ja : out STD_LOGIC_VECTOR (7 downto 0);
           jb : out STD_LOGIC_VECTOR (7 downto 0)
           );
end integer_test;

architecture rtl of integer_test is

    signal int_a: integer := 0;
    signal int_b: integer range 0 to 255 := 0;

begin

    counter1: process (sysclk) is
    begin
        if sysclk'event and sysclk='1' then
            int_a <= int_a +1;
            if (int_b <= 25) then
                int_b <= int_b +1;
            else int_b <= 0;
            end if;
        end if;
    end process counter1;

    ja <= std_logic_vector(to_unsigned(int_a, ja'length));
    jb <= std_logic_vector(to_unsigned(int_b, jb'length));

end rtl;
