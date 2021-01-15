-----------------------------------------------------------
----- PACKAGE pk_RMS_3
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.PK_FREQ_DIV.all;
use work.pk_contador_binario.all;

PACKAGE pk_RMS_3 IS
	COMPONENT RMS_3 IS
		PORT (
			input_1 , input_2 , input_3 : IN STD_LOGIC_VECTOR(15 downto 0);
			ready_I  	: IN STD_LOGIC;
			reset 		: IN STD_LOGIC;
			clk 		: IN STD_LOGIC;
			enable		: IN STD_LOGIC;
			o_1, o_2, o_3: OUT STD_LOGIC_VECTOR(15 downto 0)
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

library work;
use work.PK_FREQ_DIV.all;
use work.pk_contador_binario.all;

ENTITY RMS_3 IS
	PORT (
		input_1 , input_2 , input_3 : IN STD_LOGIC_VECTOR(15 downto 0);
		ready_I  : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		clk   : IN STD_LOGIC;
		enable: IN STD_LOGIC;
		o_1, o_2, o_3: OUT STD_LOGIC_VECTOR(15 downto 0)
	);
END RMS_3;


-----------------------------------------------------------
----- ARCHITECTURE RMS_3
-----------------------------------------------------------
ARCHITECTURE arch of RMS_3 IS
------- Constant-----------------------------------------
constant CONST_LPM_WIDTHD : natural := 32;
constant CONST_LPM_WIDTHN : natural := 32;
constant veinte : std_LOGIC_VECTOR (4 downto 0)  := "10100"; 

------- Signals -----------------------------------------
signal

--	Sn,Sn_1,Sn_2,Sn_3,Sn_4,
--	Sn_5,Sn_6,Sn_7,Sn_8,Sn_9,
--	Sn_10,Sn_11,Sn_12,Sn_13,
--	Sn_14,Sn_15,Sn_16,Sn_17,
--	Sn_18,Sn_19,
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
	R_T,  divide,

	s_dataa_sub, s_datab_sub,s_datab_add, s_T,
	s_sub_result, s_T_I1_ant, s_T_I2_ant, s_T_I3_ant


: STD_LOGIC_VECTOR(31 downto 0) := (OTHERS => '0');

signal result , out_1 , out_2 , out_3 : STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');
signal s_clk, clear, cont_en : STD_LOGIC;
signal ready_I_rising, s_clk_rising : std_logic_vector(2 downto 0);
signal Resto : STD_LOGIC_VECTOR(4 downto 0) := (OTHERS => '0');
signal tope : std_logic_vector(1 downto 0);
------- component lpm_div  -----------------------------------------
component lpm_div IS
	PORT
	(
		denom		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		numer		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		quotient		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		remain		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
	);
END component;
------- component lpm_add_sub_wizard  -----------------------------------------
component lpm_add_sub_wizard IS
	PORT
	(
		add_sub		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;
------- component sqrt_wizard  -----------------------------------------
COMPONENT sqrt_wizard IS
	PORT
	(
		radical		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		remainder		: OUT STD_LOGIC_VECTOR (16 DOWNTO 0)
	);
END COMPONENT;
--------- state_type  ---------------------------------------------------
type state_type is
		(state_I1, state_I2, state_I3, waiting_ready);
	attribute enum_encoding : string;
	attribute enum_encoding of state_type : type is "gray";
	signal STATE, NXSTATE : state_type;
------- BEGIN  ---------------------------------------------------------
BEGIN
---------- new_sample process--------------------------------------------
	new_sample : process(input_1,input_2,input_3, ready_I, enable,reset)
	begin
		if (ready_I'event AND ready_I = '1') then
			if (enable = '1') and reset = '0' then
			
			
--				s_T_I1 <= std_logic_vector(unsigned(s_T_I1) - unsigned(Xn_19)) + STD_LOGIC_VECTOR(signed(input_1)*signed(input_1));
--				s_T_I2 <= std_logic_vector(unsigned(s_T_I2) - unsigned(Yn_19)) + STD_LOGIC_VECTOR(signed(input_2)*signed(input_2));
--				s_T_I3 <= std_logic_vector(unsigned(s_T_I3) - unsigned(Zn_19)) + STD_LOGIC_VECTOR(signed(input_3)*signed(input_3));



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
		
			end if;
		end if;
	end process;


--s_T_I1_ant <= s_T_I1;	
--s_T_I2_ant <= s_T_I2;
--s_T_I3_ant <= s_T_I3;	
---------- crono_behav process--------------------------------------------
 crono_behav : process(STATE, ready_I, input_1,input_2,input_3, ready_I, enable)
	begin
	
		ready_I_rising <= ready_I_rising(ready_I_rising'left-1 downto 0) & ready_I;
--		s_clk_rising <= s_clk_rising(s_clk_rising'left-1 downto 0) & s_clk;
		
		case STATE is
		
			WHEN waiting_ready => 
				if ready_I_rising(ready_I_rising'left downto ready_I_rising'left-1) = "01" then
					if (enable = '1') then
						NXSTATE <= state_I1;
					end if;
				end if;	
			WHEN  state_I1 =>
			
--				Sn_19 <= Xn_19;
--				Sn_18 <= Xn_18;
--				Sn_17 <= Xn_17;
--				Sn_16 <= Xn_16;
--				Sn_15 <= Xn_15;
--				Sn_14 <= Xn_14;
--				Sn_13 <= Xn_13;
--				Sn_12 <= Xn_12;
--				Sn_11 <= Xn_11;
--				Sn_10 <= Xn_10;
--				Sn_9 <= Xn_9;
--				Sn_8 <= Xn_8;
--				Sn_7 <= Xn_7;
--				Sn_6 <= Xn_6;
--				Sn_5 <= Xn_5;
--				Sn_4 <= Xn_4;	
--				Sn_3 <= Xn_3;
--				Sn_2 <= Xn_2;
--				Sn_1 <= Xn_1;
--                Sn   <= Xn;


				divide  <= s_T_I1;
				out_1 <= result;
				NXSTATE <= state_I2;	
			WHEN state_I2 =>
--				Sn_19 <= Yn_19;
--				Sn_18 <= Yn_18;
--				Sn_17 <= Yn_17;
--				Sn_16 <= Yn_16;
--				Sn_15 <= Yn_15;
--				Sn_14 <= Yn_14;
--				Sn_13 <= Yn_13;
--				Sn_12 <= Yn_12;
--				Sn_11 <= Yn_11;
--				Sn_10 <= Yn_10;
--				Sn_9 <= Yn_9;
--				Sn_8 <= Yn_8;
--				Sn_7 <= Yn_7;
--				Sn_6 <= Yn_6;
--				Sn_5 <= Yn_5;
--				Sn_4 <= Yn_4;	
--				Sn_3 <= Yn_3;
--				Sn_2 <= Yn_2;
--				Sn_1 <= Yn_1;
--                Sn <= Yn;
				divide  <= s_T_I2;
				out_2 <= result;
				NXSTATE <= state_I3;
			WHEN state_I3 =>

--				Sn_19 <= Zn_19;
--				Sn_18 <= Zn_18;
--				Sn_17 <= Zn_17;
--				Sn_16 <= Zn_16;
--				Sn_15 <= Zn_15;
--				Sn_14 <= Zn_14;
--				Sn_13 <= Zn_13;
--				Sn_12 <= Zn_12;
--				Sn_11 <= Zn_11;
--				Sn_10 <= Zn_10;
--				Sn_9 <= Zn_9;
--				Sn_8 <= Zn_8;
--				Sn_7 <= Zn_7;
--				Sn_6 <= Zn_6;
--				Sn_5 <= Zn_5;
--				Sn_4 <= Zn_4;	
--				Sn_3 <= Zn_3;
--				Sn_2 <= Zn_2;
--				Sn_1 <= Zn_1;
--                Sn <= Zn;
				divide  <= s_T_I3;
				out_3 <= result;
				NXSTATE <= waiting_ready;
			WHEN others =>
				NXSTATE <= waiting_ready;
		end case;
	end process;


---------------------
--s_clock_1 : FREQ_DIV
---------------------
--	generic map (
--		FREC_IN => 50000,
--		FREC_OUT => 25000
--	 )
--	 port map (
--		 CLK_IN => clk,
--		 CLK_OUT => s_clk
--	 );

---------------
address_counter : contador_binario 
---------------
	generic map (
		N => 2
	)
	port map (
		clk => clk, 
	    clear => '1',--clear, 
		enable => '1',--cont_en,
	    COUNT_MAX => std_logic_vector(to_unsigned(2, 2)) ,
	    -- COUNT_MAX tope del contador, en este caso corresponde a 20 -> cant de muestras en UN CICLO
		count => tope
	);


--divide <= Sn + Sn_1 + Sn_2 + Sn_3 + Sn_4 + Sn_5 + Sn_6 + Sn_7
--			 + Sn_8 + Sn_9 + Sn_10 + Sn_11 + Sn_12 + Sn_13 + Sn_14 + Sn_15
--			 + Sn_16 + Sn_17 + Sn_18 + Sn_19;
-----------------------
t1 : lpm_div
-----------------------
port map (
	numer => divide,-- s_T,
	denom => veinte,
	quotient => R_T,
	remain => Resto
);

-------------------------
sqrt : sqrt_wizard
-------------------------
port map (
	radical  => R_T,
	q  => result
);

o_1 <= out_1;
o_2 <= out_2;
o_3 <= out_3;

------ sync : process--
sync : process (clk,reset,STATE)
begin
 if reset = '1' then
	STATE <= waiting_ready;
elsif clk'event and clk = '1' and tope = "00" then
	STATE <= NXSTATE;
end if;
end process;


END arch;
--
-----------------------------------------------------------------------
-------------------------- SIN MAQUINA DE ESTADOS ---------------------
-----------------------------------------------------------------------
--
-------------------------------------------------------------
------- PACKAGE pk_RMS_3
-------------------------------------------------------------
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use ieee.STD_LOGIC_UNSIGNED.ALL;
--
--PACKAGE pk_RMS_3 IS
--	COMPONENT RMS_3 IS
--		PORT (
--			input_1 , input_2 , input_3 : IN STD_LOGIC_VECTOR(15 downto 0);
--			ready_I  	: IN STD_LOGIC;
--			reset 		: IN STD_LOGIC;
--			clk 		: IN STD_LOGIC;
--			enable		: IN STD_LOGIC;
--			o_1, o_2, o_3: OUT STD_LOGIC_VECTOR(15 downto 0)
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
--ENTITY RMS_3 IS
--	PORT (
--		input_1 , input_2 , input_3 : IN STD_LOGIC_VECTOR(15 downto 0);
--		ready_I  : IN STD_LOGIC;
--		reset : IN STD_LOGIC;
--		clk   : IN STD_LOGIC;
--		enable: IN STD_LOGIC;
--		o_1, o_2, o_3: OUT STD_LOGIC_VECTOR(15 downto 0)
--	);
--END RMS_3;
--
-------------------------------------------------------------
------- ARCHITECTURE RMS_3
-------------------------------------------------------------
--ARCHITECTURE arch of RMS_3 IS
--------- Constant-----------------------------------------
--constant CONST_LPM_WIDTHD : natural := 32;
--constant CONST_LPM_WIDTHN : natural := 32;
--constant veinte : std_LOGIC_VECTOR (31 downto 0)  := "00000000000000000000000000010100"; 
--------- Signals -----------------------------------------
--signal
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
--	R_T, R_T2, R_T3, Resto , divide
--
--: STD_LOGIC_VECTOR(31 downto 0) := (OTHERS => '0');
--signal 
--	result , out_1 , out_2 , out_3
--: STD_LOGIC_VECTOR(15 downto 0) := (OTHERS => '0');
--
--
--signal ready_I_rising : std_logic_vector(2 downto 0);
--------- component LPM_DIVIDE  -----------------------------------------
--component LPM_DIVIDE
-- generic (LPM_WIDTHN : natural;
--			 LPM_WIDTHD : natural;
--			LPM_NREPRESENTATION : string := "UNSIGNED";
--			LPM_DREPRESENTATION : string := "UNSIGNED";
----			LPM_PIPELINE : natural := 0;
----			LPM_TYPE : string := L_DIVIDE;
--			LPM_HINT : string := "UNUSED");
--			port (NUMER : in std_logic_vector(LPM_WIDTHN-1 downto 0);
--					DENOM : in std_logic_vector(LPM_WIDTHD-1 downto 0);
----					ACLR : in std_logic := '0';
--					CLOCK : in std_logic := '0';
----					CLKEN : in std_logic := '1';
--					QUOTIENT : out std_logic_vector(LPM_WIDTHN-1 downto 0);
--					REMAIN : out std_logic_vector(LPM_WIDTHD-1 downto 0));
--end component;
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
--		(state_I1, state_I2, state_I3, waiting_ready);
--	attribute enum_encoding : string;
--	attribute enum_encoding of state_type : type is "gray";
--	signal STATE, NXSTATE : state_type;
--------- BEGIN  ---------------------------------------------------------
--BEGIN
------------ new_sample process--------------------------------------------
--	new_sample : process(input_1,input_2,input_3, ready_I, enable)
--	begin
--		if (ready_I'event AND ready_I = '1') then
--			if (enable = '1') then
--			
--				Xn_19 <= Xn_18;	Xn_18 <= Xn_17;	Xn_17 <= Xn_16;	Xn_16 <= Xn_15;	Xn_15 <= Xn_14;
--				Xn_14 <= Xn_13;	Xn_13 <= Xn_12;	Xn_12 <= Xn_11;	Xn_11 <= Xn_10;	Xn_10 <= Xn_9;
--				Xn_9 <= Xn_8; Xn_8 <= Xn_7;	Xn_7 <= Xn_6; Xn_6 <= Xn_5;	Xn_5 <= Xn_4; Xn_4 <= Xn_3;	
--				Xn_3 <= Xn_2; Xn_2 <= Xn_1;	Xn_1 <= Xn;	
--				
--				Xn   <= STD_LOGIC_VECTOR(signed(input_1)*signed(input_1));
--				
--				
--				Yn_19 <= Yn_18;	Yn_18 <= Yn_17;	Yn_17 <= Yn_16;	Yn_16 <= Yn_15;	Yn_15 <= Yn_14;
--				Yn_14 <= Yn_13;	Yn_13 <= Yn_12;	Yn_12 <= Yn_11;	Yn_11 <= Yn_10;	Yn_10 <= Yn_9;
--				Yn_9 <= Yn_8; Yn_8 <= Yn_7;	Yn_7 <= Yn_6; Yn_6 <= Yn_5;	Yn_5 <= Yn_4;
--				Yn_4 <= Yn_3; Yn_3 <= Yn_2;	Yn_2 <= Yn_1; Yn_1 <= Yn; 
--				
--				Yn   <= STD_LOGIC_VECTOR(signed(input_2)*signed(input_2));
--				
--
--				
--				Zn_19 <= Zn_18; Zn_18 <= Zn_17;	Zn_17 <= Zn_16;	Zn_16 <= Zn_15;
--				Zn_15 <= Zn_14;	Zn_14 <= Zn_13;	Zn_13 <= Zn_12;
--				Zn_12 <= Zn_11;	Zn_11 <= Zn_10;	Zn_10 <= Zn_9;
--				Zn_9 <= Zn_8; Zn_8 <= Zn_7;	Zn_7 <= Zn_6; Zn_6 <= Zn_5; Zn_5 <= Zn_4;
--				Zn_4 <= Zn_3;Zn_3 <= Zn_2; Zn_2 <= Zn_1;Zn_1 <= Zn;
--				
--				Zn   <= STD_LOGIC_VECTOR(signed(input_3)*signed(input_3));
--				
--
----				s_T_I1 <= std_logic_vector(unsigned(s_T_I1) - unsigned(Xn_19)) + STD_LOGIC_VECTOR(signed(input_1)*signed(input_1));
----				s_T_I2 <= std_logic_vector(unsigned(s_T_I2) - unsigned(Yn_19)) + STD_LOGIC_VECTOR(signed(input_2)*signed(input_2));
----				s_T_I3 <= std_logic_vector(unsigned(s_T_I3) - unsigned(Zn_19)) + STD_LOGIC_VECTOR(signed(input_3)*signed(input_3));
--
--			
--			end if;
--		end if;
--	end process;
--
--
--
--				s_T_I1 <= Xn + Xn_1 + Xn_2 + Xn_3 + Xn_4 + Xn_5 + Xn_6 + Xn_7
--					 + Xn_8 + Xn_9 + Xn_10 + Xn_11 + Xn_12 + Xn_13 + Xn_14 + Xn_15
--					  + Xn_16 + Xn_17 + Xn_18 + Xn_19; 
--
--				s_T_I2 <= Yn + Yn_1 + Yn_2 + Yn_3 + Yn_4 + Yn_5 + Yn_6 + Yn_7
--						 + Yn_8 + Yn_9 + Yn_10 + Yn_11 + Yn_12 + Yn_13 + Yn_14 + Yn_15
--						  + Yn_16 + Yn_17 + Yn_18 + Yn_19;
--
--				s_T_I3 <= Zn + Zn_1 + Zn_2 + Zn_3 + Zn_4 + Zn_5 + Zn_6 + Zn_7
--						 + Zn_8 + Zn_9 + Zn_10 + Zn_11 + Zn_12 + Zn_13 + Zn_14 + Zn_15
--						  + Zn_16 + Zn_17 + Zn_18 + Zn_19;
--
-------------------------
--t1 : LPM_DIVIDE
-------------------------
--generic map (
--	LPM_WIDTHN => CONST_LPM_WIDTHD,
--	LPM_WIDTHD => CONST_LPM_WIDTHN
--)
--port map (
--	NUMER => s_T_I1, 
--	DENOM => veinte,
--	QUOTIENT => R_T,
--	REMAIN => Resto
--);
-------------------------
--sqrt_1 : sqrt_wizard
-------------------------
--port map (
--	radical  => R_T,
--	q  => out_1
--);
--
-------------------------
--t2 : LPM_DIVIDE
-------------------------
--generic map (
--	LPM_WIDTHN => CONST_LPM_WIDTHD,
--	LPM_WIDTHD => CONST_LPM_WIDTHN
--)
--port map (
--	NUMER => s_T_I2, 
--	DENOM => veinte,
--	QUOTIENT => R_T2,
--	REMAIN => Resto
--);
-------------------------
--sqrt_2 : sqrt_wizard
-------------------------
--port map (
--	radical  => R_T2,
--	q  => out_2
--);
--
-------------------------
--t3 : LPM_DIVIDE
-------------------------
--generic map (
--	LPM_WIDTHN => CONST_LPM_WIDTHD,
--	LPM_WIDTHD => CONST_LPM_WIDTHN
--)
--port map (
--	NUMER => s_T_I3, 
--	DENOM => veinte,
--	QUOTIENT => R_T3,
--	REMAIN => Resto
--);
-------------------------
--sqrt_3 : sqrt_wizard
-------------------------
--port map (
--	radical  => R_T3,
--	q  => out_3
--);
--
--o_1 <= out_1;
--o_2 <= out_2;
--o_3 <= out_3;
--
--
--
--END arch;
--




