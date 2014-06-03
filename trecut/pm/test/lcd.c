/************************************************************************ *********
 * Proiectarea cu Microprocesoare
 * Bibliotecã
 *********************************************************************************/
#define F_CPU 16000000
#include "lcd.h"
#include <util/delay.h>

/*****************************
 * IMPLEMENTARE API LCD.     *
 *****************************/

void LCD_init()
{
	LcdDATA_DDR |=  (1<<LcdD4)|(1<<LcdD5)|(1<<LcdD6)|(1<<LcdD7);	// Setam pinii de date ca pini de iesire
	LcdCMD_DDR  |=  (1<<LcdRS)|(1<<LcdRW)|(1<<LcdE);				// Setam pinii de comenzi ca pini de iesire

	LCD_waitNotBusy();
	
	LcdCMD_PORT   &= ~(1<<LcdRS);								// Setam linia RS pe low
	LcdCMD_PORT   &= ~(1<<LcdRW);								// Setam linia RW pe low (acum suntem in modul de trimis instructiuni)
	LcdDATA_PORT  &= ~(1<<LcdD4)&~(1<<LcdD6)&~(1<<LcdD7); 		// Specificam ca vrem 4 fire de date, prima comanda (LcdD5 activ, restul nu)
	LcdDATA_PORT  |=  (1<<LcdD5);								// Setam pinii de comenzi ca pini de iesire
	
	LcdCMD_PORT |=  (1<<LcdE);					// Setam linia E(nable) pe high; aceasta ii specifica LCD-ului sa preia datele
	LCD_waitInstructions(12);					// Asteptam o perioada de timp T
	LcdCMD_PORT &= ~(1<<LcdE );					// Setam linia E(nable) pe low; transferul s-a terminat

	LCD_writeInstruction(LCD_INSTR_4wire); 		// Incarcam comanda: 4 bit data, 2 lines, 5x8 font
	LCD_writeInstruction(LCD_INSTR_display); 	// Display On, Cursor On, Blinking On
	LCD_writeInstruction(0x06);					// Increment, no shift
	LCD_writeInstruction(0x01);					// Clear Display
	
}

/* Trimite o instructiune catre lcd (vezi datasheet) */
void LCD_writeInstruction(unsigned char _instruction)
{				
	LCD_waitNotBusy();	// asteptam ca LCD-ul sa fie liber sa primeasca comenzile	
	RS_LOW();	// setam pinul RS pe low (low=instructiuni, high=date)
	RW_LOW();	// setam pinul RW pe low (suntem in modul de comenzi acum)
	LCD_write(_instruction);	// apelam procedura ce trimite byte-ul pe firele de date

}

/* Trimite date catre LCD pentru afisare	*/
void LCD_writeData(unsigned char _data)
{
	LCD_waitNotBusy();	// asteptam ca LCD-ul sa fie liber sa primeasca comenzile	
	RS_HIGH();	// setam pinul RS pe low (low=instructiuni, high=date)
	RW_LOW();	// setam pinul RW pe low (suntem in modul de comenzi acum)
	LCD_write(_data);	// apelam procedura ce trimite byte-ul pe firele de date
}

void LCD_write(unsigned char _byte)
{
	// scriem cei mai semnificativi 4 biti pe firele de date
    unsigned char _byte2;
	
	_byte2 = _byte>>4;

	LcdDATA_PORT &= ~(1<<LcdD4);
	if ( bit_is_set( _byte2, 0 ) )
		LcdDATA_PORT |= (1<<LcdD4);
		
	LcdDATA_PORT &= ~(1<<LcdD5);
	if ( bit_is_set( _byte2, 1 ) )
		LcdDATA_PORT |= (1<<LcdD5);

	LcdDATA_PORT &= ~(1<<LcdD6);
	if ( bit_is_set( _byte2, 2 ) )
		LcdDATA_PORT |= (1<<LcdD6);

	LcdDATA_PORT &= ~(1<<LcdD7);
	if ( bit_is_set( _byte2, 3 ) )
		LcdDATA_PORT |= (1<<LcdD7);
		
	ENABLE();	// Setam Pinul E pe high
	LCD_waitInstructions(12);	// Asteptam o perioada de timp T
	DISABLE();	// Setam Pinul E pe low
	LCD_waitInstructions(12);	// Asteptam o perioada de timp T
	
	// scriem cei mai putin semnificativi 4 biti pe firele de date
	LcdDATA_PORT &= ~(1<<LcdD4);
	if ( bit_is_set( _byte, 0 ) )
		LcdDATA_PORT |= (1<<LcdD4);
	
	LcdDATA_PORT &= ~(1<<LcdD5);
	if ( bit_is_set( _byte, 1 ) )
		LcdDATA_PORT |= (1<<LcdD5);

	LcdDATA_PORT &= ~(1<<LcdD6);
	if ( bit_is_set( _byte, 2 ) )
		LcdDATA_PORT |= (1<<LcdD6);

	LcdDATA_PORT &= ~(1<<LcdD7);
	if ( bit_is_set( _byte, 3 ) )
		LcdDATA_PORT |= (1<<LcdD7);

	ENABLE();	// Setam Pinul E pe high
	LCD_waitInstructions(12);	// Asteptam o perioada de timp T
	DISABLE();	// Setam Pinul E pe low
}

