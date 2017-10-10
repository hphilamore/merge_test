const int left_echoPin = 4; // Echo Pin
const int mid_echoPin = 6;
const int right_echoPin = 8;

const int left_trigPin = 3; // Trigger Pin
const int mid_trigPin = 5; // Trigger Pin
const int right_trigPin = 7; // Trigger Pin


void setup() {
 Serial.begin (9600);
}


void loop()
{
 
Serial.print ("left:");
Serial.println(getDistance(left_echoPin, left_trigPin));
Serial.print ("centre:");
Serial.println(getDistance(mid_echoPin, mid_trigPin));
Serial.print ("right:");
Serial.println(getDistance(right_echoPin, right_trigPin));
delay(1000);

}



int getDistance(int echoPin, int trigPin)
{
long duration, distance; // Duration used to calculate distance

   
 pinMode(trigPin, OUTPUT);
 pinMode(echoPin, INPUT);
  
    digitalWrite(trigPin, LOW); 
     delayMicroseconds(2); 
    
     digitalWrite(trigPin, HIGH);
     delayMicroseconds(10); 
     
     digitalWrite(trigPin, LOW);
     duration = pulseIn(echoPin, HIGH);
 
     //Calculate the distance (in cm) based on the speed of sound.
     distance = duration/58.2;
     return(distance);
}

 
 
 
 

