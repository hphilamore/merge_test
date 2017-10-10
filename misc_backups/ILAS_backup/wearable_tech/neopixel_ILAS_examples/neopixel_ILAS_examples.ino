#include <Adafruit_NeoPixel.h>

#define PIN 8
#define NUM_LEDS 1
#define BRIGHTNESS 100            

//Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, PIN, NEO_GRBW + NEO_KHZ800);
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(115200);
  strip.setBrightness(BRIGHTNESS);  //  limits the brightness. takes 0-255
  strip.begin();
  strip.show();                     // Initialize the light to OFF
}

void loop() {

// light ON
strip.setPixelColor(0, 250 , 250 , 250);
strip.show();
delay(1000);


//// light OFF
//strip.setPixelColor(0, 0, 0, 0);
//strip.show();
//delay(1000);


//// Change intensity
//strip.setPixelColor(0, 20, 20, 20);
//strip.show();
//delay(1000);
//strip.setPixelColor(0, 100, 100, 100);
//strip.show();
//delay(1000);
//strip.setPixelColor(0, 250, 250, 250);
//strip.show();
//delay(1000);


//// Fade in 
//for (int i=0; i<256; i++)
////for (int i=0; i<256; i+=10)
//{  
//  strip.setPixelColor(0, i , i , i);
//  strip.show();
//  delay(50);
//}


//// Fade out
//for (int i=255; i>0; i--)
////for (int i=255; i>0; i-=10)
//{
//  strip.setPixelColor(0, i , i , i);
//  strip.show();
//  delay(50);
//}


//// Cycle colours
//unsigned int colours[3];
//
//// Start with red.
//colours[0] = 255;
//colours[1] = 0;
//colours[2] = 0;  
//
//
//for (int C1 = 0; C1 < 3; C1 += 1) 
//  {
//      // If (C1 == 2), C2 = 0. Otherwise C2 = C1 + 1  
//      int C2 = (C1 == 2) ? 0 : C1 + 1;
//
//      // Cross fade two colours
//      for(int i = 0; i < 255; i ++) 
//      {
//        colours[C1] -= 1;
//        colours[C2] += 1;      
//        strip.setPixelColor(0, colours[0] , colours[1] , colours[2]);
//        strip.show();
//        delay(10);
//      }
//  }


}





  

//strip.setPixelColor(0, 255, 0, 0);
//strip.Color(255, 0, 0), 50); // Red
//strip.Color(0, 255, 0), 50); // Green
//strip.Color(0, 0, 255), 50); // Blue
//strip.Color(255, 255, 255, 255), 50); // White
  
  // Some example procedures showing how to display to the pixels:


  
  //colorWipe(strip.Color(0, 255, 0), 50); // Green
//  colorWipe(strip.Color(0, 0, 255), 50); // Blue
//  colorWipe(strip.Color(255, 255, 255, 255), 50); // White
//  BRIGHT += 50;
//  strip.setBrightness(BRIGHT); // 0 to 255

  //whiteOverRainbow(20,75,5);  

//  pulseWhite(5); 

  // fullWhite();
  // delay(2000);

  //rainbowFade2White(3,3,1);




//// Fill the dots one after the other with a color
//void colorWipe(uint32_t c, uint8_t wait) {
//  for(uint16_t i=0; i<strip.numPixels(); i++) {
//    strip.setPixelColor(i, c);
//    strip.show();
//    delay(wait);
//  }
//}

//void pulseWhite(uint8_t wait) {
//  for(int j = 0; j < 256 ; j++){
//      for(uint16_t i=0; i<strip.numPixels(); i++) {
//          strip.setPixelColor(i, strip.Color(250,250,250, gamma[j] ) );
//        }
//        delay(wait);
//        strip.show();
//      }
//
//  for(int j = 255; j >= 0 ; j--){
//      for(uint16_t i=0; i<strip.numPixels(); i++) {
//          strip.setPixelColor(i, strip.Color(0,0,0, gamma[j] ) );
//        }
//        delay(wait);
//        strip.show();
//      }
//}