void LCD_waitNotBusy()
{
	_delay_ms(10);
	/*
	unsigned char _loop = 1;

	while (_loop)
	{
		LcdDATA_DDR &= ~(1<<LcdD4 | 1<<LcdD5 | 1<<LcdD6 | 1<<LcdD7);	// Setam pinii de date de la LCD pe in pt a citi busy flag
		LcdDATA_PORT &= ~(1<<LcdD4 | 1<<LcdD5 | 1<<LcdD6 | 1<<LcdD7); 	// Dezactivam pullup resistor pentru pinii de in
		
		LcdCMD_PORT &= ~(1<<LcdE);					// Setam pin-ul e pe low; ar trebui sa fie deja low, doar ne asiguram
		LcdCMD_PORT &= ~(1<<LcdRS);					// Setam pinul RS pe low
		LcdCMD_PORT |=  (1<<LcdRW);					// Setam pinul RW pe high (acum suntem in modul de interogare busy/adr)
		
		LcdCMD_PORT |= (1<<LcdE);						// Setam Pinul E pe high
		LCD_waitInstructions(6);						// Asteptam o perioada de timp T
		_loop = LcdDATA_PIN & (1<<LcdD7);				// Citim busy flag-ul
		LcdCMD_PORT &= ~(1<<LcdE);						// Setam Pinul E pe low
		
		LCD_waitInstructions(6);						// Asteptam o perioada de timp T
		
		LcdCMD_PORT |= (1<<LcdE);						// Setam Pinul E pe high
		LCD_waitInstructions(6);						// Asteptam o perioada de timp T
		LcdCMD_PORT &= ~(1<<LcdE);						// Setam Pinul E pe low

		LcdDATA_DDR |= (1<<LcdD4 | 1<<LcdD5 | 1<<LcdD6 | 1<<LcdD7); // Setam Portul de LCD ca port de iesire la loc
	}
	*/
}

void LCD_waitInstructions(unsigned char _instructions)
{
	while (_instructions--)
		;
}


void LCD_printDecimal2u(unsigned int _n)
{
	unsigned char tmp=0;
	
	// Extragem sutele
	while(_n>=100)
		_n-=100;

	while(_n>=10){
		tmp++;
		_n-=10;
	}

	LCD_writeData(tmp+'0');
	LCD_writeData(_n+'0');
}

void LCD_printHexa(unsigned int _n)
{
	unsigned char _tmp = _n>>4;
	if (_tmp>9)
		_tmp += 'A'-10;
	else
		_tmp += '0';
	LCD_writeData( _tmp );
	_tmp = _n & 0x0F;
	if (_tmp>9)
		_tmp += 'A'-10;
	else
		_tmp += '0';
	LCD_writeData( _tmp );
}


void LCD_print(char* _msg)
{
	unsigned char i=0;
	for( ; _msg[i]!=0 && i<16; i++)
		LCD_writeData( _msg[i] );
}

void LCD_print2(char* _msg1, char* _msg2)
{
	LCD_writeInstruction(LCD_INSTR_clearDisplay);
	LCD_print(_msg1);
	LCD_writeInstruction(LCD_INSTR_nextLine);
	LCD_print(_msg2);
}
