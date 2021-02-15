transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {f:/software1/quartusll_13.1/altera/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/cycloneiii_ver
vmap cycloneiii_ver ./verilog_libs/cycloneiii_ver
vlog -vlog01compat -work cycloneiii_ver {f:/software1/quartusll_13.1/altera/quartus/eda/sim_lib/cycloneiii_atoms.v}

if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {encoder_test_8_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/Users/22357/Desktop/encoder_test/simulation/modelsim {C:/Users/22357/Desktop/encoder_test/simulation/modelsim/encoder_test.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneiii_ver -L gate_work -L work -voptargs="+acc"  encoder_test_vlg_tst

add wave *
view structure
view signals
run -all
