#define left_echoPin 4 // Echo Pin
#define mid_echoPin 6
#define right_echoPin 8

#define left_trigPin 3 // Trigger Pin
#define mid_trigPin 5 // Trigger Pin
#define right_trigPin 7 // Trigger Pin

#define left_ledPin 9 // Trigger Pin
#define mid_ledPin 10 
#define right_ledPin 11 

#define maxD 20




void setup() {
 Serial.begin (9600);
 pinMode (left_ledPin, OUTPUT);
 pinMode (mid_ledPin, OUTPUT);
 pinMode (right_ledPin, OUTPUT);
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

 
 
 
 
