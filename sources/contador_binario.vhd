-----------------------------------------------------------
----- PACKAGE pk_contador_binario
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

PACKAGE pk_contador_binario IS
   COMPONENT contador_binario IS
	GENERIC (
			N : integer
	);
   	PORT (
			clear : IN STD_LOGIC;
			enable : IN STD_LOGIC;
			clk  : IN STD_LOGIC;
			
			COUNT_MAX : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '1');

			count : OUT STD_LOGIC_VECTOR(N-1 downto 0)
		);
   END COMPONENT;
END PACKAGE;

-----------------------------------------------------------
----- ENTITY contador_binario
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


ENTITY contador_binario IS
	GENERIC (
		N : integer := 2
	);
	PORT (
		clear : IN STD_LOGIC;
		enable : IN STD_LOGIC;
		clk  : IN STD_LOGIC;

		COUNT_MAX : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '1');
		
		count : OUT STD_LOGIC_VECTOR(N-1 downto 0)
	);
END contador_binario;


ARCHITECTURE contador_binario_arch OF contador_binario IS

SIGNAL count_tmp : STD_LOGIC_VECTOR(N-1 downto 0);

BEGIN
	ciclo: PROCESS (clear, enable, clk)
	BEGIN
		IF (clk'event AND clk = '1') THEN 
			IF (clear = '0') THEN
				count_tmp <= (OTHERS => '0');
			ELSIF (enable = '1') THEN
				
				IF (count_tmp = COUNT_MAX-1) THEN
					count_tmp <= (OTHERS => '0');
				ELSE
					count_tmp <= count_tmp + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS ciclo;
	count <= count_tmp;
END contador_binario_arch;
