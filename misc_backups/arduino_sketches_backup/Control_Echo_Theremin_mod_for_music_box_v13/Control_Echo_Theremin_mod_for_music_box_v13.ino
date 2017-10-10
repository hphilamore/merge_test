/*  Example of a simple light-sensing theremin-like
		instrument with long echoes,
		using Mozzi sonification library.
	
		Demonstrates ControlDelay() for echoing control values,
		and smoothing an analog input from a sensor
		signal with RollingAverage().
	
		The circuit: 
	 
			 Audio output on digital pin 9 on a Uno or similar, or
			DAC/A14 on Teensy 3.1, or 
			 check the README or http://sensorium.github.com/Mozzi/
	
		Light dependent resistor (LDR) and 5.1k resistor on analog pin 1:
			 LDR from analog pin to +5V (3.3V on Teensy 3.1)
			 5.1k resistor from analog pin to ground
		
		Mozzi help/discussion/announcements:
		https://groups.google.com/forum/#!forum/mozzi-users
	
		Tim Barrass 2013, CC by-nc-sa.
*/

//#include <ADC.h>  // Teensy 3.1 uncomment this line and install http://github.com/pedvide/ADC
#include <MozziGuts.h>
#include <Oscil.h> // oscillator template

#include <tables/sin2048_int8.h> // sine table for oscillator
#include <RollingAverage.h>
#include <ControlDelay.h>

#define left_echoPin 4 // Echo Pin
#define left_trigPin 3 // Trigger Pin
#define maxD 20
//#define MAX_DISTANCE 10 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
#define INPUT_PIN 0 // analog control input
const char KNOB_PIN = 0; // set the input for the knob to analog pin

unsigned int echo_cells_1 = 32;
unsigned int echo_cells_2 = 60;
unsigned int echo_cells_3 = 127;

#define CONTROL_RATE 64
ControlDelay <128, int> kDelay; // 2seconds

// oscils to compare bumpy to averaged control input
Oscil <SIN2048_NUM_CELLS, AUDIO_RATE> aSin0(SIN2048_DATA);
Oscil <SIN2048_NUM_CELLS, AUDIO_RATE> aSin1(SIN2048_DATA);
Oscil <SIN2048_NUM_CELLS, AUDIO_RATE> aSin2(SIN2048_DATA);
Oscil <SIN2048_NUM_CELLS, AUDIO_RATE> aSin3(SIN2048_DATA);

byte volume;

// use: RollingAverage <number_type, how_many_to_average> myThing
RollingAverage <int, 32> kAverage; // how_many_to_average has to be power of 2
//int averaged;
//int average_knob

void setup(){
  kDelay.set(echo_cells_1);
  Serial.begin(115200); // NEEDED FOR NICE SOUND 
  startMozzi();

  int knob_value = 500;
  volume = knob_value >> 2;  // 10 bits (0->1023) shifted right by 2 bits to give 8 bits (0->255)

  pinMode(left_echoPin, INPUT);
  pinMode(left_trigPin, OUTPUT);
}


void updateControl(){
//
//  pinMode(left_echoPin, INPUT);
//  pinMode(left_trigPin, OUTPUT);
  
  int bumpy_input = mozziAnalogRead(INPUT_PIN);
  int knob = mozziAnalogRead(KNOB_PIN); // value is 0-1023
  //int light_level = getDistance(left_echoPin, left_trigPin) * 10;

  digitalWrite(left_trigPin, LOW); 
     //delayMicroseconds(2); 
    
  digitalWrite(left_trigPin, HIGH);
  delayMicroseconds(2); 
     
  digitalWrite(left_trigPin, LOW);
     
  int duration = pulseIn(left_echoPin, HIGH);
  int distance = duration/58.2;
  int average_string_freq;

  if (distance >=0){
    // int string_freq = 100 * distance/5;
    // int string_freq = 100 * distance/2;
    // int string_freq = 1024 - (100 * distance/2);
    int string_freq = 1100 - (100 * distance/ 4);
    average_string_freq = kAverage.next(string_freq);
    aSin0.setFreq(average_string_freq);
    Serial.println(distance);
    Serial.println(average_string_freq);


       if (average_string_freq >=0){         
        aSin0.setFreq(average_string_freq);   
      }
      else{
        aSin0.setFreq(2);
      }         
  }
  else{
    aSin0.setFreq(2);
  }

  aSin1.setFreq(kDelay.next(average_string_freq));
  aSin2.setFreq(kDelay.read(echo_cells_2));
  aSin3.setFreq(kDelay.read(echo_cells_3));
     
}


int updateAudio(){
//  return 3*((int)aSin0.next()+aSin1.next()+(aSin2.next()>>1)
//    +(aSin3.next()>>2)) >>3;

    //return ((int)aSin0.next()) >> 8;

    return ((int)aSin0.next() * volume) >> 8;
}


void loop(){
  audioHook();
}

int getDistance(int echoPin, int trigPin)
{
long duration, distance; // Duration used to calculate distance

   
 pinMode(trigPin, OUTPUT);
 pinMode(echoPin, INPUT);
  
    digitalWrite(trigPin, LOW); 
     //delayMicroseconds(2); 
    
     digitalWrite(trigPin, HIGH);
     //delayMicroseconds(2); 
     
     digitalWrite(trigPin, LOW);
     
     duration = pulseIn(echoPin, HIGH);
     return duration;
     //Calculate the distance (in cm) based on the speed of sound.
//     distance = duration/58.2;
//     return(distance);
     
}


