// I2C interface by default
//
#include "Wire.h"
#include "SparkFunIMU.h"
#include "SparkFunLSM303C.h"
#include "LSM303CTypes.h"

// #define DEBUG 1 in SparkFunLSM303C.h turns on debugging statements.
// Redefine to 0 to turn them off.

LSM303C myIMU;

float Xacc;
float Yacc;
float Zacc;
float vector;

void setup()
{
  Serial.begin(115200);
  if (myIMU.begin() != IMU_SUCCESS)
  {
    Serial.println("Failed setup.");
    while(1);
  }
}

void loop()
{

Xacc = (myIMU.readAccelX(), 4);
Yacc = (myIMU.readAccelY(), 4);
Zacc = (myIMU.readAccelZ(), 4);
vector = sqrt(sq(Xacc) + sq(Yacc) + sq(Zacc));

//Serial.print("\nAccelerometer:\n");

Serial.print(myIMU.readAccelX(), 4);
Serial.print("\t");
Serial.print(myIMU.readAccelY(), 4);
Serial.print("\t");
Serial.print(myIMU.readAccelZ(), 4);
Serial.print("\t");
Serial.println(vector);
//Serial.print("\t");

  
  delay(10);
}
