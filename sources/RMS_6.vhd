-----------------------------------------------------------
----- PACKAGE pk_RMS_3
-----------------------------------------------------------
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use ieee.STD_LOGIC_UNSIGNED.ALL;
--
--library work;
--use work.PK_FREQ_DIV.all;
--use work.pk_contador_binario.all;
--
--PACKAGE pk_RMS_6 IS
--	COMPONENT RMS_6 IS
--		PORT (
--			input_1 , input_2 , input_3 : IN STD_LOGIC_VECTOR(15 downto 0);
--			input_B1 , input_B2 , input_B3 : IN STD_LOGIC_VECTOR(15 downto 0);
--			ready_I  	: IN STD_LOGIC;
--			reset 		: IN STD_LOGIC;
--			clk 		: IN STD_LOGIC;
--			enable		: IN STD_LOGIC;
--			o_1, o_2, o_3: OUT STD_LOGIC_VECTOR(15 downto 0);
--			o_B1, o_B2, o_B3: OUT STD_LOGIC_VECTOR(15 downto 0)
--		);
--	END COMPONENT;
--END PACKAGE;
--
-------------------------------------------------------------
------- ENTITY RMS_3
-------------------------------------------------------------
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use ieee.STD_LOGIC_UNSIGNED.ALL;
--
--library work;
--use work.PK_FREQ_DIV.all;
--use work.pk_contador_binario.all;
--
--ENTITY RMS_6 IS
--	PORT (
--		input_1 , input_2 , input_3 : IN STD_LOGIC_VECTOR(15 downto 0);
--		input_B1 , input_B2 , input_B3 : IN STD_LOGIC_VECTOR(15 downto 0);
--		ready_I  	: IN STD_LOGIC;
--		reset 		: IN STD_LOGIC;
--		clk 		: IN STD_LOGIC;
--		enable		: IN STD_LOGIC;
--		o_1, o_2, o_3: OUT STD_LOGIC_VECTOR(15 downto 0);
--		o_B1, o_B2, o_B3: OUT STD_LOGIC_VECTOR(15 downto 0)
--	);
--END RMS_6;
--
--
-------------------------------------------------------------
------- ARCHITECTURE RMS_3
-------------------------------------------------------------
--ARCHITECTURE arch of RMS_6 IS
--------- Constant-----------------------------------------
--constant CONST_LPM_WIDTHD : natural := 32;
--constant CONST_LPM_WIDTHN : natural := 32;
--constant veinte : std_LOGIC_VECTOR (4 downto 0)  := "10100"; 
--
--------- Signals -----------------------------------------
--signal
--
--	XnB,Xn_B1,Xn_B2,Xn_B3,Xn_B4,
--	Xn_B5,Xn_B6,Xn_B7,Xn_B8,Xn_B9,
--	Xn_B10,Xn_B11,Xn_B12,Xn_B13,
--	Xn_B14,Xn_B15,Xn_B16,Xn_B17,
--	Xn_B18,Xn_B19,
--	--- Para I2
--	YnB,Yn_B1,Yn_B2,Yn_B3,Yn_B4,
--	Yn_B5,Yn_B6,Yn_B7,Yn_B8,Yn_B9,
--	Yn_B10,Yn_B11,Yn_B12,Yn_B13,
--	Yn_B14,Yn_B15,Yn_B16,Yn_B17,
--	Yn_B18,Yn_B19,
--	--- Para I3
--	ZnB,Zn_B1,Zn_B2,Zn_B3,Zn_B4,
--	Zn_B5,Zn_B6,Zn_B7,Zn_B8,Zn_B9,
--	Zn_B10,Zn_B11,Zn_B12,Zn_B13,
--	Zn_B14,Zn_B15,Zn_B16,Zn_B17,
--	Zn_B18,Zn_B19,
--	--- Para I1
--	Xn,Xn_1,Xn_2,Xn_3,Xn_4,
--	Xn_5,Xn_6,Xn_7,Xn_8,Xn_9,
--	Xn_10,Xn_11,Xn_12,Xn_13,
--	Xn_14,Xn_15,Xn_16,Xn_17,
--	Xn_18,Xn_19,
--	--- Para I2
--	Yn,Yn_1,Yn_2,Yn_3,Yn_4,
--	Yn_5,Yn_6,Yn_7,Yn_8,Yn_9,
--	Yn_10,Yn_11,Yn_12,Yn_13,
--	Yn_14,Yn_15,Yn_16,Yn_17,
--	Yn_18,Yn_19,
--	--- Para I3
--	Zn,Zn_1,Zn_2,Zn_3,Zn_4,
--	Zn_5,Zn_6,Zn_7,Zn_8,Zn_9,
--	Zn_10,Zn_11,Zn_12,Zn_13,
--	Zn_14,Zn_15,Zn_16,Zn_17,
--	Zn_18,Zn_19,
--	--- Operaciones
--	s_T_I1, s_T_I2, s_T_I3,
--	s_T_IB1, s_T_IB2, s_T_IB3,
--	R_T,  divide,
--	s_T
--
--: STD_LOGIC_VECTOR(31 downto 0) := (OTHERS => '0');
--
--signal result , out_1 , out_2 , out_3 , out_B1 , out_B2 , out_B3: STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');
--signal s_clk, clear, cont_en : STD_LOGIC;
--signal ready_I_rising, s_clk_rising : std_logic_vector(2 downto 0);
--signal Resto : STD_LOGIC_VECTOR(4 downto 0) := (OTHERS => '0');
--signal tope : std_logic_vector(1 downto 0);
--------- component lpm_div  -----------------------------------------
--component lpm_div IS
--	PORT
--	(
--		denom		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
--		numer		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--		quotient		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
--		remain		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
--	);
--END component;
--------- component lpm_add_sub_wizard  -----------------------------------------
--component lpm_add_sub_wizard IS
--	PORT
--	(
--		add_sub		: IN STD_LOGIC ;
--		dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--		datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
--	);
--END component;
--------- component sqrt_wizard  -----------------------------------------
--COMPONENT sqrt_wizard IS
--	PORT
--	(
--		radical		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
--		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
--		remainder		: OUT STD_LOGIC_VECTOR (16 DOWNTO 0)
--	);
--END COMPONENT;
----------- state_type  ---------------------------------------------------
--type state_type is
--		(state_I1, state_I2, state_I3, state_IB1, state_IB2, state_IB3,waiting_ready);
--	attribute enum_encoding : string;
--	attribute enum_encoding of state_type : type is "gray";
--	signal STATE, NXSTATE : state_type;
--------- BEGIN  ---------------------------------------------------------
--BEGIN
------------ new_sample process--------------------------------------------
--	new_sample : process(input_1,input_2,input_3, ready_I, enable,reset)
--	begin
--		if (ready_I'event AND ready_I = '1') then
--			if (enable = '1') and reset = '0' then
--			
--				Xn_19 <= Xn_18;	Xn_18 <= Xn_17;	Xn_17 <= Xn_16;	Xn_16 <= Xn_15;	Xn_15 <= Xn_14;
--				Xn_14 <= Xn_13;	Xn_13 <= Xn_12;	Xn_12 <= Xn_11;	Xn_11 <= Xn_10;	Xn_10 <= Xn_9;
--				Xn_9 <= Xn_8; Xn_8 <= Xn_7;	Xn_7 <= Xn_6; Xn_6 <= Xn_5;	Xn_5 <= Xn_4; Xn_4 <= Xn_3;	
--				Xn_3 <= Xn_2; Xn_2 <= Xn_1;	Xn_1 <= Xn;	
--				
--				Xn   <= STD_LOGIC_VECTOR(signed(input_1)*signed(input_1));
--				s_T_I1 <= Xn + Xn_1 + Xn_2 + Xn_3 + Xn_4 + Xn_5 + Xn_6 + Xn_7
--						     + Xn_8 + Xn_9 + Xn_10 + Xn_11 + Xn_12 + Xn_13 + Xn_14 + Xn_15
--						     + Xn_16 + Xn_17 + Xn_18 + Xn_19; 
--				Yn_19 <= Yn_18;	Yn_18 <= Yn_17;	Yn_17 <= Yn_16;	Yn_16 <= Yn_15;	Yn_15 <= Yn_14;
--				Yn_14 <= Yn_13;	Yn_13 <= Yn_12;	Yn_12 <= Yn_11;	Yn_11 <= Yn_10;	Yn_10 <= Yn_9;
--				Yn_9 <= Yn_8; Yn_8 <= Yn_7;	Yn_7 <= Yn_6; Yn_6 <= Yn_5;	Yn_5 <= Yn_4;
--				Yn_4 <= Yn_3; Yn_3 <= Yn_2;	Yn_2 <= Yn_1; Yn_1 <= Yn; 
--				Yn   <= STD_LOGIC_VECTOR(signed(input_2)*signed(input_2));
--					
--				s_T_I2 <= Yn + Yn_1 + Yn_2 + Yn_3 + Yn_4 + Yn_5 + Yn_6 + Yn_7
--						     + Yn_8 + Yn_9 + Yn_10 + Yn_11 + Yn_12 + Yn_13 + Yn_14 + Yn_15
--						     + Yn_16 + Yn_17 + Yn_18 + Yn_19;
--
--	
--				Zn_19 <= Zn_18; Zn_18 <= Zn_17;	Zn_17 <= Zn_16;	Zn_16 <= Zn_15;
--				Zn_15 <= Zn_14;	Zn_14 <= Zn_13;	Zn_13 <= Zn_12;
--				Zn_12 <= Zn_11;	Zn_11 <= Zn_10;	Zn_10 <= Zn_9;
--				Zn_9 <= Zn_8; Zn_8 <= Zn_7;	Zn_7 <= Zn_6; Zn_6 <= Zn_5; Zn_5 <= Zn_4;
--				Zn_4 <= Zn_3;Zn_3 <= Zn_2; Zn_2 <= Zn_1;Zn_1 <= Zn;
--				
--
--				Zn   <= STD_LOGIC_VECTOR(signed(input_3)*signed(input_3));
--				
--				s_T_I3 <= Zn + Zn_1 + Zn_2 + Zn_3 + Zn_4 + Zn_5 + Zn_6 + Zn_7
--							 + Zn_8 + Zn_9 + Zn_10 + Zn_11 + Zn_12 + Zn_13 + Zn_14 + Zn_15
--							 + Zn_16 + Zn_17 + Zn_18 + Zn_19;
--							 
--							 
--			-----------------------------------------------------		 
--							 
--							 
--				Xn_B19 <= Xn_B18;	Xn_B18 <= Xn_B17;	Xn_B17 <= Xn_B16;	Xn_B16 <= Xn_B15;	Xn_B15 <= Xn_B14;
--				Xn_B14 <= Xn_B13;	Xn_B13 <= Xn_B12;	Xn_B12 <= Xn_B11;	Xn_B11 <= Xn_B10;	Xn_B10 <= Xn_B9;
--				Xn_B9 <= Xn_B8; Xn_B8 <= Xn_B7;	Xn_B7 <= Xn_B6; Xn_B6 <= Xn_B5;	Xn_B5 <= Xn_B4; Xn_B4 <= Xn_B3;	
--				Xn_B3 <= Xn_B2; Xn_B2 <= Xn_B1;	Xn_B1 <= XnB;	
--				
--				XnB   <= STD_LOGIC_VECTOR(signed(input_B1)*signed(input_B1));
--				s_T_IB1 <= XnB + Xn_B1 + Xn_B2 + Xn_B3 + Xn_B4 + Xn_B5 + Xn_B6 + Xn_B7
--							 + Xn_B8 + Xn_B9 + Xn_B10 + Xn_B11 + Xn_B12 + Xn_B13 + Xn_B14 + Xn_B15
--							 + Xn_B16 + Xn_B17 + Xn_B18 + Xn_B19;
--						     
--				Yn_B19 <= Yn_B18;	Yn_B18 <= Yn_B17;	Yn_B17 <= Yn_B16;	Yn_B16 <= Yn_B15;	Yn_B15 <= Yn_B14;
--				Yn_B14 <= Yn_B13;	Yn_B13 <= Yn_B12;	Yn_B12 <= Yn_B11;	Yn_B11 <= Yn_B10;	Yn_B10 <= Yn_B9;
--				Yn_B9 <= Yn_B8; Yn_B8 <= Yn_B7;	Yn_B7 <= Yn_B6; Yn_B6 <= Yn_B5;	Yn_B5 <= Yn_B4; Yn_B4 <= Yn_B3;	
--				Yn_B3 <= Yn_B2; Yn_B2 <= Yn_B1;	Yn_B1 <= YnB;	
--				
--				YnB   <= STD_LOGIC_VECTOR(signed(input_B2)*signed(input_B2));
--					
--				s_T_IB2 <= YnB + Yn_B1 + Yn_B2 + Yn_B3 + Yn_B4 + Yn_B5 + Yn_B6 + Yn_B7
--							 + Yn_B8 + Yn_B9 + Yn_B10 + Yn_B11 + Yn_B12 + Yn_B13 + Yn_B14 + Yn_B15
--							 + Yn_B16 + Yn_B17 + Yn_B18 + Yn_B19;
--
--	
--				Zn_B19 <= Zn_B18;	Zn_B18 <= Zn_B17;	Zn_B17 <= Zn_B16;	Zn_B16 <= Zn_B15;	Zn_B15 <= Zn_B14;
--				Zn_B14 <= Zn_B13;	Zn_B13 <= Zn_B12;	Zn_B12 <= Zn_B11;	Zn_B11 <= Zn_B10;	Zn_B10 <= Zn_B9;
--				Zn_B9 <= Zn_B8; Zn_B8 <= Zn_B7;	Zn_B7 <= Zn_B6; Zn_B6 <= Zn_B5;	Zn_B5 <= Zn_B4; Zn_B4 <= Zn_B3;	
--				Zn_B3 <= Zn_B2; Zn_B2 <= Zn_B1;	Zn_B1 <= ZnB;	
--				
--
--				ZnB   <= STD_LOGIC_VECTOR(signed(input_B3)*signed(input_B3));
--				
--				s_T_IB3 <= ZnB + Zn_B1 + Zn_B2 + Zn_B3 + Zn_B4 + Zn_B5 + Zn_B6 + Zn_B7
--							 + Zn_B8 + Zn_B9 + Zn_B10 + Zn_B11 + Zn_B12 + Zn_B13 + Zn_B14 + Zn_B15
--							 + Zn_B16 + Zn_B17 + Zn_B18 + Zn_B19;
--		
--			end if;
--		end if;
--	end process;
--
--
------------ crono_behav process--------------------------------------------
-- crono_behav : process(STATE, ready_I, input_1,input_2,input_3,input_B1,input_B2,input_B3, ready_I, enable)
--	begin
--	
--		ready_I_rising <= ready_I_rising(ready_I_rising'left-1 downto 0) & ready_I;
--
--		case STATE is
--		
--			WHEN waiting_ready => 
--				if ready_I_rising(ready_I_rising'left downto ready_I_rising'left-1) = "01" then
--					if (enable = '1') then
--						NXSTATE <= state_I1;
--					end if;
--				end if;	
--			WHEN  state_I1 =>
--				divide  <= s_T_I1;
--				out_1 <= result;
--				NXSTATE <= state_I2;	
--			WHEN state_I2 =>
--				divide  <= s_T_I2;
--				out_2 <= result;
--				NXSTATE <= state_I3;
--			WHEN state_I3 =>
--				divide  <= s_T_I3;
--				out_3 <= result;
--				NXSTATE <= state_IB1;
--			WHEN  state_IB1 =>
--				divide  <= s_T_IB1;
--				out_B1 <= result;
--				NXSTATE <= state_IB2;	
--			WHEN state_IB2 =>
--				divide  <= s_T_I2;
--				out_B2 <= result;
--				NXSTATE <= state_IB3;
--			WHEN state_IB3 =>
--				divide  <= s_T_IB3;
--				out_B3 <= result;
--				NXSTATE <= waiting_ready;
--			WHEN others =>
--				NXSTATE <= waiting_ready;
--		end case;
--	end process;
--
--
-----------------
--address_counter : contador_binario 
-----------------
--	generic map (
--		N => 2
--	)
--	port map (
--		clk => clk, 
--	    clear => '1',--clear, 
--		enable => '1',--cont_en,
--	    COUNT_MAX => std_logic_vector(to_unsigned(2, 2)) ,
--	    -- COUNT_MAX tope del contador, en este caso corresponde a 20 -> cant de muestras en UN CICLO
--		count => tope
--	);
-------------------------
--t1 : lpm_div
-------------------------
--port map (
--	numer => divide,-- s_T,
--	denom => veinte,
--	quotient => R_T,
--	remain => Resto
--);
--
---------------------------
--sqrt : sqrt_wizard
---------------------------
--port map (
--	radical  => R_T,
--	q  => result
--);
--
--o_1 <= out_1;
--o_2 <= out_2;
--o_3 <= out_3;
--
--o_B1 <= out_B1;
--o_B2 <= out_B2;
--o_B3 <= out_B3;
--
-------- sync : process--
--sync : process (clk,reset,STATE)
--begin
-- if reset = '1' then
--	STATE <= waiting_ready;
--elsif clk'event and clk = '1' and tope = "00" then
--	STATE <= NXSTATE;
--end if;
--end process;
--
--
--END arch;

---------------------------------------------------------------------
------------------------ SIN MAQUINA DE ESTADOS ---------------------
---------------------------------------------------------------------

-----------------------------------------------------------
----- PACKAGE pk_RMS_3
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

PACKAGE pk_RMS_6 IS
	COMPONENT RMS_6 IS
		PORT (
			input_1 , input_2 , input_3 : IN STD_LOGIC_VECTOR(15 downto 0);
			input_B1 , input_B2 , input_B3 : IN STD_LOGIC_VECTOR(15 downto 0);
			ready_I  	: IN STD_LOGIC;
			reset 		: IN STD_LOGIC;
			clk 		: IN STD_LOGIC;
			enable		: IN STD_LOGIC;
			o_1, o_2, o_3: OUT STD_LOGIC_VECTOR(15 downto 0);
			o_B1, o_B2, o_B3: OUT STD_LOGIC_VECTOR(15 downto 0)
		);
	END COMPONENT;
END PACKAGE;

-----------------------------------------------------------
----- ENTITY RMS_3
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY RMS_6 IS
	PORT (
			input_1 , input_2 , input_3 : IN STD_LOGIC_VECTOR(15 downto 0);
			input_B1 , input_B2 , input_B3 : IN STD_LOGIC_VECTOR(15 downto 0);
			ready_I  	: IN STD_LOGIC;
			reset 		: IN STD_LOGIC;
			clk 		: IN STD_LOGIC;
			enable		: IN STD_LOGIC;
			o_1, o_2, o_3: OUT STD_LOGIC_VECTOR(15 downto 0);
			o_B1, o_B2, o_B3: OUT STD_LOGIC_VECTOR(15 downto 0)
	);
END RMS_6;

-----------------------------------------------------------
----- ARCHITECTURE RMS_3
-----------------------------------------------------------
ARCHITECTURE arch of RMS_6 IS
------- Constant-----------------------------------------
constant CONST_LPM_WIDTHD : natural := 32;
constant CONST_LPM_WIDTHN : natural := 32;
constant veinte : std_LOGIC_VECTOR (31 downto 0)  := "00000000000000000000000000010100"; 
------- Signals -----------------------------------------
signal

	XnB,Xn_B1,Xn_B2,Xn_B3,Xn_B4,
	Xn_B5,Xn_B6,Xn_B7,Xn_B8,Xn_B9,
	Xn_B10,Xn_B11,Xn_B12,Xn_B13,
	Xn_B14,Xn_B15,Xn_B16,Xn_B17,
	Xn_B18,Xn_B19,
	--- Para I2
	YnB,Yn_B1,Yn_B2,Yn_B3,Yn_B4,
	Yn_B5,Yn_B6,Yn_B7,Yn_B8,Yn_B9,
	Yn_B10,Yn_B11,Yn_B12,Yn_B13,
	Yn_B14,Yn_B15,Yn_B16,Yn_B17,
	Yn_B18,Yn_B19,
	--- Para I3
	ZnB,Zn_B1,Zn_B2,Zn_B3,Zn_B4,
	Zn_B5,Zn_B6,Zn_B7,Zn_B8,Zn_B9,
	Zn_B10,Zn_B11,Zn_B12,Zn_B13,
	Zn_B14,Zn_B15,Zn_B16,Zn_B17,
	Zn_B18,Zn_B19,
	--- Para I1
	Xn,Xn_1,Xn_2,Xn_3,Xn_4,
	Xn_5,Xn_6,Xn_7,Xn_8,Xn_9,
	Xn_10,Xn_11,Xn_12,Xn_13,
	Xn_14,Xn_15,Xn_16,Xn_17,
	Xn_18,Xn_19,
	--- Para I2
	Yn,Yn_1,Yn_2,Yn_3,Yn_4,
	Yn_5,Yn_6,Yn_7,Yn_8,Yn_9,
	Yn_10,Yn_11,Yn_12,Yn_13,
	Yn_14,Yn_15,Yn_16,Yn_17,
	Yn_18,Yn_19,
	--- Para I3
	Zn,Zn_1,Zn_2,Zn_3,Zn_4,
	Zn_5,Zn_6,Zn_7,Zn_8,Zn_9,
	Zn_10,Zn_11,Zn_12,Zn_13,
	Zn_14,Zn_15,Zn_16,Zn_17,
	Zn_18,Zn_19,
	--- Operaciones
	s_T_I1, s_T_I2, s_T_I3,
	s_T_IB1, s_T_IB2, s_T_IB3,
	R_T, R_T2, R_T3, R_TB, R_TB2, R_TB3,  divide,Resto,
	s_T
: STD_LOGIC_VECTOR(31 downto 0) := (OTHERS => '0');
signal 
	result , out_1 , out_2 , out_3 , out_B1 , out_B2 , out_B3
: STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');



signal ready_I_rising : std_logic_vector(2 downto 0);
------- component LPM_DIVIDE  -----------------------------------------
component LPM_DIVIDE
 generic (LPM_WIDTHN : natural;
			 LPM_WIDTHD : natural;
			LPM_NREPRESENTATION : string := "UNSIGNED";
			LPM_DREPRESENTATION : string := "UNSIGNED";
--			LPM_PIPELINE : natural := 0;
--			LPM_TYPE : string := L_DIVIDE;
			LPM_HINT : string := "UNUSED");
			port (NUMER : in std_logic_vector(LPM_WIDTHN-1 downto 0);
					DENOM : in std_logic_vector(LPM_WIDTHD-1 downto 0);
--					ACLR : in std_logic := '0';
					CLOCK : in std_logic := '0';
--					CLKEN : in std_logic := '1';
					QUOTIENT : out std_logic_vector(LPM_WIDTHN-1 downto 0);
					REMAIN : out std_logic_vector(LPM_WIDTHD-1 downto 0));
end component;
------- component sqrt_wizard  -----------------------------------------
COMPONENT sqrt_wizard IS
	PORT
	(
		radical		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		remainder		: OUT STD_LOGIC_VECTOR (16 DOWNTO 0)
	);
END COMPONENT;
BEGIN
---------- new_sample process--------------------------------------------
---------- new_sample process--------------------------------------------
	new_sample : process(input_1,input_2,input_3, ready_I, enable,reset)
	begin
		if (ready_I'event AND ready_I = '1') then
			if (enable = '1') and reset = '0' then
			
				Xn_19 <= Xn_18;	Xn_18 <= Xn_17;	Xn_17 <= Xn_16;	Xn_16 <= Xn_15;	Xn_15 <= Xn_14;
				Xn_14 <= Xn_13;	Xn_13 <= Xn_12;	Xn_12 <= Xn_11;	Xn_11 <= Xn_10;	Xn_10 <= Xn_9;
				Xn_9 <= Xn_8; Xn_8 <= Xn_7;	Xn_7 <= Xn_6; Xn_6 <= Xn_5;	Xn_5 <= Xn_4; Xn_4 <= Xn_3;	
				Xn_3 <= Xn_2; Xn_2 <= Xn_1;	Xn_1 <= Xn;	
				
				Xn   <= STD_LOGIC_VECTOR(signed(input_1)*signed(input_1));
				s_T_I1 <= Xn + Xn_1 + Xn_2 + Xn_3 + Xn_4 + Xn_5 + Xn_6 + Xn_7
						     + Xn_8 + Xn_9 + Xn_10 + Xn_11 + Xn_12 + Xn_13 + Xn_14 + Xn_15
						     + Xn_16 + Xn_17 + Xn_18 + Xn_19; 
				Yn_19 <= Yn_18;	Yn_18 <= Yn_17;	Yn_17 <= Yn_16;	Yn_16 <= Yn_15;	Yn_15 <= Yn_14;
				Yn_14 <= Yn_13;	Yn_13 <= Yn_12;	Yn_12 <= Yn_11;	Yn_11 <= Yn_10;	Yn_10 <= Yn_9;
				Yn_9 <= Yn_8; Yn_8 <= Yn_7;	Yn_7 <= Yn_6; Yn_6 <= Yn_5;	Yn_5 <= Yn_4;
				Yn_4 <= Yn_3; Yn_3 <= Yn_2;	Yn_2 <= Yn_1; Yn_1 <= Yn; 
				Yn   <= STD_LOGIC_VECTOR(signed(input_2)*signed(input_2));
					
				s_T_I2 <= Yn + Yn_1 + Yn_2 + Yn_3 + Yn_4 + Yn_5 + Yn_6 + Yn_7
						     + Yn_8 + Yn_9 + Yn_10 + Yn_11 + Yn_12 + Yn_13 + Yn_14 + Yn_15
						     + Yn_16 + Yn_17 + Yn_18 + Yn_19;

	
				Zn_19 <= Zn_18; Zn_18 <= Zn_17;	Zn_17 <= Zn_16;	Zn_16 <= Zn_15;
				Zn_15 <= Zn_14;	Zn_14 <= Zn_13;	Zn_13 <= Zn_12;
				Zn_12 <= Zn_11;	Zn_11 <= Zn_10;	Zn_10 <= Zn_9;
				Zn_9 <= Zn_8; Zn_8 <= Zn_7;	Zn_7 <= Zn_6; Zn_6 <= Zn_5; Zn_5 <= Zn_4;
				Zn_4 <= Zn_3;Zn_3 <= Zn_2; Zn_2 <= Zn_1;Zn_1 <= Zn;
				

				Zn   <= STD_LOGIC_VECTOR(signed(input_3)*signed(input_3));
				
				s_T_I3 <= Zn + Zn_1 + Zn_2 + Zn_3 + Zn_4 + Zn_5 + Zn_6 + Zn_7
							 + Zn_8 + Zn_9 + Zn_10 + Zn_11 + Zn_12 + Zn_13 + Zn_14 + Zn_15
							 + Zn_16 + Zn_17 + Zn_18 + Zn_19;
							 
							 
			-----------------------------------------------------		 
							 
							 
				Xn_B19 <= Xn_B18;	Xn_B18 <= Xn_B17;	Xn_B17 <= Xn_B16;	Xn_B16 <= Xn_B15;	Xn_B15 <= Xn_B14;
				Xn_B14 <= Xn_B13;	Xn_B13 <= Xn_B12;	Xn_B12 <= Xn_B11;	Xn_B11 <= Xn_B10;	Xn_B10 <= Xn_B9;
				Xn_B9 <= Xn_B8; Xn_B8 <= Xn_B7;	Xn_B7 <= Xn_B6; Xn_B6 <= Xn_B5;	Xn_B5 <= Xn_B4; Xn_B4 <= Xn_B3;	
				Xn_B3 <= Xn_B2; Xn_B2 <= Xn_B1;	Xn_B1 <= XnB;	
				
				XnB   <= STD_LOGIC_VECTOR(signed(input_B1)*signed(input_B1));
				s_T_IB1 <= XnB + Xn_B1 + Xn_B2 + Xn_B3 + Xn_B4 + Xn_B5 + Xn_B6 + Xn_B7
							 + Xn_B8 + Xn_B9 + Xn_B10 + Xn_B11 + Xn_B12 + Xn_B13 + Xn_B14 + Xn_B15
							 + Xn_B16 + Xn_B17 + Xn_B18 + Xn_B19;
						     
				Yn_B19 <= Yn_B18;	Yn_B18 <= Yn_B17;	Yn_B17 <= Yn_B16;	Yn_B16 <= Yn_B15;	Yn_B15 <= Yn_B14;
				Yn_B14 <= Yn_B13;	Yn_B13 <= Yn_B12;	Yn_B12 <= Yn_B11;	Yn_B11 <= Yn_B10;	Yn_B10 <= Yn_B9;
				Yn_B9 <= Yn_B8; Yn_B8 <= Yn_B7;	Yn_B7 <= Yn_B6; Yn_B6 <= Yn_B5;	Yn_B5 <= Yn_B4; Yn_B4 <= Yn_B3;	
				Yn_B3 <= Yn_B2; Yn_B2 <= Yn_B1;	Yn_B1 <= YnB;	
				
				YnB   <= STD_LOGIC_VECTOR(signed(input_B2)*signed(input_B2));
					
				s_T_IB2 <= YnB + Yn_B1 + Yn_B2 + Yn_B3 + Yn_B4 + Yn_B5 + Yn_B6 + Yn_B7
							 + Yn_B8 + Yn_B9 + Yn_B10 + Yn_B11 + Yn_B12 + Yn_B13 + Yn_B14 + Yn_B15
							 + Yn_B16 + Yn_B17 + Yn_B18 + Yn_B19;

	
				Zn_B19 <= Zn_B18;	Zn_B18 <= Zn_B17;	Zn_B17 <= Zn_B16;	Zn_B16 <= Zn_B15;	Zn_B15 <= Zn_B14;
				Zn_B14 <= Zn_B13;	Zn_B13 <= Zn_B12;	Zn_B12 <= Zn_B11;	Zn_B11 <= Zn_B10;	Zn_B10 <= Zn_B9;
				Zn_B9 <= Zn_B8; Zn_B8 <= Zn_B7;	Zn_B7 <= Zn_B6; Zn_B6 <= Zn_B5;	Zn_B5 <= Zn_B4; Zn_B4 <= Zn_B3;	
				Zn_B3 <= Zn_B2; Zn_B2 <= Zn_B1;	Zn_B1 <= ZnB;	
				

				ZnB   <= STD_LOGIC_VECTOR(signed(input_B3)*signed(input_B3));
				
				s_T_IB3 <= ZnB + Zn_B1 + Zn_B2 + Zn_B3 + Zn_B4 + Zn_B5 + Zn_B6 + Zn_B7
							 + Zn_B8 + Zn_B9 + Zn_B10 + Zn_B11 + Zn_B12 + Zn_B13 + Zn_B14 + Zn_B15
							 + Zn_B16 + Zn_B17 + Zn_B18 + Zn_B19;
		
			end if;
		end if;
	end process;

-----------------------
t1 : LPM_DIVIDE
-----------------------
generic map (
	LPM_WIDTHN => CONST_LPM_WIDTHD,
	LPM_WIDTHD => CONST_LPM_WIDTHN
)
port map (
	NUMER => s_T_I1, 
	DENOM => veinte,
	QUOTIENT => R_T,
	REMAIN => Resto
);
-----------------------
sqrt_1 : sqrt_wizard
-----------------------
port map (
	radical  => R_T,
	q  => out_1
);

-----------------------
t2 : LPM_DIVIDE
-----------------------
generic map (
	LPM_WIDTHN => CONST_LPM_WIDTHD,
	LPM_WIDTHD => CONST_LPM_WIDTHN
)
port map (
	NUMER => s_T_I2, 
	DENOM => veinte,
	QUOTIENT => R_T2,
	REMAIN => Resto
);
-----------------------
sqrt_2 : sqrt_wizard
-----------------------
port map (
	radical  => R_T2,
	q  => out_2
);

-----------------------
t3 : LPM_DIVIDE
-----------------------
generic map (
	LPM_WIDTHN => CONST_LPM_WIDTHD,
	LPM_WIDTHD => CONST_LPM_WIDTHN
)
port map (
	NUMER => s_T_I3, 
	DENOM => veinte,
	QUOTIENT => R_T3,
	REMAIN => Resto
);
-----------------------
sqrt_3 : sqrt_wizard
-----------------------
port map (
	radical  => R_T3,
	q  => out_3
);


-----------------------
tB1 : LPM_DIVIDE
-----------------------
generic map (
	LPM_WIDTHN => CONST_LPM_WIDTHD,
	LPM_WIDTHD => CONST_LPM_WIDTHN
)
port map (
	NUMER => s_T_IB1, 
	DENOM => veinte,
	QUOTIENT => R_TB,
	REMAIN => Resto
);
-----------------------
sqrt_B1 : sqrt_wizard
-----------------------
port map (
	radical  => R_TB,
	q  => out_B1
);

-----------------------
tB2 : LPM_DIVIDE
-----------------------
generic map (
	LPM_WIDTHN => CONST_LPM_WIDTHD,
	LPM_WIDTHD => CONST_LPM_WIDTHN
)
port map (
	NUMER => s_T_IB2, 
	DENOM => veinte,
	QUOTIENT => R_TB2,
	REMAIN => Resto
);
-----------------------
sqrt_B2 : sqrt_wizard
-----------------------
port map (
	radical  => R_TB2,
	q  => out_B2
);

-----------------------
tB3 : LPM_DIVIDE
-----------------------
generic map (
	LPM_WIDTHN => CONST_LPM_WIDTHD,
	LPM_WIDTHD => CONST_LPM_WIDTHN
)
port map (
	NUMER => s_T_IB3, 
	DENOM => veinte,
	QUOTIENT => R_TB3,
	REMAIN => Resto
);
-----------------------
sqrt_B3 : sqrt_wizard
-----------------------
port map (
	radical  => R_TB3,
	q  => out_B3
);


o_1 <= out_1;
o_2 <= out_2;
o_3 <= out_3;
o_B1 <= out_B1;
o_B2 <= out_B2;
o_B3 <= out_B3;


END arch;





