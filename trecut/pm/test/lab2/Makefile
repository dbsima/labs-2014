all: lab2.hex
 
lab2.elf: lab2.c	
	avr-gcc -mmcu=atmega324p -Os -Wall  -o lab2.elf lab2.c
 
lab2.hex: lab2.elf
	avr-objcopy  -j .text -j .data -O ihex  lab2.elf lab2.hex
	avr-size lab2.elf
 
clean:
	rm -rf lab2.elf lab2.hex