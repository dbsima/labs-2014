/*
Similar cu exerci?iul din laborator, se poate aprinde LED-ul USER, 
care este pe pinul 7 al portului D. Astfel, se pot folosi PORTD ?i 
DDRD pentru a aprinde LED-ul (index-ul în ace?ti registri fiind PD7). 
LED-ul îl gasi?i pe placu?a în dreptul marcajului LED3.

Pentru ca exemplul sa func?ioneze corespunzator, cristalul extern 
trebuie sa fie lipit ?i activat din setarile microcontroller-ului 
(fuse bits, vezi Ghidul folosire Bootloader USB, unde se activeaza 
acei fuse bi?i).

Pentru cazul în care cristalul extern nu este activat ?i 
microcontroller-ul func?ioneaza cu oscilatorul intern de 8MHz trebuie 
înlocuita defini?ia F_CPU de dinainte de includerea <util/delay.h> cu

#define F_CPU 8000000UL
*/

#include <avr/io.h>
#define F_CPU 16000000
#include <util/delay.h>
 
int main(){
	//setam toti pinii portului C ca pini de ie?ire
	DDRD = 0xFF;
 
	while(1){
		PORTD = PORTD | (1 << PD7);	// inversam starea ledului
		
		_delay_ms(50);
		PORTD = PORTD & ~(1 << PD7);
		_delay_ms(50);
	}
	return 0;
}