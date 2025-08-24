# Clock gốc 50 MHz
create_clock -name clk_50MHz -period 20.000 [get_ports {clk}]

derive_clock_uncertainty