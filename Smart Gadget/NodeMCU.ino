#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <Arduino_JSON.h>

const char* ssid = "Magma007";
const char* password = "R@zaghi.2020";

const char* serverName = "http://192.168.1.176:2090/api/Auth";
String response;
JSONVar myObject;

SoftwareSerial NodeMCU_SoftSerial (D1,D2); //RX ,TX

char c;
String dataIn;

int id;

//###################################### WIFI ########################
String connect_to_wifi(){
  WiFi.begin(ssid, password);
  Serial.print("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("Connected !");
  return "Connected";
}

//###################################### Api_Request ########################

String httpGETRequest(const char* serverName) {
  WiFiClient client;
  HTTPClient http;
    
  // Your IP address with path or Domain name with URL path 
  http.begin(client, serverName);
  
  // Send HTTP POST request
  int httpResponseCode = http.GET();
  
  String payload = "{}"; 
  
  if (httpResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    payload = http.getString();
  }
  else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  // Free resources
  http.end();

  return payload;
}

//###################################### check_api ########################

String api_request(String param){
  WiFiClient client;
  HTTPClient http;
  String response = "{}";
  String serverPath = serverName + param;
  Serial.println(serverPath);
  http.begin(client, serverPath.c_str());
      
  int httpResponseCode = http.GET();
  Serial.println(httpResponseCode);    
  if (httpResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    response = http.getString();
    Serial.println(response);
  }
  else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  http.end();
  return response;
}


void setup()
{
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(57600);
  NodeMCU_SoftSerial.begin(9600);
  c = 0;
  dataIn = "";
}

String data;
bool zedtekrar = false;

//void loop ()
//{
//  if (zedtekrar == false){
//      NodeMCU_SoftSerial.println("Connect");
//      zedtekrar = true;
//      digitalWrite(LED_BUILTIN, LOW);
//      delay(500);
//  }
//  else if (NodeMCU_SoftSerial.available() > 0) 
//  {    
//    data += (char) NodeMCU_SoftSerial.read();
//    if (data == "Hello") 
//    {
//      digitalWrite(LED_BUILTIN, HIGH);
//      Serial.println(data);
//      delay(500);
//      data = "";
//      zedtekrar = false;
//      delay(3000);  
//      NodeMCU_SoftSerial.end();
//      NodeMCU_SoftSerial.begin(9600);
//    }
//  }
//
//}



void loop()
{
  digitalWrite(LED_BUILTIN, LOW); 
    if (NodeMCU_SoftSerial.available() > 0) 
    {  
      digitalWrite(LED_BUILTIN, HIGH);  
      while(NodeMCU_SoftSerial.available() > 0){
      data += (char) NodeMCU_SoftSerial.read();
      Serial.println(data);
      if (data == "Connect") 
      {
        Serial.println(data);
        delay(500);
        data = "";
        NodeMCU_SoftSerial.end();
        NodeMCU_SoftSerial.begin(9600);
        
        //##################### STEP1 : WIFI #####################
        
        String netcheck = connect_to_wifi();
        Serial.println("Connect to net");
        if(netcheck == "Connected")
        {
          NodeMCU_SoftSerial.println("200");
          Serial.println("Sendback 200");
          NodeMCU_SoftSerial.end();
          NodeMCU_SoftSerial.begin(9600);
          delay(500);
          data = "";
        }
        else 
        {
          NodeMCU_SoftSerial.println("100");
          Serial.println("Sendback 100");
          NodeMCU_SoftSerial.end();
          NodeMCU_SoftSerial.begin(9600);
          delay(500);
          data = "";
        }
      }

      else if (data == "CheckApi")
      {
        Serial.println(data);
        delay(500);
        data = "";
        NodeMCU_SoftSerial.end();
        NodeMCU_SoftSerial.begin(9600);
          
        //################### STEP2 : Check API ##################        
        //response = api_request("/CheckApi");
        response = httpGETRequest("http://192.168.1.176:2090/api/Auth/CheckApi");
        delay(1000);
        if(response == "haps_api")
        {
          NodeMCU_SoftSerial.println("200");
          Serial.println("Sendback 200");
          NodeMCU_SoftSerial.end();
          NodeMCU_SoftSerial.begin(9600);
          delay(500);
          data = "";
        } 
        else 
        {
          NodeMCU_SoftSerial.println("400");
          Serial.println("Sendback 400");
          NodeMCU_SoftSerial.end();
          NodeMCU_SoftSerial.begin(9600);
          delay(500);
          data = "";
        }
      }
      else if (data.length() == 13 && data.startsWith("id="))
      { 
        //##################### STEP3 : Get Patient from API #####################
        
        Serial.println(data.substring(3,14));
        
        String nationalCode = data.substring(3,14);
        response = api_request(("/GetPatient?nationalCode=" + nationalCode));
        myObject = JSON.parse(response);
        bool ok = (bool)myObject["isOk"]; 
        Serial.println(ok);
        delay(500);
        if (ok == true) 
        {
          Serial.println(myObject["data"]["id"]);
          id = myObject["data"]["id"];
          Serial.println(myObject["data"]["firstName"]);
          String firstname = (const char*)myObject["data"]["firstName"];
          Serial.println(myObject["data"]["lastName"]);
          String lastname = (const char*)myObject["data"]["lastName"];
          NodeMCU_SoftSerial.println(
            "200:" + firstname + " " + lastname + "\n"
                                    );
          delay(500);
          Serial.println("Sendback 200");
          NodeMCU_SoftSerial.end();
          NodeMCU_SoftSerial.begin(9600);
          data = "";
          break;
        }
        else
        {
          NodeMCU_SoftSerial.println("Not Found");
          delay(500);
          Serial.println("Sendback 100");
          NodeMCU_SoftSerial.end();
          NodeMCU_SoftSerial.begin(9600);
          data = "";
          break;
        }  
      }      
      else if (data.startsWith("Save=") && data.endsWith("/n"))
      {
        Serial.print(data);
        if (data.length() == 17)
        {
          Serial.println(data.substring(5,15));        
//          http://192.168.190.1:2090/api/Auth/AddSituation?patientId=1&po=80&hb=80&temp=20
          String i = "?patientId=" + String(id);
          String a = "&hb=" + data.substring(5,7);
          String b = "&temp=" + data.substring(8,10);
          String c = "&po=" + data.substring(13,15);
          String address = a + b + c;
          delay(200);
          Serial.println("/AddSituation" + i + address);
          delay(200);
          String url = "/AddSituation" + i + address;
          WiFiClient client;
          HTTPClient http;
          response = "{}";
          String serverPath = serverName + url;
          Serial.println(serverPath);
          http.begin(client, serverPath);
              
          int httpResponseCode = http.GET();
          Serial.println(httpResponseCode);    
          if (httpResponseCode>0) {
            Serial.print("HTTP Response code: ");
            Serial.println(httpResponseCode);
            response = http.getString();
            Serial.println(response);
          }
          else {
            Serial.print("Error code: ");
            Serial.println(httpResponseCode);
          }
          http.end();
          
//          response = api_request(("/AddSituation?patientId=" + id + address));
          myObject = JSON.parse(response);
          bool ok = (bool)myObject["isOk"]; 
          Serial.println(ok);
          if (ok == true) 
          {
            NodeMCU_SoftSerial.println("200");
            Serial.println("Sendback 200");
            NodeMCU_SoftSerial.end();
            NodeMCU_SoftSerial.begin(9600);
            delay(500);
            data = "";
            break;
          }
          else
          {
            NodeMCU_SoftSerial.println("100");
            Serial.println("Sendback 100");
            NodeMCU_SoftSerial.end();
            NodeMCU_SoftSerial.begin(9600);
            delay(500);
            data = "";
            break;
          }
        }
        else if (data.length() == 18)
        {
          Serial.println(data.substring(5,16));
          delay(200);
//          http://192.168.190.1:2090/api/Auth/AddSituation?patientId=1&po=80&hb=80&temp=20
          String i = "?patientId=" + String(id);
          String a = "&hb=" + data.substring(5,8);
          String b = "&temp=" + data.substring(9,11);
          String c = "&po=" + data.substring(14,16);
          String address = a + b + c;
          delay(200);
          Serial.println("/AddSituation" + i + address);
          delay(200);
          String url = "/AddSituation" + i + address;
          WiFiClient client;
          HTTPClient http;
          response = "{}";
          String serverPath = serverName + url;
          Serial.println(serverPath);
          http.begin(client, serverPath);
              
          int httpResponseCode = http.GET();
          Serial.println(httpResponseCode);    
          if (httpResponseCode>0) {
            Serial.print("HTTP Response code: ");
            Serial.println(httpResponseCode);
            response = http.getString();
            Serial.println(response);
          }
          else {
            Serial.print("Error code: ");
            Serial.println(httpResponseCode);
          }
          http.end();
          
//          response = api_request(("/AddSituation?patientId=" + id + address));
          myObject = JSON.parse(response);
          bool ok = (bool)myObject["isOk"]; 
          Serial.println(ok);
          if (ok == true) 
          {
            NodeMCU_SoftSerial.println("200");
            Serial.println("Sendback 200");
            NodeMCU_SoftSerial.end();
            NodeMCU_SoftSerial.begin(9600);
            delay(500);
            data = "";
            break;
          }
          else
          {
            NodeMCU_SoftSerial.println("100");
            Serial.println("Sendback 100");
            NodeMCU_SoftSerial.end();
            NodeMCU_SoftSerial.begin(9600);
            delay(500);
            data = "";
            break;
          }
        }
        
      }
    }
    }
}
