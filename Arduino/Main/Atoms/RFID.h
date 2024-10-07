/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | RFID.h | Ruvindi Jayasooriya
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Ruvindi Jayasooriya. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

//! These libraries must be installed before using this code
#include <MFRC522v2.h>
#include <MFRC522DriverSPI.h>
#include <MFRC522DriverPinSimple.h>
#include <MFRC522Debug.h>

// Setup for RFID reader pins
MFRC522DriverPinSimple ss_pin(5); // Pin for SS (slave select)
MFRC522DriverSPI driver(ss_pin);  // SPI driver for MFRC522
MFRC522 reader(driver);           // RFID reader object

// Function to initialize the RFID reader
void RFIDsetup()
{
    Serial.println("Initializing RFID reader...");
    reader.PCD_Init();
    Serial.println("Initialized RFID reader...");
    delay(100); // Small delay to allow RFID reader to initialize
}

// Function to check for RFID UID asynchronously (non-blocking)
void getRFIDUIDAsync(void (*callback)(const String &))
{
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
        // Send UID to the callback
        callback(uidString);
    }
}
