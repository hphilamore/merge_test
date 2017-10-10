#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
                // twelve servo objects can be created on most boards
 
void setup() 
{ 
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
} 
 
void loop() 
{ 

    myservo.write(75);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
 
} 




