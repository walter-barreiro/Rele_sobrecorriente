library ieee;
use ieee.std_logic_1164.all;


PACKAGE pk_muestras IS
	COMPONENT muestras IS
		PORT (
			input : IN STD_LOGIC_VECTOR(15 downto 0);
			clk   : IN STD_LOGIC;
			enable: IN STD_LOGIC;
			o     : OUT STD_LOGIC_VECTOR(15 downto 0);
			o_1   : OUT STD_LOGIC_VECTOR(15 downto 0);
			O_2   : OUT STD_LOGIC_VECTOR(15 downto 0);
			O_3   : OUT STD_LOGIC_VECTOR(15 downto 0)
		);
	END COMPONENT;
END PACKAGE;


library ieee;
use ieee.std_logic_1164.all;

ENTITY muestras IS
	PORT (
		input : IN STD_LOGIC_VECTOR(15 downto 0);
		clk   : IN STD_LOGIC;
		enable: IN STD_LOGIC;
		o     : OUT STD_LOGIC_VECTOR(15 downto 0);
		o_1   : OUT STD_LOGIC_VECTOR(15 downto 0);
		O_2   : OUT STD_LOGIC_VECTOR(15 downto 0);
		O_3   : OUT STD_LOGIC_VECTOR(15 downto 0)
	);
END muestras;

ARCHITECTURE arch of muestras IS

SIGNAL Xn   : STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');
SIGNAL Xn_1 : STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');
SIGNAL Xn_2 : STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');
SIGNAL Xn_3 : STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');

BEGIN
	new_sample : process(input, clk, enable)
	begin
		if (clk'event AND clk = '1') then
			if (enable = '1') then
				Xn_3 <= Xn_2;
				Xn_2 <= Xn_1;
				Xn_1 <= Xn;
				Xn   <= input;
			end if;
		end if;
	end process;
	o   <= Xn;
	o_1 <= Xn_1;
	o_2 <= Xn_2;
	o_3 <= Xn_3;

END arch;








