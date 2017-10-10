
// the setup routine runs once when you press reset:

int relay_vdd = 2;       // pin that the LED is attached to
int relay_vss = 3;   // an arbitrary threshold level that's in the range of the analog input
int switch_maxon_open = 8;
int switch_maxon_close = 9;
  
  
void setup() {
  pinMode(relay_vdd, OUTPUT);
  pinMode(relay_vss, OUTPUT);
  
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  
  
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  
  int sensorValue = analogRead(A0);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  float voltage = sensorValue * (5.0 / 1023.0);
 
    digitalWrite(relay_vdd, HIGH);   // sets the LED on
    digitalWrite(relay_vss, LOW);   // sets the LED on
    
    
  if ((voltage  > 3.1) && (voltage < 4)){
    digitalWrite(switch_maxon_open, LOW);   // sets the LED on  
     digitalWrite(switch_maxon_close, HIGH);   // sets the LED on 
    
 
    
  }
  else if ((voltage  > 2.1) && (voltage < 3)){
    digitalWrite(switch_maxon_close, LOW);   // sets the LED on 
    digitalWrite(switch_maxon_open, HIGH);   // sets the LED on 
    
  }
  
  else {
    digitalWrite(switch_maxon_open, LOW);   // sets the LED on  
    digitalWrite(switch_maxon_close, LOW);   // sets the LED on  
    
 
  }
  
    
    
  // print out the value you read:
  Serial.println(voltage);
}
