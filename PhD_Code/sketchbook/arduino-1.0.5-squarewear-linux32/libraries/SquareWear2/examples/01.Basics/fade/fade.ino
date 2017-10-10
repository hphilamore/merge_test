// ***********************
// SquareWear 2.0 Examples
// Fading RGB LEDs
// http://sqrwear.com/
// ***********************
//
// (NOTE: SquareWear Mini
//  does not have built-in
//  RGB LEDs).
//
// Internal connections:
// - red:   D8
// - green: D12
// - blue:  D13
//
// This demo uses the SoftPWM
// (software PWM) library. 
// For details, please refer to
// https://code.google.com/p/rogue-code/wiki/SoftPWMLibraryDocumentation
//
// ***********************

#include <HIDSerial.h>
#include <SoftPWM.h>

#define red   8
#define green 12
#define blue  13

void fade(unsigned char pin) {
  int value;
  for(value=0;value<=255;value++) {
    SoftPWMSet(pin, value);
    delay(5);
  }
  for(value=255;value>=0;value--) {
    SoftPWMSet(pin, value);
    delay(5);
  }
}

void setup() {
  SoftPWMBegin();
  SoftPWMSet(red, 0);
  SoftPWMSet(green, 0);
  SoftPWMSet(blue, 0);
}

void loop() {
  fade(red);
  fade(green);
  fade(blue);
}
