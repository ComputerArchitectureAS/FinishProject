/**
 * @version 8 july 2017
 * @author Alexey Titov & Shir Bentabou
 */
//Libraries
import ddf.minim.*;
import processing.serial.*;
//Audio
Minim minim;
AudioPlayer startTrack,finishTrack,crashTrack,raceTrack;
//Port
Serial myPort;          //create object from Serial class
//Variables
int Frame=1;            //the global variables of position
int Allocated=1;        //the global variable denoting which word to highlight
int red=#FD010D;        //RED
int yellow=#FFFC42;     //YELLOW
int blue=#569DFF;       //BLUE
int place=1;            //place in the list
int val;                //data received from the serial port
boolean END=true;       //true-player is winner,false-player is loser
boolean shoot=true;     //true-UFO can shoot, false-UFO can not shoot
boolean joystick=true;  //true-management with a joystick, false-control from the keyboard
boolean[] keysLR;       //array for buttons right and left
String title = "Tune";  //name of the game 
//Variables of units
carUser myCar;
Road myRoad;
carRivals myRivals;
Ufo myUfo;
laserTag bullet;
//Pictures
PImage startFrame,finishFrame,crashFrame,raceFrame,tmpFrame,icon;
//Font
PFont myFont;
void setup() 
{
  size(800, 490);                      //size of frame 800x490
  //list all the available serial ports:
  printArray(Serial.list());
  //open the port you are using at the rate you want:
  try {                                                        //Exception :the joystick is connected
        String portName = Serial.list()[0];                    //name of the communication port
        val=1;
        myPort = new Serial(this, portName, 19200);
      }
  catch(ArrayIndexOutOfBoundsException e) {                    //Exception :the joystick is not connected
        System.out.println("The joystick is not connected");
        joystick=false;
      }
  //create my font
  myFont = createFont("Arial", 32);
  textFont(myFont);
  textAlign(CENTER, CENTER);
  //pictures
  tmpFrame=startFrame=loadImage("start.jpg");
  finishFrame=loadImage("finish.jpg");
  crashFrame=loadImage("crash.jpg");
  raceFrame=loadImage("grass.jpg");
  icon=loadImage("icon.png");                        //loading icon images
  surface.setIcon(icon);                             //change the processing icon on the machine icon
  //change the processing title on name of game 
  frame.setTitle(title);
  //audio
  minim = new Minim(this);
  startTrack = minim.loadFile("start.mp3");
  finishTrack = minim.loadFile("finish.mp3");
  crashTrack = minim.loadFile("crash.mp3");
  raceTrack=minim.loadFile("race.mp3");
  startTrack.loop();
  //units
  myCar=new carUser();
  myUfo=new Ufo();
  bullet=new laserTag(myUfo.GetX());
  myRoad=new Road();
  myRivals=new carRivals();
  keysLR=new boolean[2];
  keysLR[0]=false;            //no press left
  keysLR[1]=false;            //no press right
}
 
