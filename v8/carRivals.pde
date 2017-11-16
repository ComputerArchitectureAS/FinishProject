/**
 * @version 8 july 2017
 * @author Alexey Titov & Shir Bentabou
 */
class carRivals
{ 
  int[] x;                     //x-coordinate of rival
  int[] y;                     //y-coordinate of rival
  int shift;                   //how much to shift
  PImage carRival;
  //constructor
  carRivals()
  { 
    x=new int[7];
    y=new int[7];
    for(int i=0;i<7;i++)  
    {
         float r = random(20);
         if (r<11)
           x[i]=345;
         else
           x[i]=420;
         r = random(20,100);
         if (i==0)
           y[i]=-2000+(int)r;
         else
         y[i]=y[i-1]+(int)r+250;
    }
    shift=1;
    carRival=loadImage("car2.jpg");
  }
  //return to the initial data
  void reset()
  {
    for(int i=0;i<7;i++)  
    {
         float r = random(20);
         if (r<11)
           x[i]=345;
         else
           x[i]=420;
         r = random(20,100);
         if (i==0)
           y[i]=-2000+(int)r;
         else
         y[i]=y[i-1]+(int)r+250;
    }
    shift=1;
  }
  //displaying enemies 
  void display() 
  { 
   for(int i=0;i<7;i++)
   {
     image(carRival,x[i],y[i]);
   }
   for(int i=0;i<7;i++)
   {
       y[i]+=shift;
   }
  }
  //return x-coordinate of rivals on place i
  int GetX(int i)
  {
    return x[i];
  }
  //return y-coordinate of rivals on place i
  int GetY(int i)
  {
    return y[i];
  }
}
