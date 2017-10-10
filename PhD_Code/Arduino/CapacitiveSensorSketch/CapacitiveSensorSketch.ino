#include <CapacitiveSensor.h>

/*
 * CapitiveSense Library Demo Sketch
 * Paul Badger 2008
 * Uses a high value resistor e.g. 10M between send pin and receive pin
 * Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
 * Receive pin is the sensor pin - try different amounts of foil/metal on this pin
 */


CapacitiveSensor   cs_3_2 = CapacitiveSensor(3,2);        // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
CapacitiveSensor   cs_6_5 = CapacitiveSensor(6,5);        // 10M resistor between pins 4 & 6, pin 6 is sensor pin, add a wire and or foil
CapacitiveSensor   cs_9_8 = CapacitiveSensor(9,8);        // 10M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil

void setup()                    
{
   cs_3_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
   Serial.begin(9600);
}

void loop()                    
{
    long start = millis();
    long total1 =  cs_3_2.capacitiveSensor(30);
    long total2 =  cs_6_5.capacitiveSensor(30);
    long total3 =  cs_9_8.capacitiveSensor(30);

    Serial.print(millis() - start);        // check on performance in milliseconds
    Serial.print("\t");                    // tab character for debug windown spacing

    Serial.print(total1);                  // print sensor output 1
    Serial.print("\t");
    Serial.print(total2);                  // print sensor output 2
    Serial.print("\t");
    Serial.println(total3);                // print sensor output 3

    delay(50);                             // arbitrary delay to limit data to serial port 
}
