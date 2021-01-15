library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

PACKAGE pk_filter IS
	COMPONENT filter IS
		GENERIC (
			N : INTEGER
		);
		PORT (
			-- INPUT
			clk         : IN STD_LOGIC;	
			enable      : IN STD_LOGIC;
			ready_data  : IN STD_LOGIC;
			data_in     : IN STD_LOGIC_VECTOR(N-1 downto 0);
			-- OUTPUT
			data_out    : OUT STD_LOGIC_VECTOR(N-1 downto 0)
		);
	END COMPONENT;
END PACKAGE;

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.pk_samples.all;
use work.pk_mean.all;
use work.pk_contador_binario.all;
use work.PK_FREQ_DIV.all;

entity filter is
	GENERIC (
			N : INTEGER := 16
		);
	PORT (
		-- INPUT
		clk         : IN STD_LOGIC;	
		enable      : IN STD_LOGIC;
		ready_data  : IN STD_LOGIC;
		data_in     : IN STD_LOGIC_VECTOR(N-1 downto 0);
		-- OUTPUT
		data_out    : OUT STD_LOGIC_VECTOR(N-1 downto 0)
	);
end filter;      


architecture arch of filter is
	
	constant M : integer := 10;
	
	signal s_clk: std_logic;
	signal s_address: std_logic_vector(M-1 downto 0);
	signal s_data: std_logic_vector(N-1 downto 0);
	signal q_ram: std_logic_vector(N-1 downto 0);
  
	SIGNAL Xn   : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');
	SIGNAL Xn_1 : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');
	SIGNAL Xn_2 : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');
	SIGNAL Xn_3 : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');
	SIGNAL Yn   : STD_LOGIC_VECTOR(N-1 downto 0) := (OTHERS => '0');
		  

  
	component ram_dq_2 IS
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


s_clk <= clk;

samples_inst : samples
	GENERIC MAP (
		N => N
	)
	PORT MAP (
			input 	=> data_in,
			clk   	=> ready_data,
			enable	=> enable,
			o_0   	=> Xn,
			o_1   	=> Xn_1,
			o_2   	=> Xn_2,
			o_3   	=> Xn_3
	);

suma_4_inst : mean
	PORT MAP (
			i_0   => Xn,   -- Xn
			i_1   => Xn_1, -- Xn-1
			i_2   => Xn_2, -- Xn-2
			i_3   => Xn_3, -- Xn-3
			clk   => ready_data,
--			enable=>;
			o     => Yn    -- Yn
	);
	
		
data_out 		<= Yn;


end architecture; 
