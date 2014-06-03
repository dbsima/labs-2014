/*
Similar cu placa de laborator, pe placa de etapa I exista un buton USER,
pe care îl puteti folosi cum doriti. Switch-ul este legat pe PD6 si are o 
rezistenta la masa pentru când butonul este apasat.

Setup-ul curent are nevoie de activarea rezistentelor de pull-up pentru a 
functiona ca în laborator, dar are avantajul ca nu deranjeaza atunci când 
este nevoie de PD6 în alte scopuri si protejeaza microcontroller-ul de 
scurturi (pentru cazul în care setati PD6 ca output pe 0 si apasati în 
acelasi timp butonul).
*/

#include <avr/io.h>
 
int main()
{
  DDRD &= ~(1 << PD6);  // pinul PD6 va fi input
  PORTD |= (1 << PD6);  // activam rezistenta de pull-up
 
  DDRD |= (1 << PD7);   // pinul corespunzator led-ului USER este output
 
  while (1)
  {
    if (!(PIND & (1 << PD6))) // daca bitul corespunzator PD6 este 0
      PORTD |= (1 << PD7);    // LED ON
    else 
      PORTD &= ~(1 << PD7);   // LED OFF
  }
  return 0;
}