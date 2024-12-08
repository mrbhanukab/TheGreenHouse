#include <WebSocketsClient.h>

WebSocketsClient webSocket;

// Global variable for authentication response handling
bool waitingForAuthResponse = false;

// Function prototype for handling authentication response in RFID.h
void handleAuthResponse(String payload);

void readWebSocket() {
  webSocket.loop();
}

bool isWebSocketConnected() {
  return webSocket.isConnected();
}

void sendWebSocketMessage(String &message) {
  if (isWebSocketConnected()) {
    webSocket.sendTXT(message);
  }
}

void hexdump(const void *mem, uint32_t len, uint8_t cols = 16) {
  const uint8_t *src = (const uint8_t *)mem;
  Serial.printf("\n[HEXDUMP] Address: 0x%08X len: 0x%X (%d)", (ptrdiff_t)src, len, len);
  for (uint32_t i = 0; i < len; i++) {
    if (i % cols == 0) {
      Serial.printf("\n[0x%08X] 0x%08X: ", (ptrdiff_t)src, i);
    }
    Serial.printf("%02X ", *src);
    src++;
  }
  Serial.printf("\n");
}

void webSocketEvent(WStype_t type, uint8_t *payload, size_t length) {
  String message;  // Declare message outside the switch statement
  switch (type) {
    case WStype_DISCONNECTED:
      connected = false;
      Serial.printf("[WSc] Disconnected!\n");
      break;
    case WStype_CONNECTED:
      connected = true;
      Serial.printf("[WSc] Connected to url: %s\n", payload);
      webSocket.sendTXT("company=blackHoleCorp;greenHouse=GH-MA-01");
      break;
    case WStype_TEXT:
      Serial.printf("[WSc] get text: %s\n", payload);
      message = String((char *)payload);
      Serial.println(message);
      if (message.startsWith("auth/")) {
        handleAuthResponse(message);
      } else if (message.startsWith("env/")) {
        int tempIndex = message.indexOf("temperatureLimit=");
        int humIndex = message.indexOf("humidityLimit=");
        int lightIndex = message.indexOf("forcedLight=");
        if (tempIndex != -1) {
          int endIndex = message.indexOf(';', tempIndex);
          if (endIndex == -1) endIndex = message.length();
          temperatureLimit = message.substring(tempIndex + 17, endIndex).toInt();
        }
        if (humIndex != -1) {
          int endIndex = message.indexOf(';', humIndex);
          if (endIndex == -1) endIndex = message.length();
          humidityLimit = message.substring(humIndex + 14, endIndex).toInt();
        }
        if (lightIndex != -1) {
          int endIndex = message.indexOf(';', lightIndex);
          if (endIndex == -1) endIndex = message.length();
          String lightValue = message.substring(lightIndex + 12, endIndex);
          forcedLight = (lightValue == "true");
        }
        Serial.printf("Updated limits: temperatureLimit=%d, humidityLimit=%d\n", temperatureLimit, humidityLimit);
      }
      break;
    case WStype_BIN:
      Serial.printf("[WSc] get binary length: %u\n", length);
      hexdump(payload, length);
      break;
    case WStype_ERROR:
    case WStype_FRAGMENT_TEXT_START:
    case WStype_FRAGMENT_BIN_START:
    case WStype_FRAGMENT:
    case WStype_FRAGMENT_FIN:
      break;
  }
}

void webhookSetup() {
  webSocket.begin("192.168.43.238", 3005, "/");
  webSocket.onEvent(webSocketEvent);
  webSocket.setReconnectInterval(5000);
}
