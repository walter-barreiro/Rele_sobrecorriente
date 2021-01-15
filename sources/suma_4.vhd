library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE pk_mean IS
	COMPONENT mean IS
		PORT (
			clk	  : IN STD_LOGIC;
			i_0   : IN STD_LOGIC_VECTOR(15 downto 0); -- Xn
			i_1   : IN STD_LOGIC_VECTOR(15 downto 0); -- Xn-1
			i_2   : IN STD_LOGIC_VECTOR(15 downto 0); -- Xn-2
			i_3   : IN STD_LOGIC_VECTOR(15 downto 0); -- Xn-3
--			clk   : IN STD_LOGIC;
--			enable: IN STD_LOGIC;
			o     : OUT STD_LOGIC_VECTOR(15 downto 0) -- Yn
		);
	END COMPONENT;
END PACKAGE;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

LIBRARY lpm;
USE lpm.lpm_components.all;

ENTITY mean IS
	PORT (
		clk				: IN STD_LOGIC;
		i_0   : IN STD_LOGIC_VECTOR(15 downto 0); -- Xn
		i_1   : IN STD_LOGIC_VECTOR(15 downto 0); -- Xn-1
		i_2   : IN STD_LOGIC_VECTOR(15 downto 0); -- Xn-2
		i_3   : IN STD_LOGIC_VECTOR(15 downto 0); -- Xn-3
--		clk   : IN STD_LOGIC;
--		enable: IN STD_LOGIC;
		o     : OUT STD_LOGIC_VECTOR(15 downto 0) -- Yn
	);
END mean;

ARCHITECTURE sumar of mean IS

SIGNAL sum_1 : SIGNED(15 downto 0);
SIGNAL sum_2 : SIGNED(15 downto 0);
SIGNAL sum 	 : SIGNED(15 downto 0);

BEGIN
sum_1 <= signed(i_0) + signed(i_1);
sum_2 <= signed(i_2) + signed(i_3);

sum <= sum_1 + sum_2;

o  <= std_logic_vector(shift_right(sum,2)); 

-- Si llegamos a implementarlo con shift hay que tener precaucion
-- con los numeros negativos

-- Lo estuve probando y creo que funca
	
END ARCHITECTURE;













