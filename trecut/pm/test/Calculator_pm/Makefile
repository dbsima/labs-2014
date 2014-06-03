all: calc.hex 

calc.elf: calc.c lcd.c key.c
	avr-gcc -mmcu=atmega16 -Wall  -o $@ $^ -Os -lm
 
calc.hex: calc.elf
	avr-objcopy  -j .text -j .data -O ihex  calc.elf calc.hex
	avr-size calc.elf
 
clean:
	rm -rf calc.elf calc.hex 
