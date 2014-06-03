#ifndef __KEY_H
#define __KEY_H

#include <avr/io.h>             // Include file for AVR

#define keyport_1    PORTA        //Keypad Port
#define keyportddr_1 DDRA         //Data Direction Register
#define keyportpin_1 PINA         //Keypad Port Pins

#define keyport_2    PORTD	      //Keypad Port
#define keyportddr_2 DDRD         //Data Direction Register
#define keyportpin_2 PIND         //Keypad Port Pins

#define col1_1 PA0                //Column1 PortA.0
#define col1_2 PA1                //Column2 PortA.1
#define col1_3 PA2                //Column3 PortA.2

#define col2_1 PD5                //Column1 PortB.0
#define col2_2 PD6                //Column2 PortB.1
#define col2_3 PD4                //Column3 PortB.2

#define TRUE 1
#define FALSE 0

extern unsigned char key_pressed[24];
void key_init();
int get_key();

#endif
