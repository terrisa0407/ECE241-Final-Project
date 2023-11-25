# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog -novopt cd.v

#load simulation using mux as the top level simulation module
vsim Countdown

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets
force {resetn} 0 0ps, 1 40ns
force {CDA} 1
force {clk} 1 0ps, 0 {10ns} -r 20ns
#run simulation for a few 
run 1000000000ns
