/*
 * Voltage divider circuit. 
 * Calculates value of R1 (ohms)
 * Calculates resistivity of the material (ohms/cm) based on the distance between the "probes" 
 * touching the material to make R1.
 * R1 (typically variable) resister to be measured: connected between supply voltage Vs and probe pin.
 * R2 fixed resister: connected between probe pin and ground.
 */
#include <SoftwareSerial.h> 
#include <Adafruit_NeoPixel.h>
#include "Wire.h"
#include "SparkFunIMU.h"
#include "SparkFunLSM303C.h"
#include "LSM303CTypes.h"
#define PIN 8
#define NUM_LEDS 1

int probeA = A11; //10;
int probeB = A7; //9;
float Vs = 3.3;
float R2 = 330;
float dist = 1; // probe lead distance apart 
int threshold = 100;
int maxSenseA = 1000;    // the maximum value 
int minSenseA = 23;      // the minimum value 
int maxSenseB = 1000;    // the maximum value 
int minSenseB = 23;      // the minimum value 
float x, y, z, w; 

//create a NeoPixel strip
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, PIN, NEO_GRB + NEO_KHZ800);

//create accelerometer
LSM303C myIMU;

//create software serial for bluetooth
SoftwareSerial BTserial(10, 9); // RX | TX     # on flora
 
void setup() 
{
  strip.begin(); 
  strip.show();
  Serial.begin(9600);
  BTserial.begin(9600);
  myIMU.begin(); 
  
//  Serial.print("reading");
//  Serial.print("\t");
//  Serial.print("voltage");
//  Serial.print("\t");
//  Serial.print("R1");
//  Serial.print("\n");
}
 
void loop() 
{
  int readingA  = analogRead(probeA);     // binary  value read across voltage divider  
  int readingB  = analogRead(probeB);     // binary  value read across voltage divider  
  float voltage = readingA*(Vs/1023.0);  // voltage read across voltage divider
  float R1 = (R2 * Vs / voltage) - R2;  // resistance in ohms per cm

  x = float((myIMU.readAccelX()));

y = float((myIMU.readAccelY()));

z = float((myIMU.readAccelZ()));

w = sqrt(sq(x)+sq(y)+sq(z));

  
//  Serial.print(readingA);
//  Serial.print("\t");
//  Serial.print(voltage);
//  Serial.print("\t");
//  Serial.print(R1); 
//  Serial.print("\n");
//  delay(10);

//BTserial.print("A= ");
//BTserial.print(readingA);
//BTserial.print("\t");
//BTserial.print("\t");
//BTserial.print("\t");
//BTserial.print("B= ");
//BTserial.print(readingB);
//BTserial.print("\n");

BTserial.print("x= ");
BTserial.print(x);
BTserial.print("\t");
BTserial.print("\t");
BTserial.print("\t");
BTserial.print("w= ");
BTserial.print(w);
BTserial.print("\n");





// fade brightness of single LED light

int i = map(readingA, minSenseA, maxSenseA, 0, 255);

strip.setPixelColor(0, i , i , i);

int j = map(readingB, minSenseB, maxSenseB, 0, 255);

strip.setPixelColor(0, i , j , 0);


strip.show();
delay(50);
 
}

