/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | Main.ino | Yashara Wanigasekara
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Yashara Wanigasekara. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

//? Including Atoms
#include "Atoms/FromPlant.h"
#include "Atoms/WIFI.h"
// #include "Atoms/Firestore.h"
// #include "Atoms/RFID.h"
// #include "Atoms/Buzzer.h"
// #include "Atoms/OLED.h"
// #include "Atoms/AutomatedLighting.h"
// #include "Atoms/EnvironmentSensing.h"

// unsigned long lastRFIDCheck = 0;         // Timer to track RFID check
// const unsigned long RFIDInterval = 500;  // Interval between RFID checks (in ms)

void setup() {
  //! For the board
  Serial.begin(115200);
  setupPlantChat();
  // OLEDsetup();
  disconnectWIFI();
  WIFISetup();
  // RFIDsetup();
  // BuzzerSetup();
  // AutomatedLightingSetup();
  // EnvironmentSensingSetup();
}

// void handleAuthResult(const String &message) {
//     Serial.println(message);
// }

void loop() {
  // Check Wi-Fi connection status
  struct connectionState wifiStatus = EnsureWIFIIsConnected();

  if (wifiStatus.isConnected) {
    Serial.print("Connected to SSID: ");
    Serial.println(wifiStatus.ssid);
        // Only call the chat function if connected
        chatWithPlant("Strawberry-01", 25); // Example moisture limit
        
        // Wait a bit before the next call to avoid flooding
        delay(1000);
  } else {
    Serial.println("Wi-Fi Not Connected.");
  }

  // // Asynchronously check for RFID cards every RFIDInterval milliseconds
  // unsigned long currentMillis = millis();
  // if (currentMillis - lastRFIDCheck >= RFIDInterval) {
  //   lastRFIDCheck = currentMillis;
  //   getRFIDUIDAsync(printUID);
  // }

  delay(1000);
}

// // Callback function to print the UID to the Serial monitor
// void welcomeToneTask(void *parameter);
// void notifyTask(void *parameter);

// // Function to handle printing RFID UID and executing tasks concurrently
// void printUID(const String &uid) {
//   if (uid != "") {
//     Serial.print("RFID UID: ");
//     Serial.println(uid);

//     // Create two tasks to run welcomeTone and Serial print concurrently
//     xTaskCreatePinnedToCore(
//       welcomeToneTask,    // Function that handles the welcome tone
//       "welcomeToneTask",  // Task name
//       4096,               // Stack size for the task
//       NULL,               // Parameter for the task (none needed)
//       1,                  // Task priority (1 is default)
//       NULL,               // Task handle (can be null if not needed)
//       0                   // Core 0 (run this task on Core 0)
//     );

//     xTaskCreatePinnedToCore(
//       notifyTask,    // Function that handles Serial printing
//       "notifyTask",  // Task name
//       4096,          // Stack size for the task
//       NULL,          // Parameter for the task (none needed)
//       1,             // Task priority (1 is default)
//       NULL,          // Task handle (can be null if not needed)
//       1              // Core 1 (run this task on Core 1)
//     );
//   }
// }

// // Task for running the welcomeTone function
// void welcomeToneTask(void *parameter) {
//   welcomeTone();
//   vTaskDelete(NULL);
// }

// // Task for printing 'h' to Serial
// void notifyTask(void *parameter) {
//   Serial.print("hi");
//   ShowInOLED(0, 0, 2, "Hi");
//   vTaskDelete(NULL);
// }
