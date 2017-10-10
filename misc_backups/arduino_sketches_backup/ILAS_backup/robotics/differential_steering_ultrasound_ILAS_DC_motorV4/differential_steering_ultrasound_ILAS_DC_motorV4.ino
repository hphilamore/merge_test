/******************************************************************************
Code based on:
Differential steering with continuous rotation servos and Arduino Uno:
http://42bots.com/tutorials/differential-steering-with-continuous-rotation-servos-and-arduino/
L298 motor driver:
https://tronixlabs.com.au/news/tutorial-l298n-dual-motor-controller-module-2a-and-arduino/
Optical tachometer:
https://learn.sparkfun.com/tutorials/qrd1114-optical-detector-hookup-guide?_ga=1.57060067.834043405.1459523277
www.instructables.com/id/Arduino-Based-Optical-Tachometer/
4 --> left servo
3 --> right servo
2 --> Photodetector Collector pin
******************************************************************************/
//#include <Servo.h>
#include <NewPing.h>

#define LEFT 0
#define RIGHT 1

long coder[2] = {
  0,0};
int lastSpeed[2] = {
  0,0};

#define TRIGGER_PIN_SIDE  13  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN_SIDE     12  // Arduino pin tied to echo pin on the ultrasonic sensor.
//#define TRIGGER_PIN_FRONT  4  // Arduino pin tied to trigger pin on the ultrasonic sensor.
//#define ECHO_PIN_FRONT     3  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 200 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
//#define RED_PIN  5  // Arduino pin tied to trigger pin on the ultrasonic sensor.
//#define GREEN_PIN     6  // Arduino pin tied to echo pin on the ultrasonic sensor.

NewPing side_sonar(TRIGGER_PIN_SIDE, ECHO_PIN_SIDE, MAX_DISTANCE); // NewPing setup of pins and maximum distance.
//NewPing front_sonar(TRIGGER_PIN_FRONT, ECHO_PIN_FRONT, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

const float pi = 3.142;
const float DistanceFromWall = 15;
const float DistanceFromObstacle = 15;

// the number of pulses on the encoder wheel
float EnRes = 10;

// motor one
int enA = 5;
int in1 = 7;
int in2 = 6;
// motor two
int enB = 9;
int in3 = 11;
int in4 = 10;

int check = 255;

// the time (in mS) increment to record the encoder output for before outputting to serial 
//int TachoIncrement = 2000;
int TachoIncrement = 500;

// timer and counter variables
// sets the period an operation lasts for in mS
long DrivePeriod;
long TachoPeriod;
long OpPeriod;
volatile unsigned long minElapsed = 10;
volatile unsigned long maxElapsed = 2500;
volatile unsigned long elapsedTime;
volatile unsigned long previousTime;
unsigned long DriveStartTime;
unsigned long TachoStartTime;
unsigned long count;
unsigned long Time;
unsigned long T;
unsigned long timeold;
float timer;    
float rps;
float radps;
int PWM_signal;
int PWM_min;
int PWM_max;

float speedL;
float speedR;

unsigned long counter;

//Servo LeftServo;
//Servo RightServo;

//// the control signal for the left servo
//const int leftServoPin = 4;
//
//// the control signal for the right servo
//const int rightServoPin = 3;

void setup()
{
//   LeftServo.attach(leftServoPin);
//   leftServo.attach(rightServoPin);

//   pinMode(RED_PIN, OUTPUT);
//   pinMode(GREEN_PIN, OUTPUT);
   
   
   Serial.begin(9600);
   
   //Interrupt 0 is digital pin 2, so that is where the IR detector is connected
   //Triggers on RISING (FALLING from HIGH to LOW)
  attachInterrupt(0, LwheelSpeed, FALLING);    //init the interrupt mode for the digital pin 2
  attachInterrupt(1, RwheelSpeed, FALLING);   //init the interrupt mode for the digital pin 3
   
   //attachInterrupt(0, rps_fun, FALLING);
  
   count = 0;
   timeold = 0;


    pinMode(enA, OUTPUT);
    pinMode(in1, OUTPUT);
    pinMode(in2, OUTPUT);
    pinMode(enB, OUTPUT);
    pinMode(in3, OUTPUT);
    pinMode(in4, OUTPUT);
   
   
//   Serial.print("side");
//   Serial.print("\t");
//   Serial.println("front");
}

