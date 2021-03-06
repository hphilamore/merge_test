// DATA
// declare object of class type Car called myCar
Car myCar; 



//CONSTRUCTOR (initialise)
void setup(){
  size(200,200);
  myCar = new Car();  //initialise object using new constructor();
}

//FUCNTIONALITY to call subfunctions contained in class
void draw(){
  background(255);
  myCar.display();
  myCar.drive();
}


// CLASS
class Car{  
  //class DATA 
  // declare variables
    color c;
    float xpos;
    float ypos;
    float xspeed;
  
  
  //CONSTRUCTOR (umbrella setup, data initialised for each class)
  Car(){
    c=color(255);
    xpos = width/2;
    ypos = height/2;
    xspeed = 1;
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







  