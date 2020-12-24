library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Spi is
    Port ( SCK  : in  STD_LOGIC;    -- SPI input clock
           DATA : in  STD_LOGIC;    -- SPI serial data input
           CS   : in  STD_LOGIC;    -- chip select input (active low)
           LED  : inout STD_LOGIC_VECTOR (7 downto 0));
end Spi;

architecture ar of Spi is
    signal dat_reg : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
begin

    process (SCK)
    begin
        if (SCK'event and SCK = '1') then  -- rising edge of SCK
            if (CS = '0') then             -- SPI CS must be selected
                -- shift serial data into dat_reg on each rising edge
                -- of SCK, MSB first
                dat_reg <= dat_reg(6 downto 0) & DATA;
            end if;
        end if;
    end process;

    -- only update LEDs when not shifting (CS inactive)
    LED <= dat_reg when (CS = '1') else LED;

end ar;