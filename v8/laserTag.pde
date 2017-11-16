/**
 * @version 8 july 2017
 * @author Alexey Titov & Shir Bentabou
 */
class laserTag
{
  int length;                        //length of laser
  int width;                         //width of laser 
  int x;                             //x-coordinate of laser
  int y;                             //y-coordinate of laser
  //constructor
  laserTag(int Ux)
  {
    length = 20;
    width = 10;
    //chosing where to shoot
    x = Ux + (int)(Math.random() *(120));
    y = 70;
  }
  //return to the initial data
  void reset(int Ux)
  {
    x = Ux + (int)(Math.random() *(120));
    y=70;
  }
  //displaying laser
  //return true-if the laser is in the player's sight, false-otherwise
  boolean display()
  { 
    ellipseMode(CENTER);
    noStroke();
    fill(#FF0000);
    ellipse(x,y,width,length);
    if (y<500)
    {
      y+=3;
      return true;
    }
    y=70;
    return false;
  }
 //set new x-coordinate
 void setX(int bx)
 {
    x = bx + (int)(Math.random() *(120));
 }
 //return x-coordinate of laser
 int GetX()
 {
    return x;
 }
 //return y-coordinate of laser
 int GetY()
 {
    return y;
 }
}
