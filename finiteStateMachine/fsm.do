# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog -novopt fsm.v

#load simulation using mux as the top level simulation module
vsim fsm

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets
force {resetn} 0 0ps, 1 5ps
force {LOAD} 0 0ps, 1 30ps, 0 40ps, 1 50ps, 0 60ps
force {sensor} 0 0ps, 1 10ps
force {pause} 0 0ps, 1 75ps, 0 90ps 
force {CDADone} 0 0ps, 1 20ps
force {clk} 1 0ps, 0 {2ps} -r 5ps
#run simulation for a few 
run 100ps

