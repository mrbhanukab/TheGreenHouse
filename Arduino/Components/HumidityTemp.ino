#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// Define the DHT22 sensor pin and type
#define DHTPIN 2
#define DHTTYPE DHT22

// Initialize the DHT sensor
DHT dht(DHTPIN, DHTTYPE);

// Define LED pins
#define RED_LED_PIN 7
#define BLUE_LED_PIN 8

// Define OLED display parameters
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET    -1
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

void setup() {
  // Initialize Serial Monitor
  Serial.begin(9600);
  
  // Initialize DHT sensor
  dht.begin();
  
  // Initialize LED pins
  pinMode(RED_LED_PIN, OUTPUT);
  pinMode(BLUE_LED_PIN, OUTPUT);

  // Initialize the OLED display
  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;);
  }
  
  // Clear the buffer
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(SSD1306_WHITE);
}

void loop() {
  // Read temperature and humidity from DHT22
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  // Check if any reads failed and exit early (to try again).
  if (isnan(humidity) || isnan(temperature)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

  // Print the values to the Serial Monitor
  Serial.print(F("Humidity: "));
  Serial.print(humidity);
  Serial.print(F("%  Temperature: "));
  Serial.print(temperature);
  Serial.println(F("°C "));
  
  // Display the temperature and humidity on the OLED
  display.clearDisplay();
  display.setCursor(0, 10);
  display.print(F("Temp: "));
  display.print(temperature);
  display.print(F(" C"));
  
  display.setCursor(0, 30);
  display.print(F("Humidity: "));
  display.print(humidity);
  display.print(F(" %"));

  display.display();
  
  // Control LEDs based on temperature
  if (temperature < 25) {
    digitalWrite(RED_LED_PIN, HIGH);   // Turn on Red LED
    digitalWrite(BLUE_LED_PIN, HIGH);   // Turn off Blue LED
  } else if (temperature <= 35) {
    digitalWrite(RED_LED_PIN, LOW);    // Turn off Red LED
    digitalWrite(BLUE_LED_PIN, LOW);  // Turn on Blue LED
  } else {
    digitalWrite(RED_LED_PIN, LOW);    // Turn off Red LED
    digitalWrite(BLUE_LED_PIN, HIGH);   // Turn off Blue LED
  }
  
  // Delay for a bit before taking another reading
  delay(2000);
}
