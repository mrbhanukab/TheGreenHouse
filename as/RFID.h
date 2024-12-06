#include <MFRC522v2.h>
#include <MFRC522DriverSPI.h>
#include <MFRC522DriverPinSimple.h>
#include <MFRC522Debug.h>

// Setup for RFID reader pins
MFRC522DriverPinSimple ss_pin(5); // Pin for SS (slave select)
MFRC522DriverSPI driver(ss_pin);  // SPI driver for MFRC522
MFRC522 reader(driver);           // RFID reader object

// Function to initialize the RFID reader
void RFIDsetup(){
    Serial.println("Initializing RFID reader...");
    reader.PCD_Init();
    Serial.println("Initialized RFID reader...");
    delay(100); // Small delay to allow RFID reader to initialize
}

String read(){
    if (reader.PICC_IsNewCardPresent() && reader.PICC_ReadCardSerial())
    {
        String uidString = "";
        for (byte i = 0; i < reader.uid.size; i++)
        {
            uidString += String(reader.uid.uidByte[i], HEX);
            if (i < reader.uid.size - 1)
            {
                uidString += ":";
            }
        }

        // Halt and stop encryption after reading the card
        reader.PICC_HaltA();
        reader.PCD_StopCrypto1();
        Serial.println(uidString);
//        return(uidString);
    }
}