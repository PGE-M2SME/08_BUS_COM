library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
   
entity toplevel is
    port (
        CLK_50M         : IN std_logic;
        pins            : IN std_logic_vector (3 downto 0);
--        leds            : OUT std_logic_vector(7 downto 0)        
        mort            : out std_logic_vector(7 downto 0)
    );
end entity toplevel;
   
architecture arch_bus_com of toplevel is

signal s_enable_read        : std_logic;
signal Enable_buscom_s      : std_logic;
signal ID_Cmd_s             : std_logic_vector(7 downto 0);
signal Type_bus_s           : std_logic_vector(1 downto 0);
signal Adresse_s            : std_logic_vector(7 downto 0);
signal Taille_mot_s         : std_logic_vector(7 downto 0);
signal Operateur_baud_s     : std_logic_vector(7 downto 0);
signal Facteur_baud_s       : std_logic_vector(7 downto 0);
signal Mot_s                : std_logic_vector(7 downto 0);
signal rout                 : std_logic_vector(7 downto 0);


begin
 
The_Bus_Com : entity work.bus_com 
    port map (
        CLK_50M         => CLK_50M,
        pins            => pins,
        Enable_bus_com  => '1',
        ID_Cmd          => ID_Cmd_s,
        Type_bus        => Type_bus_s,
        Adresse         => Adresse_s,
        Taille_mot      => Taille_mot_s,
        Operateur_baud  => Operateur_baud_s,
        Facteur_baud    => Facteur_baud_s,
        Mot             => Mot_s
--        leds            => rout
    );
mort <= not Mot_s;
--leds <= not rout;
end architecture arch_bus_com;