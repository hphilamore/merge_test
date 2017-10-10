/*  Example playing a sinewave at a set frequency,
    using Mozzi sonification library.
  
    Demonstrates the use of Oscil to play a wavetable.
  
    Circuit: Audio output on digital pin 9 on a Uno or similar, or
    DAC/A14 on Teensy 3.1, or 
    check the README or http://sensorium.github.com/Mozzi/
  
    Mozzi help/discussion/announcements:
    https://groups.google.com/forum/#!forum/mozzi-users
  
    Tim Barrass 2012, CC by-nc-sa.
*/

//#include <ADC.h>  // Teensy 3.1 uncomment this line and install http://github.com/pedvide/ADC
#include <MozziGuts.h>
#include <Oscil.h> // oscillator template
#include <tables/sin2048_int8.h> // sine table for oscillator

// use: Oscil <table_size, update_rate> oscilName (wavetable), look in .h file of table #included above
Oscil <2048, AUDIO_RATE> aSin(SIN2048_DATA);
Oscil <2048, AUDIO_RATE> kVib(SIN2048_DATA);

float centre_freq = 440.0;
float depth = 0.25;

// use #define for CONTROL_RATE, not a constant
#define CONTROL_RATE 128 // powers of 2 please


void setup(){
  kVib.setFreq(6.5f); // set the frequency
  startMozzi(CONTROL_RATE); // set a control rate of 128 (powers of 2 please)
  aSin.setFreq(440); // set the frequency
  
}


void updateControl(){
  float vibrato = depth * kVib.next();
  aSin.setFreq(centre_freq + vibrato);
  // put changing controls in here
}


int updateAudio(){
  return aSin.next(); // return an int signal centred around 0
}


void loop(){
  audioHook(); // required here
}



