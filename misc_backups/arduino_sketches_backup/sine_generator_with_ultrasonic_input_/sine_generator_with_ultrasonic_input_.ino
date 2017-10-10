/*
 *
 * DDS Sine Generator mit ATMEGS 168
 * Timer2 generates the  31250 KHz Clock Interrupt
 *
 * KHM 2009 /  Martin Nawrath
 * Kunsthochschule fuer Medien Koeln
 * Academy of Media Arts Cologne

 */

 #define NOTE_B0  31
#define NOTE_C1  33
#define NOTE_CS1 35
#define NOTE_D1  37
#define NOTE_DS1 39
#define NOTE_E1  41
#define NOTE_F1  44
#define NOTE_FS1 46
#define NOTE_G1  49
#define NOTE_GS1 52
#define NOTE_A1  55
#define NOTE_AS1 58
#define NOTE_B1  62
#define NOTE_C2  65
#define NOTE_CS2 69
#define NOTE_D2  73
#define NOTE_DS2 78
#define NOTE_E2  82
#define NOTE_F2  87
#define NOTE_FS2 93
#define NOTE_G2  98
#define NOTE_GS2 104
#define NOTE_A2  110
#define NOTE_AS2 117
#define NOTE_B2  123
#define NOTE_C3  131
#define NOTE_CS3 139
#define NOTE_D3  147
#define NOTE_DS3 156
#define NOTE_E3  165
#define NOTE_F3  175
#define NOTE_FS3 185
#define NOTE_G3  196
#define NOTE_GS3 208
#define NOTE_A3  220
#define NOTE_AS3 233
#define NOTE_B3  247
#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494
#define NOTE_C5  523
#define NOTE_CS5 554
#define NOTE_D5  587
#define NOTE_DS5 622
#define NOTE_E5  659
#define NOTE_F5  698
#define NOTE_FS5 740
#define NOTE_G5  784
#define NOTE_GS5 831
#define NOTE_A5  880
#define NOTE_AS5 932
#define NOTE_B5  988
#define NOTE_C6  1047
#define NOTE_CS6 1109
#define NOTE_D6  1175
#define NOTE_DS6 1245
#define NOTE_E6  1319
#define NOTE_F6  1397
#define NOTE_FS6 1480
#define NOTE_G6  1568
#define NOTE_GS6 1661
#define NOTE_A6  1760
#define NOTE_AS6 1865
#define NOTE_B6  1976
#define NOTE_C7  2093
#define NOTE_CS7 2217
#define NOTE_D7  2349
#define NOTE_DS7 2489
#define NOTE_E7  2637
#define NOTE_F7  2794
#define NOTE_FS7 2960
#define NOTE_G7  3136
#define NOTE_GS7 3322
#define NOTE_A7  3520
#define NOTE_AS7 3729
#define NOTE_B7  3951
#define NOTE_C8  4186
#define NOTE_CS8 4435
#define NOTE_D8  4699
#define NOTE_DS8 4978

#include <medianFilter.h>

#define left_echoPin 4 // Echo Pin
#define left_trigPin 3 // Trigger Pin

int soundpin = 11;

medianFilter Filter;

int value;
int filtered;
int maxDistance = 50;

#include "avr/pgmspace.h"
typedef const unsigned char prog_uchar;

// table of 256 sine values / one sine period / stored in flash memory
PROGMEM  prog_uchar sine256[]  = {
  127,130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,176,178,181,184,187,190,192,195,198,200,203,205,208,210,212,215,217,219,221,223,225,227,229,231,233,234,236,238,239,240,
  242,243,244,245,247,248,249,249,250,251,252,252,253,253,253,254,254,254,254,254,254,254,253,253,253,252,252,251,250,249,249,248,247,245,244,243,242,240,239,238,236,234,233,231,229,227,225,223,
  221,219,217,215,212,210,208,205,203,200,198,195,192,190,187,184,181,178,176,173,170,167,164,161,158,155,152,149,146,143,139,136,133,130,127,124,121,118,115,111,108,105,102,99,96,93,90,87,84,81,78,
  76,73,70,67,64,62,59,56,54,51,49,46,44,42,39,37,35,33,31,29,27,25,23,21,20,18,16,15,14,12,11,10,9,7,6,5,5,4,3,2,2,1,1,1,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,9,10,11,12,14,15,16,18,20,21,23,25,27,29,31,
  33,35,37,39,42,44,46,49,51,54,56,59,62,64,67,70,73,76,78,81,84,87,90,93,96,99,102,105,108,111,115,118,121,124

};

//PROGMEM const unsigned char sine256[]  = {
//  127,130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,176,178,181,184,187,190,192,195,198,200,203,205,208,210,212,215,217,219,221,223,225,227,229,231,233,234,236,238,239,240,
//  242,243,244,245,247,248,249,249,250,251,252,252,253,253,253,254,254,254,254,254,254,254,253,253,253,252,252,251,250,249,249,248,247,245,244,243,242,240,239,238,236,234,233,231,229,227,225,223,
//  221,219,217,215,212,210,208,205,203,200,198,195,192,190,187,184,181,178,176,173,170,167,164,161,158,155,152,149,146,143,139,136,133,130,127,124,121,118,115,111,108,105,102,99,96,93,90,87,84,81,78,
//  76,73,70,67,64,62,59,56,54,51,49,46,44,42,39,37,35,33,31,29,27,25,23,21,20,18,16,15,14,12,11,10,9,7,6,5,5,4,3,2,2,1,1,1,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,9,10,11,12,14,15,16,18,20,21,23,25,27,29,31,
//  33,35,37,39,42,44,46,49,51,54,56,59,62,64,67,70,73,76,78,81,84,87,90,93,96,99,102,105,108,111,115,118,121,124
//}


