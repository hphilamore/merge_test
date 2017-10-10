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
}

void loop()
{
x = float((myIMU.readAccelX()));
y = float((myIMU.readAccelY()));
z = float((myIMU.readAccelZ()));
w = sqrt(sq(x)+sq(y)+sq(z));


  //Serial.print("\t");
  //x = 1;

//  Serial.print(myIMU.readAccelX(), 4);
//Serial.print("\t");
//
//  Serial.print(myIMU.readAccelY(), 4);
//  Serial.print("\t");
 
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
    steps=steps+1;
    flag=1;  
    digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(200);                       // wait for a second
    digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
    //delay(200);        
  }
   else if (w > threshold && flag==1)
  {
    //do nothing 
  }
  
  if (w <threshold  && flag==1)
  {
    flag=0;
  }

     Serial.println(steps);
     
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