void draw()
{
  background(tmpFrame);
  if (Frame==1)
  {
    tmpFrame=startFrame;
    textSize(50);
    //START
    if (Allocated==1)
      fill(yellow);
    else
      fill(red);
    text("START",width/2,130);
    //INSTRUCTION
    if (Allocated==2)
      fill(yellow);
    else
      fill(red);
    text("INSTRUCTIONS",width/2,200);
    //ABOUT US
    if (Allocated==3)
      fill(yellow);
    else
      fill(red);
    text("ABOUT US",width/2,270);
    //EXIT
    if (Allocated==4)
      fill(yellow);
    else
      fill(red);
    text("EXIT",width/2,340);
  }
  else
    if (Frame==2)
    {
      tmpFrame=raceFrame;
      myRoad.display();
      myCar.display();
      myCar.move(keysLR);
      myRivals.display();
      myUfo.display();
      shooting();
      CheckPosition();
    }
    else
      if(Frame==3)
      {
        textSize(26);
        fill(yellow);
        text("Pressing the left button the car moves to the left\n"+
             "Pressing the right button the car moves to the right\n"+
             "Pressing the two buttons together the car will accelerate\n",width/2,height/2);
      }
      else
        if(Frame==4)
        {
          textSize(50);
          fill(blue);
          text("ALEXEY TITOV        334063021\n"+
               "SHIR BENTABOU    302895529",400,200);
        }
        else
        {
          raceTrack.pause();
          textSize(50);
          fill(yellow);
          if (END)                                        //WINNER
          {
            tmpFrame=finishFrame;
            text("YOU ARE THE WINNER",width/2,height/3);
          }
          else                                            //LOSER
          {
            tmpFrame=crashFrame;
            text("YOU ARE A LOSER!!!",width/2,height/3);
          }
        }
      if(joystick)   
        EventPush();
}
//Click on the button
void keyPressed()
{
  joystick=false;
  if(keyCode==RIGHT)                //click on the right button
  {
    keysLR[1]=true;
    if (Frame!=2 && Frame!=5)          //menu or about us or instruction
    {
      if  (Allocated==2)              //instruction
        Frame=3;
      else
        if (Allocated==3)             //about us
          Frame=4;
        else
          if (Allocated==4)           //exit
            {exit();}
          else
          {
             Frame=2;
             startTrack.pause();
             raceTrack.loop();
           }
      }
  }
  else
    if(keyCode==LEFT)              //click on the left button
    {
       keysLR[0]=true;
       if (Frame==1)                  //menu
       {
         if(Allocated==4)
           Allocated=1;
         else 
           Allocated++;
       }
       else
         if (Frame==3 || Frame==4)   //about us or instruction
         {
           Frame=1;
           Allocated=1;
         }
    }
    if (Frame==5 && keysLR[0] &&keysLR[1])              //finish or crash
    {
      Frame=1;
      Allocated=1;
      reset();
    }
  }
  //no click the buttons
  void keyReleased()
  {
     if (keyCode==LEFT)
       keysLR[0]=false;
     else
       if (keyCode==RIGHT)
         keysLR[1]=false;    
  }
  //check position of user car and rivals
  void CheckPosition()
  {
    int x,y;                 //coordinate user car
    int xR,yR;               //coordinat rival car
    int xB,yB;               //coordinat bullet
    x=myCar.GetX();       y=myCar.GetY();
    xB=bullet.GetX();     yB=bullet.GetY();
    if(yB>=(y-8) && yB<=(y+80) && xB>=(x-9) && xB<=(x+35))  //conditions to end the game with loss
    {
      Frame=5;
      END=false;
      crashTrack.loop();
      return;
    }
    for (int i=0;i<7;i++)
    {  
       xR=myRivals.GetX(i);  yR=myRivals.GetY(i);        //coordinat rival car
       if(yR>=(y-79) && yR<=(y+79) && xR>=(x-40) && xR<=(x+40))  //conditions to end the game with loss
       {
         Frame=5;
         END=false;
         crashTrack.loop();
         return;
       }
     }
     place=1;
     for (int i=6;i>=0;i--)
     {  
       yR=myRivals.GetY(i);              //coordinat rival car
       if(yR<y+60)
         place++;
     }
     fill(red);
     textSize(50);
     text(place+" th",70,100);
     yR=myRivals.GetY(0);              //coordinat rival car
     if (place==1 && yR==600)          //conditions to end the game with victory
     {
       Frame=5;
       END=true;
       finishTrack.loop();
       return;
     }
  }
  //return to the initial data
  void reset()
  {
    myCar.reset();
    myUfo.reset();
    myRivals.reset();
    bullet.reset(myUfo.GetX());
    shoot=true;                 //ready for new shot
    keysLR[0]=false;            //no press left
    keysLR[1]=false;            //no press right
    crashTrack.pause();
    finishTrack.pause();
    startTrack.play();
  }
  //laser shooting
  void shooting()
  {
    int xB=bullet.GetX();                  //x-coordinate bullet
    if (shoot && xB>=330 && xB<=470)       //displaying of the released laser
      shoot=bullet.display();
    else                                   //preparation for new launch
    {
      bullet.setX(myUfo.GetX());
      shoot=true;
    }
  }
//check which buttons are pressed
void EventPush()
{
  myPort.write('T');
  val = myPort.read();             // read it and store it in val
  keyPressedPort();
}
//using launchpad
void keyPressedPort()
{
  if(val==3)                //click on the right button
  {
    keysLR[1]=true;
    keysLR[0]=false;
    if (Frame!=2 && Frame!=5)          //menu or about us or instruction
    {
      if  (Allocated==2)              //instruction
        Frame=3;
      else
        if (Allocated==3)             //about us
          Frame=4;
        else
          if (Allocated==4)           //exit
            {exit();}
          else
          {
             Frame=2;
             startTrack.pause();
             raceTrack.loop();
           }
      }
  }
  else
    if(val==2)              //click on the left button
    {
       keysLR[0]=true;
       keysLR[1]=false;
       if (Frame==1)                  //menu
       {
         if(Allocated==4)
           Allocated=1;
         else 
           Allocated++;
       }
       else
         if (Frame==3 || Frame==4)   //about us or instruction
         {
           Frame=1;
           Allocated=1;
         }
    }
    else
    {
      if (val==4)                    //two buttons in the NO position
      {
        keysLR[0]=true;
        keysLR[1]=true;
      }
      else
        if (val==1)                  //two buttons in the Off position
        {
          keysLR[0]=false;
          keysLR[1]=false;
        }
    }
    if (Frame==5 && val==4)          //finish or crash
    {
      Frame=1;
      Allocated=1;
      reset();
    }
  }
