library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.pk_mu_emulator.all;
use work.pk_RMS_3.all;
use work.pk_overcurrent_selector.all;
use work.pk_filter.all;
use work.pk_RMS.all;



entity prueba_overcurrent is
	PORT (
		-- INPUT
		clk         : IN STD_LOGIC;	
		reset 		: IN STD_LOGIC;
		enable      : IN STD_LOGIC;
		
		signal_select : IN STD_LOGIC;
		signal_select_2 : IN STD_LOGIC;
		
		fault_I_A : IN STD_LOGIC;
		fault_I_B : IN STD_LOGIC;
		fault_I_C : IN STD_LOGIC;
		
		-- OUTPUT
		response_time_test : OUT STD_LOGIC_VECTOR(10 downto 0);
		fault_time_test    : OUT STD_LOGIC_VECTOR(10 downto 0);
		OVERCURRENT    : OUT STD_LOGIC

	);
end prueba_overcurrent;      


architecture arch of prueba_overcurrent is
	
	constant M : integer := 5;
	constant N : integer := 16;
	constant const_I_sp : integer := 200;
	constant const_Im : integer := 4000;
	
	signal s_clk, ready_I_A: std_logic;
	signal s_address : std_logic_vector(M-1 downto 0);
	signal s_address_2: std_logic_vector(10-1 downto 0);
	signal s_data, I_A, I_B , I_C, data_in, I_A_filter, I_B_filter, I_C_filter
	
	
	
	: std_logic_vector(N-1 downto 0);
	signal q_ram,q_ram_2,q_ram_3: std_logic_vector(N-1 downto 0);
  
	SIGNAL Xn, Yn , Zn  : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');	  

  
	component ram_dq IS
		PORT
		(
			address			: IN STD_LOGIC_VECTOR (M-1 DOWNTO 0);
			clock			: IN STD_LOGIC ;
			data			: IN STD_LOGIC_VECTOR (N-1 DOWNTO 0);
			wren			: IN STD_LOGIC ;
			q				: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)
		);
	END component;
		
begin

--------------
emulador : mu_emulator
--------------
	GENERIC MAP (

		N_bits => N,
		M_bits => M,
		fault_time => 500,
		fault_magnitude => 5
	)
   	PORT MAP (
		enable => enable,
		reset => reset,
		clk => clk,
		current_fault_I_A => fault_I_A,
		current_fault_I_B => fault_I_B,
		current_fault_I_C => fault_I_C,
		
		ready	 => ready_I_A,
		I_A   => I_A,
		I_B   => I_B,
		I_C   => I_C,
		address => s_address
		);

--------------
filtro1 : filter
--------------
	GENERIC MAP (
		N =>16
	)
PORT MAP (
	clk    =>    clk,
	enable  =>   enable,
	ready_data =>ready_I_A,
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
	ready_data =>ready_I_A,
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
	ready_data =>ready_I_A,
	data_in    => I_C,
	-- OUTPUT
	data_out    => I_C_filter
	);
----------------
--rms_instantiation : RMS 
----------------
--	PORT MAP (
--		input => I_A_filter,
--		clk => ready_I_A,
--		enable => enable,
--		
--		o => Xn
--		
--		);
----------------
--rms_instantiation2 : RMS 
----------------
--	PORT MAP (
--		input => I_B_filter,
--		clk => ready_I_A,
--		enable => enable,
--		
--		o => Yn
--		
--		);
----------------
--rms_instantiation3 : RMS 
----------------
--	PORT MAP (
--		input => I_C_filter,
--		clk => ready_I_A,
--		enable => enable,
--		
--		o => Zn
--		
--		);
--------------
rms_instantiation : RMS_3
--------------
	PORT MAP (
		input_1 => I_A_filter,
		input_2 => I_B_filter,
		input_3 => I_C_filter,
		clk => clk,
		ready_I => ready_I_A,
		enable => enable,
		reset => reset,
		--Output		
		o_1 => Xn,
		o_2 => Yn,
		o_3 => Zn
	);
---------- Multiplexor ----------
data_in <=  Yn when signal_select = '1' and signal_select_2 = '0'  else
			Zn when signal_select = '0' and signal_select_2 = '1' else
			Xn when signal_select = '0' and signal_select_2 = '0';
--------------------------------
-------------------------------------
overcurrent_inst: overcurrent_selector
-------------------------------------
	GENERIC MAP (
		N 	=> N
	)
	PORT MAP (
		clk   => clk,
		ready =>  ready_I_A,
		I_A_rms  => Xn,
		I_B_rms  => Yn,
		I_C_rms  => Zn,
		enable => enable,
		reset => reset,
		I_sp  => const_I_sp,   -- Current setpoint, asintota vertical, ser consistentes con la memoria que este cargada?
		Im   =>  const_Im,
		response_time_test  => response_time_test,
		fault_time_test  => fault_time_test,
		
		OVERCURRENT => OVERCURRENT  -- Senial de sobrecorriente
   	);

--------------
ram_dq_i : ram_dq
--------------
	PORT MAP (
		address	     => s_address,
		clock	 	 => ready_I_A,
		data	 	 => data_in,
		wren	 	 => enable,
		q	 		 => q_ram
	);

--data_out 		<= q_ram;


end architecture; 
