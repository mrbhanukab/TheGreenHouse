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

int chatWithPlant(const char *PLANT_NAME, int SOIL_MOISTURE_LIMIT)
{
    // Prepare the message
    unsigned long timestamp = Get_Epoch_Time();
    String message = String(timestamp) + ":" + String(PLANT_NAME) + ":" + String(SOIL_MOISTURE_LIMIT) + ":?";

    // Send the message with timestamp
    Serial.println(message);

    // Wait for response from Pro Mini
    while (!Serial.available())
    {
        // Wait for data to be available
    }

    // Read the response
    String response = Serial.readStringUntil('\n');

    // Parse the response to extract SOIL_MOISTURE_Current
    int firstColonIndex = response.indexOf(':');
    int secondColonIndex = response.indexOf(':', firstColonIndex + 1);
    int thirdColonIndex = response.indexOf(':', secondColonIndex + 1);

    String soilMoistureCurrentStr = response.substring(thirdColonIndex + 1);
    int SOIL_MOISTURE_Current = soilMoistureCurrentStr.toInt();

    // Return the current soil moisture
    return SOIL_MOISTURE_Current;
}