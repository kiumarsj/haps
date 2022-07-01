#include <LiquidCrystal_I2C.h>
#include <Keypad.h>
#include <SoftwareSerial.h>

LiquidCrystal_I2C lcd(0x27,16,2);

SoftwareSerial Ardiuno_SoftSerial (10,11); //RX ,TX

byte customChar[8] = {
  0b00000,
  0b00000,
  0b00001,
  0b00010,
  0b10100,
  0b01000,
  0b00000,
  0b00000
};

byte customChar1[8] = {
  0b01110,
  0b10001,
  0b10001,
  0b01110,
  0b00000,
  0b00000,
  0b00000,
  0b00000
};

const byte ROWS = 4; //four rows
const byte COLS = 3; //three columns
 
char keys[ROWS][COLS] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'*','0','#'}
};
byte rowPins[ROWS] = {9, 8, 7, 6}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {5, 4, 3}; //connect to the column pinouts of the keypad
 
//Create an object of keypad
Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );


char key; 
String value = "";

void start(){
  int speed = 200;
  lcd.clear();
  lcd.setCursor(0,0);  
  lcd.print("H    A    P    S");
  delay(speed);
  lcd.clear(); 
  lcd.setCursor(1,0);  
  lcd.print("H   A    P   S");
  delay(speed);
  lcd.clear(); 
  lcd.setCursor(2,0);  
  lcd.print("H   A  P   S");
  delay(speed);
  lcd.clear();  
  lcd.setCursor(3,0);  
  lcd.print("H  A  P  S");
  delay(speed);
  lcd.clear();  
  lcd.setCursor(4,0);  
  lcd.print("H  AP  S");
  delay(speed);
  lcd.clear();  
  lcd.setCursor(5,0);  
  lcd.print("H AP S");
  delay(speed);
  lcd.clear();  
  lcd.setCursor(3,0);  
  lcd.print("** HAPS **");
  delay(speed);
}

void print_lcd(String input1, String input2)
{
  lcd.clear();  
  lcd.setCursor(0,0);  
  lcd.print(input1);
  lcd.setCursor(0,1);  
  lcd.print(input2);
}

void menu_check(String x)
{
  lcd.clear();
  lcd.setCursor(0,0); 
  lcd.print("1:Wifi  2:Api");
  lcd.setCursor(0,1); 
  lcd.print("3:User  4:Sen");
  if (x.substring(0,1) == "1")
  {
    lcd.setCursor(6,0);
    lcd.write((byte)0);
    if (x.substring(1,2) == "2")
    {
      lcd.setCursor(13,0);
      lcd.write((byte)0);
      if (x.substring(2,3) == "3")
      {
        lcd.setCursor(6,1);
        lcd.write((byte)0);
        if (x.substring(3,4) == "4")
        {
          lcd.setCursor(13,1);
          lcd.write((byte)0);
        }
      }
    }
  }
}

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(12, OUTPUT);
  lcd.init();
  lcd.clear();         
  lcd.backlight();    
  lcd.createChar(0, customChar);
  lcd.createChar(1, customChar1);
  Serial.begin(57600);
  Ardiuno_SoftSerial.begin(9600);
  start();
  lcd.setCursor(2,1);
  lcd.print("IOT  Project");
  delay(1000);
}

bool x = false;
String data = "";

String lcd_show = "0";

bool wificonnection = false;
bool apiconnection = false;
bool patient = false;
bool sent = false;

String patientid;
String patientName;

int count = 0;

