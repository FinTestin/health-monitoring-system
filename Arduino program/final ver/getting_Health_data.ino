#define analogTem 35
#include <WiFi.h>
#include <Wire.h>
#include <FirebaseESP32.h>
#include "MAX30105.h"
#include "heartRate.h"

#define WIFI_SSID "your_SSID" // your WIFI
#define WIFI_PASSWORD "your_PASSWORD" //  your WIFI Password
#define FIREBASE_HOST "your_firebase_database_url"
#define FIREBASE_Authorization_key "your_firebase_database_secret"

MAX30105 particleSensor;
const byte RATE_SIZE = 4; //Increase this for more averaging. 4 is good.
byte rates[RATE_SIZE]; //Array of heart rates
byte rateSpot = 0;
long lastBeat = 0; //Time at which the last beat occurred
float beatsPerMinute;
float BPM = 0;
int beatAvg;
int Avg =0;

FirebaseData firebaseData;
FirebaseJson json;

uint32_t tsLastReport = 0;

void MAX30102pox(){
    if (!particleSensor.begin(Wire, I2C_SPEED_FAST)){ //Use default I2C port, 400kHz speed
      //Serial.println("MAX30105 was not found. Please check wiring/power. ");
      while (1);
    }
    //Serial.println("Place your index finger on the sensor with steady pressure.");
    particleSensor.setup(); //Configure sensor with default settings
    particleSensor.setPulseAmplitudeRed(0x0A); //Turn Red LED to low to indicate sensor is running
    particleSensor.setPulseAmplitudeGreen(0); //Turn off Green LED
}
void setup(){
    Serial.begin(115200);
    //wifi connect____________________________________________
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED){
      delay(500);
      //Serial.println("Establishing connection to WiFi..");
    }
    //MAX30102 connect________________________________________
    MAX30102pox();
    //firebase connect________________________________________
    Firebase.begin(FIREBASE_HOST,FIREBASE_Authorization_key);
}
 
void loop(){
  long irValue = particleSensor.getIR();
  int TemRawValue = analogRead(analogTem);
  float Voltage = TemRawValue * (1330 / 1024.0);//3.3V and arm 1330
  float TempData = Voltage * 0.1;
  
  if (checkForBeat(irValue) == true){
    long delta = millis() - lastBeat;
    lastBeat = millis();
    //Serial.println(delta);//hand base 2000-3000
    beatsPerMinute =60/(delta / 3800.0);//org 1000 testing 3000
    //Firebase.setFloat(firebaseData,"/ESP32/BPM", beatsPerMinute);
    if (beatsPerMinute < 255 && beatsPerMinute > 20){
      rates[rateSpot++] = (byte)beatsPerMinute; //Store this reading in the array
      rateSpot %= RATE_SIZE; //Wrap variable
      beatAvg = 0;//Take average of reading
      for (byte x = 0 ; x < RATE_SIZE ; x++)
        beatAvg += rates[x];
      beatAvg /= RATE_SIZE;
      Firebase.setFloat(firebaseData,"/ESP32/Avg", beatAvg);
      Firebase.setFloat(firebaseData,"/ESP32/Temperature", TempData);  
    }
  }
  //Serial.print(beatsPerMinute);
  //Serial.println("bpm");
  //Serial.print(beatAvg);
  //Serial.println("avg bpm");
  //Serial.print(TempData,1);
  //Serial.println(" \xC2\xB0 C");
}
