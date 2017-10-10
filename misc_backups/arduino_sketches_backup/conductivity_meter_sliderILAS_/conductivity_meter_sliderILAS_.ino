/*
 * Voltage divider circuit. 
 * Calculates value of R1 (ohms)
 * Calculates resistivity of the material (ohms/cm) based on the distance between the "probes" 
 * touching the material to make R1.
 * R1 (typically variable) resister to be measured: connected between supply voltage Vs and probe pin.
 * R2 fixed resister: connected between probe pin and ground.
 */
 
#include <Adafruit_NeoPixel.h>
#define PIN 8
#define NUM_LEDS 1

int probeA = 10;
float Vs = 3.3;
float R2 = 330;
float dist = 1; // probe lead distance apart 
int threshold = 100;
int maxSenseA = 1000;    // the maximum value 
int minSenseA = 23;      // the minimum value 


Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, PIN, NEO_GRB + NEO_KHZ800);
 
void setup() 
{
  strip.begin();
  strip.show();
  Serial.begin(9600);
  Serial.print("reading");
  Serial.print("\t");
  Serial.print("voltage");
  Serial.print("\t");
  Serial.print("R1");
  Serial.print("\n");
}
 
void loop() 
{
  int readingA  = analogRead(probeA);     // binary  value read across voltage divider  
  float voltage = readingA*(Vs/1023.0);  // voltage read across voltage divider
  float R1 = (R2 * Vs / voltage) - R2;  // resistance in ohms per cm
  
  Serial.print(readingA);
  Serial.print("\t");
  Serial.print(voltage);
  Serial.print("\t");
  Serial.print(R1); 
  Serial.print("\n");
  delay(10);

// fade brightness of single LED light
int i = map(readingA, minSenseA, maxSenseA, 0, 255);

strip.setPixelColor(0, i , i , i);

strip.show();
delay(50);
 
}

