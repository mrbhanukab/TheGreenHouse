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

/*
? MFRC522 Reader parameters
! Configurable, take an unused pin.
* PIN Layout: https://github.com/OSSLibraries/Arduino_MFRC522v2#pin-layout
*/
MFRC522DriverPinSimple ss_pin(10);
MFRC522DriverSPI driver(ss_pin);
MFRC522 reader(driver);

//! Include this in the setup() function of the main code
void RFIDsetup()
{
    reader.PCD_Init();
}

String getRFIDUID()
{
    String uidString = ""; // String to store the UID

    if (reader.PICC_IsNewCardPresent() && reader.PICC_ReadCardSerial())
    {
        for (byte i = 0; i < reader.uid.size; i++)
        {
            uidString += String(reader.uid.uidByte[i], HEX);
            if (i < reader.uid.size - 1)
            {
                uidString += ":";
            }
        }

        reader.PICC_HaltA();
        reader.PCD_StopCrypto1();
    }

    return uidString;
}