// Define the plant name
#define PLANT_NAME "Strawberry-01" // Corrected spelling

// Initialize the soil moisture level (replace with actual sensor reading)
int currentSoilMoistureLevel = 30; // Example value

// Initialize Serial for communication
void setup() {
    Serial.begin(9600); // Serial for communication with ESP32
    Serial.println("Hi, from Pro Mini!");
}

void loop() {
    // Check if there is data from ESP32
    if (Serial.available()) {
        String receivedData = Serial.readStringUntil('\n');
        Serial.println(receivedData);
        // Check if the received data contains the PLANT_NAME
        if (receivedData.indexOf(PLANT_NAME) != -1) {
            Serial.println("Received Data: " + receivedData);

            // Split the received data based on the first colon
            int separator1 = receivedData.indexOf(':');
            if (separator1 != -1) {
                String timestampStr = receivedData.substring(0, separator1); // Get the timestamp
                String messageContent = receivedData.substring(separator1 + 1); // Get the rest of the message

                // Split the message content further
                int separator2 = messageContent.indexOf(':');
                if (separator2 != -1) {
                    String plantName = messageContent.substring(0, separator2);
                    String soilMoistureLimitStr = messageContent.substring(separator2 + 1);

                    // Log the received values
                    Serial.println("Timestamp: " + timestampStr);
                    Serial.println("Plant Name: " + plantName);
                    Serial.println("Soil Moisture Limit: " + soilMoistureLimitStr);

                    // Send response back with the current moisture level
                    Serial.println(timestampStr + ":" + plantName + ":" + String(currentSoilMoistureLevel));
                } else {
                    Serial.println("Error parsing message content.");
                }
            } else {
                Serial.println("Error parsing received data.");
            }
        }
    }
}
