library ieee;
use ieee.std_logic_1164.all;

library work;
use work.pk_mu_emulator.all;
use work.pk_RMS.all;

entity prueba_RMS is
	PORT (
		-- INPUT
		clk         : IN STD_LOGIC;	
		reset 		: IN STD_LOGIC;
		enable      : IN STD_LOGIC;
		fault_I_A : IN STD_LOGIC;
		-- OUTPUT

		data_out    : OUT STD_LOGIC_VECTOR(15 downto 0);
		data_in      : OUT STD_LOGIC_VECTOR(15 downto 0)
	);
end prueba_RMS;      


architecture arch of prueba_RMS is
	
	constant M : integer := 5;
	constant N : integer := 16;
	
	signal s_clk, ready_I_A: std_logic;
	signal s_address: std_logic_vector(M-1 downto 0);
	signal s_data, I_A, I_B, I_C: std_logic_vector(N-1 downto 0);
	signal q_ram: std_logic_vector(N-1 downto 0);
  
		SIGNAL Yn   : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');	  

  
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
			fault_magnitude => 10
	)
   	PORT MAP (
			enable => enable,
			reset => reset,
			clk => clk,
			current_fault_I_A => fault_I_A,
			current_fault_I_B => '0',
			current_fault_I_C => '0',

			--OUTPUT
			ready	 => ready_I_A,
			I_A   => I_A,
			I_B   => I_B,
			I_C   => I_C,
			address => s_address
		);

--------------
rms_instantiation : RMS 
--------------
	PORT MAP (
		input => I_A,
		clk => ready_I_A,
		enable => enable,
		--OUTPUT
		o => Yn
	);

--------------
ram_dq_i : ram_dq 
--------------
	PORT MAP (
		address	     => s_address,
		clock	 	 => ready_I_A,
		data	 	 => Yn,
		wren	 	 => enable,
		
		q	 		 => q_ram
	);
		
data_out 		<= q_ram;
data_in  		<= I_A;


end architecture; 
