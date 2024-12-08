#include "Atoms/globalVariables.h"
#include "Atoms/secrets.h"
#include "Atoms/definePins.h"

#include "Atoms/WIFI.h"
#include "Atoms/OLED.h"
#include "Atoms/Buzzer.h"
#include "Atoms/websocket.h"
#include "Atoms/RFID.h"
#include "Atoms/DHTsense.h"
#include "Atoms/plant.h"
#include "Atoms/Light.h"

TaskHandle_t RFIDTaskHandle = NULL;

void setup() {
  Serial.begin(115200);
  disconnectWIFI();
  OLEDsetup();
  bootingSplash("Version 3.0");
  delay(1000);
  bootingSplash("Init I/O...");
  setupIO();
  bootingSplash("Init WiFi...");
  WIFISetup();
  bootingSplash("Init RFID...");
  RFIDsetup();
  bootingSplash("Init DHT...");
  DHTSetup();
  bootingSplash("Init WebSocket...");
  webhookSetup();
  bootingSplash("Init Buzzer...");
  BuzzerSetup();
  bootingSplash("Init Tasks...");
  xTaskCreate(
    readRFID,        // Task function
    "Read RFID",     // Task name
    2000,            // Stack size (in words)
    NULL,            // Task input parameter
    1,               // Priority of the task
    &RFIDTaskHandle  // Task handle
  );
    bootingSplash("Done!");
    delay(500);
    display.clearDisplay();
    display.display();
}

void loop() {
  struct connectionState wifiStatus = EnsureWIFIIsConnected();
  if (wifiStatus.isConnected) {
    unsigned long currentMillis = millis();
    showCurrentTempratureAndHumidity(previousTemperature, previousHumidity);
    bottomPanel(wifiStatus.ssid, wifiStatus.ip, connected);

    if (currentMillis - previousMillisDHT >= intervalDHT) {
      previousMillisDHT = currentMillis;
      readPlant();
      lightON();
      readPlant()
      checkAndSendDHTData();
    }

    if (currentMillis - previousMillisWebSocket >= intervalWebSocket) {
      previousMillisWebSocket = currentMillis;
      readWebSocket();
    }
  } else {
    reconnectingScreen();
  }
}
