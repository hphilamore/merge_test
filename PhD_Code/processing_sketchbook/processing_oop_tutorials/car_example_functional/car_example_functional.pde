//DATA 
// declare variables
color c;
float xpos;
float ypos;
float xspeed;

//CONSTRUCTOR (initialise)
void setup(){
  size(200,200);
  c = color(255);
  xpos = width/2;
  ypos = height/2;
  xspeed = 1;
 }
 
//FUNCTIONALITY
//define draw function
void draw(){
  background(0);
  display();
  drive();
}

//define display and drive subfunctions

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
  
    
  
  
  
  