void loop() 
{
//digitalWrite(in3, LOW);
//digitalWrite(in4, HIGH);
 for (int i = 100; i < 255; i = i + 10)  
  {
    Drive(i, i, 4000); 
    //analogWrite(enB, i);
  }
  // decelerate from maximum speed to zero
  for (int i = 255; i >= 100; i = i - 10)
  {
    Drive(i, i, 4000); 
    //analogWrite(enB, i);
  }  
   
 }



  void LwheelSpeed()
{
//  elapsedTime = millis() - previousTime;
//  if (elapsedTime < minElapsed )  //false interrupt
//  {
//    return;
//  }
//  if (elapsedTime >= minElapsed && elapsedTime <= maxElapsed )  //in range
//  {
//    previousTime = millis();
//    coder[LEFT] ++;  //count the left wheel encoder interrupts
//    Serial.println(coder[LEFT]);
//  }
//  if (elapsedTime > maxElapsed )  //timeout
//  {
//    previousTime = millis();
//  } 
  
  coder[LEFT] ++;  //count the left wheel encoder interrupts
  Serial.println(coder[LEFT]);
}


void RwheelSpeed()
{
  coder[RIGHT] ++; //count the right wheel encoder interrupts
}




//void Drive(int leftMotorSpeed, int rightMotorSpeed, long DrivePeriod) 
void Drive(float leftMotorSpeed, float rightMotorSpeed, long DrivePeriod) 


  {
    // set left motor direction
    if(leftMotorSpeed < 0) 
    {
      digitalWrite(in1, HIGH);
      digitalWrite(in2, LOW);
      leftMotorSpeed = abs(leftMotorSpeed);
    }
    
    else
    {
      digitalWrite(in1, LOW);
      digitalWrite(in2, HIGH);
    }
  
    // set right motor direction
    if(rightMotorSpeed < 0) 
    {
      digitalWrite(in3, HIGH);
      digitalWrite(in4, LOW);
      rightMotorSpeed = abs(rightMotorSpeed);
    }
    
    else
    {
      digitalWrite(in3, LOW);
      digitalWrite(in4, HIGH);
    }
  
    DriveStartTime = millis();
    timer = millis() 	;
            
    while ((millis() - DriveStartTime) < DrivePeriod)	        
    {  
//      Serial.print(leftMotorSpeed);
//      Serial.print("\t");
//      Serial.println(leftMotorSpeed);
//      analogWrite(enA, 255);
//      analogWrite(enB, 255);
      //tachometer(leftMotorSpeed, DrivePeriod);
      analogWrite(enA, leftMotorSpeed);
      analogWrite(enB, rightMotorSpeed); 
      tachometer(leftMotorSpeed);
      
      
      

     
    }
  }

  void tachometer(float PWM)
{
  if(millis() - timer > 500)
      {      
        detachInterrupt(0); 
        speedL = float(coder[LEFT]);   //record the latest speed value
        speedR = float(coder[RIGHT]);

        Time = millis() ;
        
        T = float(Time - timer); 
        rps = 1000*speedL/(EnRes * T); 
        radps = 2*pi*1000*speedL/(EnRes * T); 

//        Serial.print(PWM);
//        Serial.print("\t");
        //Serial.println(coder[LEFT]);
        //Serial.print("\t");
//        Serial.println(coder[RIGHT]);
//        Serial.print("\t");
//        Serial.print(rps);
//        Serial.print("\t");
//        Serial.println(radps);
        
        coder[LEFT] = 0;                 //clear the data buffer
        coder[RIGHT] = 0;
        timer = millis();

        attachInterrupt(0, LwheelSpeed, FALLING);    //init the interrupt mode for the digital pin 2
     }
  
}


 
