/*
Arduino Servo Test sketch
*/
#include <Servo.h>
Servo servoMain; // Define our Servo
Servo servoSwim;
int button = 2;
int enable_mouth = 3;
int phase_mouth = 4;
int enable_swim = 5;

void setup()
{
   pinMode(button, INPUT);
   pinMode(enable_mouth, OUTPUT);
   pinMode(phase_mouth, OUTPUT);
   pinMode(enable_swim, OUTPUT);

   digitalWrite(button, LOW);
   digitalWrite(enable_mouth, LOW);
   digitalWrite(phase_mouth, LOW);
   digitalWrite(enable_swim, LOW);
   
   Serial.begin(9600);
  
}


void loop()

/////////////////////////////////////////////////////
// EAT - OPEN
////////////////////////////////////////////////////

{

   if (digitalRead(button) == HIGH)
      {
       digitalWrite(enable_mouth, HIGH);
       delay(3000); 
       digitalWrite(enable_mouth, LOW);
       delay(100);

       digitalWrite(enable_swim, HIGH);
       delay(10000); 
       digitalWrite(enable_swim, LOW);
       delay(100);

       digitalWrite(phase_mouth, HIGH);
       digitalWrite(enable_mouth, HIGH);
       delay(5000); 
       digitalWrite(enable_mouth, LOW);
       digitalWrite(phase_mouth, LOW);
       delay(100);
      }
    
    
  else
  {
    digitalWrite(enable_swim, LOW);
    digitalWrite(enable_mouth, LOW);
    digitalWrite(phase_mouth, LOW);
  }

}
  

