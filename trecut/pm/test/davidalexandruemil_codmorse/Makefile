all: lab1.hex
 
lab1.elf: lab1.c	
	avr-gcc -mmcu=atmega16 -Wall  -I/usr/lib/avr/include/avr -o lab1.elf lab1.c lcd.c
 
lab1.hex: lab1.elf
	avr-objcopy  -j .text -j .data -O ihex  lab1.elf lab1.hex
	avr-size lab1.elf
 
clean:
	rm -rf lab1.elf lab1.hex
