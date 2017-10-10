/*
This code is used to drive a robot to follow a reflective line of tape.
This code runs servomotors at the same speed. The red wire of each servo goes
to power and the black wire goes to ground. The white wire of each servo goes
to one of the digital pins on the Arduino (you pick the pins). The IR sensors connect to
analog pins 0 and 1.
*/

int analogPin0 = 0; // define a variable for the left IR senor pin (pin 3, output pin, from the left IR sensor

int sensorValL = 0; // variable to store the value coming from the sensor, initialize it to 0

int analogPin1 = 1; //define a variable for the right IR senor pin (pin 3, output pin, from the right IR sensor

int sensorValR = 0; // variable to store the value coming from the sensor, initialize it to 0

int leftMotorPin = 6; //select a digital pin to drive the left motor
int rightMotorPin =5; //select a digital pin to drive the right motor
int leftMotorPulseWidth = 100; 
int rightMotorPulseWidth = 100; 
int level = 600; 


void setup()
{
 pinMode(leftMotorPin, OUTPUT); // configure the pin called lefMotorPin as an output
 pinMode(rightMotorPin, OUTPUT); // configure the pin called rightMotorPin as an output
}

void loop()
{
sensorValL = analogRead(analogPin0); // left IR sensor
sensorValR = analogRead(analogPin1); //right IR sensor

 digitalWrite(leftMotorPin, HIGH);
 delayMicroseconds(1500 + leftMotorPulseWidth);
 digitalWrite(leftMotorPin, LOW);

 delayMicroseconds(20000);

 digitalWrite(rightMotorPin, HIGH);
 delayMicroseconds(1500 - rightMotorPulseWidth);
 digitalWrite(rightMotorPin, LOW);


if ( sensorValL > level) rightMotorPulseWidth = 0;

if ( sensorValL <= level) rightMotorPulseWidth = 100;

if ( sensorValL > level) leftMotorPulseWidth = 0;

if ( sensorValR > level) leftMotorPulseWidth = 0;

if ( sensorValR <= level) leftMotorPulseWidth = 100;

if ( sensorValR > level) rightMotorPulseWidth = 0;
}
