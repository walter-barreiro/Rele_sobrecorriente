library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_unsigned.ALL;
use work.pk_wb_register.all;

PACKAGE pk_suma IS
	COMPONENT suma IS
	PORT (
			RST_I		: in std_logic;
			ENA_I		: in std_logic;
			CLK_I		: in std_logic;
			DATA_I  	: in STD_LOGIC_VECTOR(31 downto 0);
			DATA_OUT   	: OUT  STD_LOGIC_VECTOR(63 downto 0)
	);
	END COMPONENT;
END PACKAGE;

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_unsigned.ALL;
use work.pk_wb_register.all;

entity suma is
  port (
			RST_I		: in std_logic;
			ENA_I		: in std_logic;
			CLK_I		: in std_logic;
			DATA_I  	: in STD_LOGIC_VECTOR(31 downto 0);
			DATA_OUT   	: OUT  STD_LOGIC_VECTOR(63 downto 0)
	);
end entity suma;
 
architecture rtl of suma is
begin

register_wb : wb_register
GENERIC map (
	granularity_width => 8,
	sel_width => 1
)
port map (
	RST_I  =>	RESET_In,
	CLK_I  =>	CLK_I,
	DAT_I  =>	DAT_I,
	WE_I    =>	WE_I, 
	SEL_I   =>	"1",
	--register output signals
	ACK_O   =>	sg_ACK_O_register,
	DAT_O   =>	sg_DAT_O_register,
	Q      =>   sq_q_register
);


DATA_OUT <= DATA_I + sq_q_register;

end architecture rtl;