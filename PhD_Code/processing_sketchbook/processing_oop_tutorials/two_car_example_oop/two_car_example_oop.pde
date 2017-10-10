// DATA
// declare all instances of object of class type Car called myCar
Car myCar1; 
Car myCar2;



//setup (initialise umbrella DATA and initialise all instances given in DATA)
void setup(){
  size(200,200);
  myCar1 = new Car(color(255,0,0),0,50,2);  //initialise object using new constructor();
  myCar2 = new Car(color(50,50,0),width/2, height/2, 10 );  //initialise object using new constructor();
}

//FUCNTIONALITY to call subfunctions contained in class
void draw(){
  background(255);
  myCar1.display();
  myCar1.drive();
  myCar2.display();
  myCar2.drive();
}


// CLASS
class Car{  
  //class DATA 
  // declare variables
    color c;
    float xpos;
    float ypos;
    float xspeed;
  
  
  //CONSTRUCTOR now contains arguments for setup of individual objects
  //Car(){
  Car(color tempC, float tempXpos, float tempYpos, float tempXspeed){
    //c=color(255);
    //xpos = width/2;
    //ypos = height/2;
    //xspeed = 1;
    c = tempC;
    xpos = tempXpos;
    ypos = tempYpos;
    xspeed = tempXspeed;
  }
  
  //CLASS FUNCTIONALITY
  //define display and drive subfunctions for car class
  //higher function with which to call these two subfunctions is defined outside of class
  
  void display(){
    rectMode(CENTER);
    fill(c);
    rect(xpos,ypos,20,10); //draw rectangle using x,y,w,h
  }
  
  void drive() {
    xpos = xpos + xspeed; // new position
    if (xpos > width){
      xpos = 0;
    }
  }  
  
}







  