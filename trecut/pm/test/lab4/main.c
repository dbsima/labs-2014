/*---------------------------------------------------------------*/
/* 8-pin SD audio player R0.04                     (C)ChaN, 2010 */
/*---------------------------------------------------------------*/
#define F_CPU 16000000
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/sleep.h>
#include <avr/wdt.h>
#include <string.h>
#include <stdio.h>
#include "diskio.h"
#include "pff.h"
#include "lcd.h"

#define FCC(c1,c2,c3,c4)	(((DWORD)c4<<24)+((DWORD)c3<<16)+((WORD)c2<<8)+(BYTE)c1)	/* FourCC */

#define STARTED 1
#define STAHPED 2
//#define NEXT  3
//#define PREV  4


/*---------------------------------------------------------*/
/* Work Area                                               */
/*---------------------------------------------------------*/

volatile BYTE FifoRi, FifoWi, FifoCt;	/* FIFO controls */

unsigned char Buff1[256];		/* Wave output FIFO */
unsigned char Buff2[256];		/* Wave output FIFO */

FATFS Fs;			/* File system object */
DIR Dir;			/* Directory object */
FILINFO Fno;		/* File information */

WORD rb;			/* Return value. Put this here to avoid bugs of avr-gcc */

uint16_t miliseconds;
uint8_t minutes, seconds, hours;
unsigned char time_string[20];
/*---------------------------------------------------------*/

static
DWORD load_header (void)	/* 0:Invalid format, 1:I/O error, >1:Number of samples */
{
	DWORD sz;


	if (pf_read(Buff1, 12, &rb)) return 1;	/* Load file header (12 bytes) */

	if (rb != 12 || LD_DWORD(Buff1+8) != FCC('W','A','V','E')) return 0;

	for (;;) {
		pf_read(Buff1, 8, &rb);			/* Get Chunk ID and size */
		if (rb != 8) return 0;
		sz = LD_DWORD(&Buff1[4]);		/* Chunk size */

		switch (LD_DWORD(&Buff1[0])) {	/* FCC */
		case FCC('f','m','t',' ') :					/* 'fmt ' chunk */
			if (sz > 100 || sz < 16) return 0;		/* Check chunk size */
			pf_read(Buff1, sz, &rb);					/* Get content */
			if (rb != sz) return 0;
			if (Buff1[0] != 1) return 0;				/* Check coding type (1) */
			if (Buff1[2] != 1 && Buff1[2] != 2) 		/* Check channels (1/2) */
				return 0;
			
			if (Buff1[14] != 8 && Buff1[14] != 16)	/* Check resolution (8/16) */
				return 0;
			
			OCR0A = (BYTE)(F_CPU/8/LD_WORD(&Buff1[4]))-1;	/* Sampling freq */
			
			break;

		case FCC('d','a','t','a') :				/* 'data' chunk (start to play) */
			return sz;

		case FCC('L','I','S','T') :				/* 'LIST' chunk (skip) */
		case FCC('f','a','c','t') :				/* 'fact' chunk (skip) */
			pf_lseek(Fs.fptr + sz);
			break;

		default :								/* Unknown chunk (error) */
			return 0;
		}
	}

	return 0;
}




volatile uint8_t read1 = 1;

volatile uint16_t counter=0;

volatile uint8_t sync = 0;


ISR(TIMER0_COMPA_vect)
{
	
	
	if(sync == 1)
	{
		
		if(read1 == 1)
		{
			OCR1A = (unsigned char)Buff1[counter++];
			
			if(counter == 256)
			{
				//PORTC = 0x80;
				read1 = 0;
				counter = 0;
			}
		}
		else if(read1 == 0)
		{
			OCR1A = (unsigned char)Buff2[counter++];
			if(counter == 256)
			{
				//PORTC = 0x40;
				read1 = 1;
				counter = 0;
			}
		}
		
		
	}
}

ISR(TIMER2_COMPA_vect)
{
	miliseconds++;
	if(miliseconds == 1000)
	{
		miliseconds = 0;
		
		seconds++;
		
		if(seconds == 60) 
		{
			seconds = 0;
			minutes++;
			if(minutes == 60)
			{
				minutes = 0;
				hours++;
				if(hours == 24) hours = 0;
			}
		}
		
		sprintf(time_string, "%02d:%02d:%02d", hours, minutes, seconds);
		LCD_writeInstruction(LCD_INSTR_nextLine);
		LCD_print(time_string);	
	}
}

void Timer0_init(void)
{
	TCCR0A = _BV(WGM01);
	TCCR0B = _BV(CS01);//CTC, FCPU/8
	TIMSK0 = _BV(OCIE0A);
}

void Timer1_init(void)
{
	TCCR1A = _BV(COM1A1)|_BV(COM1A0)|_BV(WGM10);
	TCCR1B = _BV(WGM12)|_BV(CS10);
}

void Timer2_init(void)
{
	TCCR2A = _BV(WGM21);
	TCCR2B = _BV(CS22)|_BV(CS20);//CTC, FCPU/8
	TIMSK2 = _BV(OCIE2A);
	OCR2A = 125;
}

