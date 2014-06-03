/*
O parte din laboratorul de saptamâna asta se poate rula si pe 
placuta voastra de proiect. Codul urmator este extras din laborator 
si va folosi LED-ul de pe PD7 si timer-ul 2.

Puteti aplica ce ati învatat în laborator:

Încercati sa faceti acelasi lucru cu întreruperi
Puteti face ex3 din laborator cu timer-ul 1, dar sa schimbati valoarea 
de pe PD7 folosindu-va de întreruperile TIMER1_COMPA_vect si 
TIMER1_COMPB_vect
*/

#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 16000000
#include <util/delay.h>
#include <math.h>
 
float r = 0;
float increment = M_PI/100;
 
int main(void)
{
	/**** Initializare Timer 2 ****/
	DDRD |= (1 << PD7);	
		DDRC |= (1 << PD7);	
	TCCR2A |= (1 << COM2A1) | (1 << WGM21) | (1 << WGM20);
	TCCR2B |= (1 << CS20);
 
	while (1)
	{
		r += increment;
		increment += M_PI/10000;
 
		OCR2A = 128 + 127 * sin(r);
 
		_delay_ms(10);
	}  
	return 0;
}