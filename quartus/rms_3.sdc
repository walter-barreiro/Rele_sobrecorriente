set_time_format -unit ns -decimal_places 3

create_clock -name clk -period 20 [get_ports clk]

derive_pll_clocks