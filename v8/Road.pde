/**
 * @version 8 july 2017
 * @author Alexey Titov & Shir Bentabou
 * @ID Shir:302895529     Alexey:334063021
 */
class Road
{ 
  int[] line;                  //y-coordinate of white line
  int shift;                   //how much to shift
  //constructor
  Road() 
  { 
    line=new int[5];
    line[0]=-50;
    for(int i=1;i<5;i++)  
      line[i]=line[i-1]+150;
    shift=2;  
  }
  //displaying road and restriction lines.
  void display() 
  { 
    rectMode(CENTER);
    fill(100);
    rect(400,245,140,490);        //x and y coordinates of centre, width,height
    for(int i=0;i<5;i++)
    {
      fill(255);
      noStroke();
      rect(width/2,line[i],10,60);
    }
    for(int i=0;i<5;i++)
    {
       line[i]+=shift;
       if(line[i]>=580)
       {
         line[i]=-50;
       }
    }
  }
}