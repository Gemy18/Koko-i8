vsim work.koko_micro
add wave sim:/koko_micro/*
mem load -i /home/moemen/CMP/Koko-i8/test_ins.mem /koko_micro/instruction_mem_port/instruction_mem
mem load -i /home/moemen/CMP/Koko-i8/test_ram.mem /koko_micro/mem_data_ram/ram
force -freeze sim:/koko_micro/reset 1 0
force -freeze sim:/koko_micro/int_r 0 0
force -freeze sim:/koko_micro/in_port 16'h0000 0
force -freeze sim:/koko_micro/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/koko_micro/clk_mem 1 0, 0 {50 ps} -r 100
force -freeze sim:/koko_micro/clk_reg_file 1 0, 0 {25 ps} -r 50
run
force -freeze sim:/koko_micro/reset 0 0
run
