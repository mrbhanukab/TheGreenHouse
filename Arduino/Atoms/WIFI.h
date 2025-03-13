#include <WiFi.h>
#include <WiFiMulti.h>

WiFiMulti wifiMulti;

const uint32_t connectTimeoutMs = 30000;
struct connectionState{
    bool isConnected;
    const char *ssid;
    char ip[16];
};

void WIFISetup(){
   WiFi.mode(WIFI_STA);
   for (int i = 0; i < NUM_NETWORKS; i++) wifiMulti.addAP(wifiNetworks[i].ssid, wifiNetworks[i].password);
}

void disconnectWIFI(){ WiFi.disconnect(); }

struct connectionState EnsureWIFIIsConnected()
{
    static char ssidBuffer[33];
    struct connectionState current;

    if (wifiMulti.run(connectTimeoutMs) == WL_CONNECTED)
    {
        current.isConnected = true;
        strncpy(ssidBuffer, WiFi.SSID().c_str(), sizeof(ssidBuffer) - 1);
        ssidBuffer[sizeof(ssidBuffer) - 1] = '\0'; // Ensure null termination
        current.ssid = ssidBuffer;
        strncpy(current.ip, WiFi.localIP().toString().c_str(), sizeof(current.ip) - 1);
        current.ip[sizeof(current.ip) - 1] = '\0'; // Ensure null termination
    }
    else
    {
        current.isConnected = false;
        current.ssid = "Not Connected";
        strncpy(current.ip, "null", sizeof(current.ip) - 1);
        current.ip[sizeof(current.ip) - 1] = '\0'; // Ensure null termination
    }

    return current;
}