
-----------------------------------------------------------
----- PACKAGE pk_RMS
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

PACKAGE pk_RMS IS
	COMPONENT RMS IS
		PORT (
			input : IN STD_LOGIC_VECTOR(15 downto 0);
			clk   : IN STD_LOGIC;
			enable: IN STD_LOGIC;
			o: OUT STD_LOGIC_VECTOR(15 downto 0)
			--square_sum_1 : OUT STD_LOGIC_VECTOR(31 downto 0);
			--square_sum_2 : OUT STD_LOGIC_VECTOR(31 downto 0)
		);
	END COMPONENT;
END PACKAGE;

-----------------------------------------------------------
----- ENTITY RMS
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY RMS IS
	PORT (
		input : IN STD_LOGIC_VECTOR(15 downto 0);
		clk   : IN STD_LOGIC;
		enable: IN STD_LOGIC;
		o : OUT STD_LOGIC_VECTOR(15 downto 0)
	);
END RMS;
-----------------------------------------------------------
----- ARCHITECTURE RMS
-----------------------------------------------------------
ARCHITECTURE arch of RMS IS
------- Constant-----------------------------------------
constant CONST_LPM_WIDTHD : natural := 32;
constant CONST_LPM_WIDTHN : natural := 32;
constant veinte : std_LOGIC_VECTOR (31 downto 0)  := "00000000000000000000000000010100"; 
------- Signal -----------------------------------------
signal
	Xn,Xn_1,Xn_2,Xn_3,Xn_4,
	Xn_5,Xn_6,Xn_7,Xn_8,Xn_9,
	Xn_10,Xn_11,Xn_12,Xn_13,
	Xn_14,Xn_15,Xn_16,Xn_17,
	Xn_18,Xn_19
: STD_LOGIC_VECTOR(31 downto 0) := (OTHERS => '0');
signal s_T,	R_T, s_T_ant : STD_LOGIC_VECTOR(31 downto 0) := (OTHERS => '0');
------- component LPM_DIVIDE  -----------------------------------------
component LPM_DIVIDE
 generic (LPM_WIDTHN : natural;
			 LPM_WIDTHD : natural;
			LPM_NREPRESENTATION : string := "UNSIGNED";
			LPM_DREPRESENTATION : string := "UNSIGNED";
			LPM_PIPELINE : natural := 0;
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
------- BEGIN  ---------------------------------------------------------
BEGIN
	new_sample : process(input, clk, enable)
	begin
		if (clk'event AND clk = '1') then
			if (enable = '1') then		
				s_T <= Xn + Xn_1 + Xn_2 + Xn_3 + Xn_4 + Xn_5 + Xn_6 + Xn_7
						     + Xn_8 + Xn_9 + Xn_10 + Xn_11 + Xn_12 + Xn_13 + Xn_14 + Xn_15
						     + Xn_16 + Xn_17 + Xn_18 + Xn_19; 
				Xn_19 <= Xn_18;
				Xn_18 <= Xn_17;
				Xn_17 <= Xn_16;
				Xn_16 <= Xn_15;
				Xn_15 <= Xn_14;
				Xn_14 <= Xn_13;
				Xn_13 <= Xn_12;
				Xn_12 <= Xn_11;
				Xn_11 <= Xn_10;
				Xn_10 <= Xn_9;
				Xn_9 <= Xn_8;
				Xn_8 <= Xn_7;
				Xn_7 <= Xn_6;
				Xn_6 <= Xn_5;
				Xn_5 <= Xn_4;
				Xn_4 <= Xn_3;	
				Xn_3 <= Xn_2;
				Xn_2 <= Xn_1;
				Xn_1 <= Xn;
				Xn   <= STD_LOGIC_VECTOR(signed(input)*signed(input));
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
	NUMER => s_T, 
	DENOM => veinte,
	QUOTIENT => R_T
);
-----------------------
sqrt : sqrt_wizard
-----------------------
port map (
	radical  => R_T,
	q  => o
);
END arch;



