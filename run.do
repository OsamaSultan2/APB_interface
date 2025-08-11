vlib work 
vlog APB_master.v APB_master_tb.v
vsim -voptargs=+acc APB_master_tb
add wave *
add wave -position insertpoint  \
sim:/APB_master_tb/dut/cs \
sim:/APB_master_tb/dut/ns 
run -all
