---------------------------
------ MERGING UNIT -------
---------------------------

-- EMULATOR--------------

-- Esta unidad emula el comportamiento
-- de la Merging Unit, a traves de una 
-- ROM cargada con una sinusoidal de 50Hz,
-- y una READY_SIGNAL generada por un clk
-- a 1kHz

-----------------------------------------------------------
----- PACKAGE pk_mu_emulator
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

PACKAGE pk_mu_emulator IS
   COMPONENT mu_emulator IS
	GENERIC (
		N_bits : integer;
		M_bits : integer;
		fault_time     : integer;     -- Fault Time, tiempo en ms para que se produzca la falla
		fault_magnitude : integer     -- how big is the fault, ex. Amp = 400 y FM = 10 => FaultAmp = 4000
	);
   	PORT (
		enable : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		clk  : IN STD_LOGIC;
		current_fault_I_A : IN STD_LOGIC;
		current_fault_I_B : IN STD_LOGIC;
		current_fault_I_C : IN STD_LOGIC;

		
		ready			: OUT STD_LOGIC;
		address			: out std_logic_vector(M_bits-1 downto 0); --Para guardar enla misma direccion de la ram
		I_A             : OUT STD_LOGIC_VECTOR(N_bits-1 downto 0);
		I_B             : OUT STD_LOGIC_VECTOR(N_bits-1 downto 0);
		I_C             : OUT STD_LOGIC_VECTOR(N_bits-1 downto 0)
	);
   END COMPONENT;
END PACKAGE;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.PK_FREQ_DIV.all;
use work.pk_contador_binario.all;


ENTITY mu_emulator IS
	GENERIC (
		N_bits : integer := 16;
		M_bits : integer := 5;
		fault_time     : integer := 500;     -- Fault Time, tiempo en ms para que se produzca la falla
		fault_magnitude : integer := 10     -- how big is the fault, ex. Amp = 400 y FM = 10 => FaultAmp = 4000
	);
	PORT (
		-- INPUT
		clk				: IN STD_LOGIC;
		reset			: IN STD_LOGIC;
		enable 			: IN STD_LOGIC;
		current_fault_I_A : IN STD_LOGIC;
		current_fault_I_B : IN STD_LOGIC;
		current_fault_I_C : IN STD_LOGIC;
		
		-- OUTPUT
		ready			: OUT STD_LOGIC;
		address			: out std_logic_vector(M_bits-1 downto 0);
		I_A             : OUT STD_LOGIC_VECTOR(N_bits-1 downto 0);
		I_B             : OUT STD_LOGIC_VECTOR(N_bits-1 downto 0);
		I_C             : OUT STD_LOGIC_VECTOR(N_bits-1 downto 0)
		
		
	);
END mu_emulator;

ARCHITECTURE arch of mu_emulator IS

CONSTANT T_ms_bits : integer := 16;  -- hasta 64k ms para tiempo de falla eq 64seg
signal time_ms     : STD_LOGIC_VECTOR(T_ms_bits-1 downto 0);
signal s_clk_ms    : STD_LOGIC;

SIGNAL s_clk      : STD_LOGIC;
signal s_address  : std_logic_vector(M_bits-1 downto 0);

signal I_A_signal	   : std_logic_vector(N_bits-1 downto 0);
signal I_B_signal	   : std_logic_vector(N_bits-1 downto 0);
signal I_C_signal	   : std_logic_vector(N_bits-1 downto 0);




signal ready_signal         : STD_LOGIC;


signal I_A_fault : std_logic_vector(2*N_bits-1 downto 0);
signal I_B_fault : std_logic_vector(2*N_bits-1 downto 0);
signal I_C_fault : std_logic_vector(2*N_bits-1 downto 0);



component signal_IA IS
	PORT
	(
		address			: IN STD_LOGIC_VECTOR (M_bits-1 DOWNTO 0);
		clock			: IN STD_LOGIC ;
		q				: OUT STD_LOGIC_VECTOR (N_bits-1 DOWNTO 0)
	);
