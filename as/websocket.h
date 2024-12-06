#include <WebSocketsClient.h>
#define serverAddress "192.168.43.238"
#define serverPort 3005

WebSocketsClient webSocket;

void webSocketEvent(WStype_t type, uint8_t *payload, size_t length) {
    String message = String((char *)payload);

    switch (type) {
      case WStype_DISCONNECTED:
        Serial.println("WebSocket disconnected!");
        break;

      case WStype_CONNECTED:
        Serial.println("WebSocket connected!");
        // Send a message to the server upon connection
        webSocket.sendTXT("company=blackHoleCorp;greenHouse=GH-MA-01");
        break;

      case WStype_TEXT:
        Serial.println("Message received from server: " + message);
        break;

      case WStype_ERROR:
        Serial.println("WebSocket error occurred!");
        break;

      default:
        break;
    }
  }
