// I2C interface by default
//
#include "Wire.h"
#include "SparkFunIMU.h"
#include "SparkFunLSM303C.h"
#include "LSM303CTypes.h"

// #define DEBUG 1 in SparkFunLSM303C.h turns on debugging statements.
// Redefine to 0 to turn them off.

LSM303C myIMU;


int steps, flag;
float x, y, z, w; 
float threshold = 900;
unsigned long timeOld, timeNew, StepPeriod, aveStepPeriod;
const int numReadings = 10;
int readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

//float y; 
//float z; 
//float w;

void setup()
{
  Serial.begin(115200);
  if (myIMU.begin() != IMU_SUCCESS)
  {
    Serial.println("Failed setup.");
    while(1);
  }
  
  pinMode(LED_BUILTIN, OUTPUT);
  
  for (int thisReading = 0; thisReading < numReadings; thisReading++) 
  {
    readings[thisReading] = 0;
  }
}

void loop()
{
x = float((myIMU.readAccelX()));
y = float((myIMU.readAccelY()));
z = float((myIMU.readAccelZ()));
w = sqrt(sq(x)+sq(y)+sq(z));
 
Serial.print(x);
Serial.print("\t");
Serial.print(y);
Serial.print("\t");
Serial.print(z);
Serial.print("\t");
Serial.print(w);
Serial.print("\t");


  if (w>threshold && flag==0)
  {
    timeNew = millis();
    StepPeriod = timeNew - timeOld;
    timeOld = millis();    

     
    steps=steps+1;
    flag=1;  
    
    digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(200);                       // wait for a second
    digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW      
  }
  
   else if (w > threshold && flag==1)
  {
    //do nothing 
  }
  
  if (w <threshold  && flag==1)
  { 
    flag=0;
  }

      Serial.print("\t");
      Serial.println(steps);



  total = total - readings[readIndex];   
  readings[readIndex] = StepPeriod;  
  total = total + readings[readIndex]; // add the reading to the total: 
  readIndex = readIndex + 1;  // advance to the next position in the array:
  if (readIndex >= numReadings)   // if we're at the end of the array...
  {
    readIndex = 0;     // ...wrap around to the beginning:
  }
  aveStepPeriod = total / numReadings; // calculate the average:
  if (aveStepPeriod != StepPeriod)
  {
    // DO SOMETHING...
  }
 
   
     
//    Serial.println('\n');
//    Serial.print("steps=");
//    Serial.println(steps);
    

  
  //Serial.print("\t");


//  Serial.println(myIMU.readAccelZ(), 4);

//x = (myIMU.readAccelX(), 4);
//y = (myIMU.readAccelY(), 4);
//z = (myIMU.readAccelZ(), 4);
//
//Serial.print(x);
//Serial.print("\t");
//
//Serial.print(y);
//Serial.print("\t");
//
//Serial.println(z);


  delay(100);
}
