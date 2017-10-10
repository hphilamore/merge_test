import java.util.*; 
Random generator; // processing has class Random already defined

void setup(){
  
  size(640, 360);
  generator = new Random();    //instaniates new variable
}

void draw(){
  float num = (float) generator.nextGaussian();    // (float) converts the type of variable returned, double, to a float
                                                 // nextGaussian returns normal distribution of random numbers, mean=0, SD=1
                                                 
  float sd = 60;
  float mean = 320;
  float x = num * sd + mean; // num = range -1, 1 
  
  noStroke();
  fill(255,10);
  ellipse(x,180,16,16);
}                                                 