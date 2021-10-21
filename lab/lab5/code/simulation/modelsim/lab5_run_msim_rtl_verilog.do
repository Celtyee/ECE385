transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/OneDrive\ -\ International\ Campus,\ Zhejiang\ University/University/ece/ECE385/lab/lab5/code/lab5_code {D:/OneDrive - International Campus, Zhejiang University/University/ece/ECE385/lab/lab5/code/lab5_code/lab5_toplevel0.sv}
vlog -sv -work work +incdir+D:/OneDrive\ -\ International\ Campus,\ Zhejiang\ University/University/ece/ECE385/lab/lab5/code/lab5_code {D:/OneDrive - International Campus, Zhejiang University/University/ece/ECE385/lab/lab5/code/lab5_code/lab5_shift_registers.sv}
vlog -sv -work work +incdir+D:/OneDrive\ -\ International\ Campus,\ Zhejiang\ University/University/ece/ECE385/lab/lab5/code/lab5_code {D:/OneDrive - International Campus, Zhejiang University/University/ece/ECE385/lab/lab5/code/lab5_code/lab5_controller.sv}
vlog -sv -work work +incdir+D:/OneDrive\ -\ International\ Campus,\ Zhejiang\ University/University/ece/ECE385/lab/lab5/code/lab5_code {D:/OneDrive - International Campus, Zhejiang University/University/ece/ECE385/lab/lab5/code/lab5_code/HexDriver.sv}
vlog -sv -work work +incdir+D:/OneDrive\ -\ International\ Campus,\ Zhejiang\ University/University/ece/ECE385/lab/lab5/code/lab5_code {D:/OneDrive - International Campus, Zhejiang University/University/ece/ECE385/lab/lab5/code/lab5_code/carry_lookahead_adder.sv}

vlog -sv -work work +incdir+D:/OneDrive\ -\ International\ Campus,\ Zhejiang\ University/University/ece/ECE385/lab/lab5/code/lab5_code {D:/OneDrive - International Campus, Zhejiang University/University/ece/ECE385/lab/lab5/code/lab5_code/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
