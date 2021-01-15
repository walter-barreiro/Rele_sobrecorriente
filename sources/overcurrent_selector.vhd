--------------------------------------
---- SELECTOR DE SOBRECORRIENTE ------
--------------------------------------

-----------------------------------------------------------
----- package pk_overcurrent_selector
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

PACKAGE pk_overcurrent_selector IS
   COMPONENT overcurrent_selector IS
	GENERIC (
		N : INTEGER -- Sample WIDTH I_A
	);
   	PORT(
		clk     		: IN  STD_LOGIC;
		ready	    	: IN  STD_LOGIC;
		I_A_rms 		: IN  STD_LOGIC_VECTOR(N-1 downto 0);
		I_B_rms 		: IN  STD_LOGIC_VECTOR(N-1 downto 0);
		I_C_rms 		: IN  STD_LOGIC_VECTOR(N-1 downto 0);
		enable      	: IN  STD_LOGIC;
		reset 	    	: IN  STD_LOGIC;
		I_sp            : IN  INTEGER;  -- Current setpoint, asintota vertical, ser consistentes con la memoria que este cargada?
		Im              : IN  INTEGER;	
		response_time_test : OUT STD_LOGIC_VECTOR(10 downto 0);
		fault_time_test    : OUT STD_LOGIC_VECTOR(10 downto 0);
		
		OVERCURRENT : OUT STD_LOGIC -- Senial de sobrecorriente
   	);
   END COMPONENT;
END PACKAGE;

-----------------------------------------------------------
----- ENTITY overcurrent_selector
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.PK_FREQ_DIV.all;
use work.pk_contador_binario.all;

ENTITY overcurrent_selector IS
	GENERIC (
		N : INTEGER := 16 -- Sample WIDTH
	);
   	PORT(
		clk     		: IN  STD_LOGIC;
		ready	    	: IN  STD_LOGIC;
		I_A_rms 		: IN  STD_LOGIC_VECTOR(N-1 downto 0);
		I_B_rms 		: IN  STD_LOGIC_VECTOR(N-1 downto 0);
		I_C_rms 		: IN  STD_LOGIC_VECTOR(N-1 downto 0);
		enable      	: IN  STD_LOGIC;
		reset 	    	: IN  STD_LOGIC;
		I_sp            : IN  INTEGER;  -- Current setpoint, asintota vertical, ser consistentes con la memoria que este cargada?
		Im              : IN  INTEGER;------ Agregar corriente de falla instantanea...
		response_time_test : OUT STD_LOGIC_VECTOR(10 downto 0);
		fault_time_test    : OUT STD_LOGIC_VECTOR(10 downto 0);

		OVERCURRENT : OUT STD_LOGIC -- Senial de sobrecorriente
   	);
END overcurrent_selector;

ARCHITECTURE arch of overcurrent_selector IS


component IDMT_SI_200_01_rom IS
	PORT
	(
		address			: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock			: IN STD_LOGIC ;
		q				: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
	);
END component;


signal I_A_rms_dir, I_B_rms_dir, I_C_rms_dir    : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');

signal I_A_in_fault_zone, I_B_in_fault_zone, I_C_in_fault_zone : STD_LOGIC;

signal T_I_A, T_I_B, T_I_C : STD_LOGIC_VECTOR(10 downto 0);

signal I_A_fault_time, I_B_fault_time, I_C_fault_time : STD_LOGIC_VECTOR(10 downto 0);

signal I_A_response_time, I_B_response_time, I_C_response_time : STD_LOGIC_VECTOR(10 downto 0);


signal s_clk       : STD_LOGIC;

signal I_A_times_up, I_B_times_up, I_C_times_up, times_up    : STD_LOGIC;


begin

-------------------
-- Over Current? --
-------------------

-- Posible idea, suponiendo que LSB del tiempo t equivale a 50ms
-- podriamos usar un contador y un FREC_DIV que funcione a 50ms es decir 
-- si tenemos 50000000Hz y queremos una serian 20Hz la salida que queremos
-- 20Hz = 1000/50ms ?
-- Y creo que aca es el unico momento que se necesita tranformar la corriente 
-- con lo de LSB 1.024, para comparar en la LOOKUP TABLE

-- La direccion para ver en la rom va a ser I_rms - 1 - Amplitud_Falla  si es mayor a 0,
-- entonces la direccion 0 corresponderia a cuando hay amplitud de falla + 1
-- porque en amp de falla el t es inf.

-- Estuve pensando formas de implementear lo de LSB 1.024, una idea podria ser multiplicar por 1024 i.e. 
-- shiftear a la izquierda 10 lugares y despues dividir entre 1000 y ta quedarnos con la parte entera de eso

-- Creo que hacer la conversion al final es mejor porque nos evitamos arrastrar errores de redondeo por ej




-- Tenemos, en principio crear 2 curvas SI 
-- Una con I_sp = 200 y otra I_sp = 800
-- Zona de falla con curva desde 1.1xI_sp - 20xI_sp
-- Despues de los 20xIsp indicar sobrecorriente de forma instantanea



-- Luego con el tiempo obtenido, se compara periodicamente
-- con un timer que arranca en el primer
-- llamado de sobrecorriente, si el tiempo transcurrido
-- es mayor que el tiempo marcado por T(I_rms) automaticamente
-- se dispara la senial de OVERCURRENT


-- POR LO QUE ESTUVE LEYENDO, NO LLEGUE A PROBAR
-- SE PUEDE UTILIZAR COMPARADORES DEL ESTILO > O <