#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))

int ledPin = 13;                 // LED pin 7
int testPin = 7;
int t2Pin = 6;
byte bb;

double dfreq;
// const double refclk=31372.549;  // =16MHz / 510
const double refclk=31376.6;      // measured

// variables used inside interrupt service declared as voilatile
volatile byte icnt;              // var inside interrupt
volatile byte icnt1;             // var inside interrupt
volatile byte c4ms;              // counter incremented all 4ms
volatile unsigned long phaccu;   // pahse accumulator
volatile unsigned long tword_m;  // dds tuning word m

void setup()
{
  pinMode(ledPin, OUTPUT);      // sets the digital pin as output
  Serial.begin(115200);        // connect to the serial port
  Serial.println("DDS Test");

  pinMode(6, OUTPUT);      // sets the digital pin as output
  pinMode(7, OUTPUT);      // sets the digital pin as output
  pinMode(11, OUTPUT);     // pin11= PWM  output / frequency output
  Filter.begin();
  pinMode(soundpin, OUTPUT);   

  Setup_timer2();

  // disable interrupts to avoid timing distortion
  cbi (TIMSK0,TOIE0);              // disable Timer0 !!! delay() is now not available
  sbi (TIMSK2,TOIE2);              // enable Timer2 Interrupt

  dfreq=1000.0;                    // initial output frequency = 1000.o Hz
  tword_m=pow(2,32)*dfreq/refclk;  // calulate DDS new tuning word 

}
void loop()
{
  while(1) {
     if (c4ms > 250) {                 // timer / wait fou a full second
      c4ms=0;

      value = getDistance(left_echoPin, left_trigPin);
      filtered= Filter.run(value);
      Serial.print("In: ");
      Serial.print(value);
      Serial.print(" - Out: ");
      Serial.println(filtered);
      // Jouhikko strings gda
      int level = map(value, 0, 40, NOTE_C6, NOTE_C3);

      
      //dfreq=analogRead(0);             // read Poti on analog pin 0 to adjust output frequency from 0..1023 Hz
      dfreq=level/5;             // read Poti on analog pin 0 to adjust output frequency from 0..1023 Hz

      cbi (TIMSK2,TOIE2);              // disble Timer2 Interrupt
      tword_m=pow(2,32)*dfreq/refclk;  // calulate DDS new tuning word
      sbi (TIMSK2,TOIE2);              // enable Timer2 Interrupt 

      Serial.print(dfreq);
      Serial.print("  ");
      Serial.println(tword_m);
    }

   sbi(PORTD,6); // Test / set PORTD,7 high to observe timing with a scope
   cbi(PORTD,6); // Test /reset PORTD,7 high to observe timing with a scope
  }
 }
//******************************************************************
// timer2 setup
// set prscaler to 1, PWM mode to phase correct PWM,  16000000/510 = 31372.55 Hz clock
void Setup_timer2() {

// Timer2 Clock Prescaler to : 1
  sbi (TCCR2B, CS20);
  cbi (TCCR2B, CS21);
  cbi (TCCR2B, CS22);

  // Timer2 PWM Mode set to Phase Correct PWM
  cbi (TCCR2A, COM2A0);  // clear Compare Match
  sbi (TCCR2A, COM2A1);

  sbi (TCCR2A, WGM20);  // Mode 1  / Phase Correct PWM
  cbi (TCCR2A, WGM21);
  cbi (TCCR2B, WGM22);
}

//******************************************************************
// Timer2 Interrupt Service at 31372,550 KHz = 32uSec
// this is the timebase REFCLOCK for the DDS generator
// FOUT = (M (REFCLK)) / (2 exp 32)
// runtime : 8 microseconds ( inclusive push and pop)
ISR(TIMER2_OVF_vect) {

  sbi(PORTD,7);          // Test / set PORTD,7 high to observe timing with a oscope

  phaccu=phaccu+tword_m; // soft DDS, phase accu with 32 bits
  icnt=phaccu >> 24;     // use upper 8 bits for phase accu as frequency information
                         // read value fron ROM sine table and send to PWM DAC
  OCR2A=pgm_read_byte_near(sine256 + icnt);    

  if(icnt1++ == 125) {  // increment variable c4ms all 4 milliseconds
    c4ms++;
    icnt1=0;
   }   

 cbi(PORTD,7);            // reset PORTD,7
}

int getDistance(int echoPin, int trigPin)
{
long duration, distance; // Duration used to calculate distance
   
 pinMode(trigPin, OUTPUT);
 pinMode(echoPin, INPUT);
  
    digitalWrite(trigPin, LOW); 
     //delayMicroseconds(2); 
    
     digitalWrite(trigPin, HIGH);
     delayMicroseconds(2); 
     
     digitalWrite(trigPin, LOW);
     
     duration = pulseIn(echoPin, HIGH);
 
     //Calculate the distance (in cm) based on the speed of sound.
     distance = duration/58.2;
     return(distance);     
}
