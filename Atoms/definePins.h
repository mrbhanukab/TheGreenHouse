#define BUZZER_PIN 14
#define DHTPIN 25
#define SOIL_MOISTURE_PIN 32
#define AUTH_LIGHT_PIN 12

void setupIO(){
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(AUTH_LIGHT_PIN, OUTPUT);

  pinMode(SOIL_MOISTURE_PIN, INPUT);
}