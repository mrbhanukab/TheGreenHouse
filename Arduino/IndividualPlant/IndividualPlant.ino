#define PLANT_NAME "Strawberry-01"

int currentSoilMoistureLevel = 30; // Example value

void setup() {
    Serial.begin(19200); // For UART communication with ESP32
}

void loop() {
    // Check if data is received from ESP32
    if (Serial.available() > 0) {
        String receivedData = Serial.readStringUntil('\n');  // Read until newline character
        String firstPart, secondPart, thirdPart;
        int firstSeparator = receivedData.indexOf(':'); // Find the first ':'
        int secondSeparator = receivedData.indexOf(':', firstSeparator + 1); // Find the second ':'
        
        if (firstSeparator != -1) {
            // Extract the first part (from the start to the first ':')
            firstPart = receivedData.substring(0, firstSeparator);
        }

        if (secondSeparator != -1) {
            // Extract the second part (between the first ':' and the second ':')
            secondPart = receivedData.substring(firstSeparator + 1, secondSeparator);
            
            // Extract the third part (between the second ':' and '?' excluding the ':?')
            int questionMarkIndex = receivedData.indexOf('?', secondSeparator); // Find the '?'
            if (questionMarkIndex == -1) questionMarkIndex = receivedData.length(); // If no '?', read till end
            thirdPart = receivedData.substring(secondSeparator + 1, questionMarkIndex); // Exclude the '?' at the end
            
            // Convert thirdPart to an integer (moisture level limit)
            int moistureLimit = thirdPart.toInt(); // Convert to int
            
            // Check if the received plant name matches
            if (secondPart == PLANT_NAME) {
                Serial.println(firstPart + ":" + secondPart + ":" + String(currentSoilMoistureLevel)); // Outputs: timestamp:plant_name:current_soil_moisture_level
            }
        }
    }
}
