#include "WIFI.h"
#include "OLED.h"
#include "websocket.h"

void setup() {
  Serial.begin(115200);
  disconnectWIFI();
  OLEDsetup();

  bootingSplash("Version 3.0");
  delay(1000);

  bootingSplash("Init WiFi...");
  WIFISetup();

  bootingSplash("Init WS...");
  webSocket.begin(serverAddress, serverPort, "/");
  webSocket.onEvent(webSocketEvent);
  webSocket.setReconnectInterval(3000);

  bootingSplash("Done!");
  delay(500);
  display.clearDisplay();
  display.display();
}

void loop() {
  webSocket.sendTXT("auth/afasf");
  delay(2000);
}





// //? Including Atoms
// #include "Atoms/AutomatedLighting.h"
// #include "Atoms/Buzzer.h"
// #include "Atoms/EnvironmentSensing.h"
// #include "Atoms/Firestore.h"
// #include "Atoms/FromPlant.h"
// #include "Atoms/OLED.h"
// #include "Atoms/RFID.h"
// #include "Atoms/WIFI.h"

// // Timing variables
// unsigned long previousMillisRFID = 0;
// unsigned long previousMillisEnvironment = 0;
// unsigned long previousMillisForcedLight = 0;

// // Interval constants
// const long intervalEnvironment = 1000;
// const long intervalForcedLight = 3000; // 3 seconds
// const long intervalAutomatedLighting = 100; // 100 milliseconds

// // Task handle for the automated lighting task
// TaskHandle_t AutomatedLightingTaskHandle = NULL;

// // Global variable to store the forced light status
// bool isForcedLightOn = false;

// void setup() {
//   Serial.begin(115200);
//   disconnectWIFI();
//   OLEDsetup();
//   bootingSplash(false);
//   WIFISetup();
//   chatSetup();
//   RFIDsetup();
//   AutomatedLightingSetup();
//   BuzzerSetup();
//   EnvironmentSensingSetup();
//   delay(1200);
//   bootingSplash(true);
//   delay(1000);
//   display.clearDisplay();
//   display.display();
// }

// void loop() {
//   struct connectionState wifiStatus = EnsureWIFIIsConnected();

//   if (wifiStatus.isConnected) {
//     getRFIDUIDAsync(onRFIDReceived);
//     runEnvironmentSensing();
//     bottomPanel(wifiStatus.ssid, wifiStatus.ip);

//     // Fetch the forced light status every 3 seconds
//     unsigned long currentMillis = millis();
//     if (currentMillis - previousMillisForcedLight >= intervalForcedLight) {
//       previousMillisForcedLight = currentMillis;
//       isForcedLightOn = fetchForcedLightStatusOf("Malabe-GH01");
//     }

//     // Create the automated lighting task if not already created
//     if (AutomatedLightingTaskHandle == NULL) {
//       xTaskCreate(runAutomatedLightingTask, "AutomatedLightingTask", 8192, NULL, 1, &AutomatedLightingTaskHandle); // Let FreeRTOS decide the core
//     }
//   } else {
//     reconnectingScreeen();

//     // Delete the automated lighting task if it is created
//     if (AutomatedLightingTaskHandle != NULL) {
//       vTaskDelete(AutomatedLightingTaskHandle);
//       AutomatedLightingTaskHandle = NULL;
//     }
//   }
// }

// void runEnvironmentSensing() {
//   unsigned long currentMillis = millis();
//   if (currentMillis - previousMillisEnvironment >= intervalEnvironment) {
//     previousMillisEnvironment = currentMillis;
//     Environment limits = fetchEnvironmentLimitsOf("Malabe-GH01");
//     struct environmentData currentData = ReturnEnvironmentData(limits.temperature, limits.humidity);
//     showCurrentTempratureAndHumidity(currentData.temperature, currentData.humidity);
//     // Serial.println("Chat: " + chatWithPlant("Strawberry-01", limits.humidity));
//     std::map<String, int> moistureData = {{"Strawberry-01", 60}};
//     setCurrentEnvironmentOf("Malabe-GH01", currentData.temperature, currentData.humidity, moistureData);
//   }
// }

// void runAutomatedLightingTask(void *pvParameters) {
//   for (;;) {
//     AutomatedLighting(isForcedLightOn);
//     vTaskDelay(intervalAutomatedLighting / portTICK_PERIOD_MS); // Delay for 100 milliseconds
//   }
// }

// void onRFIDReceived(const String &uid) {
//   validatingUserScreeen();
//   asyncAuthenticatingUser(uid, "Malabe-GH01", [](const byte &status, const String &userName) {
//     if (status == 1) {
//       String message = userName + " entered the greenhouse!";
//       if (createNewAlert("Malabe-GH01", "security", message.c_str())) {
//         validStatusUserScreeen(1);
//         authTone();
//       } else {
//         validStatusUserScreeen(4);
//       }
//     } else if (status == 2) {
//       validStatusUserScreeen(2);
//       notAuthTone();
//     } else if (status == 3) {
//       validStatusUserScreeen(3);
//       notAuthTone();
//     } else {
//       validStatusUserScreeen(4);
//       notAuthTone();
//     }
//   });
// }