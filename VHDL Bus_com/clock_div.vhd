Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY clock_div IS
	generic (reg_ref : integer := 25000000);
	PORT ( 
		CLK : IN STD_LOGIC;
		cpt : OUT STD_LOGIC
		);
		
END clock_div;

ARCHITECTURE arch_clock_div OF clock_div IS

signal Reg : STD_LOGIC_VECTOR (25 downto 0);
signal cptsig : STD_LOGIC ;


BEGIN

process (CLK)
begin 
	if (CLK = '1' and CLK'EVENT) then
		reg <= reg + '1' ;
		if (reg = reg_ref) then
			reg <= ( others => '0');
			cptsig <= not cptsig;
		end if;
	end if;
	
end process;
cpt <= cptsig;

END arch_clock_div;