NAME=chessFinal

all: chessFinal

chessFinal: chessFinal.asm
	nasm -f elf -F dwarf -g chessFinal.asm
	gcc -g -m32 -o chessFinal chessFinal.o /usr/local/share/csc314/driver.c /usr/local/share/csc314/asm_io.o
	rm chessFinal.o
