// I2C interface by default
//
#include "Wire.h"
#include "SparkFunIMU.h"
#include "SparkFunLSM303C.h"
#include "LSM303CTypes.h"

// #define DEBUG 1 in SparkFunLSM303C.h turns on debugging statements.
// Redefine to 0 to turn them off.

LSM303C myIMU;

int Xacc; 
int Yacc;
int Zacc;

//float vector

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

Serial.print("\nAccelerometer:\n");

Serial.print(Xacc);
Serial.print(" ");
Serial.print(Yacc);
Serial.print(" ");
Serial.print(Zacc);
Serial.print(" ");

  
  //Get all parameters
  
//  //Serial.print(" X = ");
//  Serial.print(" ");
//  Serial.print;
//  //Serial.print(" Y = ");
//  Serial.print(" ");
//  Serial.print
////Serial.print(" Z = ");
//  Serial.print(" ");
//  Serial.print



//  // Not supported by hardware, so will return NAN
//  Serial.print("\nGyroscope:\n");
//  Serial.print(" X = ");
//  Serial.println(myIMU.readGyroX(), 4);
//  Serial.print(" Y = ");
//  Serial.println(myIMU.readGyroY(), 4);
//  Serial.print(" Z = ");
//  Serial.println(myIMU.readGyroZ(), 4);
//
//  Serial.print("\nMagnetometer:\n");
//  Serial.print(" X = ");
//  Serial.println(myIMU.readMagX(), 4);
//  Serial.print(" Y = ");
//  Serial.println(myIMU.readMagY(), 4);
//  Serial.print(" Z = ");
//  Serial.println(myIMU.readMagZ(), 4);
//
//  Serial.print("\nThermometer:\n");
//  Serial.print(" Degrees C = ");
//  Serial.println(myIMU.readTempC(), 4);
//  Serial.print(" Degrees F = ");
//  Serial.println(myIMU.readTempF(), 4);

//vector = sqrt(sq(x.^2 + y.^2 + z.^2, 2));
  
  delay(10);
}
