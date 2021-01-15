library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.pk_RMS_3.all;
use work.pk_overcurrent_selector.all;
use work.pk_filter.all;

PACKAGE pk_relay is
	COMPONENT relay is
		PORT (
			-- INPUT
			clk         : IN STD_LOGIC;	
			reset 		: IN STD_LOGIC;
			enable      : IN STD_LOGIC;
			ready 		: IN STD_LOGIC;
			I_A 		: IN std_logic_vector(15 downto 0);
			I_B  		: IN std_logic_vector(15 downto 0);
			I_C			: IN std_logic_vector(15 downto 0);
			-- OUTPUT
			OVERCURRENT    : OUT STD_LOGIC

		);
   END COMPONENT;
END PACKAGE;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.pk_RMS_3.all;
use work.pk_overcurrent_selector.all;
use work.pk_filter.all;

entity relay is
	GENERIC (
		N : integer := 16;
		M : integer := 5
	);
	PORT (
		-- INPUT
		clk         : IN STD_LOGIC;	
		reset 		: IN STD_LOGIC;
		enable      : IN STD_LOGIC;
		ready 		: IN STD_LOGIC;
		I_A 		: IN std_logic_vector(15 downto 0);
		I_B  		: IN std_logic_vector(15 downto 0);
		I_C			: IN std_logic_vector(15 downto 0);
		-- OUTPUT
		OVERCURRENT    : OUT STD_LOGIC

	);
end relay;      

architecture arch of relay is
	
	constant const_I_sp : integer := 220;
	constant const_Im : integer := 4000;
	
	signal 
		I_A_filter, I_B_filter, I_C_filter
	: std_logic_vector(N-1 downto 0);
 
	SIGNAL Xn, Yn , Zn  : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');	  
 
begin

--------------
filtro1 : filter
--------------
	GENERIC MAP (
		N =>16
	)
PORT MAP (
	clk    =>    clk,
	enable  =>   enable,
	ready_data => ready,
	data_in    => I_A,
	-- OUTPUT
	data_out    => I_A_filter
	);
--------------
filtro2 : filter
--------------
	GENERIC MAP (
		N =>16
	)
PORT MAP (
	clk    =>    clk,
	enable  =>   enable,
	ready_data =>ready,
	data_in    => I_B,
	-- OUTPUT
	data_out    => I_B_filter
	);
--------------
filtro3 : filter
--------------
	GENERIC MAP (
		N =>16
	)
PORT MAP (
	clk    =>    clk,
	enable  =>   enable,
	ready_data =>ready,
	data_in    => I_C,
	-- OUTPUT
	data_out    => I_C_filter
	);

--------------
rms_instantiation : RMS_3
--------------
	PORT MAP (
		input_1 => I_A_filter,
		input_2 => I_B_filter,
		input_3 => I_C_filter,
		clk =>     clk,
		ready_I => ready,
		enable =>  enable,
		reset =>   reset,
		--Output		
		o_1 => Xn,
		o_2 => Yn,
		o_3 => Zn
	);
-------------------------------------
overcurrent_inst: overcurrent_selector
-------------------------------------
	GENERIC MAP (
		N 	=> N
	)
	PORT MAP (
		clk   => clk,
		ready =>  ready,
		I_A_rms  => Xn,
		I_B_rms  => Yn,
		I_C_rms  => Zn,
		enable => enable,
		reset => reset,
		I_sp  => const_I_sp,   -- Current setpoint, asintota vertical, ser consistentes con la memoria que este cargada?
		Im   =>  const_Im,
		
		OVERCURRENT => OVERCURRENT  -- Senial de sobrecorriente
   	);

end architecture; 
