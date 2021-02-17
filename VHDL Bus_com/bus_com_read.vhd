library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity bus_com_read is
    port (
        CLK_50M         : IN    std_logic;
        pins            : IN    std_logic_vector (3 downto 0);
        Enable_read     : IN    std_logic;
        Type_bus        : OUT   std_logic_vector(1 downto 0);
        Adresse         : OUT   std_logic_vector(7 downto 0);
        Taille_mot      : OUT   std_logic_vector(7 downto 0);
        Operateur_baud  : OUT   std_logic_vector(7 downto 0);
        Facteur_baud    : OUT   std_logic_vector(7 downto 0);
        Mot             : OUT   std_logic_vector(7 downto 0)
--        leds            : OUT std_logic_vector(7 downto 0)
    );
end entity bus_com_read;

architecture arch_bcr of bus_com_read is
-- signaux entite
signal s_type_bus   : std_logic_vector(1 downto 0);
signal pipo_RX      : std_logic;                        -- pour tester le RX (correspond au data_valid du RX)

-- signaux mots
signal SPI_mot      : std_logic_vector(7 downto 0);
signal I2C_mot      : std_logic_vector(7 downto 0);
signal UART_mot     : std_logic_vector(7 downto 0);

-- signaux de la machine a etat 
type etats is (standby, detection, SPI, I2C, UART);
signal currentstate : etats;
signal nextstate    : etats;

-- signaux enables 
signal d_enable     : std_logic; --signal enable de la detection des pins
signal SPI_enable   : std_logic;
signal I2C_enable   : std_logic;
signal UART_enable  : std_logic;  
 
begin 
      
Detection_config : entity work.test_pin
    port map(
        CLK_50M => CLK_50M,
        pins    => pins,
        config  => s_type_bus,
        enable  => d_enable
--        leds    => leds
    );

Lecture_SPI : entity work.Spi
    port map(
        SCK     => pins(3),
        DATA    => pins(2),
        CS      => pins(0),
        enable  => SPI_enable,
        Mot_spi => SPI_mot  
    );

Lecture_UART : entity work.UART_RX
    port map(
        i_Clk       => CLK_50M,
        i_RX_Serial => pins(2),
        enable      => UART_enable,
        o_RX_DV     => pipo_RX,
        o_RX_Byte   => UART_mot
    );
    
-- current state assignment
process (CLK_50M)
begin 
if (rising_edge(CLK_50M)) then 
    currentstate <= nextstate;
end if;
end process;

process(currentstate, Enable_read, s_type_bus)
begin
case currentstate is 
    when standby => 
        if (Enable_read = '1') then 
            nextstate <= detection ;
        else 
            nextstate <= standby;
        end if;

    when detection =>
        case s_type_bus is
            when "00" =>
                nextstate <= detection;
        
            when "01" => 
                nextstate <= SPI;
            
            when "10" => 
                nextstate <= I2C;

            when "11" => 
                nextstate <= UART;
            when others =>
                nextstate <= standby;

        end case;

        if (Enable_read ='0') then 
            nextstate <= standby;
        end if;
    
    when others => 
        if (Enable_read ='0') then 
            nextstate <= standby;
        end if;
end case;
end process ;

process (currentstate)
begin
case currentstate is

    when standby =>
        SPI_enable  <= '0';
        I2C_enable  <= '0';
        UART_enable <= '0';
        d_enable    <= '0';
    
    when detection =>
        d_enable    <= '1';

    when SPI => 
        SPI_enable  <= '1';
        I2C_enable  <= '0';
        UART_enable <= '0';
        d_enable    <= '0';
    
     when I2C => 
        SPI_enable  <= '0';
        I2C_enable  <= '1';
        UART_enable <= '0';
        d_enable    <= '0';
   
    when UART => 
        SPI_enable  <= '0';
        I2C_enable  <= '0';
        UART_enable <= '1';
        d_enable    <= '0';
    
end case;

end process;

-- affectation du type bus
Type_bus <= s_type_bus;

-- affecttion des mots
Mot <=  SPI_mot  when SPI_enable  = '1' else
        I2C_mot  when I2C_enable  = '1' else
        UART_mot when UART_enable = '1';

end architecture arch_bcr;
