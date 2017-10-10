import java.util.*; 


Random generator; // processing has class Random already defined
float t = 0;


void setup(){
  background(0);
  size(640, 640);
  frameRate(30);
  generator = new Random();    //instaniates new variable
}


void draw(){
  //float numx = (float) generator.nextGaussian();    // (float) converts the type of variable returned, double, to a float
  //                                               // nextGaussian returns normal distribution of random numbers, mean=0, SD=1
                                                 
  //float numy = (float) generator.nextGaussian();    // (float) converts the type of variable returned, double, to a float
  //                                               // nextGaussian returns normal distribution of random numbers, mean=0, SD=1                                               
                                                 
  //float sd = 120;
  //float mean = 320;
  //float x = numx * sd + mean; // num = range -1, 1 
  //float y = numy * sd + mean; // num = range -1, 1 
  //float h = sqrt(pow(abs(x-mean),2) + pow(abs(y-mean),2)); 
  
  float n = noise(t);
  println(n);
  t++;
  //t += 0.01;
 
  //noStroke();
  //fill(255,10);
  //ellipse(x,y, 500/h, 500/h);
  ////print(h + "\n");
  ////print(h + "\n");
  ////print("\n");
  //delay(50);
}                                                 