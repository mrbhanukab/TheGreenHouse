#include <MFRC522v2.h>
#include <MFRC522DriverSPI.h>
#include <MFRC522DriverPinSimple.h>
#include <MFRC522Debug.h>

// Setup for RFID reader pins
MFRC522DriverPinSimple ss_pin(5);  // Pin for SS (slave select)
MFRC522DriverSPI driver(ss_pin);   // SPI driver for MFRC522
MFRC522 reader(driver);            // RFID reader object

// Global variables for authentication response handling
extern bool waitingForAuthResponse;
unsigned long authResponseStartTime = 0;
const unsigned long authResponseTimeout = 15000;  // 12 seconds

// Function to initialize the RFID reader
void RFIDsetup() {
  Serial.println("Initializing RFID reader...");
  reader.PCD_Init();
  Serial.println("Initialized RFID reader...");
}

// Function to check for RFID UID asynchronously (non-blocking)
void readRFID(void *pvParameters) {
  while (true) {
    if (!waitingForAuthResponse && reader.PICC_IsNewCardPresent() && reader.PICC_ReadCardSerial()) {
      validating = true;
      validatingUserScreen();
      String uidString = "";
      for (byte i = 0; i < reader.uid.size; i++) {
        uidString += String(reader.uid.uidByte[i], HEX);
        if (i < reader.uid.size - 1) {
          uidString += ":";
        }
      }

      // Halt and stop encryption after reading the card
      reader.PICC_HaltA();
      reader.PCD_StopCrypto1();
      Serial.println(uidString);

      // Send the UID to the WebSocket server
      String message = "auth/" + uidString;
      sendWebSocketMessage(message);

      // Set the flag and start the timeout
      waitingForAuthResponse = true;
      authResponseStartTime = millis();
    }

    // Check for timeout
    if (waitingForAuthResponse && millis() - authResponseStartTime >= authResponseTimeout) {
      Serial.println("failed");
      validStatusUserScreen(5);
      waitingForAuthResponse = false;
      validating = false;
    }

    // Add a delay to allow other tasks to run
    vTaskDelay(10 / portTICK_PERIOD_MS);
  }
}

// Function to handle authentication response
void handleAuthResponse(String payload) {
  waitingForAuthResponse = true;
  if (waitingForAuthResponse) {
    if (payload == "auth/nun") {
      validStatusUserScreen(3);
      notAuthTone();
      validating = false;
    } else if (payload == "auth/approved") {
      digitalWrite(AUTH_LIGHT_PIN, HIGH);
      validStatusUserScreen(1);
      authTone();
      digitalWrite(AUTH_LIGHT_PIN, LOW);

      validating = false;
    }
    waitingForAuthResponse = false;
  }
}

// Declare the sendWebSocketMessage function so it can be used in this file
void sendWebSocketMessage(String &message);