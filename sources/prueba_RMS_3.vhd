library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.pk_mu_emulator.all;
use work.pk_RMS_3.all;
use work.PK_FREQ_DIV.all;
use work.pk_contador_binario.all;
use work.pk_RMS.all;

entity prueba_RMS_3 is
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
		data_out    : OUT STD_LOGIC_VECTOR(15 downto 0)

	);
end prueba_RMS_3;      


architecture arch of prueba_RMS_3 is
	
	constant M : integer := 5;
	constant N : integer := 16;
	
	signal s_clk, ready_I_A: std_logic;
	signal s_address : std_logic_vector(M-1 downto 0);
	signal s_address_2: std_logic_vector(10-1 downto 0);
	signal s_data, I_A, I_B , I_C, data_in: std_logic_vector(N-1 downto 0);
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

---------------------
--ready_signal_inst : FREQ_DIV
---------------------
--	generic map (
--		FREC_IN => 50000,
--		FREC_OUT => 5000
--	 )
--	 port map (
--		 CLK_IN => clk,
--		 CLK_OUT => s_clk
--	 );
--	
-----------------
--address_counter : contador_binario 
-----------------
--	generic map (
--		N => 10
--	)
--	port map (
--		clk => s_clk, 
--	    clear => NOT reset, 
--		enable => enable,
--	    count => s_address_2,
--	    COUNT_MAX => std_logic_vector(to_unsigned(1000, 10)) 
--	    -- COUNT_MAX tope del contador, en este caso corresponde a 20 -> cant de muestras en UN CICLO
--	);

--------------
emulador : mu_emulator
--------------
	GENERIC MAP (

		N_bits => N,
		M_bits => M,
		fault_time => 500,
		fault_magnitude => 10
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


----------------
--rms_instantiation : RMS 
----------------
--	PORT MAP (
--		input => I_A,
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
--		input => I_B,
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
--		input => I_C,
--		clk => ready_I_A,
--		enable => enable,
--		
--		o => Zn
--		
--		);
--
--
--
--
--
--------------
rms_instantiation : RMS_3
--------------
	PORT MAP (
		input_1 => I_A,
		input_2 => I_B,
		input_3 => I_C,
		clk => clk,
		ready_I => ready_I_A,
		enable => enable,
		reset => reset,
		--Output		
		o_1 => Xn,
		o_2 => Yn,
		o_3 => Zn
	);
	
data_in <=  Yn when signal_select = '1' and signal_select_2 = '0'  else
			Zn when signal_select = '0' and signal_select_2 = '1' else
			Xn when signal_select = '0' and signal_select_2 = '0';

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

data_out 		<= Xn;


end architecture; 
