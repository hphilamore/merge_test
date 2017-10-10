class Walker{
  float x; 
  float y;
  color c;
  
  // CONTRUCTOR: initialistaion DATA for class walker
  //Walker(color walkC, float walkX,float walkY){
  Walker(float walkX,float walkY){
    //c= walkC;
    x= walkX;
    y= walkY;
  }
  
  //FUNCTIONALITY for class walker
  void display(){
    stroke(0);
    point(x,y);
  }
  
  void step(){
    
    float choicex = (random(-1,1)); // nb DO NOT SPECIFY float
    float choicey = (random(-2,2));   
    
    
    // OR
    
    //float choicex = int(random(3))-1; //yields -1, 0,or 1
    //float choicey = int(random(3))-1; //yields -1, 0,or 1
    
    ////notably float choicex = (random(3))-1; //tends to move down and right (+ve direction) as float automatically chosen
    ////    float choicex = int(random(3))-1; //yields -1, 0,or 1
    ////    float choicey = int(random(3))-1; //yields -1, 0,or 1
    
    x += choicex;
    y += choicey;
    
    // OR
    
    //choice = int(random(4));
   
    //if(choice == 0){
    //  //x = x+1
    //  x++;
    //}
    
    //else if(choice == 1){
    //  //y = y+1
    //  x--;
    //}
    
    //else if(choice == 2){
    //  //y = y+1
    //  y++;
    //}
    
    //else{
    //  y--;
    //}
      
    
    
    
  }
  
}

Walker walker1;
Walker walker2;

//SETUP
void setup(){
  size(1000, 500);
  walker1 = new Walker(width/2, height/2);
  walker2 = new Walker(200, 200);
}

//FUNCTIONALITY
void draw(){
  walker1.step();
  walker1.display();
  walker2.step();
  walker2.display();
}
  
  
  
  


   
  
  
    
  