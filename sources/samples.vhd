library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

PACKAGE pk_samples IS
	COMPONENT samples IS
		GENERIC (
			N : INTEGER
		);
		PORT (
			input : IN STD_LOGIC_VECTOR(N-1 downto 0);
			clk   : IN STD_LOGIC;
			enable: IN STD_LOGIC;
			o_0   : OUT STD_LOGIC_VECTOR(N-1 downto 0);
			o_1   : OUT STD_LOGIC_VECTOR(N-1 downto 0);
			o_2   : OUT STD_LOGIC_VECTOR(N-1 downto 0);
			o_3   : OUT STD_LOGIC_VECTOR(N-1 downto 0)
		);
	END COMPONENT;
END PACKAGE;


library ieee;
use ieee.std_logic_1164.all;

ENTITY samples IS
	GENERIC (
		N : INTEGER
	);
	PORT (
		input : IN STD_LOGIC_VECTOR(N-1 downto 0);
		clk   : IN STD_LOGIC;
		enable: IN STD_LOGIC;
		o_0   : OUT STD_LOGIC_VECTOR(N-1 downto 0);
		o_1   : OUT STD_LOGIC_VECTOR(N-1 downto 0);
		o_2   : OUT STD_LOGIC_VECTOR(N-1 downto 0);
		o_3   : OUT STD_LOGIC_VECTOR(N-1 downto 0)
	);
END samples;

ARCHITECTURE arch of samples IS

SIGNAL Xn_0 : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');
SIGNAL Xn_1 : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');
SIGNAL Xn_2 : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');
SIGNAL Xn_3 : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');

BEGIN
	new_sample : process(input, clk, enable)
	begin
		if (clk'event AND clk = '1') then
			if (enable = '1') then
				Xn_3 <= Xn_2;
				Xn_2 <= Xn_1;
				Xn_1 <= Xn_0;
				Xn_0 <= input;
			end if;
		end if;
	end process;
	o_0 <= Xn_0;
	o_1 <= Xn_1;
	o_2 <= Xn_2;
	o_3 <= Xn_3;
END arch;








