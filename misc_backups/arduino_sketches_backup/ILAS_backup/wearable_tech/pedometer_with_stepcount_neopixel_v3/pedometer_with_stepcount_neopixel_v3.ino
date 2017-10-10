#include <Adafruit_NeoPixel.h>

// I2C interface by default
//
#include "Wire.h"
#include "SparkFunIMU.h"
#include "SparkFunLSM303C.h"
#include "LSM303CTypes.h"

#define PIN 8
#define NUM_LEDS 1
//create a NeoPixel strip
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, PIN, NEO_GRB + NEO_KHZ800);

LSM303C myIMU;

float x, y, z, w; 
int steps, flag; //flag; // 
float threshold = 900;
float thresholdPace = 0.003;

long MeasurePeriod = 3000; 
unsigned long startTime = millis() ;   
unsigned long endTime = millis(); 
int stepsOld = 0;
int stepsNew; 
float paceAve, timer, pacer; 

void setup()
{
  Serial.begin(115200);
  strip.begin();
  strip.show();
  if (myIMU.begin() != IMU_SUCCESS)
  {
    Serial.println("Failed setup.");
    while(1);
  }  
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



  if (w>threshold && flag==0)
  {
    steps=steps+1;
    
    flag=1;  

     // light ON
    strip.setPixelColor(0, 255, 0, 0);
    strip.show();
    delay(200);
    // light OFF
    strip.setPixelColor(0, 0, 0, 0);
    strip.show();       
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
 Serial.print(steps);    

  //delay(100);

  // ********************************************

   if ((millis() - startTime) > MeasurePeriod)
   {
     stepsNew = steps;   
     endTime = millis();     
     paceAve = float(stepsNew - stepsOld)/ float(endTime - startTime); 
     stepsOld = steps;
     startTime = millis();    
   }

   Serial.print("\t");
   Serial.println(paceAve, 6); 

   if (paceAve > thresholdPace)
   {
    strip.setPixelColor(0, 0, 255, 0);
    strip.show();
    delay(200);
   }  
 
 
}
