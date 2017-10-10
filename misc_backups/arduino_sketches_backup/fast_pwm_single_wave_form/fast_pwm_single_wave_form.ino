#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
  pinMode(3, OUTPUT); // output pin for OCR2B, this is Arduino pin number
  pinMode(11, OUTPUT); // output pin for OCR0B
  pinMode(12, OUTPUT); // output pin for OCR0B
  pinMode(9, OUTPUT); // output pin for OCR2B, this is Arduino pin number
  pinMode(10, OUTPUT); // output pin for OCR0B

  TCCR2A = _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM20); // Output A frequency: 16 MHz / 64 / (180+1) / 2 = 690.6Hz
  
  TCCR2B = _BV(CS22);                                           // Output B frequency: 16 MHz / 64 / 255 / 2 = 490.196Hz

  //TCCR2B = TCCR2B & 0b11111000 | 0x05;
  
  OCR2A = 180;
  OCR2B = 10;

  TCCR1A = _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM10); // Output A frequency: 16 MHz / 64 / (180+1) / 2 = 690.6Hz
  
  TCCR1B = _BV(CS10);                                           // Output B frequency: 16 MHz / 64 / 255 / 2 = 490.196Hz

  //TCCR2B = TCCR2B & 0b11111000 | 0x05;
  
  OCR1A = 100;
  OCR1B = 50;

   
//  TCCR1B = (1 << CS10); // Set prescaler to full 16MHz
//  TCCR1A |= (1 << COM1A1); // Pin low when TCNT1=OCR1A
//  TCCR1A |= (1 << WGM10); // Use 8-bit fast PWM mode
//  TCCR1B |= (1 << WGM12);
//
//   TCCR2A = 0; // No options in control register A
//   TCCR2B = (1 << CS21); // Set prescaler to divide by 8
//   TIMSK2 = (1 << OCIE2A); // Call ISR when TCNT2 = OCRA2
//   OCR2A = 32; // Set frequency of generated wave
//   sei(); // Enable interrupts to generate waveform!
  
//  // In the next line of code, we:
//  // 1. Set the compare output mode to clear OC2A and OC2B on compare match.
//  //    To achieve this, we set bits COM2A1 and COM2B1 to high.
//  // 2. Set the waveform generation mode to fast PWM (mode 3 in datasheet).
//  //    To achieve this, we set bits WGM21 and WGM20 to high.
//  TCCR2A = _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM20);
//
//  // In the next line of code, we:
//  // 1. Set the waveform generation mode to fast PWM mode 7 —reset counter on
//  //    OCR2A value instead of the default 255. To achieve this, we set bit
//  //    WGM22 to high.
//  // 2. Set the prescaler divisor to 1, so that our counter will be fed with
//  //    the clock's full frequency (16MHz). To achieve this, we set CS20 to
//  //    high (and keep CS21 and CS22 to low by not setting them).
//  TCCR2B = _BV(WGM22) | _BV(CS20);
//
//  // OCR2A holds the top value of our counter, so it acts as a divisor to the
//  // clock. When our counter reaches this, it resets. Counting starts from 0.
//  // Thus 63 equals to 64 divs.
//  OCR2A = 63;
//  // This is the duty cycle. Think of it as the last value of the counter our
//  // output will remain high for. Can't be greater than OCR2A of course. A
//  // value of 0 means a duty cycle of 1/64 in this case.
//  OCR2B = 0;
//
//  // Just some code to change the duty cycle every 5 microseconds.
//  while (1)
//  {
//    _delay_us(5);
//    if ( OCR2B < 63 )
//      OCR2B += 5;
//    else
//      OCR2B = 0;
//
//   _delay_us(5);
//    if ( OCR2A < 63 )
//      OCR1A += 5;
//    else
//      OCR1A = 0;
//  }
}
