#ifndef __LCD_H
#define __LCD_H

#include <avr/io.h>
#include <avr/interrupt.h>

/************************************************************************ 
 * DEFINE-uri pentru parametrizarea modulului LCD
 ************************************************************************/
#define LcdDATA_DDR		DDRC			// Portul pe care conectam firele de date la LCD-ul
#define LcdDATA_PORT	PORTC
#define LcdDATA_PIN		PINC

#define LcdCMD_DDR		DDRC			// Portul pe care conectam firele de comenzi la LCD
#define LcdCMD_PORT		PORTC
#define LcdCMD_PIN		PINC

#define LcdD4			 PC4				// Pin-ul pentru firul de date D4 de pe LCD
#define LcdD5			 PC5				// Pin-ul pentru firul de date D5 de pe LCD
#define LcdD6			 PC6				// Pin-ul pentru firul de date D6 de pe LCD
#define LcdD7			 PC7				// Pin-ul pentru firul de date D7 de pe LCD

#define LcdRS			 PC1			    // Pinul pentru selectare operatie (LCD)
#define LcdRW			 PC2				// Pinul pentru Read/ Write (LCD)
#define LcdE			 PC3				// Pinul de Enable (LCD)

#define LCD_INSTR_4wire 			0x20 	// 4 fire date, font 5x8, 1 linie
#define LCD_INSTR_display 			0x0C 	// Display On, Cursor On, Blinking On ( 1 Display Cursor Blink )
#define LCD_INSTR_clearDisplay  	0x01 	// Clear Display
#define LCD_INSTR_returnHome		0x02 	// Return Cursor and LCD to Home Position
#define LCD_INSTR_nextLine 			0xC0 	// Return Cursor and LCD to Home Position
#define LCD_INSTR_gotoCGRAM			0x40	// go to Character Generator RAM
#define LCD_SET_DDRAM_ADDR    	    0x80	// Set DDRAM Address

#define RS_HIGH()				LcdCMD_PORT |= _BV(LcdRS)
#define RS_LOW()				LcdCMD_PORT &= ~_BV(LcdRS)
 
#define RW_HIGH()				LcdCMD_PORT |= _BV(LcdRW)
#define RW_LOW()				LcdCMD_PORT &= ~_BV(LcdRW)
 
#define ENABLE()				LcdCMD_PORT |= _BV(LcdE)
#define DISABLE()				LcdCMD_PORT &= ~_BV(LcdE)



/*************
 * API LCD   *
 *************/
/* Initializare modul LCD. Trebuie apelata inainte de a se face orice operatie cu LCD-ul */
void LCD_init();                
/* Trimite o instructiune catre lcd (vezi datasheet) */
void LCD_writeInstruction(unsigned char _instruction);	
/* Trimite date catre LCD pentru afisare	*/
void LCD_writeData(unsigned char _data);		
/* Trimite un byte catre LCD la modul general (nu conteaza daca e instructiune sau date) */
void LCD_write(unsigned char _byte);
/* Asteptam pana cand lcd-ul devine disponibil pt o noua comanda	*/			
void LCD_waitNotBusy();					
/* Asteapta un numar de cicli de ceas	*/
void LCD_waitInstructions(unsigned char _instructions);	
/* Afiseaza imformatia pe LCD (doar 1 linie, primele 16 caractere)	*/
void LCD_print(char* _msg);					
/* Afisare numar in baza 10 pe LCD	*/
void LCD_printDecimal2u(unsigned int _n);		
/* Afisare numar in baza 16 pe LCD	*/
void LCD_printHexa(unsigned int _n);			

#endif
