# INPUTS
# 8 Switches - SWITCH [7:0]
set_property IOSTANDARD LVCMOS18 [get_ports SWITCH[0]] 
set_property PACKAGE_PIN F22 [get_ports SWITCH[0]] 

set_property IOSTANDARD LVCMOS18 [get_ports SWITCH[1]] 
set_property PACKAGE_PIN G22 [get_ports SWITCH[1]] 

set_property IOSTANDARD LVCMOS18 [get_ports SWITCH[2]] 
set_property PACKAGE_PIN H22 [get_ports SWITCH[2]] 

set_property IOSTANDARD LVCMOS18 [get_ports SWITCH[3]] 
set_property PACKAGE_PIN F21 [get_ports SWITCH[3]] 

set_property IOSTANDARD LVCMOS18 [get_ports SWITCH[4]] 
set_property PACKAGE_PIN H19 [get_ports SWITCH[4]] 

set_property IOSTANDARD LVCMOS18 [get_ports SWITCH[5]] 
set_property PACKAGE_PIN H18 [get_ports SWITCH[5]] 

set_property IOSTANDARD LVCMOS18 [get_ports SWITCH[6]] 
set_property PACKAGE_PIN H17 [get_ports SWITCH[6]] 

set_property IOSTANDARD LVCMOS18 [get_ports SWITCH[7]] 
set_property PACKAGE_PIN M15 [get_ports SWITCH[7]] 


# 2 Buttons  - BUTTON [2:0]
set_property IOSTANDARD LVCMOS18 [get_ports BUTTON[0]] 
set_property PACKAGE_PIN P16 [get_ports BUTTON[0]]

set_property IOSTANDARD LVCMOS18 [get_ports BUTTON[1]] 
set_property PACKAGE_PIN R18 [get_ports BUTTON[1]]

set_property IOSTANDARD LVCMOS18 [get_ports BUTTON[2]] 
set_property PACKAGE_PIN N15 [get_ports BUTTON[2]]


# OUTPUTS
# 8 LEDs - LED [7:0]
set_property IOSTANDARD LVCMOS18 [get_ports LED[0]] 
set_property PACKAGE_PIN T22 [get_ports LED[0]] 

set_property IOSTANDARD LVCMOS18 [get_ports LED[1]] 
set_property PACKAGE_PIN T21 [get_ports LED[1]] 

set_property IOSTANDARD LVCMOS18 [get_ports LED[2]] 
set_property PACKAGE_PIN U22 [get_ports LED[2]] 

set_property IOSTANDARD LVCMOS18 [get_ports LED[3]] 
set_property PACKAGE_PIN U21 [get_ports LED[3]] 

set_property IOSTANDARD LVCMOS18 [get_ports LED[4]] 
set_property PACKAGE_PIN V22 [get_ports LED[4]] 

set_property IOSTANDARD LVCMOS18 [get_ports LED[5]] 
set_property PACKAGE_PIN W22 [get_ports LED[5]] 

set_property IOSTANDARD LVCMOS18 [get_ports LED[6]] 
set_property PACKAGE_PIN U19 [get_ports LED[6]] 

set_property IOSTANDARD LVCMOS18 [get_ports LED[7]] 
set_property PACKAGE_PIN U14 [get_ports LED[7]] 


# 2 Seven Segment Displays
set_property IOSTANDARD LVCMOS18 [get_ports SEGMENT[6]] 
set_property PACKAGE_PIN Y11 [get_ports SEGMENT[6]]

set_property IOSTANDARD LVCMOS18 [get_ports SEGMENT[5]] 
set_property PACKAGE_PIN AA11 [get_ports SEGMENT[5]]

set_property IOSTANDARD LVCMOS18 [get_ports SEGMENT[4]] 
set_property PACKAGE_PIN Y10 [get_ports SEGMENT[4]]

set_property IOSTANDARD LVCMOS18 [get_ports SEGMENT[3]] 
set_property PACKAGE_PIN AA9 [get_ports SEGMENT[3]]

set_property IOSTANDARD LVCMOS18 [get_ports SEGMENT[2]] 
set_property PACKAGE_PIN W12 [get_ports SEGMENT[2]]

set_property IOSTANDARD LVCMOS18 [get_ports SEGMENT[1]] 
set_property PACKAGE_PIN W11 [get_ports SEGMENT[1]]

set_property IOSTANDARD LVCMOS18 [get_ports SEGMENT[0]] 
set_property PACKAGE_PIN V10 [get_ports SEGMENT[0]]

set_property IOSTANDARD LVCMOS18 [get_ports CTRL] 
set_property PACKAGE_PIN W8 [get_ports CTRL]

# create clock
set_property PACKAGE_PIN Y9 [get_ports SYSCLK]
set_property IOSTANDARD LVCMOS18 [get_ports SYSCLK]
create_clock -name sys_clk_pin -period 10 -waveform [0 5] [get_ports SYSCLK]