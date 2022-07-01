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

bool wificonnection = false;

bool patient = false;
String patientid;
String patientName;

bool addsituation;

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

void print_under_haps(String input)
{
  lcd.clear();  
  lcd.setCursor(3,0);  
  lcd.print("** HAPS **");
  lcd.setCursor(0,1);  
  lcd.print(input);
}

void setup() {
  lcd.init();
  lcd.clear();         
  lcd.backlight();    
  lcd.createChar(0, customChar);
  lcd.createChar(1, customChar1);
  Serial.begin(57600);
  Ardiuno_SoftSerial.begin(9600);
  start();
}

bool x = false;
String data = "";

bool loop_while = true;

void loop() {

//  if(wificonnection = true)
//  {
//    lcd_show = "1";
//    if(apiconnection = true)
//    {
//      lcd_show = "12";
//      if(patient = true)
//      {
//        lcd_show = "123";
//        if(sent = true)
//        {
//          lcd_show = "1234";
//          menu_check(lcd_show);
//          delay(2000);
//          sent = false;
//          lcd_show = "0";
//        }
//      }
//    }
//  }else{lcd_show = "0";}

  lcd.clear();  
  lcd.setCursor(3,0);  
  lcd.print("** HAPS **");
  lcd.setCursor(0,1);  
  lcd.print("Press   to Start");
  lcd.setCursor(6,1);
  lcd.write((byte)0);
 
  while(true){
    key = keypad.getKey();
    if (key == '#')
    {
      print_under_haps("Connecting...");
      // send for check API
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
        if (data == "200")
        {
          digitalWrite(LED_BUILTIN, LOW);
          Serial.println(data);
          print_under_haps("Connected !");
          delay(2000);
          data = "";
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
          wificonnection = true;
          loop_while = true;
          break;
        }  
        else if (data == "400" || data == "100")
        {
          digitalWrite(LED_BUILTIN, LOW);
          Serial.println(data);
          print_under_haps("Disconnected !");
          delay(500);
          data = "";
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
          wificonnection = false;
          loop_while = false;
          break;
        }
      }
      }
      if (loop_while == false){break;} 
      else 
      {
        lcd.clear();         
        lcd.setCursor(0,0);  
        lcd.print("National Code:");
  
        while(true)
        {
          key = keypad.getKey();
          if (key=='#')
          {
            patientid = value;
            break;
          }
          else if (key=='*')
          {
            value="";
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
      
      lcd.clear();
      lcd.setCursor(0,0);  
      lcd.print(value);
      lcd.setCursor(0,1);  
      lcd.print("Searching ...");
      
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
          patient = false;
          break;
        }
        else if(data.startsWith("200:") && data.endsWith("\n"))
        {
          Serial.print(data);
          patientName = data.substring(4,-2);
          patient = true;
          break;
        }
      }
      }
      if (patient == false){break;}
      else if (patient == true)
      {
        lcd.clear();
        lcd.setCursor(0,0);  
        lcd.print(patientName);
        lcd.setCursor(1,1);  
        lcd.print("Is this right?");
        while(true)
        {
          key = keypad.getKey();
          if (key=='#')
          {
            patientid = value;
            break;
          }
          else if (key=='*')
          {
            value="";
            break;
          }
          else if (key)
          {
          lcd.setCursor(0,1);  
          value = value + key;
          lcd.print(value);
          }
        }
        if (key == '*')
        {
          patientName = "";
          patient = false;
          break;
        }

        lcd.clear();
        lcd.setCursor(0,0);  
        lcd.print("Heart  Temp  pO2");

        String hb = "";
        String temp = "";
        String po = "";
        
        lcd.setCursor(0,1);
        lcd.print(hb + "bpm ");  
        lcd.setCursor(7,1);
        lcd.print(temp + " ");
        lcd.setCursor(11,1);
        lcd.write((byte)1);
        lcd.setCursor(13,1);
        lcd.print(po + "%");
        //lcd.print("120bpm 37.6  95%");
        // Reading Sensors
        delay(300);

        int t;
        float T;
        int H;
        int O;
        
        while(true)
        {
          key = keypad.getKey();
          if (key=='#'){break;}
          
          H = random(75,130);
          hb = String(H);
          
          t = analogRead(A0);
          T = t * 0.48828125;
          temp = String(T);

          O = random(85,99);
          po = String(O);
          
          delay(200);

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
        }

        String x = hb + "/" + temp.substring(0,4) + "/" + po;
        Ardiuno_SoftSerial.print(("Save=" + x + "/n"));
        Serial.println(("Save=" + x + "/n"));
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
          if (data = "200")
          {
            lcd.clear();
            lcd.setCursor(0,0);  
            lcd.print("New Situation of");
            lcd.setCursor(1,1);  
            lcd.print("Patient saved.");
            addsituation = true;
            delay(5000);
            break;
          }
          else
          {
            lcd.clear();
            lcd.setCursor(0,0);  
            lcd.print("New Situation of");
            lcd.setCursor(0,1);  
            lcd.print("Patient not send");
            addsituation = false;
            delay(5000);
            break;
          }
          Ardiuno_SoftSerial.end();
          Ardiuno_SoftSerial.begin(9600);
        }
        }
        if (addsituation == false) {break;}
        else if (addsituation == true) {break;}
      }
     
      }
    }
    
  }
  
  
 
}
