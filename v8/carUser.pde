/**
 * @version 8 july 2017
 * @author Alexey Titov & Shir Bentabou
 */
class carUser
{ 
  int x;              //x-coordinate of user car
  int y;              //y-coordinate of user car
  int speed;          //speed of car
  PImage youCar;
  //constructor
  carUser() 
  { 
    x=390;
    y=400;
    speed=1;
    youCar=loadImage("car1.png");
  }
  //return to the initial data
  void reset()
  {
    x=390;
    y=400;
    speed=1;
  }
  //displaying user car
  void display() 
  { 
    image(youCar,x,y);
  }
  //movement of user car
  void move(boolean[] k)
  {
    if (k[0]&&!k[1])
    {
      if (x-5>325)
        x-=speed;
    }
    else
      if (!k[0]&&k[1])
      {
        if (x+5<445)
          x+=speed;
      }
      else
        if(k[0]&&k[1])
        {
          if (y-5>40)
            y-=speed;
        }
        else
        {
          if (y+5<400)
            y+=speed;
        }
  }
  //return x-coordinate of user car
  int GetX()
  {
    return x;
  }
  //return y-coordinate of user car
  int GetY()
  {
    return y;
  }
}
