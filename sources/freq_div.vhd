---------------------------------------------------------
-- FREQ_DIV
-- creacion 27/03/05 . Revisado 17/03/06.
-- Revisad0 2/ag0/2011, cambio a variables como se lleva la cuenta
-- Circuito divisor de frecuencia
--
-- Para su uso deben ajustarse las constantes:
-- FREC_OUT : Frecuencia de reloj deseada (en Hz)
-- FREC_IN : Frecuencia de reloj entrante (en Hz)
--
---------------------------------------------------------

-----------------------------------------------------------
----- package PK_FREQ_DIV
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

PACKAGE PK_FREQ_DIV IS
   COMPONENT FREQ_DIV IS
	GENERIC (
		FREC_IN : INTEGER; -- Frecuencia de reloj entrante (Hz)
		FREC_OUT : INTEGER -- Frecuencia de reloj deseada (Hz)
	);
   	PORT(
         CLK_IN     : IN  STD_LOGIC;
		 CLK_OUT    : OUT STD_LOGIC
   	);
   END COMPONENT;
END PACKAGE;

-----------------------------------------------------------
----- ENTITY FREQ_DIV
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.MATH_REAL.ALL;

ENTITY FREQ_DIV IS
	GENERIC (
		FREC_IN : INTEGER := 50000000; -- Frecuencia de reloj entrante (Hz)
		FREC_OUT : INTEGER := 1 -- Frecuencia de reloj deseada (Hz)
	);
   	PORT(
      CLK_IN     : IN  STD_LOGIC;
   	  CLK_OUT    : OUT STD_LOGIC
   	);
END FREQ_DIV;

ARCHITECTURE synth of FREQ_DIV IS

-- Calculate the number of bits required to represent a given value
function NumBits(val : integer) return integer is
    variable result : integer;
begin
    if val=0 then
        result := 0;
    else
        result  := natural(ceil(log2(real(val))));
    end if;
    return result;
end;


-- Constants --------------------------------------
		
CONSTANT REL : INTEGER := ((FREC_IN / FREC_OUT)/2 );

-- Signals ----------------------------------------
signal CLK_OUT_AUX : std_logic;
signal CLK_COUNTER : std_logic_vector(NumBits(REL)-1 downto 0);

begin

-------------------------------------
CLK_DIVIDER_PROCESS: process(CLK_IN)
-------------------------------------
   begin
      if (CLK_IN'event and CLK_IN='1') then
         if (CLK_COUNTER > (REL-2)) then
            CLK_OUT_AUX <= not(CLK_OUT_AUX);
            CLK_COUNTER <= (others => '0');
         else 
            CLK_COUNTER <= CLK_COUNTER +1;
         end if;   
   end if;
end process;   

CLK_OUT <= CLK_OUT_AUX;

end synth;
