// Arduino Signal Filtering Library: median filter example
// Copyright 2012-2015 Jeroen Doggen (jeroendoggen@gmail.com)
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

#define right_echoPin 8 // Echo Pin
#define right_trigPin 7 // Trigger Pin
#define mid_echoPin 6 // Echo Pin
#define mid_trigPin 5 // Trigger Pin
#define left_echoPin 4 // Echo Pin
#define left_trigPin 3 // Trigger Pin

int rightStringPin = 11;
int midStringPin = 10;
int leftStringPin = 9;

medianFilter rightFilter;
medianFilter midFilter;
medianFilter leftFilter;
medianFilter Filter;

int level;
int value;
int filtered;
int maxDistance = 50;


void setup()
{
  Serial.begin(115200);
  rightFilter.begin();
  midFilter.begin();
  leftFilter.begin();
  
  pinMode(rightStringPin, OUTPUT); 
  pinMode(midStringPin, OUTPUT); 
  pinMode(leftStringPin, OUTPUT);   
}

void loop()
{
//###############
  //value = analogRead(A0);
  value = getDistance(left_echoPin, left_trigPin);
  filtered= leftFilter.run(value);
  level = map(value, 0, 40, NOTE_C6, NOTE_C3);
  
  Serial.print("In: ");
  Serial.print(value);
  Serial.print(" - Out: ");
  Serial.print(filtered);
  // Jouhikko strings gda
 
  if(value < maxDistance){
          //setPwmFrequency(11,level);
         //pwmWrite(11, level);
         tone(leftStringPin, level);
        // delay(maxDistance);
      }
      else {
        noTone(leftStringPin);
      }
  
  //delay(100);                                     //make it readable
  //delay(10);                                     //make it readable
  delay(50);                                     //make it readable
// ################

//  Serial.print("\t");
//
  //value = analogRead(A0);
  value = getDistance(right_echoPin, right_trigPin);
  filtered= rightFilter.run(value);
  level = map(value, 0, 40, NOTE_C6, NOTE_C3);
  
  Serial.print("In: ");
  Serial.print(value);
  Serial.print(" - Out: ");
  Serial.println(filtered);
  // Jouhikko strings gda
 
  if(value < maxDistance){
          //setPwmFrequency(11,level);
         //pwmWrite(11, level);
         tone(rightStringPin, level);
//         delay(maxDistance);
      }
      else {
        noTone(rightStringPin);
      }
  
  //delay(100);                                     //make it readable
  //delay(10);                                     //make it readable
  delay(50);                                     //make it readable

  
///

 Serial.println();
  
}



void DistanceToSound(int echoPin, int trigPin, int StringPin, int range_high, int range_low){

  value = getDistance(echoPin, trigPin);
  filtered= Filter.run(value);
  int level = map(value, 0, 40, range_high, range_low);
  
  Serial.print("In: ");
  Serial.print(value);
  Serial.print(" - Out: ");
  Serial.print(filtered);
  Serial.print("\t");
  // Jouhikko strings gda
 
  if(value < maxDistance){
          //setPwmFrequency(11,level);
         //pwmWrite(11, level);
         tone(StringPin, level);
         delay(50);
      }
      else {
        noTone(StringPin);
      }
  
  //delay(100);                                     //make it readable
  //delay(10);                                     //make it readable
  delay(50);                                     //make it readable
  
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
