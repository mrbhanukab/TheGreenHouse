#define BUZZER_PIN 14
#define DHTPIN 25
#define SOIL_MOISTURE_PIN 15
#define AUTH_LIGHT_PIN 2
#define LED 33
#define PIR 35
#define LDR 32
#define HEATER 13
#define COOLER 12
#define FAN 26
#define PUMP 4

void setupIO(){
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(SOIL_MOISTURE_PIN, INPUT);
  pinMode(AUTH_LIGHT_PIN, OUTPUT);
  pinMode(PIR, INPUT);
  pinMode(LDR, INPUT);
  pinMode(HEATER, OUTPUT);
  pinMode(COOLER, OUTPUT);
  pinMode(FAN, OUTPUT);
  pinMode(PUMP, OUTPUT);
  ledcAttach(LED, 500, 13);
}
