/**
 * @version 8 july 2017
 * @author Alexey Titov & Shir Bentabou
 */
const int pushButton1 = PUSH1;        //button SW1
const int pushButton2 = PUSH2;        //button SW2
#define LEDR RED_LED                  //macro of RED_LED
#define LEDG GREEN_LED                //macro of Green_LED
#define LEDB BLUE_LED                 //macro of BLUE_LED
//
void setup() 
{
   Serial.begin(19200);                // speed
   // initialize the leds as an output: 
   pinMode(LEDR, OUTPUT);
   pinMode(LEDG, OUTPUT); 
   pinMode(LEDB, OUTPUT);           
   // initialize the pushbutton pins as an input: 
   pinMode(pushButton1, INPUT_PULLUP);
   pinMode(pushButton2, INPUT_PULLUP); 
}
//
void loop()
{
  while (Serial.available())            // If data is available to read
  { 
    if (digitalRead(pushButton1) == LOW and digitalRead(pushButton2) == LOW) 
    {                                          // If switch is ON,
      Serial.write(4);                         // send 4 to Processing
      OffLeds();
      digitalWrite(LEDB, HIGH);
    } 
    else
      if (digitalRead(pushButton1) == LOW) 
      {                                        // If switch is ON,
        Serial.write(2);                       // send 2 to Processing
        OffLeds();
        digitalWrite(LEDR, HIGH);
      } 
      else 
        if (digitalRead(pushButton2) == LOW) 
        {                                      // If switch is ON,
          Serial.write(3);                     // send 3 to Processing
          OffLeds();
          digitalWrite(LEDG, HIGH);
        } 
        else
        {                                      // If the switch is not ON,
          Serial.write(1);                     // send 1 to Processing
          OffLeds();
        }
    delay(100);                                // Wait 100 milliseconds
   }                    
}
void OffLeds()
{
  digitalWrite(LEDR, LOW);
  digitalWrite(LEDG, LOW);
  digitalWrite(LEDB, LOW);
}