--if unsigned(I_A_rms) > 20*I_sp then -- Instantanea
--	response_time <= 0;
--elsif unsigned(I_A_rms) > I_sp then -- Aca en realidad seria 1.1xIsp
--	I_A_dir <= unsigned(I_A_rms) - I_sp - 1;
--	response_time <= T_I_signal;
--else
--	-- fuera de la zona de fallos, deberiamos resetear el timer?


-- Estaba pensando tambien que podriamos hacer una sola curva con TMS = 0.1
-- Y cuando aumenten el TMS es solo multiplicar por los valores de esa tabla
-- Ej. TMS = 0.5 => 5*0.1, pedimos que ingrese el TMS*10
-- Ej TMS = 1    => debe ingresar 10 ent. 10*0.1 = 1
-- Es claro que esto solo sirve para los multiplos del 1-10 de 0.1
-- de esta forma no podemos crear por ej una tabla con TMS = 0.27



---------------------------------------
---------- CRONO-TIMER ----------------
---------------------------------------

-------------------
 timer_clock : FREQ_DIV
-------------------
	generic map (
		FREC_IN => 50000,
		FREC_OUT => 20   ------- 20Hz son 20 ciclos por segundo entonces 20*50 = 1000 ms = 1s  
	 )
	 port map (
		 CLK_IN => clk,
		 CLK_OUT => s_clk
	 );

---------------
timer_counter_A : contador_binario 
---------------
	generic map (
		N => 11      -- Era el numero de bits que manejabamos para el tiempo 2^11 = 2048 (50ms) => 
	)
	port map (
		clk    => s_clk, 
	    clear  => I_A_in_fault_zone, -- si esta en la zona de falla no se hace el clear (se activa por bajo)
		enable => enable,
	    count  => I_A_fault_time
	);
	
	
---------------
timer_counter_B : contador_binario 
---------------
	generic map (
		N => 11      -- Era el numero de bits que manejabamos para el tiempo 2^11 = 2048 (50ms) => 
	)
	port map (
		clk    => s_clk, 
	    clear  => I_B_in_fault_zone, -- si esta en la zona de falla no se hace el clear (se activa por bajo)
		enable => enable,
	    count  => I_B_fault_time
	);

---------------
timer_counter_C : contador_binario 
---------------
	generic map (
		N => 11      -- Era el numero de bits que manejabamos para el tiempo 2^11 = 2048 (50ms) => 
	)
	port map (
		clk    => s_clk, 
	    clear  => I_C_in_fault_zone, -- si esta en la zona de falla no se hace el clear (se activa por bajo)
		enable => enable,
	    count  => I_C_fault_time
	);



I_A_in_fault_zone <= '1' WHEN unsigned(I_A_rms) > I_sp ELSE
				     '0';
				     
I_B_in_fault_zone <= '1' WHEN unsigned(I_B_rms) > I_sp ELSE
				     '0';
				     
I_C_in_fault_zone <= '1' WHEN unsigned(I_C_rms) > I_sp ELSE
				     '0';
				     
				 

I_A_rms_dir <= I_A_rms - I_sp - 1;

I_B_rms_dir <= I_B_rms - I_sp - 1;

I_C_rms_dir <= I_C_rms - I_sp - 1;



--------------
IDMT_LUP_I_A : IDMT_SI_200_01_rom
--------------
	PORT MAP (
		address	 => I_A_rms_dir(11 downto 0), -- es una especie de redireccion
		clock	 => clk,
		q	 	 => T_I_A
	);
	
--------------
IDMT_LUP_I_B : IDMT_SI_200_01_rom
--------------
	PORT MAP (
		address	 => I_B_rms_dir(11 downto 0), -- es una especie de redireccion
		clock	 => clk,
		q	 	 => T_I_B
	);

--------------
IDMT_LUP_I_C : IDMT_SI_200_01_rom
--------------
	PORT MAP (
		address	 => I_C_rms_dir(11 downto 0), -- es una especie de redireccion
		clock	 => clk,
		q	 	 => T_I_C
	);
	
	
--------------------------------
--I_A_response_time <= (OTHERS => '0') WHEN (unsigned(I_A_rms) > Im) ELSE
--				     T_I_A
				     
I_A_response_time <= T_I_A WHEN (unsigned(I_A_rms) < Im) ELSE
				     (OTHERS => '0');

I_B_response_time <= T_I_B WHEN (unsigned(I_B_rms) < Im) ELSE
				     (OTHERS => '0');
				     
I_C_response_time <= T_I_C WHEN (unsigned(I_C_rms) < Im) ELSE
				     (OTHERS => '0');
				  
				  
I_A_times_up <= '0' WHEN I_A_response_time > I_A_fault_time ELSE
				'1';
I_B_times_up <= '0' WHEN I_B_response_time > I_B_fault_time ELSE
				'1';
I_C_times_up <= '0' WHEN I_C_response_time > I_C_fault_time ELSE
				'1';
				
times_up <=  I_A_times_up OR I_B_times_up OR I_C_times_up;

			 
			  
sobre : process(ready)
begin
if (ready'event AND ready = '1') then
	if times_up = '1' then
		OVERCURRENT <= '1';
	else
		OVERCURRENT <= '0';
	end if;
end if;
end process sobre;

--OVERCURRENT <= '0' WHEN response_time > fault_time ELSE
--				   '1';

response_time_test <= I_A_response_time;
fault_time_test <= I_A_fault_time;

-- Creo que hay que usar la senial ready para procesar las seniales, porque I_A_rms tiene muchos cambios antes de quedar fija


end arch;
