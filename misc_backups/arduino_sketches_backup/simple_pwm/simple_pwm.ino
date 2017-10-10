int pwmPin = 9; // output pin supporting PWM
int inPin = 3; // voltage connected to analog pin 3, e.g. a potentiometer
int val = 0; // variable to store the read value
float volt = 0; // variable to hold the voltage read
void setup()
{
pinMode(pwmPin, OUTPUT); // sets the pin as output
}
void loop()
{
val = analogRead(inPin); // read the input pin
val = 1000; // read the input pin
volt =(5.0 * val) / 1023;
val = 255 * (volt / 5);
analogWrite(pwmPin, val);
}

