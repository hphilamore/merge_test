/*************************************************
 * Public Constants from pitches.h
 *************************************************/

#define NOTE_B0  31
#define NOTE_C1  33
#define NOTE_CS1 35
#define NOTE_D1  37
#define NOTE_DS1 39
#define NOTE_E1  41
#define NOTE_F1  44
#define NOTE_FS1 46
#define NOTE_G1  49
#define NOTE_GS1 52
#define NOTE_A1  55
#define NOTE_AS1 58
#define NOTE_B1  62
#define NOTE_C2  65
#define NOTE_CS2 69
#define NOTE_D2  73
#define NOTE_DS2 78
#define NOTE_E2  82
#define NOTE_F2  87
#define NOTE_FS2 93
#define NOTE_G2  98
#define NOTE_GS2 104
#define NOTE_A2  110
#define NOTE_AS2 117
#define NOTE_B2  123
#define NOTE_C3  131
#define NOTE_CS3 139
#define NOTE_D3  147
#define NOTE_DS3 156
#define NOTE_E3  165
#define NOTE_F3  175
#define NOTE_FS3 185
#define NOTE_G3  196
#define NOTE_GS3 208
#define NOTE_A3  220
#define NOTE_AS3 233
#define NOTE_B3  247
#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494
#define NOTE_C5  523
#define NOTE_CS5 554
#define NOTE_D5  587
#define NOTE_DS5 622
#define NOTE_E5  659
#define NOTE_F5  698
#define NOTE_FS5 740
#define NOTE_G5  784
#define NOTE_GS5 831
#define NOTE_A5  880
#define NOTE_AS5 932
#define NOTE_B5  988
#define NOTE_C6  1047
#define NOTE_CS6 1109
#define NOTE_D6  1175
#define NOTE_DS6 1245
#define NOTE_E6  1319
#define NOTE_F6  1397
#define NOTE_FS6 1480
#define NOTE_G6  1568
#define NOTE_GS6 1661
#define NOTE_A6  1760
#define NOTE_AS6 1865
#define NOTE_B6  1976
#define NOTE_C7  2093
#define NOTE_CS7 2217
#define NOTE_D7  2349
#define NOTE_DS7 2489
#define NOTE_E7  2637
#define NOTE_F7  2794
#define NOTE_FS7 2960
#define NOTE_G7  3136
#define NOTE_GS7 3322
#define NOTE_A7  3520
#define NOTE_AS7 3729
#define NOTE_B7  3951
#define NOTE_C8  4186
#define NOTE_CS8 4435
#define NOTE_D8  4699
#define NOTE_DS8 4978



#define left_echoPin 4 // Echo Pin
#define mid_echoPin 6
#define right_echoPin 8

#define left_trigPin 3 // Trigger Pin
#define mid_trigPin 5 // Trigger Pin
#define right_trigPin 7 // Trigger Pin

#define maxD 20

int soundpin = 11;

// Define the number of samples to keep track of.  The higher the number,
// the more the readings will be smoothed, but the slower the output will
// respond to the input.  Using a constant rather than a normal variable lets
// use this value to determine the size of the readings array.
const int numReadings = 10;

int readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

void setup() {
 Serial.begin (9600);

 pinMode(soundpin, OUTPUT);
 for (int thisReading = 0; thisReading < numReadings; thisReading++) {
  readings[thisReading] = 0;
  }
}


void loop()
{
 
Serial.print ("left:");
Serial.println(getDistance(left_echoPin, left_trigPin));
int distance = getDistance(left_echoPin, left_trigPin);


// subtract the last reading:
  total = total - readings[readIndex];
  // read from the sensor:
//  readings[readIndex] = analogRead(inputPin);
readings[readIndex] = distance;
  // add the reading to the total:
  total = total + readings[readIndex];
  // advance to the next position in the array:
  readIndex = readIndex + 1;

  // if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  }

  // calculate the average:
  average = total / numReadings;
  // send it to the computer as ASCII digits
  Serial.println(average);
  delay(1); 


//int level = map(distance, 0, 20, 500, 300);
//int level = map(average, 0, 40, 500, 0);
int level = map(average, 0, 40, NOTE_C5, NOTE_C4);

if(distance < 40){
        
       tone(11, level);
       delay(1);
    }
    else {
      noTone(11);
    }

//Serial.print ("centre:");
//Serial.println(getDistance(mid_echoPin, mid_trigPin));
//Serial.print ("right:");
//Serial.println(getDistance(right_echoPin, right_trigPin));
//delay(1000);

}



int getDistance(int echoPin, int trigPin)
{
long duration, distance; // Duration used to calculate distance

   
 pinMode(trigPin, OUTPUT);
 pinMode(echoPin, INPUT);
  
    digitalWrite(trigPin, LOW); 
     //delayMicroseconds(2); 
    
     digitalWrite(trigPin, HIGH);
     delayMicroseconds(2); 
     
     digitalWrite(trigPin, LOW);
     
     duration = pulseIn(echoPin, HIGH);
 
     //Calculate the distance (in cm) based on the speed of sound.
     distance = duration/58.2;
     return(distance);

     
}

 
 
 
 