END component;

component signal_IB IS
	PORT
	(
		address			: IN STD_LOGIC_VECTOR (M_bits-1 DOWNTO 0);
		clock			: IN STD_LOGIC ;
		q				: OUT STD_LOGIC_VECTOR (N_bits-1 DOWNTO 0)
	);
END component;

component signal_IC IS
	PORT
	(
		address			: IN STD_LOGIC_VECTOR (M_bits-1 DOWNTO 0);
		clock			: IN STD_LOGIC ;
		q				: OUT STD_LOGIC_VECTOR (N_bits-1 DOWNTO 0)
	);
END component;


BEGIN

--s_clk <= clk;

-------------------
 ready_signal_inst : FREQ_DIV
-------------------
	generic map (
		FREC_IN => 50000,
		FREC_OUT => 1000
	 )
	 port map (
		 CLK_IN => clk,
		 CLK_OUT => s_clk
	 );
	
---------------
address_counter : contador_binario 
---------------
	generic map (
		N => M_bits
	)
	port map (
		clk => s_clk, 
	    clear => NOT reset, 
		enable => enable,
	    count => s_address,
	    COUNT_MAX => std_logic_vector(to_unsigned(20, M_bits)) 
	    -- COUNT_MAX tope del contador, en este caso corresponde a 20 -> cant de muestras en UN CICLO
	);
	address <= s_address;


--------------
I_A_signal_rom : signal_IA
--------------
	PORT MAP (
		address	 => s_address,
		clock	 => clk,
		q	 	 => I_A_signal
	);
	
--------------
I_B_signal_rom : signal_IB 
--------------
	PORT MAP (
		address	 => s_address,
		clock	 => clk,
		q	 	 => I_B_signal
	);

--------------
I_C_signal_rom : signal_IC 
--------------
	PORT MAP (
		address	 => s_address,
		clock	 => clk,
		q	 	 => I_C_signal
	);
	
	
---------------------
-- clk_ms : FREQ_DIV
---------------------
--	generic map (
--		FREC_IN => 50000,
--		FREC_OUT => 1000
--	 )
--	 port map (
--		 CLK_IN => clk,
--		 CLK_OUT => s_clk_ms
--	 );
	 
-----------------
--time_ms_counter : contador_binario 
-----------------
--	generic map (
--		N => T_ms_bits -- hasta 64k ms para tiempo de falla eq 64seg
--	)
--	port map (
--		clk => s_clk_ms, 
--	    clear => NOT reset, 
--		enable => enable,
--	    count => time_ms
--	);

--current_fault : process(time_ms)
--BEGIN
--	IF (clk'event AND clk = '1') THEN
--		IF (I_A_fault = '1') THEN
--			IF (to_integer(unsigned(time_ms)) < fault_time) THEN
--				I_A <= s_data;
--			ELSE
--				I_A_32 <= (s_data*std_logic_vector(to_signed(fault_magnitude, s_data'length)));
--				I_A <= I_A_32(15 downto 0);
--			END IF;
--		END IF;
--	END IF;
--END process current_fault;


I_A_fault <= (I_A_signal*std_logic_vector(to_signed(fault_magnitude, N_bits)));

I_A <= I_A_fault(N_bits-1 downto 0) when current_fault_I_A = '1' else
	   I_A_signal;
	   
	   
I_B_fault <= (I_B_signal*std_logic_vector(to_signed(fault_magnitude, N_bits)));

I_B <= I_B_fault(N_bits-1 downto 0) when current_fault_I_B = '1' else
	   I_B_signal;
	   
I_C_fault <= (I_C_signal*std_logic_vector(to_signed(fault_magnitude, N_bits)));

I_C <= I_C_fault(N_bits-1 downto 0) when current_fault_I_C = '1' else
	   I_C_signal;
	   

ready <= s_clk;

END ARCHITECTURE;
