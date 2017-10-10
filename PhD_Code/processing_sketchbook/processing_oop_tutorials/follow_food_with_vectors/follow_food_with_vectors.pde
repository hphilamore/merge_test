class Walker{
  //float x; 
  //float y;
  //color c;
  PVector location;
  PVector velocity;
  PVector follow_food;
  PVector follow_walk;

  
  
  // CONTRUCTOR: initialistaion DATA for class walker
  //Walker(color walkC, float walkX,float walkY){
  Walker(float locX, float locY, float velX, float velY){
    location = new PVector(locX, locY);
    velocity = new PVector(velX, velY);
   }
  
  //FUNCTIONALITY for class walker
  void step(){
    
    follow_food = new PVector(food1.location.x, food1.location.y);
    follow_walk = new PVector(location.x, location.y);
    println(follow_food);
    println(follow_walk);
    println(" ");
    
    follow_food.sub(follow_walk);
    follow_food.normalize();
        
    //follow_food.sub(follow_walk);
    //println(follow_food); //dif
    //println(follow_walk); //same
    //println(" ");
    //println(" ");
    
    location.add(follow_food);
    
    if(location.x > width || location.x < 0){
      follow_food.x = follow_food.x * -1;
    }
    
    if(location.y > height || location.y < 0){
      follow_food.y = follow_food.y * -1;
    }
    
    location.add(follow_food);  
    
    

    //velocity = food1.location;
    //velocity.sub(location);
    //velocity.normalize();
    
    //location.add(velocity);
    
    //if(location.x > width || location.x < 0){
    //  velocity.x = velocity.x * -1;
    //}
    
    //if(location.y > height || location.y < 0){
    //  velocity.y = velocity.y * -1;
    //}
    
    //location.add(velocity);   
    
  }
  
  
  void display(){
    noStroke();
    fill(0);
    ellipse(location.x, location.y, 50, 50);
  }
  
}



// CLASS Food is based on class Car from prev. example
class Food{  
 //class DATA 
 // declare variables
  color c;
  PVector location;
  PVector velocity;
  
  
  
 //CONSTRUCTOR now contains arguments for setup of individual objects
 //Car(){
 Food(color tempC, float tempXpos, float tempYpos, float tempXspeed, float tempYspeed){
   c = tempC;
   location = new PVector(tempXpos, tempYpos);
   velocity = new PVector(tempXspeed, tempYspeed);
   
 }
  
//  //CLASS FUNCTIONALITY
//  //define display and drive subfunctions for car class
//  //higher function with which to call these two subfunctions is defined outside of class
  
 void display(){
   rectMode(CENTER);
   fill(c);
   rect(location.x,location.y,50,30); //draw rectangle using x,y,w,h
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

////SETUP
void setup(){
 size(1000, 500);
 walker1 = new Walker(width/2, height/2, random(-5,5), random(-5,5));
 walker2 = new Walker(200, 200, random(-5,5), random(-5,5));
 food1 = new Food(color(0,255,0), width/2, height/2, 3, 2);
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
}
  
  
  
  


   
  
  
    
  