#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

#define DHTTYPE DHT11

DHT_Unified dht(DHTPIN, DHTTYPE);

void DHTSetup() {
  dht.begin();
  sensor_t sensor;
  dht.temperature().getSensor(&sensor);
  Serial.println(F("------------------------------------"));
  Serial.println(F("Temperature Sensor"));
  Serial.print(F("Sensor Type: "));
  Serial.println(sensor.name);
  Serial.print(F("Driver Ver:  "));
  Serial.println(sensor.version);
  Serial.print(F("Unique ID:   "));
  Serial.println(sensor.sensor_id);
  Serial.print(F("Max Value:   "));
  Serial.print(sensor.max_value);
  Serial.println(F("°C"));
  Serial.print(F("Min Value:   "));
  Serial.print(sensor.min_value);
  Serial.println(F("°C"));
  Serial.print(F("Resolution:  "));
  Serial.print(sensor.resolution);
  Serial.println(F("°C"));
  Serial.println(F("------------------------------------"));
  dht.humidity().getSensor(&sensor);
  Serial.println(F("Humidity Sensor"));
  Serial.print(F("Sensor Type: "));
  Serial.println(sensor.name);
  Serial.print(F("Driver Ver:  "));
  Serial.println(sensor.version);
  Serial.print(F("Unique ID:   "));
  Serial.println(sensor.sensor_id);
  Serial.print(F("Max Value:   "));
  Serial.print(sensor.max_value);
  Serial.println(F("%"));
  Serial.print(F("Min Value:   "));
  Serial.print(sensor.min_value);
  Serial.println(F("%"));
  Serial.print(F("Resolution:  "));
  Serial.print(sensor.resolution);
  Serial.println(F("%"));
  Serial.println(F("------------------------------------"));
}

struct environmentData {
  int humidity;
  int temperature;
};

environmentData readDHT() {
  environmentData current;
  sensors_event_t event;
  dht.temperature().getEvent(&event);

  if (isnan(event.temperature)) {
    Serial.println(F("Error reading temperature!"));
  } else {
//     Serial.print(F("Temperature: "));
    current.temperature = static_cast<int>(event.temperature);
//     Serial.print(current.temperature);
//     Serial.println(F("°C"));
  }

  dht.humidity().getEvent(&event);
  if (isnan(event.relative_humidity)) {
    Serial.println(F("Error reading humidity!"));
  } else {
//     Serial.print(F("Humidity: "));
    current.humidity = static_cast<int>(event.relative_humidity);
//     Serial.print(current.humidity);
//     Serial.println(F("%"));
  }

  return current;
}

void checkAndSendDHTData() {
  environmentData currentData = readDHT();

  // Check if the temperature or humidity has changed
  if (currentData.temperature != previousTemperature || currentData.humidity != previousHumidity) {
    String message = "env/currentTemperature=" + String(currentData.temperature) + ";currentHumidity=" + String(currentData.humidity);
    sendWebSocketMessage(message);

    // Update the stored values
previousTemperature = static_cast<int>(currentData.temperature);
previousHumidity = static_cast<int>(currentData.humidity);
  }

   if (previousTemperature > temperatureLimit) {
   Serial.println("Temperature is above the limit");
    } else if (previousTemperature < temperatureLimit) {
    Serial.println("Temperature is below the limit");
    } else {
    }

    if (previousHumidity != humidityLimit) {
    Serial.println("Humidity is above the limit");
    } else {
    Serial.println("Humidity is below the limit");
    }
}