//void rainbowFade2White(uint8_t wait, int rainbowLoops, int whiteLoops) {
//  float fadeMax = 100.0;
//  int fadeVal = 0;
//  uint32_t wheelVal;
//  int redVal, greenVal, blueVal;
//
//  for(int k = 0 ; k < rainbowLoops ; k ++){
//    
//    for(int j=0; j<256; j++) { // 5 cycles of all colors on wheel
//
//      for(int i=0; i< strip.numPixels(); i++) {
//
//        wheelVal = Wheel(((i * 256 / strip.numPixels()) + j) & 255);
//
//        redVal = red(wheelVal) * float(fadeVal/fadeMax);
//        greenVal = green(wheelVal) * float(fadeVal/fadeMax);
//        blueVal = blue(wheelVal) * float(fadeVal/fadeMax);
//
//        strip.setPixelColor( i, strip.Color( redVal, greenVal, blueVal ) );
//
//      }
//
//      //First loop, fade in!
//      if(k == 0 && fadeVal < fadeMax-1) {
//          fadeVal++;
//      }
//
//      //Last loop, fade out!
//      else if(k == rainbowLoops - 1 && j > 255 - fadeMax ){
//          fadeVal--;
//      }
//
//        strip.show();
//        delay(wait);
//    }
//  
//  }
//
//
//
//  delay(500);
//
//
//  for(int k = 0 ; k < whiteLoops ; k ++){
//
//    for(int j = 0; j < 256 ; j++){
//
//        for(uint16_t i=0; i < strip.numPixels(); i++) {
//            strip.setPixelColor(i, strip.Color(0,0,0, gamma[j] ) );
//          }
//          strip.show();
//        }
//
//        delay(2000);
//    for(int j = 255; j >= 0 ; j--){
//
//        for(uint16_t i=0; i < strip.numPixels(); i++) {
//            strip.setPixelColor(i, strip.Color(0,0,0, gamma[j] ) );
//          }
//          strip.show();
//        }
//  }
//
//  delay(500);
//
//
//}
//
//void whiteOverRainbow(uint8_t wait, uint8_t whiteSpeed, uint8_t whiteLength ) {
//  
//  if(whiteLength >= strip.numPixels()) whiteLength = strip.numPixels() - 1;
//
//  int head = whiteLength - 1;
//  int tail = 0;
//
//  int loops = 3;
//  int loopNum = 0;
//
//  static unsigned long lastTime = 0;
//
//
//  while(true){
//    for(int j=0; j<256; j++) {
//      for(uint16_t i=0; i<strip.numPixels(); i++) {
//        if((i >= tail && i <= head) || (tail > head && i >= tail) || (tail > head && i <= head) ){
//          strip.setPixelColor(i, strip.Color(0,0,0, 255 ) );
//        }
//        else{
//          strip.setPixelColor(i, Wheel(((i * 256 / strip.numPixels()) + j) & 255));
//        }
//        
//      }
//
//      if(millis() - lastTime > whiteSpeed) {
//        head++;
//        tail++;
//        if(head == strip.numPixels()){
//          loopNum++;
//        }
//        lastTime = millis();
//      }
//
//      if(loopNum == loops) return;
//    
//      head%=strip.numPixels();
//      tail%=strip.numPixels();
//        strip.show();
//        delay(wait);
//    }
//  }
//  
//}
//void fullWhite() {
//  
//    for(uint16_t i=0; i<strip.numPixels(); i++) {
//        strip.setPixelColor(i, strip.Color(0,0,0, 255 ) );
//    }
//      strip.show();
//}
//
//
//// Slightly different, this makes the rainbow equally distributed throughout
//void rainbowCycle(uint8_t wait) {
//  uint16_t i, j;
//
//  for(j=0; j<256 * 5; j++) { // 5 cycles of all colors on wheel
//    for(i=0; i< strip.numPixels(); i++) {
//      strip.setPixelColor(i, Wheel(((i * 256 / strip.numPixels()) + j) & 255));
//    }
//    strip.show();
//    delay(wait);
//  }
//}
//
//void rainbow(uint8_t wait) {
//  uint16_t i, j;
//
//  for(j=0; j<256; j++) {
//    for(i=0; i<strip.numPixels(); i++) {
//      strip.setPixelColor(i, Wheel((i+j) & 255));
//    }
//    strip.show();
//    delay(wait);
//  }
//}
//
//// Input a value 0 to 255 to get a color value.
//// The colours are a transition r - g - b - back to r.
//uint32_t Wheel(byte WheelPos) {
//  WheelPos = 255 - WheelPos;
//  if(WheelPos < 85) {
//    return strip.Color(255 - WheelPos * 3, 0, WheelPos * 3,0);
//  }
//  if(WheelPos < 170) {
//    WheelPos -= 85;
//    return strip.Color(0, WheelPos * 3, 255 - WheelPos * 3,0);
//  }
//  WheelPos -= 170;
//  return strip.Color(WheelPos * 3, 255 - WheelPos * 3, 0,0);
//}
//
//uint8_t red(uint32_t c) {
//  return (c >> 8);
//}
//uint8_t green(uint32_t c) {
//  return (c >> 16);
//}
//uint8_t blue(uint32_t c) {
//  return (c);
//}


