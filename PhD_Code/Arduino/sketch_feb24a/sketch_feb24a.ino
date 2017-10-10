
 
// These constants won't change:
const int analogPin = A0;    // pin that the sensor is attached to
const int relay_vdd = 13;       // pin that the LED is attached to
const int relay_vss = 12;   // an arbitrary threshold level that's in the range of the analog input

void setup() {
  // initialize the LED pin as an output:
    pinMode(analogPin, INPUT);
  pinMode(relay_vdd, OUTPUT);
  pinMode(relay_vss, OUTPUT);
  // initialize serial communications:
  Serial.begin(9600);
}

void loop() {
  // read the value of the potentiometer:
  int analogValue = analogRead(analogPin);

  // if the analog value is high enough, turn on the LED:
  if (analogValue > 614) {
    digitalWrite(relay_vdd, HIGH);
    digitalWrite(relay_vss, LOW);
      delay(1);        // delay in between reads for stability
  } 
  else {
    digitalWrite(relay_vdd, LOW);
    digitalWrite(relay_vss, HIGH); 
    delay(1);        // delay in between reads for stability
  }

  // print the analog value:
  Serial.println(analogValue);
  delay(1);        // delay in between reads for stability
}
