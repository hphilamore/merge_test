/*  Example sliding between frequencies,
    using Mozzi sonification library.
  
    Demonstrates using Smooth to filter a control signal.
  
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
#include <EventDelay.h>
#include <Smooth.h>
#include <mozzi_midi.h>

// this is a high value to avoid zipper noise
#define CONTROL_RATE 1024 

#define left_echoPin 4 // Echo Pin
#define left_trigPin 3 // Trigger Pin

// use: Oscil <table_size, update_rate> oscilName (wavetable), look in .h file of table #included above
Oscil <SIN2048_NUM_CELLS, AUDIO_RATE> aSin(SIN2048_DATA);

// for scheduling freq changes
EventDelay kFreqChangeDelay;

Smooth <int> kSmoothFreq(0.975f);
int target_freq, target_freq1, target_freq2;


void setup(){
  Serial.begin (115200);
  target_freq1 = 441;
  target_freq2 = 330;
  target_freq = 300;
  kFreqChangeDelay.set(1000); // 1000ms countdown, within resolution of CONTROL_RATE
  startMozzi(CONTROL_RATE);
  pinMode(left_echoPin, INPUT);
  pinMode(left_trigPin, OUTPUT);
}


void updateControl(){

  digitalWrite(left_trigPin, LOW); 
     //delayMicroseconds(2); 
    
  digitalWrite(left_trigPin, HIGH);
  delayMicroseconds(2); 
     
  digitalWrite(left_trigPin, LOW);

  int duration = pulseIn(left_echoPin, HIGH);
  int distance = duration/58.2;
  
  if(kFreqChangeDelay.ready()){
//    if (target_freq == target_freq1) {
//      target_freq = target_freq2;
//    }
//    else{
//      target_freq = target_freq1;
//    }
    kFreqChangeDelay.start();
  }

  int smoothed_freq = kSmoothFreq.next(target_freq);
  aSin.setFreq(smoothed_freq);
}


int updateAudio(){
  return aSin.next();
}


void loop(){
  audioHook();
}

