/************************************************************************ *********
 * David Alexandru-Emil 334CA
 * Dispozitiv de invatare a Codului Morse
 *********************************************************************************/

#define F_CPU 16000000
#define DOT 500

#include <avr/io.h>
#include <util/delay.h>

//#include <string.h>
#include "lcd.h"

/* ELEMENTE MORSE */
void dot()
{
	PORTA |= 1<<PA7; // LED on
	_delay_ms(DOT);
	PORTA &= !(1<<PA7); // LED off
}
void dash()
{
	PORTA |= 1<<PA7; // LED on
	_delay_ms(3*DOT);
	PORTA &= !(1<<PA7); // LED off
}
void space(int mode)
{
	_delay_ms(DOT*mode);
}
/* LITERE */
void A()
{
	dot();
	beep(100,25);
	space(1);
	dash();
	beep(200,100);
	space(3);
}
void O()
{
	dash();
	beep(200,100);
	space(1);
	dash();
	beep(200,100);
	space(1);
	dash();
	beep(200,100);
	space(3);
}
void S()
{
	dot();
	beep(100,25);
	space(1);
	dot();
	beep(100,25);
	space(1);
	dot();
	beep(100,25);
	space(3);
}
/* FUNCTIILE DE OUTPUT PE LED,BUZZER*/
void view_MORSE(char* msg, char* msg2)
{
	int i;
	LCDClear();
	LCDWriteString(msg2);
	for (i=0;i<strlen(msg);i++) {
		if (msg[i]=='s') S();
		else if (msg[i]=='o') O();
	}
}
void beep (unsigned int cycles, unsigned int freq) {
	DDRC |= 1<<PC0;					//make PC0 an output
	while (cycles > 0) {
		PORTC |= 1<<PC0;			// buzzer pin high
		_delay_ms(freq);
		PORTC &= !(1<<PC0);		// buzzer pin low
		_delay_ms(freq);
		cycles--;
	}
	return;
}

int main()
{
    unsigned int i;
	
	/* LED */
	DDRA |= 1<<PA7;				// initializam pin-ul pentru outputul LED-ului
	DDRC |= 1<<PC0;				// pin-ul buzzerului este pe output
	LCDInit(LS_BLINK|LS_ULINE); //Initialize LCD module
	LCDClear();					//Clear the screen
	
	// DEMO MODE 
	while(1){
		
		// SOS
		view_MORSE("sos","SOS = ...____...");
	}
	
	return 0;
}