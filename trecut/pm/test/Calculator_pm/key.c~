#include "key.h"
#include "lcd.h"

unsigned char key_pressed[24]={'1', '2', '3',
							  '4', '5', '6',
							  '7', '8', '9',
							  'o', '0', '=',
							  '+', '-', '*',
							  '/', 'r', 'p',  // '/'     , radical, putere
							  't', 's', 'c',  // tangenta, sin    , cos
							  '.', 'x', 'y'}; // .       , arcsin , arccos							  


void key_init()
{
	keyportddr_1 = 0b11111000;
	keyport_1    = 0b00000111;
	
	keyportddr_2 = 0b10001111;
	keyport_2    = 0b01110000;
}
int get_key()
{
	int i;
	int ind = 0;
	
	for(i = 0; i < 4; i++)
	{
		keyport_1 &=~(0x80>>(4 - i));
		keyportpin_1 = 0b00000111;
		if( !bit_is_set(keyportpin_1,col1_1))
		{
			//check COL1
			while(!bit_is_set(keyportpin_1,col1_1)); //wait for release
			return ind;	//return the index of the key pressed
		}
		if( !bit_is_set(keyportpin_1,col1_2))
		{
			//check COL1
			while(!bit_is_set(keyportpin_1,col1_2)); //wait for release
			return ind + 1;	//return the index of the key pressed
		}
		if( !bit_is_set(keyportpin_1,col1_3))
		{
			//check COL1
			while(!bit_is_set(keyportpin_1,col1_3)); //wait for release
			return ind + 2;	//return the index of the key pressed
		}
		ind = ind + 3;
		keyport_1 |= (0x80>>(4 - i));
	}
	
	for(i = 0; i < 4; i++)
	{
		keyport_2   = 0b11111111;
		keyport_2 &=~(1<<(3-i));
		keyportpin_2 = 0b01110000;

		if( !bit_is_set(keyportpin_2,col2_1))
		{
			//check COL1
			while(!bit_is_set(keyportpin_2,col2_1)); //wait for release
			return ind;	//return the index of the key pressed
		}
		if( !bit_is_set(keyportpin_2,col2_2))
		{
			//check COL1
			while(!bit_is_set(keyportpin_2,col2_2)); //wait for release
			return ind + 1;	//return the index of the key pressed
		}
		if( !bit_is_set(keyportpin_2,col2_3))
		{
			//check COL1
			while(!bit_is_set(keyportpin_2,col2_3)); //wait for release
			return ind + 2;	//return the index of the key pressed
		}
		ind = ind + 3;
		keyport_2 |= (1>>(3-i));
	}
	
	return -1;
}
