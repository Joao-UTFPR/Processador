ghdl -a instructionRegister.vhd
ghdl -a mux2x1.vhd
ghdl -a PC.vhd
ghdl -a register16bits.vhd
ghdl -a registerBank.vhd
ghdl -a ROM.vhd
ghdl -a stateMachine.vhd
ghdl -a UC.vhd
ghdl -a ula.vhd
ghdl -a processador.vhd



ghdl -a processador_tb.vhd
ghdl -r processador_tb --wave=ondas.ghw

gtkwave ondas.ghw