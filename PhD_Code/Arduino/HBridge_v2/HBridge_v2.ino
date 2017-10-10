/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.

  Most Arduinos have an on-board LED you can control. On the Uno and
  Leonardo, it is attached to digital pin 13. If you're unsure what
  pin the on-board LED is connected to on your Arduino model, check
  the documentation at http://arduino.cc

  This example code is in the public domain.

  modified 8 May 2014
  by Scott Fitzgerald
 */


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 13 as an output.
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(10, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  
  int sensorValue = analogRead(A0);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  float voltage = sensorValue * (5.0 / 1023.0);
//  digitalWrite(13, LOW);   // turn the LED on (HIGH is the voltage level)
//  digitalWrite(12, LOW);   // turn the LED on (HIGH is the voltage level)
//  digitalWrite(11, LOW);   // turn the LED on (HIGH is the voltage level)
//  digitalWrite(10, LOW);   // turn the LED on (HIGH is the voltage level)
//  delay(10000);    // wait for a second
 if                    (voltage  > 3.1) { 
  digitalWrite(13, HIGH);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(12, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(11, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(10, LOW);   // turn the LED on (HIGH is the voltage level)
  delay(10000);  
 }  // wait for a second
  
//  digitalWrite(13, LOW);   // turn the LED on (HIGH is the voltage level)
//  digitalWrite(12, LOW);   // turn the LED on (HIGH is the voltage level)
//  digitalWrite(11, LOW);   // turn the LED on (HIGH is the voltage level)
//  digitalWrite(10, LOW);   // turn the LED on (HIGH is the voltage level)
//  delay(10000);              // wait for a second
   else if ((voltage  > 2.1) && (voltage < 3)){
  digitalWrite(13, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(12, HIGH);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(11, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(10, LOW);   // turn the LED on (HIGH is the voltage level)
  delay(10000);    
   }
   
    else if ((voltage  > 1.1) && (voltage < 2)){
  digitalWrite(13, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(12, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(11, HIGH);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(10, LOW);   // turn the LED on (HIGH is the voltage level)
  delay(10000);    
   }
   
   
    else if ((voltage  > 0.1) && (voltage < 1)){
  digitalWrite(13, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(12, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(11, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(10, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(10000);    
   }
  
   
   
 
 else{
   digitalWrite(13, LOW);   // sets the LED on  
    digitalWrite(12, LOW);   // sets the LED on  
     digitalWrite(11, LOW);   // turn the LED on (HIGH is the voltage level)
  digitalWrite(10, LOW);   // turn the LED on (HIGH is the voltage level)
    
 
  }
   // wait for a second
}
