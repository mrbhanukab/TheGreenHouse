/*
 *     _____ _              ___
 *    /__   \ |__   ___    / _ \_ __ ___  ___ _ __     /\  /\___  _   _ ___  ___
 *      / /\/ '_ \ / _ \  / /_\/ '__/ _ \/ _ \ '_ \   / /_/ / _ \| | | / __|/ _ \
 *     / /  | | | |  __/ / /_\\| | |  __/  __/ | | | / __  / (_) | |_| \__ \  __/
 *     \/   |_| |_|\___| \____/|_|  \___|\___|_| |_| \/ /_/ \___/ \__,_|___/\___|
 *    Arduino Part | FromPlant.h| Bhanuka Bandara
 *
 *    This entire system was developed and maintained by Bhanuka Bandara, Ruvindi Jayasooriya,
 *    Muditha Pasan, Yashara Wanigasekara, Safak Ahamed, and Sandini Imesha. This specific part
 *    was developed by Bhanuka Bandara. For more information about this section of the system, please
 *    refer to the following wiki link: [wiki link about this part of the code].
 */

#include <HardwareSerial.h>

HardwareSerial SerialPort(2); // we are using UART2

void chatSetup()
{
    SerialPort.begin(38400, SERIAL_8N1, 16, 17);
}

int chatWithPlant(const char *PLANT_NAME, int SOIL_MOISTURE_LIMIT)
{
    // Prepare the message
    unsigned long timestamp = Get_Epoch_Time();
    String message = String(timestamp) + ":" + String(PLANT_NAME) + ":" + String(SOIL_MOISTURE_LIMIT) + ":?\n"; // Add newline character
    SerialPort.println(message);
    unsigned long startMillis = millis();
    while (SerialPort.available() > 0)
    {
        String receivedData = SerialPort.readStringUntil('\n'); // Read until newline character
        int firstColonIndex = receivedData.indexOf(':');
        int secondColonIndex = receivedData.indexOf(':', firstColonIndex + 1);
        int thirdColonIndex = receivedData.indexOf(':', secondColonIndex + 1);
        if (secondColonIndex != -1 && secondColonIndex > firstColonIndex)
        {
            String receivedPlantName = receivedData.substring(firstColonIndex + 1, secondColonIndex);
            if (receivedPlantName.equals(PLANT_NAME))
            {
                // Extract the soil moisture current as a string and convert to int
                String soilMoistureCurrentStr = receivedData.substring(thirdColonIndex + 1);
                soilMoistureCurrentStr.trim();                              // Trim any whitespace or newlines
                int SOIL_MOISTURE_Current = soilMoistureCurrentStr.toInt(); // Convert to int

                return SOIL_MOISTURE_Current; // Return the current soil moisture
            }
            else
            {
                Serial.println("Received plant name does not match the expected name.");
                return -1;
            }
        }
    }
    while (!(SerialPort.available() > 0))
    {
        Serial.println("Timeout waiting for response");
        return -1; // Indicate timeout
    }
}