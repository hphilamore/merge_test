class Walker{
  //float x; 
  //float y;
  //color c;
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector dir;
  float walkHeight;
  float walkWidth;
  


  
  
  // CONTRUCTOR: initialistaion DATA for class walker
  //Walker(color walkC, float walkX,float walkY){
  Walker(float locX, float locY, float velX, float velY, float startHeight, float startWidth){
    location = new PVector(locX, locY);
    velocity = new PVector(velX, velY);
    walkHeight = startHeight;
    walkWidth = startWidth;
   }
  
  //FUNCTIONALITY for class walker
  void step(){
    
    float r = random(1);
    float accMag = 0.1;                                              //magnitude of acceleration
    
    PVector dir = PVector.sub(food1.location, location);             //vector of food from walker
    
    float m = dir.mag();                                             //magnitude of that vector
    
    if (r < 0.8){                                                    // set ratio by which walker is likely to follow food
    
    //PVector acceleration = PVector.sub(food1.location, location);
    
      acceleration = dir;
      acceleration.normalize();
      acceleration.mult(accMag);
      velocity.add(acceleration);
      location.add(velocity);
    }
           
   
    
    else{   
      
      acceleration = new PVector(random(-1,1), random(-1,1)); 
      acceleration.normalize();
      
      //float m = acceleration.mag();
      
      acceleration.mult(1/(m*accMag));
      velocity.add(acceleration);
      location.add(velocity);
    }
    

    
    
    if(location.x > width || location.x < 0){
       velocity.x = velocity.x * -1;
    }
  
    if(location.y > height || location.y < 0){
       velocity.y = velocity.y * -1;
    }
  
  location.add(velocity);  
  
}
      

  void display(){
    noStroke();
    fill(255,0,0,100);
    ellipse(location.x, location.y, walkWidth, walkHeight);
  }
  
}



// CLASS Food is based on class Car from prev. example
class Food{  
 //class DATA 
 // declare variables
  color c;
  PVector location;
  PVector velocity;
  float foodHeight;
  float foodWidth;
  
  
  
 //CONSTRUCTOR now contains arguments for setup of individual objects
 //Car(){
 Food(color tempC, float tempXpos, float tempYpos, float tempXspeed, float tempYspeed, float startHeight, float startWidth){
   c = tempC;
   location = new PVector(tempXpos, tempYpos);
   velocity = new PVector(tempXspeed, tempYspeed);
   foodHeight = startHeight;
   foodWidth = startWidth;
   
 }
  
//  //CLASS FUNCTIONALITY
//  //define display and drive subfunctions for car class
//  //higher function with which to call these two subfunctions is defined outside of class
  
 void display(){
   noStroke();
   fill(c);
   //ellipse(location.x, location.y, 100, 75);
   ellipse(location.x, location.y, foodWidth, foodHeight);
   
   //rectMode(CENTER);
   //fill(c);
   //rect(location.x,location.y,50,30); //draw rectangle using x,y,w,h
 }
  
 void drive() {
   
   location.add(velocity);
   
    if (location.x > width || location.x < 0){
     velocity.x = velocity.x * -1;
   }
    
    if (location.y > height || location.y < 0){
     velocity.y = velocity.y * -1;
   }
 }  
 
 
 

 
 
 
 
  
}

// Instantiate all objects
Walker walker1;
Walker walker2;
Food food1;
PVector collide;

////SETUP
void setup(){
 size(1000, 500);
 walker1 = new Walker(width/2, height/2, random(-5,5), random(-5,5), 25, 25);
 walker2 = new Walker(200, 200, random(-5,5), random(-5,5), 25, 25);
 food1 = new Food(color(0,255,0), width/2, height/2, 0.5, 0.5, 100, 100);
}

//FUNCTIONALITY
void draw(){
 background(255);
 walker1.step();
 walker1.display();
 walker2.step();
 walker2.display();
 food1.drive();
 food1.display();
 eat(walker1.location, walker1.walkHeight);
 eat(walker2.location, walker2.walkHeight);
}

void eat(PVector W, float H){
  PVector collide = PVector.sub(W, food1.location);     // vector describing distance between food and walker centre
  float colMag = collide.mag();                         // magnitude of vector
  
  float totalSize = H/2  +  food1.foodHeight/2 ; // sum of two radii
  if(colMag < totalSize){
    food1.foodHeight *= 0.99;
    food1.foodWidth *= 0.99;
  }
  
}
  
  
  
  
  
  


   
  
  
    
  