static UINT play (const char *fn)
{
	DWORD sz;
	FRESULT res;
	unsigned char read2;

	
	uint16_t size = 256;
	
	if ((res = pf_open(fn)) == FR_OK) {
	
		Timer0_init();
		Timer1_init();
		
		sz = load_header();			/* Load file header */
		if (sz < 256) return (UINT)sz;
		
		
		FifoCt = 0; FifoRi = 0; FifoWi = 0;		/* Reset FIFO */
		pf_read(Buff1, 512 - (Fs.fptr % 512), &rb);	/* Snip sector unaligned part */
		sz -= rb;

			
		res = pf_read(Buff1, size, &rb);
		if (res != FR_OK) { PORTC = 0x08; while (FifoCt) ; return res; }
		
		sync = 1;
				
		do {
				
			read2 = read1;
			
			if(read1 == 1)	
				res = pf_read(Buff2, size, &rb);
			else
				res = pf_read(Buff1, size, &rb);
				
			if (res != FR_OK) { PORTC = 0x08; break; }
			
			while(read2 == read1);
			
			if(!(PINB&(1<<PB1))) 
			{
				sync = 0;
				_delay_ms(500); 
				break;
			}
			
		
		} while (rb == size);	/* Repeat until all data read */
		
		sync = 0;
	}

	while (FifoCt) ;			/* Wait for FIFO empty */
	

	return res;
}

/*-----------------------------------------------------------------------*/
/* Main                                                                  */
int main (void)
{
	// setare pin 5 (difuzor) si pin 6 (CS_SD) al portului A ca pin de iesire
	DDRD |= (1<<PD5) | (1<<PD6);
	
	// setam toti pinii portului C ca pini de iesire
	DDRC = 0xFF;
	
	DDRB &= ~(1<<PB0);
	DDRB &= ~(1<<PB1);
	
	PORTB |= (1<<PB1) | (1<<PB0);
	PORTD &= ~((1<<PD5) | (1<<PD6));
	PORTD &= ~((1<<PD5) | (1<<PD6));
	

	LCD_init();
		
	sei();

	for (;;)
	{
		_delay_ms(1000);							/* Delay 1000ms for things to settle down */
		
		if (pf_mount(&Fs)) 
		{	
			continue;	/* Initialize FS */
		}
		
		if (pf_opendir(&Dir, "wav")) break;		/* Open /wav folder */
		
		int state = STAHPED;
		char* filename, first_wav, last_wav_played;
		
		
		
		if (!pf_readdir(&Dir, &Fno) && Fno.fname[0]) /* go to next file*/
			{		
				if (!(Fno.fattrib & (AM_DIR|AM_HID)) && strstr(Fno.fname, "WAV")) /* filter out all the folders, hidden files and the files that are not "WAV" */
				{	
					/* display the filename on the LCD */
					LCD_print(Fno.fname);
					strcpy(first_wav, Fno.fname);
				}
			}		

		while(1) 
		{
			/* check if button on PA3 (start/stahp) is pressed */
			if (!(PINA & (1 << PA3)))
			{
				if (state == STAHPED)
				{
					state = STARTED;
					LCD_print(Fno.fname);
					play(strcat("wav", Fno.fname)); // play song
				}
				else 
				{
					state = STAHPED;
					LCD_print(Fno.fname);
					FifoCt = 0; // stop melody
				}
			}
			/* check if button on PA2 (next) is pressed */
			if (!(PINA & (1 << PA2)))
			{
				sprintf(last_wav_played, "%s", Fno.fname);
				
				if (state == STARTED)
				{
					if (!pf_readdir(&Dir, &Fno) && Fno.fname[0]) /* go to next file*/
					{		
						if (!(Fno.fattrib & (AM_DIR|AM_HID)) && strstr(Fno.fname, "WAV")) /* filter out all the folders, hidden files and the files that are not "WAV" */
						{	
							/* display the filename on the LCD */
							LCD_print(Fno.fname);
							
							/* play the WAV file */
							play(strcat("wav", Fno.fname));
						}
					}			
				}
				else 
				{
					if (!pf_readdir(&Dir, &Fno) && Fno.fname[0]) /* go to next file*/
					{		
						if (!(Fno.fattrib & (AM_DIR|AM_HID)) && strstr(Fno.fname, "WAV")) /* filter out all the folders, hidden files and the files that are not "WAV" */
						{	
							/* display the filename on the LCD */
							LCD_print(Fno.fname);
						}
					}			
				}
			}
			
			/* check if button on PA1 (previous) is pressed */
			if (!(PINA & (1 << PA1)))
			{
				if (state == STARTED)
				{
					if (strcmp(last_wav_played, first_wav) != 0 )
					{
						/* display the filename on the LCD */
						LCD_print(last_wav_played);
						
						/* play the WAV file */
						play(strcat("wav", last_wav_played));
					}
					else 
						/* display the filename on the LCD */
						LCD_print(first_wav);
				}
				else
					if (strcmp(last_wav_played, first_wav) != 0 )
					/* display the filename on the LCD */
						LCD_print(last_wav_played);
			}
		}
	}
	
	return 1;
}