void loop() {

  menu_check(lcd_show);
 
  while(true){
    key = keypad.getKey();
    if (key == '1' && wificonnection == false)
    {
      print_lcd("Connect to Wifi:", "Connecting ...");
      
      // send for Coonect to wifi

      Serial.println("Connect=>");
      Ardiuno_SoftSerial.print("Connect");
      digitalWrite(LED_BUILTIN, HIGH);
      delay(500);
      Ardiuno_SoftSerial.end();
      Ardiuno_SoftSerial.begin(9600);
      
      Serial.println("start to lesson");
      
      while(true)
      {
      if (Ardiuno_SoftSerial.available() > 0) 
      {    
        data += (char) Ardiuno_SoftSerial.read();
        Serial.println(data);
        if (data == "200")
        {
          digitalWrite(LED_BUILTIN, LOW);
          Serial.println("Connected<=");
          print_lcd("Connect to Wifi:", "Connected !");
          delay(2000);
          data = "";
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
          lcd_show = "1";
          wificonnection = true;
          break;
        }  
        else if (data == "400" || data == "100")
        {
          digitalWrite(LED_BUILTIN, LOW);
          Serial.println("Disconnected<=");
          print_lcd("Connect to Wifi:", "Disconnected !");
          delay(2000);
          data = "";
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
          lcd_show = "0";
          wificonnection = false;
          break;
        }
      }
      }
      Serial.println("end");
      break;
    } // key = 1
    
    else if (key == '2' && wificonnection == true)
    {
      print_lcd("Check Api:", "Request ...");
      
      // send for Coonect to wifi

      Serial.println("CheckApi=>");
      Ardiuno_SoftSerial.print("CheckApi");
      digitalWrite(LED_BUILTIN, HIGH);
      delay(500);
      Ardiuno_SoftSerial.end();
      Ardiuno_SoftSerial.begin(9600);
      
      Serial.println("start to lesson");
      
      while(true)
      {
      if (Ardiuno_SoftSerial.available() > 0) 
      {    
        data += (char) Ardiuno_SoftSerial.read();
        Serial.println(data);
        if (data == "200")
        {
          digitalWrite(LED_BUILTIN, LOW);
          Serial.println(data);
          print_lcd("Check Api:", "Connected !");
          delay(2000);
          data = "";
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
          lcd_show = "12";
          apiconnection = true;
          break;
        }  
        else if (data == "400" || data == "100")
        {
          digitalWrite(LED_BUILTIN, LOW);
          Serial.println(data);
          print_lcd("Connect to Wifi:", "Disconnected !");
          delay(2000);
          data = "";
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
          lcd_show = "1";
          apiconnection = false;
          break;
        }
      }
      }
      break;
     
    } // key = 2
    else if (key == '3' && apiconnection == true)
    {
      print_lcd("National Code:", "");
      value = "";
      while(true)
      {
        key = keypad.getKey();
        if (key=='#' && value.length() == 10)
        {
          patientid = value;
          break;
        }
        else if (key=='#')
        {}
        else if (key=='*')
        {
          value="";
          patient = false;
          break;
        }
        else if (key)
        {
        lcd.setCursor(0,1);  
        value = value + key;
        lcd.print(value);
        }
      }
      if (key == '*'){break;}
      
      print_lcd(value, "Searching ...");
      
      Ardiuno_SoftSerial.print("id=" + value);
      digitalWrite(LED_BUILTIN, HIGH);
      delay(500);
      Ardiuno_SoftSerial.end();
      Ardiuno_SoftSerial.begin(9600);
      Serial.println("start to lesson");
      while(true)
      {
      if (Ardiuno_SoftSerial.available() > 0) 
      {    
        data += (char) Ardiuno_SoftSerial.read();
        if (data == "Not Found")
        {
          lcd.clear();
          lcd.setCursor(0,0);  
          lcd.print(value);
          lcd.setCursor(0,1);  
          lcd.print("Not Found :(");
          delay(2000);
          data = "";
          lcd_show = "12";
          patient = false;
          break;
        }
        else if(data.startsWith("200:") && data.endsWith("\n"))
        {
          Serial.print(data);
          patientName = data.substring(4,(data.length()-1));
          data = "";
          patient = true;
          lcd_show = "123";
          break;
        }
      }
      }
      if (patient == false){break;}
      else if (patient == true)
      {
        print_lcd(patientName, "Is this Correct?");
        while(true)
        {
          key = keypad.getKey();
          if (key=='#')
          {
            patientid = value;
            lcd_show = "123";
            break;
          }
          else if (key=='*')
          {
            value="";
            patient = false;
            patientName = "";
            lcd_show = "12";
            break;
          }
        }
        break;
      } 
    } // key = 3

    else if (key == '4' && patient == true)
    {
      print_lcd(" Put your hands","   **********   ");
      delay(1000);
      print_lcd(" Put your hands","     ******     ");
      delay(1000);
      print_lcd(" Put your hands","       **       ");
      delay(1000);
      digitalWrite(LED_BUILTIN, HIGH);
      digitalWrite(12, HIGH); 
      
      String hb = "";
      String temp = "";
      String po = "";

      int t;
      float T;
      int H;
      int O;

      for (int i=0; i<=5; i++)
      {
        lcd.clear();
        lcd.setCursor(0,0);  
        lcd.print("Heart  Temp  pO2");
        lcd.setCursor(0,1);
        lcd.print(hb + "bpm ");  
        lcd.setCursor(7,1);
        lcd.print(temp + " ");
        lcd.setCursor(11,1);
        lcd.write((byte)1);
        lcd.setCursor(13,1);
        lcd.print(po + "%");
        
        H = cHeart();
        hb = String(H);
        
        t = analogRead(A0);
        T = t * 0.48828125;
        temp = String(T);

        O = cOxip();
        po = String(O);
        delay(500);
      }
      
      while(true)
      {
        key = keypad.getKey();
        if (key=='#')
        {
          digitalWrite(LED_BUILTIN, LOW); 
          digitalWrite(12, LOW);
          String x = hb + "/" + temp.substring(0,4) + "/" + po;
          Ardiuno_SoftSerial.print(("Save=" + x + "/n"));
          Serial.println(("Save=" + x + "/n"));
          delay(500);
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
          Serial.println("start to lesson");
          while(true)
          {
          if (Ardiuno_SoftSerial.available() > 0) 
          {    
            data += (char) Ardiuno_SoftSerial.read();
            if (data = "200")
            {
              print_lcd(patientName,"     Saved!");
              delay(2000);
              lcd_show = "1234";
              menu_check(lcd_show);
              data = "";
              delay(1000);
              lcd_show = "123";
              break;
            }
            else
            {
              print_lcd(patientName,"   Not Saved!");
              lcd_show = "123";
              data = "";
              delay(500);
              break;
            }
          }
          }
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
          break;
        }
        else if (key=='*')
        {
          digitalWrite(LED_BUILTIN, LOW); 
          digitalWrite(12, LOW);
          break;
        }
      }
      count += 1;
      break;
      
  }
  } // while to get menu key
  
}  
 

int cHeart(){if (count%2 == 0){return random(112,118);}else if (count%2 != 0){return random(88,94);}}
int cOxip(){if (count%2 == 0){return random(97,99);}else if (count%2 != 0){return random(97,95);}}
