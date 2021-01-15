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
use work.pk_relay.all;

entity prueba_relay is
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
		OVERCURRENT    : OUT STD_LOGIC

	);
end prueba_relay;      


architecture arch of prueba_relay is
	
	constant M : integer := 5;
	constant N : integer := 16;
	constant const_I_sp : integer := 200;
	constant const_Im : integer := 4000;
	
	signal s_clk, ready: std_logic;
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
		fault_magnitude => 200
	)
   	PORT MAP (
		enable => enable,
		reset => reset,
		clk => clk,
		current_fault_I_A => fault_I_A,
		current_fault_I_B => fault_I_B,
		current_fault_I_C => fault_I_C,
		
		ready	 => ready,
		I_A   => I_A,
		I_B   => I_B,
		I_C   => I_C,
		address => s_address
		);

-----------------
rele: relay
-----------------
	PORT MAP(
		-- INPUT
		clk     => clk,
		reset   =>	reset,
		enable   => enable,
		ready 	  => ready,
		I_A 	  =>I_A,
		I_B  	=>I_B,
		I_C		=>I_C,
		-- OUTPUT
		OVERCURRENT   => OVERCURRENT
	);


end architecture; 
