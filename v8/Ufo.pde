/**
 * @version 8 july 2017
 * @author Alexey Titov & Shir Bentabou
 */
class Ufo
{ 
  int x;              //x-coordinate of UFO
  int y;              //y-coordinate of UFO
  int times;          //counter of time
  PImage ufo;
  //constructor
  Ufo() 
  { 
    x=330;
    y=0;
    ufo=loadImage("space.png");
    times = 0;
  }
  //return to the initial data
  void reset()
  {
    x=330;
    y=0;
    times = 0;
  }
  //road range - 310-440
  void display() 
  { 
    times++;
    if(times<70)
      image(ufo,x,y);
    else
    {
      if (times>72)
      {
        times=0;
        x = 220 + (int)(Math.random()*200);
      }
    }   
  }
  //return x-coordinate of UFO
  int GetX()
  {
    return x;
  }
}
