bool connected = false;
int humidityLimit=0;
int temperatureLimit=0;
int previousTemperature = 0;
int previousHumidity = 0;
bool forcedLight = false;

unsigned long previousMillisDHT = 0;
unsigned long previousMillisWebSocket = 0;
const long intervalDHT = 1000;      // 1 second
const long intervalWebSocket = 10;  // 10 milliseconds