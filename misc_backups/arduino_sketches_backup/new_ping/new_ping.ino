#include <NewPing.h>
 
#define TRIGGER_PIN  3  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     4  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 20 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.

int soundpin = 11;
 
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.
 
void setup() {
  Serial.begin(115200); // Open serial monitor at 115200 baud to see ping results.
}
 
void loop() {
  //delayMicroseconds(2); 
  delay(29);  // Wait 500ms between pings (about 2 pings/sec). 29ms should be the shortest delay between pings.
  unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
  Serial.print("Ping: ");
  Serial.print(uS / US_ROUNDTRIP_CM); // Convert ping time to distance and print result (0 = outside set distance range, no ping echo)
  Serial.print("cm ");
  unsigned int distance = uS / US_ROUNDTRIP_CM;

  int level = map(distance, 0, 20, 500, 300);
  Serial.print(level);
  //int level = map(average, 0, 50, 500, 300);
  
  if(distance < 50){
          
         tone(11, level);
         //delay(10);
      }
      else {
        noTone(11);
      }
}
