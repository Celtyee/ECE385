transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/MAR_MDR.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/tristate.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/test_memory.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/SLC3_2.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/PCU.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/Mem2IO.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/ISDU.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/IRA.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/HexDriver.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/memory_contents.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/datapath.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/slc3.sv}
vlog -sv -work work +incdir+D:/GitProject/ECE385/lab/lab6/code {D:/GitProject/ECE385/lab/lab6/code/lab6_toplevel.sv}

vlog -sv -work work +incdir+D:/GitProject/ECE385/Quartus_env/../lab/lab6/code {D:/GitProject/ECE385/Quartus_env/../lab/lab6/code/testbench_week1.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench_week1

add wave *
view structure
view signals
run 5 us
