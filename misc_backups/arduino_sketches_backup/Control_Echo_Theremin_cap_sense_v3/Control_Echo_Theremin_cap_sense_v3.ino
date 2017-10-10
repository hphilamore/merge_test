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
#include <CapacitiveSensor.h>

#define INPUT_PIN 0 // analog control input

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

CapacitiveSensor   cs_4_2 = CapacitiveSensor(4,2);        // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
CapacitiveSensor   cs_4_6 = CapacitiveSensor(4,6);        // 10M resistor between pins 4 & 6, pin 6 is sensor pin, add a wire and or foil
CapacitiveSensor   cs_4_8 = CapacitiveSensor(4,8);        // 10M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil


// use: RollingAverage <number_type, how_many_to_average> myThing
RollingAverage <int, 32> kAverage; // how_many_to_average has to be power of 2
int averaged;
int total_1;

void setup(){
  kDelay.set(echo_cells_1);
  startMozzi();
  cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  Serial.begin(9600);
}


void updateControl(){

  //long start = millis();
//  long total1 =  cs_4_2.capacitiveSensor(10);
  long total1 =  cs_4_2.capacitiveSensor(5);
  total_1 = (int) total1;
  
  
  int bumpy_input = mozziAnalogRead(INPUT_PIN);
  averaged = kAverage.next(bumpy_input);
  averaged = kAverage.next(total_1);
 // aSin0.setFreq(averaged * 2);

  aSin0.setFreq(averaged * 3);
  //aSin0.setFreq(total_1);
  //aSin0.setFreq(600);
  aSin1.setFreq(kDelay.next(averaged));  
  aSin2.setFreq(kDelay.read(echo_cells_2));
  aSin3.setFreq(kDelay.read(echo_cells_3));

//  Serial.print(millis() - start);        // check on performance in milliseconds
//  Serial.print("\t");                    // tab character for debug windown spacing
//
  //Serial.println(2500 - averaged * 3);                  // print sensor output 1
  Serial.println(averaged * 3);                  // print sensor output 1
  //Serial.print("\t");
//////  Serial.print(echo_cells_2);                  // print sensor output 2
//////  Serial.print("\t");
//////  Serial.print(echo_cells_3);                  // print sensor output 2
//////  Serial.print("\t");
//////  Serial.print(total1);                  // print sensor output 1
//  Serial.print("\t");
//  Serial.println(total_1);                  // print sensor output 1
    
   
}


int updateAudio(){
   
  return 3*((int)aSin0.next()+aSin1.next()+(aSin2.next()>>1)
    +(aSin3.next()>>2)) >>3;

}


void loop(){
  audioHook();
}


