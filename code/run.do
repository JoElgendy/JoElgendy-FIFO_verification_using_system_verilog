vlib work
vlog -f src_files.list +define+SIM   +cover -covercells
vsim -voptargs=+acc work.FIFO_top  -cover
add wave /FIFO_top/FIFO_if/* /FIFO_top/my_FIFO/*
coverage save FIFO.ucdb -onexit 
run -all

coverage exclude -src FIFO.sv -line 24 -code c
coverage exclude -src FIFO.sv -line 42 -code c

quit -sim 
vcover report FIFO.ucdb -details -annotate -all -output FIFO_coverage.txt
