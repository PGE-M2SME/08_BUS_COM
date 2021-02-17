library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity bus_com is
    port (
        CLK_50M         : IN std_logic;
        Pins            : IN std_logic_vector (3 downto 0);
        Enable_bus_com  : IN std_logic;
        ID_Cmd          : IN std_logic_vector(7 downto 0);
        Type_bus        : INOUT std_logic_vector(1 downto 0);
        Adresse         : INOUT std_logic_vector(7 downto 0);
        Taille_mot      : INOUT std_logic_vector(7 downto 0);
        Operateur_baud  : INOUT std_logic_vector(7 downto 0);
        Facteur_baud    : INOUT std_logic_vector(7 downto 0);
        Mot             : INOUT std_logic_vector(7 downto 0)
--        leds            : OUT std_logic_vector(7 downto 0)
    );
end entity bus_com;

architecture arch_bus_com of bus_com is

type etats is (s_standby, s_read, s_write, s_off);

signal s_enable_read    :   std_logic := '0';
signal s_enable_write   :   std_logic := '0';
signal currentstate     :   etats := s_off;
signal nextstate        :   etats;
    
begin
 
BC_read : entity work.bus_com_read
    port map(
        CLK_50M         => CLK_50M,
        Pins            => pins,
        Enable_read     => s_enable_read,
        Type_bus        => Type_bus,
        Adresse         => Adresse,
        Taille_mot      => Taille_mot,
        Operateur_baud  => Operateur_baud,
        Facteur_baud    => Facteur_baud,
        Mot             => Mot
--        leds            => leds
    );
  
-- current state assignment
process (CLK_50M)
begin 
if (rising_edge(CLK_50M)) then 
    currentstate <= nextstate;
end if;
 
end process;

-- next state assignment
process (currentstate, Enable_bus_com, ID_Cmd)
begin 
case currentstate is 
    when s_off =>
        if (Enable_bus_com = '1') then 
            nextstate <= s_standby;
        else 
            nextstate <= s_off;
        end if;

    when s_standby => 
        if (ID_Cmd = 0 and Enable_bus_com ='1') then 
            nextstate <= s_read;
        elsif (ID_Cmd = 1 and Enable_bus_com ='1') then 
            nextstate <= s_write;
        elsif (Enable_bus_com = '0') then
            nextstate <= s_off;
        else
            nextstate <= s_standby;
        end if;

    when s_read => 
        if (ID_Cmd = 0 and Enable_bus_com ='1') then 
            nextstate <= s_read;
        else 
            nextstate <= s_standby;
        end if;
    
    when s_write => 
        if (ID_Cmd = 1 and Enable_bus_com ='1') then 
            nextstate <= s_write;
        else 
            nextstate <= s_standby;
        end if;
end case;
end process;

-- state behaviour
 
process (currentstate)
begin 
case currentstate is 
    when s_off => 
        s_enable_read <= '0';
        s_enable_write <= '0';

    when s_standby =>
        s_enable_read <= '0';
        s_enable_write <= '0';
    
    when s_write =>
        s_enable_read <= '0';
        s_enable_write <= '1';

    when s_read =>
        s_enable_read <= '1';
        s_enable_write <= '0';
end case;
end process;

 
end architecture arch_bus_com;