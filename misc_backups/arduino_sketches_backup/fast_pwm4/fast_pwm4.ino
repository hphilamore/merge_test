#include <avr/interrupt.h> // Use timer interrupt library

/******** Sine wave parameters ********/
#define PI2 6.283185 // 2*PI saves calculation later
#define AMP 127 // Scaling factor for sine wave
#define OFFSET 128 // Offset shifts wave to all >0 values

/******** Lookup table ********/
#define LENGTH 256 // Length of the wave lookup table
byte wave[LENGTH]; // Storage for waveform

void setup() {
Serial.begin(9600);
/* Populate the waveform table with a sine wave */
for (int i=0; i<LENGTH; i++) { // Step across wave table
   float v = (AMP*sin((PI2/LENGTH)*i)); // Compute value
   wave[i] = int(v+OFFSET); // Store value as integer
  Serial.println(wave[i]);
 }


/****Set timer1 for 8-bit fast PWM output ****/
 pinMode(9, OUTPUT); // Make timer’s PWM pin an output
   pinMode(3, OUTPUT); // output pin for OCR2B, this is Arduino pin number
  pinMode(11, OUTPUT); // output pin for OCR0B
  pinMode(12, OUTPUT); // output pin for OCR0B
  pinMode(9, OUTPUT); // output pin for OCR2B, this is Arduino pin number
  pinMode(10, OUTPUT); // output pin for OCR0B
 TCCR1B = (1 << CS10); // Set prescaler to full 16MHz
 TCCR1A |= (1 << COM1A1); // Pin low when TCNT1=OCR1A
 TCCR1A |= (1 << WGM20); // Use 8-bit fast PWM mode
 TCCR1B |= (1 << WGM12);

 OCR1A = 100; // Set frequency of generated wave
 
 OCR1A = 100; // Set frequency of generated wave

/******** Set up timer2 to call ISR ********/
// TCCR2A = 0; // No options in control register A
// TCCR2B = (1 << CS21); // Set prescaler to divide by 8
// TIMSK2 = (1 << OCIE2A); // Call ISR when TCNT2 = OCRA2
// OCR2A = 18; // Set frequency of generated wave
 //sei(); // Enable interrupts to generate waveform!
}

void loop() { // Nothing to do!

////OCR2A = 18; // Set frequency of generated wave
//_delay_us(1000);
//delay(1000);
//OCR2A = 14; // Set frequency of generated wave
//delay(1000);
//OCR2A = 15; // Set frequency of generated wave
//delay(1000);
//TCCR1A |= (1 << WGM12); // Use 8-bit fast PWM mode
////delay(1000);
//OCR2A = 16; // Set frequency of generated wave
//delay(1000);
//OCR2A = 17; // Set frequency of generated wave
//delay(1000);
//OCR2A = 18; // Set frequency of generated wave
//delay(1000);
//OCR2A = 19; // Set frequency of generated wave
//delay(1000);
////OCR2A = 20; // Set frequency of generated wave
//TCCR1A = _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM10); // Output A frequency: 16 MHz / 64 / (180+1) / 2 = 690.6Hz
OCR1A = 100; // Set frequency of generated wave
//delay(1000);
//OCR2A = 32; // Set frequency of generated wave

//while (1)
//  {
//
//   _delay_us(5);
//    if ( OCR2A < 63 )
//      OCR2A += 5;
//    else
//      OCR2A = 0;
//  }
  
}

///******** Called every time TCNT2 = OCR2A ********/
//ISR(TIMER2_COMPA_vect) { // Called when TCNT2 == OCR2A
// static byte index=0; // Points to each table entry
// OCR1AL = wave[index++]; // Update the PWM output
// asm("NOP;NOP"); // Fine tuning
// TCNT2 = 6; // Timing to compensate for ISR run time
//}
